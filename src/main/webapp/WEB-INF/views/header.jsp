<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<link rel="stylesheet" href="/css/common.css">

<div style="background:#fff; border-bottom:1px solid #e5e7eb;">
  <div style="max-width:1120px; margin:0 auto; padding:14px 16px; display:flex; align-items:center; gap:16px;">

    <!-- 로고 -->
    <a href="/" style="display:flex; align-items:center; gap:10px; text-decoration:none;">
      <img src="/images/idoit_logo.png" alt="IDOIT" style="height:56px;">
    </a>

    <!-- 네비(심플) -->
    <div class="header-nav" style="display:flex; 
    					gap:14px; 
    					align-items:center; 
    					font-weight:700; 
    					color:#0b1f3b;">
      <a href="/job_posting/list" style="text-decoration:none; color:#0b1f3b;">채용공고</a>
      <a href="/resume/list" style="text-decoration:none; color:#0b1f3b;">이력서</a>
      <a href="/interview/list" style="text-decoration:none; color:#0b1f3b;">인터뷰</a>
      <a href="/board/list" style="text-decoration:none; color:#0b1f3b;">게시판</a>
      <a href="/notice/list" style="text-decoration:none; color:#0b1f3b;">공지</a>
      <a href="/faq" style="text-decoration:none; color:#0b1f3b;">FAQ</a>
    </div>

    <div style="flex:1;"></div>

    <form action="/search_log/main" method="get"
	      style="display:flex; align-items:center; gap:8px; border:1px solid #d1d5db; border-radius:999px; padding:8px 12px; min-width:320px;">
	  <span style="color:#ff7a1a; font-weight:900;">⌕</span>
	  <input type="text" name="keyword" placeholder="검색어를 입력해주세요"
	         value="${empty param.keyword ? param.q : param.keyword}"
	         style="border:none; outline:none; width:100%; font-size:14px;">
	</form>

    <!-- 우측 메뉴: 권한별 -->
    <div class="header-nav" style="display:flex; gap:10px; align-items:center; margin-left:8px;">
      <sec:authorize access="isAnonymous()">
        <a href="/member/join" style="text-decoration:none; color:#0b1f3b; font-weight:700;">회원가입</a>
        <a href="/member/login"
           style="text-decoration:none; background:#0b1f3b; color:#fff; padding:8px 12px; border-radius:10px; font-weight:800;">
          로그인
        </a>
        <a href="/company/join"
           style="text-decoration:none; border:1px solid #0b1f3b; color:#0b1f3b; padding:8px 12px; border-radius:10px; font-weight:800;">
          기업 서비스
        </a>
      </sec:authorize>

      <sec:authorize access="isAuthenticated()">
        <sec:authorize access="hasRole('ADMIN')">
          <a href="/admin" style="text-decoration:none; color:#ff7a1a; font-weight:900;">관리자</a>
        </sec:authorize>
        <sec:authorize access="hasRole('COMPANY')">
          <a href="/company" style="text-decoration:none; color:#0b1f3b; font-weight:900;">기업페이지</a>
        </sec:authorize>
        <sec:authorize access="hasRole('USER')">
          <a href="/member/mypage" style="text-decoration:none; color:#0b1f3b; font-weight:900;">마이페이지</a>
        </sec:authorize>

        <a href="/logout"
           style="text-decoration:none; background:#ff7a1a; color:#fff; padding:8px 12px; border-radius:10px; font-weight:900;">
          로그아웃
        </a>
      </sec:authorize>
    </div>

  </div>
</div>
