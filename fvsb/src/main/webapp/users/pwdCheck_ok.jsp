<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.five.users.UsersDAO"%>
<jsp:useBean id="udao" class="com.five.users.UsersDAO"></jsp:useBean>
<%
request.setCharacterEncoding("UTF-8");

String u_id = request.getParameter("u_id");
String u_pwd = request.getParameter("u_pwd");

int result = udao.loginCheck(u_id, u_pwd);

String msg = "";
String location = "";

if (result == udao.LOGIN_OK) {
	msg = "비밀번호 확인 완료";
	location = "pwdChange.jsp";
} else if (result == udao.NOT_PWD) {
	// 2. 비밀번호 불일치
	msg = "비밀번호가 일치하지 않습니다. 다시 입력해주세요.";
	location = "pwdCheck.jsp"; // 현재 확인 폼으로 돌아가기 (리셋 효과)
} else {
	// 3. 기타 오류 (DB 오류 또는 ID 없음)
	msg = "처리 중 오류가 발생했습니다. 다시 시도해 주세요.";
	location = request.getContextPath() + "/main.jsp";
}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>비밀번호 확인 결과</title>
</head>
<body>
	<script>
	window.alert('<%=msg%>');
	location.href='<%=location%>';
	</script>
</body>
</html>
