<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
<title>FAQ</title>
	<link rel="stylesheet" href="/css/faq_write.css">
</head>
<body>
<%@ include file="/WEB-INF/views/header.jsp" %>
<h2 class="faq-title">FAQ 등록</h2>

<div class="faq-box">

<form method="post" action="/admin/faq/write">

    <table class="faq-form-table">

        <tr>
            <th>카테고리</th>
            <td>
                <select name="fcategory">
                    <option value="계정">계정</option>
                    <option value="이력서">이력서</option>
                    <option value="지원현황">지원현황</option>
                    <option value="기타">기타</option>
                </select>
            </td>
        </tr>

        <tr>
            <th>질문</th>
            <td>
                <input type="text" name="fquestion" placeholder="예) 비밀번호를 잊어버렸어요" required>
            </td>
        </tr>
        <tr>
            <th>답변</th>
            <td>
                <textarea name="fanswer" placeholder="답변을 입력하세요" required></textarea>
            </td>
        </tr>
    </table>
    <div class="faq-form-footer">
    	<button type="button" class="btn-outline" onclick="location.href='/admin/faq'">취소</button>
        <button type="submit" class="btn-primary">등록</button>
    </div>
</form>
</div>
<%@ include file="/WEB-INF/views/footer.jsp" %>
</body>

</html>
