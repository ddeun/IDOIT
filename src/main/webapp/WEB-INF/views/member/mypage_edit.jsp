<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원정보 수정</title>
<!-- member-edit.css 연결 -->
<link rel="stylesheet" href="/css/mypage_edit.css">
<script>
	function goPopup(){
	   var pop = window.open("/member/mypage/jusopopup","pop","width=570,height=420,scrollbars=yes,resizable=yes")
		}
	function jusoCallBack(mzipcode, maddr, maddrdetail){
	 document.member.mzipcode.value = mzipcode;
	 document.member.maddr.value = maddr;
	 document.member.maddrdetail.value = maddrdetail;
	}
</script>
</head>
<body>
<%@ include file="/WEB-INF/views/header.jsp" %>
<div class="edit-wrap">

  <h2 class="edit-title">회원정보 수정</h2>

  <c:if test="${empty member}">
    <p style="text-align:center;">회원 정보를 불러오지 못했습니다.</p>
  </c:if>

  <c:if test="${not empty member}">
    <div class="edit-card">
      <form name="member" action="/member/mypage/edit" method="post">

        <!-- 이메일 -->
        <div class="edit-row">
          <div class="edit-label">이메일</div>
          <div class="edit-value"><b>${member.memail}</b></div>
        </div>

        <!-- 회원종류 -->
        <div class="edit-row">
          <div class="edit-label">회원종류</div>
          <div class="edit-value"><b>${member.mtype}</b></div>
        </div>

        <!-- 이름 -->
        <div class="edit-row">
          <div class="edit-label">이름</div>
          <input type="text" name="mname" value="${member.mname}">
        </div>

        <!-- 성별 -->
        <div class="edit-row">
          <div class="edit-label">성별</div>
          <div class="edit-radio-group">
            <label>
              <input type="radio" name="mgender" value="M" disabled
                <c:if test="${member.mgender == 'M'}">checked</c:if>>
              남
            </label>

            <label>
              <input type="radio" name="mgender" value="F" disabled
                <c:if test="${member.mgender == 'F'}">checked</c:if>>
              여
            </label>
          </div>
        </div>

        <!-- 생년월일 -->
        <div class="edit-row">
          <div class="edit-label">생년월일</div>
          <input type="date"
       value="<fmt:formatDate value='${member.mbirth}' pattern='yyyy-MM-dd'/>"
       readonly disabled>
        </div>

        <!-- 전화번호 -->
        <div class="edit-row">
          <div class="edit-label">전화번호</div>
          <input type="text" name="mtel" value="${member.mtel}">
        </div>

        <!-- 우편번호 -->
        <div class="edit-row">
          <div class="edit-label">우편번호</div>
          <input type="text" name="mzipcode" id="mzipcode" value="${member.mzipcode}" redaonly>
          <button type="button" class="btn btn-outline" onclick="goPopup()">주소 검색</button>
        </div>

        <!-- 주소 -->
        <div class="edit-row">
          <div class="edit-label">주소</div>
          <input type="text" name="maddr" id="maddr" value="${member.maddr}" redaonly>
        </div>

        <!-- 상세주소 -->
        <div class="edit-row">
          <div class="edit-label">상세주소</div>
          <input type="text" name="maddrdetail" value="${member.maddrdetail}">
        </div>

        <!-- 저장 버튼 -->
        <div class="edit-actions">
          <button type="submit" class="btn-save">저장</button>
          <input type="button" class="btn-cancel" value="수정취소" onclick="location.href='/member/mypage';">
        </div>

      </form>
    </div>
  </c:if>

</div>
<%@ include file="/WEB-INF/views/footer.jsp" %>

</body>
</html>
