<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
<title>FAQ 관리</title>
<link rel="stylesheet" href="/css/faq_manage.css">
</head>
<body>
<%@ include file="/WEB-INF/views/header.jsp" %>

<div class="admin-wrap">
	<h2>FAQ 관리</h2>
	
	<div class="admin-action-bar">
	  <a href="/admin/faq/write" class="btn-admin-create">FAQ 등록</a>
	</div>
	
	<table border="1" width="100%">
	    <thead>
	        <tr>
	            <th width="10%">번호</th>
	            <th width="20%">카테고리</th>
	            <th>질문</th>
	            <th width="15%">등록일</th>
	            <th width="10%">관리</th>
	        </tr>
	    </thead>
	
	    <tbody>
	        <c:forEach var="faq" items="${list}">
	            <tr>
	                <td align="center">${faq.fno}</td>
	                <td align="center">${faq.fcategory}</td>
	                <td>${faq.fquestion}</td>
	                <td align="center">
	                    <fmt:formatDate value="${faq.fcreate}" pattern="yyyy-MM-dd"/>
	                </td>
	                <td align="center">
					<div class="faq-action">
						<a href="/admin/faq/update?fno=${faq.fno}" class="btn btn-outline">수정</a>
					
					    <form method="post" action="/admin/faq/delete" onsubmit="return confirm('이 FAQ를 삭제하시겠습니까?');">
					      <input type="hidden" name="fno" value="${faq.fno}">
					      <button type="submit" class="btn btn-primary">삭제</button>
					    </form>
					  </div>
					</td>
	            </tr>
	        </c:forEach>
	
	        <c:if test="${empty list}">
	            <tr>
	                <td colspan="5" align="center">
	                    등록된 FAQ가 없습니다.
	                </td>
	            </tr>
	        </c:if>
	    </tbody>
	</table>
	<div class="admin-footer">
	    <a href="/admin" class="btn">관리자 홈</a>
	</div>
</div>
<%@ include file="/WEB-INF/views/footer.jsp" %>
	</body>
</html>