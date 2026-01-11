<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%
request.setCharacterEncoding("UTF-8");
String popupck = request.getParameter("popupck");

if ("on".equals(popupck)) {
	Cookie ck = new Cookie("popupck", "on");
	ck.setMaxAge(60*60*24); 
	ck.setPath("/");
	response.addCookie(ck);
}
%>

<script>
	window.self.close();
</script>