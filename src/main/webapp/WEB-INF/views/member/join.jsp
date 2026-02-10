<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원가입</title>

<link rel="stylesheet" href="/css/join.css">

<script>
	function goPopup(){
	   var pop = window.open("jusopopup","pop","width=570,height=420,scrollbars=yes,resizable=yes")
	}
	function jusoCallBack(mzipcode, maddr, maddrdetail){
	 document.member.mzipcode.value = mzipcode;
	 document.member.maddr.value = maddr;
	 document.member.maddrdetail.value = maddrdetail;
	}
function checkMember() {
	let f = document.member;

    let memail = f.memail.value.trim();
    let mpasswd = f.mpasswd.value.trim();
    let mpasswd2 = f.mpasswd2.value.trim();
    let mname = f.mname.value.trim();
    let mbirth = f.mbirth.value;
    let mtel = f.mtel.value.replace(/-/g, "");
    let mgender = f.mgender.value;
    let mzipcode = f.mzipcode.value;
    let maddr = f.maddr.value;

    let regExpEmail = /^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/;
    let regExpPw = /^[A-Za-z\d!?@#+]{8,16}$/;
    let regExpName = /^[가-힣a-zA-Z]{2,}$/;
    let regExpTel = /^01[016789]\d{7,8}$/;

    if (!regExpEmail.test(memail)) { alert("이메일을 입력해주세요."); return false; }
    if (!regExpPw.test(mpasswd)) { alert("비밀번호는 영문, 숫자, 특수문자 포함 8~16자입니다."); return false; }
    if (mpasswd !== mpasswd2) { alert("비밀번호와 비밀번호 확인이 일치하지 않습니다."); return false; }
    if (!regExpName.test(mname)) { alert("이름을 입력하세요."); return false; }
    if (!mgender) { alert("성별을 선택하세요."); return false; }
    if (mbirth === "") { alert("생년월일을 선택하세요."); return false; }
    if (!regExpTel.test(mtel)) { alert("전화번호를 입력하세요."); return false; }
    if (mzipcode === "" || maddr === "") { alert("주소 검색을 통해 주소를 입력하세요."); return false; }

    return true;
}
</script>
</head>

<body>

<%@ include file="/WEB-INF/views/header.jsp" %>

<div class="join-wrap">
  <div class="join-card">

    <div class="join-title">개인 회원가입</div>
    <div class="join-desc">
      기본 정보를 입력하고 IDOIT 서비스를 이용해보세요.
    </div>

    <form name="member" action="/member/join" method="post" onsubmit="return checkMember()">

      <div class="join-field">
        <label>이메일</label>
        <input type="email" name="memail" placeholder="example@email.com">
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
        <label>이름</label>
        <input type="text" name="mname">
      </div>

      <div class="join-field">
        <label>성별</label>
        <div style="display:flex; gap:12px; margin-top:4px;">
          <label><input type="radio" name="mgender" value="M"> 남</label>
          <label><input type="radio" name="mgender" value="F"> 여</label>
        </div>
      </div>

      <div class="join-field">
        <label>생년월일</label>
        <input type="date" name="mbirth">
      </div>

      <div class="join-field">
        <label>전화번호</label>
        <input type="text" name="mtel" placeholder="01012345678">
      </div>

      <div class="join-field">
        <label>주소</label>
        <div style="display:flex; gap:8px;">
          <input type="text" name="mzipcode" placeholder="우편번호" readonly>
          <button type="button" class="btn btn-outline" onclick="goPopup()">주소 검색</button>
        </div>
        <input type="text" name="maddr" placeholder="주소" readonly>
        <input type="text" name="maddrdetail" placeholder="상세주소">
      </div>

      <input type="hidden" name="mtype" value="USER">

      <button type="submit" class="btn btn-primary join-btn">회원가입</button>
      <button type="reset" class="btn btn-outline join-btn" onclick="location.href='/'">취소</button>

    </form>
  </div>
</div>

<%@ include file="/WEB-INF/views/footer.jsp" %>

</body>
</html>
