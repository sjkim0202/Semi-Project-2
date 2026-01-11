<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<jsp:useBean id="udao" class="com.five.users.UsersDAO"></jsp:useBean>
<%
String u_id = request.getParameter("u_id");
String u_pwd = request.getParameter("u_pwd");
String saveid = request.getParameter("saveid");
String returnUrl = request.getParameter("returnUrl");

if(returnUrl == null || returnUrl.equals("")){ // 로그인 경로 받음
    returnUrl = "/fvsb"; // 경로 기본값 (양진유 추가)
}

int result = udao.loginCheck(u_id, u_pwd);

if (result == udao.LOGIN_OK) {
	String u_name = udao.getUserNameById(u_id);
	session.setAttribute("sid", u_id);
	session.setAttribute("sname", u_name);

	if (saveid == null) {
		Cookie ck = new Cookie("saveid", u_id);
		ck.setMaxAge(0);
		response.addCookie(ck);
	} else {
		Cookie ck = new Cookie("saveid", u_id);
		ck.setMaxAge(60 * 60 * 24 * 30);
		response.addCookie(ck);
	}
%>
<script>
	window.alert('<%=u_name%>님 환영합니다');
	location.href = '<%=returnUrl%>';
</script>

<%
} else if (result == udao.NOT_ID || result == udao.NOT_PWD) {
%>
<script>
	window.alert('존재하지 않는 아이디 또는 잘못된 비밀번호');
	window.history.back();
</script>
<%
} else if (result == udao.ERROR) {
out.println("고객센터 연락바람");
}
%>


