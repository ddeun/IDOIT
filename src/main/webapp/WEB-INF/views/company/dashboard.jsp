<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>기업 페이지</title>

<link rel="stylesheet" href="/css/company.css">
</head>

<body>

  <%@ include file="/WEB-INF/views/header.jsp" %>

  <div class="company-wrap">

    <div class="company-hero">
      <div>
        <h1>기업 페이지</h1>
        <div class="muted" style="color:#d1fae5;">
          공고 등록 · 지원자 확인 · 기업 정보 관리를 진행합니다.
        </div>
      </div>

      <a class="btn btn-primary" href="/job_posting/writeform">공고 등록</a>
    </div>

    <div class="company-grid">

      <!-- 공고 관리 -->
      <a class="company-tile" href="/company/postings">
        <div class="company-tile-title">공고 관리</div>
        <div class="company-tile-desc">내 공고 목록 / 수정 / 삭제</div>
      </a>

      <!-- 회사 정보 -->
      <a class="company-tile" href="/company/mypage">
        <div class="company-tile-title">회사 정보</div>
        <div class="company-tile-desc">회사 소개 / 로고 / 기본 정보 수정</div>
      </a>

    </div>

  </div>

  <%@ include file="/WEB-INF/views/footer.jsp" %>

</body>
</html>
