<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>FAQ</title>
<link rel="stylesheet" href="/css/faq_list.css">
</head>
	<body>
	<%@ include file="/WEB-INF/views/header.jsp" %>
	<h2 class="faq-list-title">자주 묻는 질문</h2>
			<!-- 검색 영역 -->
			<div class="faq-search">
			  <form method="get" action="/faq/list">
			    <input type="text"
			           name="keyword"
			           value="${keyword}"
			           placeholder="궁금한 내용을 검색하세요">
			    <button type="submit">검색</button>
			  </form>
			</div>
			
			<div class="faq-accordion">
			
			  <c:forEach var="entry" items="${faqMap}">
			    <c:set var="category" value="${entry.key}" />
			    <c:set var="faqs" value="${entry.value}" />
			
			    <!-- 카테고리 블록 -->
			    <div class="faq-category">
			
			      <!-- 카테고리 버튼 -->
			      <button type="button" class="faq-category-btn">
			        <span class="arrow">▼</span>
			        ${category}
			        <span class="count">(${faqs.size()})</span>
			      </button>
			
			      <!-- 질문 리스트 -->
			      <ul class="faq-question-list">
			        <c:forEach var="faq" items="${faqs}">
			          <li>
			            <a href="/faq/detail?fno=${faq.fno}"> ${faq.fquestion}</a>
			          </li>
			        </c:forEach>
			      </ul>
			
			    </div>
			  </c:forEach>
			
			</div>
			
			<div class="faq-list-footer">
			  <a href="/faq">FAQ 메인으로 돌아가기</a>
			</div>
		
		<script>
		  document.querySelectorAll(".faq-category-btn").forEach(btn => {
		    btn.addEventListener("click", () => {
		      const category = btn.closest(".faq-category");
		      category.classList.toggle("open");
		    });
		  });
		</script>
	<%@ include file="/WEB-INF/views/footer.jsp" %>
	</body>

</html>


