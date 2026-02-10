$(document).ready(function () {

    const $editor = $('#bcontent');
    if ($editor.length === 0) return;

    /* =========================
       업로드 타입 설정
       ========================= */
    const uploadType = $editor.data('upload-type'); // board | notice

    const uploadUrlMap = {
        board: '/upload/board-image',
        notice: '/upload/notice-image'
    };

    const uploadUrl = uploadUrlMap[uploadType];

    if (!uploadUrl) {
        console.error('❌ uploadType이 지정되지 않았습니다.');
        return;
    }

    /* =========================
       Summernote 초기화
       ========================= */
    $editor.summernote({
        height: 350,
        lang: 'ko-KR',
		dialogsInBody: true,
        placeholder: uploadType === 'notice'
            ? '공지 내용을 입력하세요'
            : '내용을 입력하세요',
        toolbar: [
            ['font', ['fontname', 'fontsize']],
            ['style', ['bold', 'italic', 'underline', 'clear']],
            ['color', ['color']],
            ['para', ['ul', 'ol', 'paragraph']],
            ['insert', ['picture', 'link']],
            ['view', ['fullscreen', 'codeview']]
        ],
        fontNames: [
            '맑은 고딕', '굴림', '돋움', '바탕', '궁서',
            'Arial', 'Arial Black', 'Courier New', 'Verdana'
        ],
        fontSizes: ['8','10','12','14','16','18','24','36'],

        callbacks: {
            onImageUpload: function (files) {
                uploadImage(files[0]);
            }
        }
    });

    /* =========================
       이미지 업로드 공통 함수
       ========================= */
    function uploadImage(file) {
        const formData = new FormData();
        formData.append("file", file);

        $.ajax({
            url: uploadUrl,
            type: "POST",
            data: formData,
            processData: false,
            contentType: false,

            success: function (res) {
                /**
                 * 서버 응답 대응
                 * 1️⃣ String 반환 → "/upload/board/xxx.jpg"
                 * 2️⃣ JSON 반환 → { url: "/upload/board/xxx.jpg" }
                 */
                let imageUrl = res;

                if (typeof res === 'object' && res.url) {
                    imageUrl = res.url;
                }

                if (!imageUrl) {
                    alert('이미지 URL을 받지 못했습니다.');
                    return;
                }

                $editor.summernote('insertImage', imageUrl);
            },

            error: function (xhr) {
                console.error('❌ 이미지 업로드 실패', xhr);
                alert(
                    uploadType === 'notice'
                        ? '공지 이미지 업로드 실패'
                        : '게시글 이미지 업로드 실패'
                );
            }
        });
    }
});
