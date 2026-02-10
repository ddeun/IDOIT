<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>FAQ</title>
  <link rel="stylesheet" href="/css/faq_main.css">
</head>
<body>

<%@ include file="/WEB-INF/views/header.jsp" %>

<h2 class="faq-main-title">자주 묻는 질문 FAQ</h2>

<div class="faq-main-box">

  <!-- 네이비 메인 영역 -->
  <div class="faq-main-navy">

    <!-- 왼쪽 영역 -->
    <div class="faq-main-left">
      <h3>다른 질문이 있어요!</h3>
      <p class="faq-email">✉ tt2279@naver.com</p>
    </div>

    <!-- 오른쪽 영역 -->
    <div class="faq-main-right">
      <form action="/faq/list" method="get">
        <button type="submit" class="faq-main-link">
          자주 묻는 질문 보러가기
        </button>
      </form>
    </div>

  </div>

</div>

<div class="faq-main-footer">
  <a href="/" class="faq-back-link">메인으로 돌아가기</a>
</div>

<%@ include file="/WEB-INF/views/footer.jsp" %>

</body>
</html>
