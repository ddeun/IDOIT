<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회사 정보 수정</title>

<style>
  :root{
    --base:#0F2E55;
    --bg:#F5F7FA;
    --card:#fff;
    --line:#E5E7EB;
    --text:#111827;
    --muted:#6B7280;
    --accent:#E6EEF8;
  }

  body{
    margin:0;
    font-family:'Segoe UI','Apple SD Gothic Neo',sans-serif;
    background:var(--bg);
    color:var(--text);
  }

  .wrap{
    max-width:800px;
    margin:30px auto;
    padding:0 18px 60px;
  }

  h2{
    margin-bottom:6px;
    font-size:22px;
    font-weight:900;
    color:var(--base);
  }

  .sub{
    font-size:13px;
    color:var(--muted);
    margin-bottom:16px;
  }

  .card{
    background:var(--card);
    border:1px solid var(--line);
    border-radius:16px;
    padding:20px;
    box-shadow:0 10px 22px rgba(0,0,0,.06);
  }

  .field{margin-bottom:14px;}
  label{
    display:block;
    font-size:13px;
    font-weight:900;
    margin-bottom:6px;
    color:var(--base);
  }

  input, textarea{
    width:100%;
    padding:10px 12px;
    border-radius:10px;
    border:1px solid var(--line);
    font-size:14px;
    box-sizing:border-box;
  }

  textarea{resize:vertical; min-height:100px;}

  .inline{
    display:flex;
    align-items:center;
    gap:10px;
  }

  .btns{
    margin-top:20px;
    display:flex;
    gap:10px;
  }

  .btn{
    padding:10px 14px;
    border-radius:10px;
    font-weight:900;
    text-decoration:none;
    border:1px solid rgba(15,46,85,.35);
    background:#fff;
    color:var(--base);
    cursor:pointer;
  }

  .btn.primary{
    background:var(--base);
    color:#fff;
    border:none;
  }

  .btn:hover{background:var(--accent);}
  .btn.primary:hover{background:#163B6A;}
</style>

<script>
  function toggleEstablish(cb){
    document.getElementById('cestablish').disabled = !cb.checked;
    if(!cb.checked){
      document.getElementById('cestablish').value = '';
    }
  }
</script>
</head>

<body>
<%@ include file="/WEB-INF/views/header.jsp" %>

<div class="wrap">

  <h2>회사 정보 수정</h2>
  <div class="sub">수정하고 싶은 항목만 변경하세요.</div>

  <div class="card">
    <form action="/company/update" method="post">

      <!-- 🔑 필수 -->
      <input type="hidden" name="cno" value="${c.cno}" />

      <div class="field">
        <label>회사명</label>
        <input type="text" name="cname" value="${c.cname}" required>
      </div>

      <div class="field">
        <label>사업자번호</label>
        <input type="text" name="cbizno" value="${c.cbizno}">
      </div>

      <div class="field">
        <label>주소</label>
        <input type="text" name="caddr" value="${c.caddr}">
      </div>

      <div class="field">
        <label>상세주소</label>
        <input type="text" name="caddrdetail" value="${c.caddrdetail}">
      </div>

      <div class="field">
        <label>홈페이지</label>
        <input type="text" name="cpage" value="${c.cpage}">
      </div>

      <div class="field">
        <label>회사 소개</label>
        <textarea name="ccontent">${c.ccontent}</textarea>
      </div>

      <!-- ✅ 설립일: 선택 수정 -->
      <div class="field">
        <label>설립일 (선택)</label>
        <div class="inline">
          <input type="checkbox" id="useEst" onclick="toggleEstablish(this)">
          <span style="font-size:13px;color:var(--muted);">수정할 때만 체크</span>
        </div>
        <input type="date" id="cestablish" name="cestablish" disabled>
      </div>

      <div class="btns">
        <button class="btn primary" type="submit">수정 저장</button>
        <a class="btn" href="/company/mypage">취소</a>
      </div>

    </form>
  </div>

</div>

<%@ include file="/WEB-INF/views/footer.jsp" %>
</body>
</html>
