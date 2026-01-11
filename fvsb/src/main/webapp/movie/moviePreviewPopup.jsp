<%@page import="com.five.actor.MovieActorDAO"%>
<%@page import="java.time.LocalDate"%>
<%@page import="java.util.ArrayList"%>
<%@page import="com.five.movie.MovieDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.five.movie.MovieDTO"%>
<%@ page import="com.five.users.UsersDTO"%>
<%@ page import="com.five.actor.ActorDTO"%>
<jsp:useBean id="mdao" class="com.five.movie.MovieDAO"></jsp:useBean>
<jsp:useBean id="udao" class="com.five.users.UsersDAO"></jsp:useBean>
<jsp:useBean id="adao" class="com.five.actor.ActorDAO"></jsp:useBean>
<jsp:useBean id="madao" class="com.five.actor.MovieActorDAO"></jsp:useBean>

<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">
<title>영화 미리 보기</title>
<link rel="stylesheet" type="text/css" href="/fvsb/css/movieLayout.css">
<link rel="icon" type="image/png" href="/fvsb/img/fvsb.png">
</head>
<%
int m_idx = Integer.parseInt(request.getParameter("m_idx"));
MovieDTO mdto = mdao.movieView(m_idx);
ArrayList<String> genreList = mdao.getMovieGenres(m_idx);
ArrayList<String> actorList = mdao.getMovieActors(m_idx);
String u_id = (String) session.getAttribute("sid");
UsersDTO dto = null;

int u_age = 0;
if (u_id != null && !u_id.isEmpty()) {
	dto = udao.getUserById(u_id);
	if (dto != null) {
		u_age = LocalDate.now().getYear() - dto.getU_year();
	}
}
%>
<body class="movie-preview-popup">
	<main>
		<section>
			<article id="moviePreview">
					<table class="moviepreviewtable">
						<thead>
							<tr>
								<td colspan="4"><h2><%=mdto.getM_name()%>
									</h2></td>
							</tr>
							<tr>
								<td rowspan="3" colspan="1" id="detail0"><img
									src="<%=mdto.getM_img()%>" id="detailimg"></td>
								<td rowspan="3" id="detail1"></td>
								<td id="detail2"></td>
							</tr>



						</thead>
						<tbody>
							<tr>
								<td>국가: <%=mdto.getM_country()%></td>
							</tr>
							<tr>
								<td>개봉: <%=mdto.getM_date().substring(0, 4)%></td>
							</tr>
							<tr>
								<td colspan="2">장르: <%
								if (genreList != null && !genreList.isEmpty()) {
									for (int i = 0; i < genreList.size(); i++) {
										out.print(genreList.get(i));
										if (i < genreList.size() - 1) {
									out.print(", ");
										}
									}
								} else {
									out.print("장르 정보 없음");
								}
								%>
								</td>
							</tr>
							<tr>
								<td>감독 : <%=mdto.getM_pd()%></td>
							</tr>
							<tr>
								<td>연령: <%
								String limit = mdto.getM_limit();
								if ("ALL".equals(limit)) {
									out.print("전체 이용가");
								} else if ("12".equals(limit)) {
									out.print("12세 이상");
								} else if ("15".equals(limit)) {
									out.print("15세 이상");
								} else {
									out.print("청소년 관람불가");
								}
								%>
								</td>
							</tr>
						</tbody>
					</table>
			</article>
		</section>
	</main>
</body>
<script>
	var listBt = document.getElementById('listBt');
	if (listBt) {
		listBt.addEventListener('click', function() {
			window.open('/fvsb/review/reviewList.jsp?m_idx=' +<%=m_idx%>,'review', 'width=750,height=500');
		});
	}
	var listBt2 = document.getElementById('listBt2');
	if (listBt2) {
		listBt2.addEventListener('click', function() {
			window.alert('로그인 후에 이용해주세요');
		});
	}

	var listBt_3 = document.getElementById('listBt_3');
	if (listBt_3) {
		listBt_3.addEventListener('click', function() {
			window.alert('해당 영화의 연령 제한으로 인해 리뷰 게시판에 접근할 수 없음');
		});
	}
</script>
</html>
