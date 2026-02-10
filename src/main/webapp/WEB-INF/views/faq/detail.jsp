<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>${faq.fquestion}</title>
  <link rel="stylesheet" href="/css/faq_detail.css">
</head>
<body>

<%@ include file="/WEB-INF/views/header.jsp" %>

<div class="guide-wrap">

  <!-- 질문 제목 (Q 표시는 CSS에서 처리) -->
  <h1 class="guide-title guide-question">
    ${faq.fquestion}
  </h1>

  <!-- 본문 -->
  <div class="guide-content">
    <p>
      ${faq.fanswer}
    </p>

    <div class="guide-contact">
     더 자세한 문의는 아래로 연락주세요.<br/>
     ✉ tt2279@naver.com
   </div>
  </div>

</div>

<%@ include file="/WEB-INF/views/footer.jsp" %>

</body>
</html>
