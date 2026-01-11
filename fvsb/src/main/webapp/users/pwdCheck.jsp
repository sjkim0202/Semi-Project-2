<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
String sessionId = (String) session.getAttribute("sid");

if (sessionId == null) {
	response.sendRedirect(request.getContextPath() + "/main.jsp");
	return;
}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>비밀번호 확인</title>
<link rel="stylesheet" type="text/css" href="/fvsb/css/usersLayout.css">
<link rel="icon" type="image/png" href="/fvsb/img/fvsb.png">
</head>
<body class="pwd-check">
	<main>
		<section>
			<h2>비밀번호 확인</h2>
			<article>
				<form name="pwdCheckForm" action="pwdCheck_ok.jsp" method="post">
					<fieldset>
						<table>
							<tr>
								<th>현재 비밀번호</th>
								<td><input type="password" name="u_pwd" required></td>
							</tr>
							<tr class="button-container-row"> 
								<td colspan="2" class="combined-button-cell">
									
									<div class="confirm-area">
										<input type="submit" value="확인" class="full-width-button"> 
									</div>
									
									<div class="action-area button-row">
										<input type="reset" value="다시작성">
										<input type="button" value="취소" onclick="window.close()"> </div>
								</td>
							</tr>
						</table>
					</fieldset>
					<input type="hidden" name="u_id" value="<%=sessionId%>">
				</form>
			</article>
		</section>
	</main>
</body>
</html>