<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.five.bbs.*"%>
<%@ page import="com.five.users.*" %>
<%
request.setCharacterEncoding("UTF-8");
%>
<jsp:useBean id="bdao" class="com.five.bbs.BbsDAO" scope="session" />
<jsp:useBean id="bdto" class="com.five.bbs.BbsDTO" />
<jsp:useBean id="udao" class="com.five.users.UsersDAO" scope="session" />
<jsp:setProperty name="bdto" property="*" />
<%
String sid = (String) session.getAttribute("sid");
UsersDTO udto = udao.getUserById(sid);
bdto.setU_idx(udto.getU_idx());    
bdto.setU_name(udto.getU_name()); 
int result = bdao.bbsWrite(bdto);
String msg = (result > 0) ? "등록 성공" : "등록 실패";
%>
<script>
	window.alert("<%=msg%>");
	location.href = "bbsList.jsp";
</script>


