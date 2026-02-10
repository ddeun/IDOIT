<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>마이 페이지</title>
<link rel="stylesheet" href="/css/mypage.css">
</head>
<body>
<%@ include file="/WEB-INF/views/header.jsp" %>
<div class="mypage-wrap">

  <h2 class="mypage-title">마이페이지</h2>

  <div class="mypage-card">

    <div class="info-row">
      <span class="label">이메일</span>
      <span class="value">${member.memail}</span>
    </div>

    <div class="info-row">
      <span class="label">이름</span>
      <span class="value">${member.mname}</span>
    </div>

    <div class="info-row">
      <span class="label">성별</span>
      <span class="value">${member.mgender}</span>
    </div>

    <div class="info-row">
      <span class="label">생년월일</span>
      <span class="value">${member.mbirth}</span>
    </div>

    <div class="info-row">
      <span class="label">전화번호</span>
      <span class="value">${member.mtel}</span>
    </div>

    <div class="info-row">
      <span class="label">우편번호</span>
      <span class="value">${member.mzipcode}</span>
    </div>

    <div class="info-row">
      <span class="label">주소</span>
      <span class="value">${member.maddr}</span>
    </div>

    <div class="info-row">
      <span class="label">상세주소</span>
      <span class="value">${member.maddrdetail}</span>
    </div>

    <div class="info-row">
      <span class="label">회원 종류</span>
      <span class="value">${member.mtype}</span>
    </div>

    <div class="info-row">
      <span class="label">가입일</span>
      <span class="value">${member.mcreate}</span>
    </div>

    <div class="mypage-actions">

  <form action="/member/mypage/edit" method="get">
    <button type="submit" class="btn-outline">
      회원정보 수정
    </button>
  </form>

  <form action="/member/mypage/withdraw" method="post"
      onsubmit="return confirm('정말 회원 탈퇴하시겠습니까? 이 작업은 되돌릴 수 없습니다.');">

  <button type="submit" class="btn btn-danger">
    회원 탈퇴
    </button>
  </form>

</div>
  </div>
</div>
<%@ include file="/WEB-INF/views/footer.jsp" %>
</body>
</html>