<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인</title>
<link rel="stylesheet" href="/css/login.css">
<script>
/* 로그인 유효성 검사 */
document.addEventListener("DOMContentLoaded", function () {
    const form = document.querySelector("form[action='/j_spring_security_check']");

    form.addEventListener("submit", function (e) {
        const emailInput = form.querySelector("input[name='j_username']");
        const pwInput = form.querySelector("input[name='j_password']");

        const email = emailInput.value.trim();
        const password = pwInput.value.trim();

        if (email === "") {
            alert("아이디(이메일)를 입력해주세요.");
            emailInput.focus();
            e.preventDefault();
            return;
        }

        if (password === "") {
            alert("비밀번호를 입력해주세요.");
            pwInput.focus();
            e.preventDefault();
            return;
        }
    });
});
</script>

</head>

<body style="background:var(--bg);">

 <!-- 로그인 실패 시 알림 (Spring Security error=true) -->
  <c:if test="${param.blocked == 'true'}">
  <script>alert("비활성화된 계정입니다. 관리자에게 문의해주세요.");</script>
  </c:if>

  <c:if test="${param.error == 'true' && param.blocked != 'true'}">
  <script>alert("아이디 또는 비밀번호가 올바르지 않습니다.");</script>
  </c:if>


  <%@ include file="/WEB-INF/views/header.jsp" %>

  <div class="login-wrap">
    <div class="login-card">

      <div class="tabs">
        <div id="tabPersonal" class="tab on" onclick="setType('PERSONAL')">개인회원</div>
        <div id="tabCompany" class="tab" onclick="setType('COMPANY')">기업회원</div>
      </div>

      <form action="/j_spring_security_check" method="post">
        <!-- 이 값으로 개인/기업 구분 -->
        <input type="hidden" name="loginType" id="loginType" value="PERSONAL">

        <div class="field">
          <label>아이디(이메일)</label>
          <input class="input" type="text" name="j_username" id="emailInput" placeholder="이메일을 입력하세요">
        </div>

        <div class="field">
          <label>비밀번호</label>
          <input class="input" type="password" name="j_password" placeholder="비밀번호를 입력하세요">
        </div>

        <div class="row">
		  <label>
		    <input type="checkbox" id="rememberMe" name="remember-me">
		    로그인 유지
		  </label>
		
		  <label>
		    <input type="checkbox" id="saveId">
		    아이디 저장
		  </label>
		
		  <div style="flex:1;"></div>
		</div>


        <button type="submit" class="btn btn-primary login-btn">로그인</button>

        <div class="hint" id="joinHint">
          아직 계정이 없나요? <a href="/member/join">개인 회원가입</a>
        </div>
      </form>

      <div class="divider">소셜 계정으로 간편 로그인</div>

      <div class="social">
		  <a href="${pageContext.request.contextPath}/oauth2/authorization/kakao"
		     class="social-btn kakao">
		    <img src="/images/kakao_login.png" alt="카카오 로그인">
		  </a>
	  </div>

    </div>
  </div>

<script>
  function setType(type){
    document.getElementById('loginType').value = type;

    const p = document.getElementById('tabPersonal');
    const c = document.getElementById('tabCompany');

    if(type === 'PERSONAL'){
      p.classList.add('on'); c.classList.remove('on');
      document.getElementById('joinHint').innerHTML =
        '아직 계정이 없나요? <a href="/member/join">개인 회원가입</a>';
    } else {
      c.classList.add('on'); p.classList.remove('on');
      document.getElementById('joinHint').innerHTML =
        '아직 계정이 없나요? <a href="/company/join">기업 회원가입</a>';
    }
  }
  document.addEventListener("DOMContentLoaded", () => {
	  const form = document.querySelector("form[action='/j_spring_security_check']");
	  const email = document.getElementById("emailInput"); // id 추가했으니 OK
	  const saveId = document.getElementById("saveId");

	  if (!form || !email || !saveId) return;

	  // 저장된 아이디 있으면 자동 채움
	  const saved = localStorage.getItem("savedEmail");
	  if (saved) {
	    email.value = saved;
	    saveId.checked = true;
	  }

	  // 체크 해제하면 저장값 삭제
	  saveId.addEventListener("change", () => {
	    if (!saveId.checked) localStorage.removeItem("savedEmail");
	  });

	  // 로그인 시 저장
	  form.addEventListener("submit", () => {
	    const v = email.value.trim();
	    if (saveId.checked && v) localStorage.setItem("savedEmail", v);
	    else localStorage.removeItem("savedEmail");
	  });
	});
</script>
	<%@ include file="/WEB-INF/views/footer.jsp" %>
</body>
</html>
