<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.five.qna.*"%>
<%@ page import="com.five.users.*" %>
<%
request.setCharacterEncoding("UTF-8");
%>
<jsp:useBean id="qdao" class="com.five.qna.QnaDAO" scope="session" />
<jsp:useBean id="qdto" class="com.five.qna.QnaDTO" />
<jsp:useBean id="udao" class="com.five.users.UsersDAO" scope="session" />

<jsp:setProperty name="qdto" property="*" />
<%
String sid = (String) session.getAttribute("sid");
UsersDTO udto = udao.getUserById(sid);
qdto.setU_idx(udto.getU_idx());    
qdto.setU_name(udto.getU_name());
int result = qdao.qnaReWrite(qdto);
String msg = (result > 0) ? "답변 등록 성공" : "답변 등록 실패";
%>
<script>
	window.alert("<%=msg%>");
	location.href = "qnaList.jsp";
</script>
