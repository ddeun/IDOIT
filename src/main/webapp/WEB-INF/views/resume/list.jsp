<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>이력서 관리</title>
<link rel="stylesheet" href="/css/resume_list.css">
</head>
<body>
<%@ include file="/WEB-INF/views/header.jsp" %>

<h1 class="page-title">이력서 관리</h1>

<div class="resume-list">

  <c:choose>
    <c:when test="${empty resumes}">
      <div class="resume-card empty">
        작성한 이력서가 없습니다.
      </div>
    </c:when>

    <c:otherwise>
      <c:forEach var="r" items="${resumes}">
        <div class="resume-card">

          <!-- 점 3개 -->
          <div class="card-more">⋮</div>

          <!-- 제목 -->
          <div class="resume-title">
            <a href="/resume/detail?rno=${r.rno}">
              <c:out value="${r.rtitle}"/>
            </a>
          </div>

          <!-- 희망직무 -->
          <div class="resume-meta">
            희망직무: <c:out value="${r.rjobrole}"/>
          </div>

          <!-- 등록일 -->
          <div class="resume-date">
            <fmt:formatDate value="${r.rcreate}" pattern="yyyy.MM.dd"/> 등록
          </div>

          <!-- 관리 버튼 -->
          <div class="resume-actions">
            <a href="/resume/form/${r.rno}" class="btn-outline">수정</a>

            <form action="/resume/delete" method="post">
              <input type="hidden" name="rno" value="${r.rno}">
              <button type="submit"
                      class="btn-outline"
                      onclick="return confirm('정말 삭제할까요?')">
                삭제
              </button>
            </form>
          </div>

        </div>
      </c:forEach>
    </c:otherwise>
  </c:choose>

  <!-- 새 이력서 -->
  <div class="resume-card add">
    <a href="/resume/form">➕ 새로운 이력서를 추가해보세요!</a>
  </div>

</div>

<button type="button" class="mypage-btn" onclick="location.href='/member/mypage'">마이페이지로</button>

<%@ include file="/WEB-INF/views/footer.jsp" %>
</body>
</html>
