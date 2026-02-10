<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공지 작성</title>

<!-- jQuery -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<!-- Summernote -->
<link href="https://cdn.jsdelivr.net/npm/summernote@0.8.20/dist/summernote-lite.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/summernote@0.8.20/dist/summernote-lite.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/summernote@0.8.20/lang/summernote-ko-KR.min.js"></script>

<script src="/js/board_editor.js"></script>
<link rel="stylesheet" href="/css/notice_form.css">
</head>

<body>
<%@ include file="/WEB-INF/views/header.jsp" %>

<h2 class="notice-title">공지 작성</h2>

<form action="/admin/notices/write" method="post" class="notice-form">

    <table>
        <tr>
            <th>제목</th>
            <td>
                <input type="text" name="ntitle" required>
            </td>
        </tr>

        <tr>
            <th>고정 여부</th>
            <td>
                <select name="npin">
                    <option value="N">일반</option>
                    <option value="Y">상단 고정</option>
                </select>
            </td>
        </tr>

        <tr>
            <th>내용</th>
            <td>
                <textarea id="bcontent" name="ncontent" data-upload-type="notice"></textarea>
            </td>
        </tr>
    </table>

    <!-- 버튼 영역 -->
    <div class="notice-btn-area">
        <button type="submit">등록</button>
        <button type="button" onclick="location.href='/notice/list'">취소</button>
    </div>
</form>
<%@ include file="/WEB-INF/views/footer.jsp" %>
</body>
</html>
