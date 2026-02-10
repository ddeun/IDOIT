<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>기업회원 정보</title>
</head>
<body>
	<h1>기업 회원 관리</h1>
	
	<table>
	  <thead>
	    <tr>
	      <th>회원번호</th>
	      <th>기업 이메일</th>
	      <th>기업명</th>
	      <th>연락처</th>
	      <th>상태</th>
	      <th>권한</th>
	      <th>가입일</th>
	      <th>삭제</th>
	    </tr>
	  </thead>
	
	  <tbody>
	    <c:choose>
	      <c:when test="${empty companies}">
	        <tr>
	          <td colspan="8">기업 회원이 없습니다.</td>
	        </tr>
	      </c:when>
	
	      <c:otherwise>
	        <c:forEach var="c" items="${companies}">
	          <tr>
	            <td>${c.mno}</td>
	            <td>${c.memail}</td>
	            <td>${c.mname}</td>
	            <td>${c.mtel}</td>
	            <td>${c.mstatus}</td>
	            <td>${c.mauth}</td>
	            <td>
	              <fmt:formatDate value="${c.mcreate}" pattern="yyyy-MM-dd"/>
	            </td>
	            <td>
			      <form action="/admin/companies/delete" method="post" style="display:inline;">
					  <input type="hidden" name="cno" value="${c.cno}">
					  <button type="submit" onclick="return confirm('정말 삭제할까요?')">삭제</button>
			      </form>
	            </td>
	          </tr>
	        </c:forEach>
	      </c:otherwise>
	    </c:choose>
	  </tbody>
	</table>
	
	<br>
	
	<a href="/admin">관리자 메인으로</a>
</body>
</html>