<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원정보 수정</title>
</head>
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
<body>

	<h2>회원정보 수정</h2>
	
	<c:if test="${empty member}">
	  <p>회원 정보를 불러오지 못했습니다.</p>
	</c:if>
	
	<c:if test="${not empty member}">
	<form name="member"  action="/member/mypage/social-edit" method="post">
	  <p>이메일(수정불가): <b>${member.memail}</b></p>
	
	  이름: <input type="text" name="mname" value="${member.mname}" /><br/>
	
	  성별:
		<label>
		  <input type="radio" name="mgender" value="M"
		    <c:if test="${member.mgender == 'M'}">checked</c:if> />
		  남
		</label>
		
		<label>
		  <input type="radio" name="mgender" value="F"
		    <c:if test="${member.mgender == 'F'}">checked</c:if> />
		  여
		</label>
		<br/>
	
	  생년월일:
	  <input type="date" name="mbirth"
	    value="<fmt:formatDate value='${member.mbirth}' pattern='yyyy-MM-dd'/>" /><br/>
	
	  전화번호: <input type="text" name="mtel" value="${member.mtel}" /><br/>
	
	  우편번호: <input type="text" name="mzipcode" value="${member.mzipcode}" redaonly /><br/>
	  <button type="button" class="btn btn-outline" onclick="goPopup()">주소 검색</button>
	  주소: <input type="text" name="maddr" value="${member.maddr}" redaonly /><br/>
	  상세주소: <input type="text" name="maddrdetail" value="${member.maddrdetail}" /><br/>
	
	  <button type="submit">저장</button>
	</form>
	</c:if>

</body>
</html>
