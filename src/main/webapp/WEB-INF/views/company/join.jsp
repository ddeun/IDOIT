<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>기업 회원가입</title>
<link rel="stylesheet" href="/css/join.css">

<script>
	function goPopup(){
	   var pop = window.open("jusopopup","pop","width=570,height=420,scrollbars=yes,resizable=yes")
	}
	function jusoCallBack(czipcode, caddr, caddrdetail){
	 document.company.czipcode.value = czipcode;
	 document.company.caddr.value = caddr;
	 document.company.caddrdetail.value = caddrdetail;
	}
	
	  function checkMember() {
	        let f = document.company;

	        let memail = f.memail.value.trim();
	        let mpasswd = f.mpasswd.value.trim();
	        let mpasswd2 = f.mpasswd2.value.trim();
	        let cbizno = f.cbizno.value.trim();
	        let cname = f.cname.value.trim();
	        let czipcode = f.czipcode.value.trim();
	        let caddr = f.caddr.value.trim();
	        let cestablish = f.cestablish.value;

	        /* 정규식 */
	        let regExpEmail = /^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/;
	        let regExpPw = /^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d!?@#+]{8,16}$/;
	        let regExpCbizno = /^\d{10}$/;

	        /* 이메일 */
	        if (memail === "") {
	            alert("이메일을 입력해주세요.");
	            f.memail.focus();
	            return false;
	        }
	        if (!regExpEmail.test(memail)) {
	            alert("이메일 형식이 올바르지 않습니다.");
	            f.memail.focus();
	            return false;
	        }

	        /* 비밀번호 */
	        if (mpasswd === "") {
	            alert("비밀번호를 입력해주세요.");
	            f.mpasswd.focus();
	            return false;
	        }
	        if (!regExpPw.test(mpasswd)) {
	            alert("비밀번호는 영문, 숫자, 특수문자 포함 8~16자입니다.");
	            f.mpasswd.focus();
	            return false;
	        }
	        if (mpasswd !== mpasswd2) {
	            alert("비밀번호와 비밀번호 확인이 일치하지 않습니다.");
	            f.mpasswd2.focus();
	            return false;
	        }

	        /* 사업자번호 */
	        if (!regExpCbizno.test(cbizno)) {
	            alert("사업자번호는 숫자 10자리로 입력해주세요.");
	            f.cbizno.focus();
	            return false;
	        }

	        /* 회사명 */
	        if (cname === "") {
	            alert("회사명을 입력해주세요.");
	            f.cname.focus();
	            return false;
	        }

	        /* 주소 */
	        if (czipcode === "" || caddr === "") {
	            alert("주소 검색을 완료해주세요.");
	            return false;
	        }

	        /* 설립일 */
	        if (cestablish === "") {
	            alert("설립일을 선택해주세요.");
	            f.cestablish.focus();
	            return false;
	        }

	        return true; //
}
</script>	
</head>
<body>

<%@ include file="/WEB-INF/views/header.jsp" %>

<div class="join-wrap">
  <div class="join-card">

    <div class="join-title">기업 회원가입</div>
    <div class="join-desc">
      기업 정보를 등록하고 채용 공고를 관리해보세요.
    </div>

    <form name="company" action="/company/join" method="post" onsubmit="return checkMember()">

      <div class="join-field">
        <label>기업 이메일</label>
        <input type="text" name="memail" placeholder="example@company.com">
      </div>

      <div class="join-field">
        <label>비밀번호</label>
        <input type="password" name="mpasswd">
      </div>
      
      <div class="join-field">
        <label>비밀번호 확인</label>
        <input type="password" name="mpasswd2">
      </div>

      <div class="join-field">
        <label>사업자번호</label>
        <input type="text" name="cbizno">
      </div>

      <div class="join-field">
        <label>회사명</label>
        <input type="text" name="cname">
      </div>

      <div class="join-field">
        <label>주소</label>
        <input type="text" name="czipcode" placeholder="우편번호" readonly>
        <button type="button" class="btn btn-outline" onclick="goPopup()">주소 검색</button>
        <input type="text" name="caddr" placeholder="주소" readonly>
        <input type="text" name="caddrdetail" placeholder="상세주소">
      </div>

      <div class="join-field">
        <label>홈페이지</label>
        <input type="text" name="cpage" placeholder="https://">
      </div>

      <div class="join-field">
        <label>설립일</label>
        <input type="date" name="cestablish">
      </div>

      <input type="hidden" name="mtype" value="COMPANY">

      <button type="submit" class="btn btn-primary join-btn">
        기업 회원가입
      </button>

    </form>
  </div>
</div>

<%@ include file="/WEB-INF/views/footer.jsp" %>

</body>
</html>
