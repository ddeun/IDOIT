<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>통합 게시판</title>
<link rel="stylesheet" href="/css/board_list.css">
</head>

<body>
<%@ include file="/WEB-INF/views/header.jsp" %>

<div class="board-wrap">
  <div class="board-container">

    <!-- 헤더 -->
    <div class="board-header">
      <div class="board-title">통합 게시판</div>
    </div>

    <!-- 카테고리 -->
    <div class="board-category">
      <a href="/board/list" class="${empty selectedType ? 'active' : ''}">전체</a>
      <a href="/board/list?btype=FREE" class="${selectedType == 'FREE' ? 'active' : ''}">자유</a>
      <a href="/board/list?btype=STUDY" class="${selectedType == 'STUDY' ? 'active' : ''}">스터디</a>
      <a href="/board/list?btype=REVIEW" class="${selectedType == 'REVIEW' ? 'active' : ''}">취업후기</a>
    </div>
    
    <c:if test="${not empty selectedType}">
          <input type="hidden" name="btype" value="${selectedType}">
        </c:if>
	
	<div class="board-search">
      <form method="get" action="/board/list">
        <select name="searchType">
          <option value="title" ${searchType == 'title' ? 'selected' : ''}>제목</option>
          <option value="writer" ${searchType == 'writer' ? 'selected' : ''}>작성자</option>
          <option value="content" ${searchType == 'content' ? 'selected' : ''}>내용</option>
        </select>

        <input type="text"
               name="keyword"
               value="${keyword}"
               placeholder="검색어를 입력하세요">

        <button type="submit">검색</button>
      </form>
    </div>

    <!-- 테이블 -->
    <table class="board-table">
      <thead>
        <tr>
          <th width="10%">번호</th>
          <th width="40%">제목</th>
          <th width="20%">작성자</th>
          <th width="20%">작성일</th>
          <th width="10%">조회수</th>
        </tr>
      </thead>
      <tbody>
        <c:choose>
          <c:when test="${empty boardList}">
            <tr>
              <td colspan="5" align="center">게시글이 없습니다.</td>
            </c:when>
          <c:otherwise>
            <c:forEach var="board" items="${boardList}">
              <tr>
                <td align="center">${board.bno}</td>
                <td class="title">
                  <a href="/board/detail?bno=${board.bno}">
                    ${board.btitle}
                  </a>
                </td>
                <td align="center">${board.bwriter}</td>
                <td align="center">
                  <fmt:formatDate value="${board.bcreate}" pattern="yyyy-MM-dd"/>
                </td>
                <td align="center">${board.bview}</td>
              </tr>
            </c:forEach>
          </c:otherwise>
        </c:choose>
      </tbody>
    </table>

    <!-- 하단 -->
    <div class="board-footer">
      <a href="/" class="btn-outline">홈으로</a>
      <a href="/board/write" class="btn-primary">글쓰기</a>
    </div>

  </div>
</div>

<%@ include file="/WEB-INF/views/footer.jsp" %>
</body>
</html>
