<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>인터뷰 수정 (관리자)</title>

<style>
  :root{
    --bg:#f5f7fa;
    --card:#ffffff;
    --text:#111827;
    --muted:#6b7280;
    --line:#e5e7eb;
    --shadow:0 12px 28px rgba(0,0,0,.08);
    --radius:18px;
    --focus:0 0 0 4px rgba(15,46,85,.12);
    --primary:#0F2E55;
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

  /* 상단 링크 */
  .toplink{
    display:inline-flex;
    align-items:center;
    gap:8px;
    margin-bottom:16px;
    padding:6px 12px;
    border-radius:999px;
    color:var(--primary);
    font-weight:900;
    text-decoration:none;
    transition:background .15s ease, color .15s ease, transform .12s ease;
  }
  .toplink:hover{
    background:var(--primary);
    color:#fff;
    transform:translateX(-2px);
  }

  .card{
    background:var(--card);
    border-radius:var(--radius);
    padding:24px;
    box-shadow:var(--shadow);
    border:1px solid rgba(15,46,85,.08);
    border-top:4px solid var(--primary);
  }

  h2{
    margin:0 0 6px;
    font-size:22px;
    font-weight:900;
    color:var(--primary);
  }

  .desc{
    color:var(--muted);
    font-size:14px;
    margin-bottom:18px;
  }

  /* 폼 */
  .form{
    display:grid;
    gap:16px;
  }

  .field label{
    display:block;
    font-size:13px;
    font-weight:900;
    margin-bottom:8px;
  }

  .control{
    width:100%;
    padding:12px 14px;
    border:1px solid var(--line);
    border-radius:14px;
    font-size:14px;
    outline:none;
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
    margin-top:6px;
    font-size:12px;
    color:var(--muted);
  }

  .grid2{
    display:grid;
    grid-template-columns:1fr 1fr;
    gap:14px;
  }
  @media(max-width:720px){
    .grid2{ grid-template-columns:1fr; }
  }

  /* 버튼 */
  .btns{
    display:flex;
    justify-content:flex-end;
    gap:10px;
    margin-top:6px;
  }

  .btn{
    padding:11px 18px;
    border-radius:14px;
    font-weight:900;
    cursor:pointer;
    border:1px solid var(--line);
    background:#fff;
    color:var(--text);
    text-decoration:none;
    transition:background .15s ease, color .15s ease;
  }

  .btn.primary{
    background:var(--primary);
    color:#fff;
    border-color:var(--primary);
  }
  .btn.primary:hover{ filter:brightness(1.05); }

  .btn.ghost:hover{
    background:#f3f4f6;
  }

  .btn.danger{
    background:#ef4444;
    border-color:#ef4444;
    color:#fff;
  }
  .btn.danger:hover{ filter:brightness(1.05); }

</style>
</head>

<body>
<div class="wrap">

  <a class="toplink" href="/interview/detail?ino=${dto.ino}">← 인터뷰 상세로</a>

  <div class="card">
    <h2>인터뷰 수정 (관리자)</h2>
    <div class="desc">이 페이지는 관리자만 접근 가능합니다.</div>

    <form class="form" method="post" action="/admin/interview/update">
      <input type="hidden" name="ino" value="${dto.ino}">

      <!-- 제목 -->
      <div class="field">
        <label>제목</label>
        <input class="control" type="text" name="ititle" value="${dto.ititle}" required>
      </div>

      <!-- 한줄 요약 -->
      <div class="field">
        <label>한줄 요약</label>
        <input class="control" type="text" name="isummary" value="${dto.isummary}">
      </div>

      <!-- 카테고리 + 썸네일 -->
      <div class="grid2">
        <div class="field">
          <label>카테고리</label>
          <select class="control" name="icategory">
            <option value="">선택</option>
            <option value="서버/백엔드 개발자" ${dto.icategory=='서버/백엔드 개발자'?'selected':''}>서버/백엔드 개발자</option>
            <option value="프론트엔드 개발자" ${dto.icategory=='프론트엔드 개발자'?'selected':''}>프론트엔드 개발자</option>
            <option value="웹 풀스택 개발자" ${dto.icategory=='웹 풀스택 개발자'?'selected':''}>웹 풀스택 개발자</option>
            <option value="안드로이드 개발자" ${dto.icategory=='안드로이드 개발자'?'selected':''}>안드로이드 개발자</option>
            <option value="iOS 개발자" ${dto.icategory=='iOS 개발자'?'selected':''}>iOS 개발자</option>
            <option value="QA 엔지니어" ${dto.icategory=='QA 엔지니어'?'selected':''}>QA 엔지니어</option>
          </select>
        </div>

        <div class="field">
          <label>썸네일 이미지 경로</label>
          <input class="control" type="text" name="iimagePath" value="${dto.iimagePath}">
        </div>
      </div>

      <!-- 태그 -->
      <div class="field">
        <label>태그</label>
        <input class="control" type="text" name="itags" value="${dto.itags}">
      </div>

      <!-- 본문 -->
      <div class="field">
        <label>본문</label>
        <textarea class="control" name="icontent" required>${dto.icontent}</textarea>
      </div>

      <!-- 버튼 -->
      <div class="btns">
        <a class="btn ghost" href="/interview/detail?ino=${dto.ino}">취소</a>
        <button class="btn primary" type="submit">수정 저장</button>
      </div>
    </form>

    <!-- 삭제 -->
    <form method="post" action="/admin/interview/delete" style="text-align:right; margin-top:12px;">
      <input type="hidden" name="ino" value="${dto.ino}">
      <button class="btn danger" type="submit"
              onclick="return confirm('정말 삭제할까요?');">삭제</button>
    </form>

  </div>
</div>
</body>
</html>
