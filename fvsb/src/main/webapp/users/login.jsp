<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인</title>
<link rel="stylesheet" type="text/css" href="/fvsb/css/mainLayout.css">
<link rel="stylesheet" type="text/css" href="/fvsb/css/usersLayout.css">
<link rel="icon" type="image/png" href="/fvsb/img/fvsb.png">
</head>
<%
String saveid = "";
Cookie cks[] = request.getCookies();
if (cks != null) {
	for (Cookie temp : cks) {
		if (temp.getName().equals("saveid")) {
	saveid = temp.getValue();
		}
	}
}
%>
<body class = "login">
	<%@include file="/header.jsp"%>
	<main>
		<form name="login" action="login_ok.jsp" method="post">
			<!-- 로고 -->
			<div class="login-logo">
				<a href="/fvsb/main.jsp"> <img src="/fvsb/img/new_logo.png" alt="로고">
				</a>
			</div>

			<section>
				<input type="hidden" name="returnUrl"
					value="<%=request.getHeader("referer")%>">
				<!-- ID 입력 -->
				<div class="input-group">
					<input type="text" name="u_id" id="u_id" placeholder="아이디"
						value="<%=saveid%>" required>
				</div>
				<!-- 비밀번호 입력 -->
				<div class="input-group">
					<input type="password" name="u_pwd" id="u_pwd" placeholder="비밀번호"
						required>
				</div>
				<!-- 로그인 버튼 -->
				<button type="submit" class="btn-login">LOGIN</button>

				<!-- ID 기억하기 -->
				<div class="login-options">
					<input type="checkbox" name="saveid" value="on" id="saveid"
						<%=saveid.equals("") ? "" : "checked"%>> <label
						for="saveid">아이디 기억하기</label>
				</div>
				<!-- 회원가입 링크 -->
				<div class="login-links">
					<a href="/fvsb/users/usersJoin.jsp">회원가입</a>
				</div>
			</section>
		</form>
	</main>
	<%@include file="/footer.jsp"%>
</body>
</html>