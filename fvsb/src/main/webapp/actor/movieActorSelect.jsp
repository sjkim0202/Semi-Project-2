<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page
	import="com.five.actor.ActorDAO, com.five.actor.ActorDTO, java.util.*"%>

<jsp:useBean id="adao" class="com.five.actor.ActorDAO" />
<jsp:useBean id="mdto" class="com.five.movie.MovieDTO"></jsp:useBean>
<jsp:useBean id="mdao" class="com.five.movie.MovieDAO"></jsp:useBean>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>배우 출연 영화 목록</title>
<link rel="stylesheet" type="text/css" href="/fvsb/css/mainLayout.css">
<link rel="stylesheet" type="text/css" href="/fvsb/css/actorLayout.css">
<link rel="icon" type="image/png" href="/fvsb/img/fvsb.png">
<%
int m_idx = Integer.parseInt(request.getParameter("m_idx"));
ArrayList<ActorDTO> list = adao.actorList();
%>
<script>
	function insertActor() {
		window.open("/fvsb/actor/actorInsertPopup.jsp", "actorInsertPopup","width=500,height=600,top=150,left=150,scrollbars=yes,resizable=no");
	}
</script>
</head>
<body class="moive-actor-select">
	<h2>출연 배우 선택</h2>
	<form action="movieActor_ok.jsp" method="post">
		<input type="hidden" name="m_idx" value="<%=m_idx%>">

		<%
		for (ActorDTO a : list) {
		%>
		<input type="checkbox" name="actor" value="<%=a.getA_name()%>"><%=a.getA_name()%><br>
		<%
		}
		%>

		<input type="submit" value="출연 배우 등록">
	</form>
	<input type="button" value="배우 추가하기" onclick="insertActor()">
</body>
</html>