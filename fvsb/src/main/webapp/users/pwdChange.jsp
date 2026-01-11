<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@	page import="com.five.users.UsersDAO"%>
<jsp:useBean id="udao" class="com.five.users.UsersDAO"></jsp:useBean>
<%
String sessionId = (String) session.getAttribute("sid");
if (sessionId == null || sessionId.isEmpty()) {
	response.sendRedirect(request.getContextPath() + "/main.jsp");
	return;
}
if ("POST".equals(request.getMethod())) {

	request.setCharacterEncoding("UTF-8");

	String new_pwd = request.getParameter("new_pwd");
	String confirm_pwd = request.getParameter("confirm_pwd");

	String msg = "";
	String location = "pwdChange.jsp";

	if (!new_pwd.equals(confirm_pwd)) {
		msg = "새 비밀번호와 비밀번호가 일치하지 않습니다 ";
	} else if (new_pwd.isEmpty()) {
		msg = "새 비밀번호를 입력해주세요";
	} else {
		int updateResult = udao.updateUserPassword(sessionId, new_pwd);
		if (updateResult == 1) {
	msg = "비밀번호 변경이 완료되었습니다.";
	location = "usersInfo.jsp"; // 마이페이지로 이동
		} else {
	msg = "비밀번호 변경 중 데이터베이스 오류가 발생했습니다.";
	location = "usersInfo.jsp";
		}
	}
%>
<script>
	alert('<%=msg%>');
	if ('<%=location%>' === 'usersInfo.jsp') {
		window.close(); 
	} else {
		location.href='<%=location%>
	';
	}
</script>
<%
return; // 스크립트 실행 후 폼 출력 방지
}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>비밀번호 변경</title>
<link rel="stylesheet" type="text/css" href="/fvsb/css/usersLayout.css">
<link rel="icon" type="image/png" href="/fvsb/img/fvsb.png">
</head>
<body class="pwd-change">
	<main>
		<section>
			<h2>비밀번호 변경</h2>
			<article>
				<form name="pwdChangeForm" action="pwdChange.jsp" method="post">
					<fieldset>
						<legend>새 비밀번호 입력</legend>
						<table>
							<tr>
								<th>새 비밀번호</th>
								<td><input type="password" name="new_pwd" required></td>
							</tr>
							<tr>
								<th>새 비밀번호 확인</th>
								<td><input type="password" name="confirm_pwd" required></td>
							</tr>
							<tr>
								<td colspan="2" class="combined-button-cell">
									<div class="confirm-area">
										<input type="submit" value="변경 완료" class="full-width-button">
									</div>

									<div class="action-area button-row">
										<input type="reset" value="다시작성"> <input type="button"
											value="취소" onclick="window.close()">
									</div>
								</td>
							</tr>
						</table>
					</fieldset>
				</form>
			</article>
		</section>
	</main>
</body>
</html>