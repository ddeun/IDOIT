<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원탈퇴</title>
</head>
<body>

<h3>회원탈퇴</h3>

<p>정말 탈퇴하시겠습니까?</p>
<p>탈퇴 시 회원 정보는 복구할 수 없습니다.</p>

	<form method="post" action="/member/mypage/withdraw"
      onsubmit="return confirm('정말 탈퇴하시겠습니까? 복구할 수 없습니다.');">

    <button type="submit">탈퇴하기</button>
    &nbsp; | &nbsp;
    <a href="/member/mypage">취소</a>
	</form>
</body>
</html>