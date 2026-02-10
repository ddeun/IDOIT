<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
<title>FAQ 수정</title>
<link rel="stylesheet" href="/css/faq_write.css">
</head>
<body>
<%@ include file="/WEB-INF/views/header.jsp" %>
<h2 class="faq-title">FAQ 수정</h2>
<div class="faq-box">
  <form method="post" action="/admin/faq/update">

    <input type="hidden" name="fno" value="${faq.fno}">

    <table class="faq-form-table">
      <tr>
        <th>카테고리</th>
        <td>
          <select name="fcategory">
            <option value="계정" ${faq.fcategory == '계정' ? 'selected' : ''}>계정</option>
            <option value="이력서" ${faq.fcategory == '이력서' ? 'selected' : ''}>이력서</option>
            <option value="지원현황" ${faq.fcategory == '지원현황' ? 'selected' : ''}>지원현황</option>
            <option value="기타" ${faq.fcategory == '기타' ? 'selected' : ''}>기타</option>
          </select>
        </td>
      </tr>

      <tr>
        <th>질문</th>
        <td>
          <input type="text" name="fquestion" value="${faq.fquestion}" required>
        </td>
      </tr>
      <tr>
        <th>답변</th>
        <td>
          <textarea name="fanswer" required>${faq.fanswer}</textarea>
        </td>
      </tr>
    </table>
    <div class="faq-form-footer">
      <button type="submit" class="btn-primary">수정</button>
      <button type="button" class="btn-outline" onclick="location.href='/admin/faq';">취소</button>
    </div>
  </form>
</div>
<%@ include file="/WEB-INF/views/footer.jsp" %>
</body>

</html>