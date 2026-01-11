<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.five.users.*"%>
<%@ page import="com.five.notification.*"%>

<jsp:useBean id="ndao" class="com.five.notification.NotificationDAO" />
<jsp:useBean id="udao" class="com.five.users.UsersDAO" />

<%
request.setCharacterEncoding("UTF-8");

String sid = (String) session.getAttribute("sid");
if (sid == null || sid.equals("")) {
%>
<script>
	window.alert("로그인 후 이용 가능합니다.");
	window.close();
</script>
<%
return;
}

UsersDTO udto = udao.getUserById(sid);
if (udto == null) {
%>
<script>
	window.alert("유저 정보를 찾을 수 없습니다.");
	window.close();
</script>
<%
return;
}

int n_idx = Integer.parseInt(request.getParameter("n_idx"));
int result = ndao.deleteNotification(n_idx, udto.getU_idx());

if (result > 0) {
%>
<script>
	window.alert("삭제 성공");
	window.location.href = "/fvsb/notification/notificationList.jsp";
</script>
<%
} else {
%>
<script>
	window.alert("삭제 실패");
	window.location.href = "/fvsb/notification/notificationList.jsp";
</script>
<%
}
%>
