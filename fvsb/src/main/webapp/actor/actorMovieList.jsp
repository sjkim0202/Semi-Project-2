<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="com.five.movie.MovieDTO"%>
<%@page import="java.util.ArrayList"%>
<jsp:useBean id="mdao" class="com.five.movie.MovieDAO"></jsp:useBean>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>배우 출연 영화 목록</title>
<link rel="stylesheet" type="text/css" href="/fvsb/css/mainLayout.css">
<link rel="stylesheet" type="text/css" href="/fvsb/css/actorLayout.css">
<link rel="icon" type="image/png" href="/fvsb/img/fvsb.png">
</head>

<%
request.setCharacterEncoding("UTF-8");

String a_idx_s = request.getParameter("a_idx");
if (a_idx_s == null || a_idx_s.equals("")) {
%>
<body>
	<h2>배우 정보가 없습니다.</h2>
	<a href="/actor/actor.jsp">배우 목록으로 돌아가기</a>
</body>
</html>
<%
return;
}

int a_idx = Integer.parseInt(a_idx_s);
ArrayList<MovieDTO> list = mdao.getMoviesByActor(a_idx);
%>

<body class="actor-movie-list">
	<%@include file="/header.jsp"%>
	<main>
		<section>
			<h2>출연 영화 목록</h2>
		</section>

		<article>
			<%
			if (list == null || list.size() == 0) {
			%>
			<p>이 배우가 등록된 영화가 없습니다.</p>
			<p>
				<a href="actor.jsp">배우 목록으로 돌아가기</a>
			</p>
			<%
			} else {
			%>
			<table border="0" style="margin: auto;">
				<tr>
					<%
					for (MovieDTO m : list) {
						String imgUrl = "/fvsb/movie/" + m.getM_img();
					%>
					<td style="text-align: center; padding: 20px;"><a
						href="/fvsb/movie/movieDetail.jsp?m_idx=<%=m.getM_idx()%>"> <img
							src="<%=imgUrl%>" width="180"><br>
							<div><%=m.getM_name()%></div>
					</a>
						<div>
							개봉일 :
							<%=m.getM_date()%></div></td>
					<%
					}
					%>
				</tr>
			</table>

			<p style="text-align: center; margin-top: 30px;">
				<a href="javascript:history.back()">돌아가기</a>
			</p>
			<%
			}
			%>
		</article>
	</main>
	<%@include file="/footer.jsp"%>
</body>
</html>
