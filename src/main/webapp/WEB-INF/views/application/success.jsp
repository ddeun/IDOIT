<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>지원 완료</title>
<style>
  body{margin:0; font-family:'Segoe UI','Apple SD Gothic Neo',sans-serif; background:#F5F7FA;}
  .wrap{max-width:700px; margin:40px auto; padding:0 18px;}
  .card{background:#fff; border:1px solid #E5E7EB; border-radius:18px; padding:22px; box-shadow:0 10px 22px rgba(0,0,0,.06);}
  h2{margin:0 0 10px; color:#0F2E55;}
  .muted{color:#6B7280; font-size:14px; line-height:1.6;}
  .row{margin-top:18px; display:flex; gap:10px; flex-wrap:wrap;}
  .btn{display:inline-flex; padding:10px 14px; border-radius:10px; font-weight:900; text-decoration:none;}
  .btn.primary{background:#0F2E55; color:#fff;}
  .btn.primary:hover{background:#163B6A;}
  .btn.ghost{border:1px solid rgba(15,46,85,.25); color:#0F2E55; background:#fff;}
</style>
</head>
<body>
<%@ include file="/WEB-INF/views/header.jsp" %>

<div class="wrap">
  <div class="card">
    <h2>지원이 완료되었습니다 ✅</h2>
    <div class="muted">
      기업에서 검토 후 결과가 업데이트됩니다.<br/>
      공고 상세로 돌아가거나, 내 지원내역에서 확인할 수 있어요.
    </div>

    <div class="row">
      <a class="btn ghost" href="/job_posting/detail/${jno}">공고 상세로</a>
      <a class="btn primary" href="/application/my">내 지원내역</a>
    </div>
  </div>
</div>

<%@ include file="/WEB-INF/views/footer.jsp" %>
</body>
</html>
