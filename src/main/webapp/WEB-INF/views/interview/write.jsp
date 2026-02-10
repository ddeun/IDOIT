<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>인터뷰 작성(관리자)</title>

<style>
  :root{
    --base-color:#0F2E55;
    --base-soft:#163B6A;

    --bg:#F5F7FA;
    --card:#FFFFFF;

    --text:#111827;
    --muted:#6B7280;
    --line:#E5E7EB;
    --accent-weak:#E6EEF8;

    --shadow:0 10px 22px rgba(15,46,85,.08);
    --radius:18px;
    --focus:0 0 0 3px rgba(15,46,85,.12);
  }

  *{ box-sizing:border-box; }

  body{
    font-family:'Segoe UI','Apple SD Gothic Neo',sans-serif;
    background:var(--bg);
    margin:0;
    color:var(--text);
  }

  .wrap{
    max-width:920px;
    margin:28px auto;
    padding:0 18px 60px;
  }

  /* ✅ 목록으로 버튼 */
  .toplink{
    display:inline-flex;
    align-items:center;
    gap:8px;
    margin-bottom:16px;
    padding:6px 10px;
    border-radius:999px;
    color:var(--base-color);
    text-decoration:none;
    font-weight:900;
    transition:background .15s ease, transform .12s ease;
  }
  .toplink:hover{
    background:var(--accent-weak);
    transform:translateX(-2px);
  }.toplink{
  display:inline-flex;
  align-items:center;
  gap:8px;
  margin-bottom:16px;
  padding:6px 12px;
  border-radius:999px;
  color:var(--base-color);
  text-decoration:none;
  font-weight:900;
  transition:background .15s ease, color .15s ease, transform .12s ease;
 }

.toplink:hover{
  background:var(--base-color);
  color:#fff;
  transform:translateX(-2px);
 }
  
  .card{
    background:var(--card);
    border:1px solid var(--line);
    border-radius:var(--radius);
    padding:22px;
    box-shadow:var(--shadow);
    position:relative;
  }

  /* ✅ 상단 포인트 라인 – 끝 둥글게 */
  .card::before{
    content:"";
    position:absolute;
    top:0;
    left:18px;
    right:18px;
    height:4px;
    border-radius:999px;
    background:linear-gradient(90deg, var(--base-color), var(--base-soft));
  }

  h2{
    margin:0 0 6px;
    font-size:22px;
    font-weight:900;
    color:var(--base-color);
  }

  .desc{
    color:var(--muted);
    font-size:14px;
    margin-bottom:18px;
  }

  .form{
    display:grid;
    grid-template-columns:1fr;
    gap:14px;
  }

  .field label{
    display:block;
    font-weight:900;
    margin-bottom:8px;
    font-size:13px;
  }

  .control{
    width:100%;
    padding:12px 14px;
    border:1px solid var(--line);
    border-radius:14px;
    outline:none;
    background:#fff;
    font-size:14px;
    transition:border-color .12s ease, box-shadow .12s ease;
  }

  .control:focus{
    border-color:rgba(15,46,85,.35);
    box-shadow:var(--focus);
  }

  textarea.control{
    min-height:320px;
    resize:vertical;
    line-height:1.7;
  }

  .hint{
    color:var(--muted);
    font-size:12px;
    margin-top:6px;
  }

  .grid2{
    display:grid;
    grid-template-columns:1fr 1fr;
    gap:12px;
  }
  @media(max-width:720px){
    .grid2{ grid-template-columns:1fr; }
  }

  .btns{
    margin-top:6px;
    display:flex;
    gap:10px;
    justify-content:flex-end;
  }

  .btn{
    padding:11px 18px;
    border-radius:999px;
    border:1px solid var(--line);
    font-weight:900;
    cursor:pointer;
    text-decoration:none;
    display:inline-flex;
    align-items:center;
    justify-content:center;
    transition:background .12s ease, transform .1s ease;
  }

  .btn.primary{
    background:var(--base-color);
    color:#fff;
    border-color:var(--base-color);
  }
  .btn.primary:hover{
    background:var(--base-soft);
    transform:translateY(-1px);
  }

  .btn.ghost{
    background:#fff;
    color:var(--base-color);
  }
  .btn.ghost:hover{
    background:var(--accent-weak);
  }
</style>
</head>

<body>
<div class="wrap">

  <a class="toplink" href="/interview/list">← 인터뷰 목록으로</a>

  <div class="card">
    <h2>인터뷰 작성 (관리자)</h2>
    <div class="desc">이 페이지는 관리자만 접근 가능합니다.</div>

    <form class="form" method="post" action="/admin/interview/write">

      <div class="field">
        <label>제목</label>
        <input class="control" type="text" name="ititle" required>
      </div>

      <div class="field">
        <label>한줄 요약</label>
        <input class="control" type="text" name="isummary">
      </div>

      <div class="grid2">
        <div class="field">
          <label>카테고리</label>
          <select class="control" name="icategory">
            <option value="">선택</option>
            <option value="서버/백엔드 개발자">서버/백엔드 개발자</option>
            <option value="프론트엔드 개발자">프론트엔드 개발자</option>
            <option value="웹 풀스택 개발자">웹 풀스택 개발자</option>
            <option value="안드로이드 개발자">안드로이드 개발자</option>
            <option value="iOS 개발자">iOS 개발자</option>
            <option value="크로스플랫폼 앱개발자">크로스플랫폼 앱개발자</option>
            <option value="게임 클라이언트 개발자">게임 클라이언트 개발자</option>
            <option value="DBA">DBA</option>
            <option value="빅데이터 엔지니어">빅데이터 엔지니어</option>
            <option value="인공지능/머신러닝">인공지능/머신러닝</option>
            <option value="devops/시스템 엔지니어">devops/시스템 엔지니어</option>
            <option value="정보보안 담당자">정보보안 담당자</option>
            <option value="QA 엔지니어">QA 엔지니어</option>
            <option value="개발 PM">개발 PM</option>
            <option value="HW/임베디드">HW/임베디드</option>
            <option value="SW/솔루션">SW/솔루션</option>
            <option value="VR/AR/3D">VR/AR/3D</option>
            <option value="기술지원">기술지원</option>
          </select>
        </div>

        <div class="field">
          <label>썸네일 이미지 경로</label>
          <input class="control" type="text" name="iimagePath"
                 placeholder="/uploads/interview/xxx.jpg 또는 https://...">
        </div>
      </div>

      <div class="field">
        <label>태그</label>
        <input class="control" type="text" name="itags"
               placeholder="예) 백엔드,이직,면접,주니어">
        <div class="hint">콤마(,)로 구분</div>
      </div>

      <div class="field">
        <label>본문</label>
        <textarea class="control" name="icontent" required
          placeholder="인터뷰 내용을 입력하세요. (HTML 그대로 넣어도 됩니다)"></textarea>
      </div>

      <div class="btns">
        <a class="btn ghost" href="/interview/list">취소</a>
        <button class="btn primary" type="submit">등록</button>
      </div>

    </form>
  </div>

</div>
</body>
</html>
