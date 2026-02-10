<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공지</title>
<link rel="stylesheet" href="/css/notice_list.css">
</head>
<body>

<%@ include file="/WEB-INF/views/header.jsp" %>

<!-- ===== 전체 래퍼 ===== -->
<div class="board-wrap">
  <div class="board-container">

    <!-- ===== 헤더 ===== -->
    <div class="board-header">
      <div class="board-title">공지 사항</div>
    </div>

    <!-- ===== 테이블 ===== -->
    <table class="board-table">
      <thead>
        <tr>
          <th>제목</th>
          <th>작성일</th>
        </tr>
      </thead>

      <tbody>
        <c:forEach var="n" items="${list}">
          <tr>
            <td class="title">
              <c:if test="${n.npin == 'Y'}">&#128204;</c:if>
              <a href="/notice/detail?nno=${n.nno}">
                ${n.ntitle}
              </a>
            </td>
            <td>
              <fmt:formatDate value="${n.ndate}" pattern="yyyy-MM-dd"/>
            </td>
          </tr>
        </c:forEach>
      </tbody>
    </table>
  </div>
</div>

<%@ include file="/WEB-INF/views/footer.jsp" %>

</body>
</html>
