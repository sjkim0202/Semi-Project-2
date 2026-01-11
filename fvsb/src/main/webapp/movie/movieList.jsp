<%@page import="java.time.LocalDate"%>
<%@page import="com.five.review.ReviewDTO"%>
<%@page import="com.five.movie.MovieDTO"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.text.DecimalFormat"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<jsp:useBean id="mdao" class="com.five.movie.MovieDAO"></jsp:useBean>
<jsp:useBean id="udao" class="com.five.users.UsersDAO"></jsp:useBean>
<jsp:useBean id="rdao" class="com.five.review.ReviewDAO"></jsp:useBean>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>영화 목록</title>
<link rel="stylesheet" type="text/css" href="/fvsb/css/mainLayout.css">
<link rel="stylesheet" type="text/css" href="/fvsb/css/movieLayout.css">
<link rel="icon" type="image/png" href="/fvsb/img/fvsb.png">
</head>
<%
String u_id = (String) session.getAttribute("sid");
DecimalFormat df = new DecimalFormat("0.0");

int year = LocalDate.now().getYear();
int month = LocalDate.now().getMonthValue();
int day = LocalDate.now().getDayOfMonth();
int now = year * 10000 + month * 100 + day;

String movie_ls = request.getParameter("movie_ls");
if (movie_ls == null || movie_ls.equals("")) {
	movie_ls = "1";
}
int cpmovie_l = Integer.parseInt(movie_ls);

String off_ls = request.getParameter("off_ls");
if (off_ls == null || off_ls.equals("")) {
	off_ls = "1";
}
int cpoff_ls = Integer.parseInt(off_ls);

String genre_ls = request.getParameter("genre_ls");
if (genre_ls == null || genre_ls.equals("")) {
	genre_ls = "1";
}
int cpgenre_ls = Integer.parseInt(genre_ls);

String korea_ls = request.getParameter("korea_ls");
if (korea_ls == null || korea_ls.equals("")) {
	korea_ls = "1";
}
int cpkorea_ls = Integer.parseInt(korea_ls);

String foreign_ls = request.getParameter("foreign_ls");
if (foreign_ls == null || foreign_ls.equals("")) {
	foreign_ls = "1";
}
int cpforeign_ls = Integer.parseInt(foreign_ls);

int listSize = 5;

ArrayList<MovieDTO> fullArr = mdao.getMovieList();

ArrayList<MovieDTO> movie_korea_on = new ArrayList<>();
ArrayList<MovieDTO> movie_korea_off = new ArrayList<>();
ArrayList<MovieDTO> movie_foreign_on = new ArrayList<>();
ArrayList<MovieDTO> movie_foreign_off = new ArrayList<>();

if (fullArr != null) {
	for (MovieDTO mdto : fullArr) {
		String m_date_s = mdto.getM_date().substring(0, 4) + mdto.getM_date().substring(5, 7)
		+ mdto.getM_date().substring(8);
		int m_date = Integer.parseInt(m_date_s);

		boolean released = (now >= m_date);
		if ("korea".equals(mdto.getM_country())) {
	if (released) {
		movie_korea_on.add(mdto);
	} else {
		movie_korea_off.add(mdto);
	}
		} else {
	if (released) {
		movie_foreign_on.add(mdto);
	} else {
		movie_foreign_off.add(mdto);
	}
		}
	}
}

ArrayList<MovieDTO> allArr_on = new ArrayList<>();
allArr_on.addAll(movie_korea_on);
allArr_on.addAll(movie_foreign_on);

ArrayList<MovieDTO> allArr_off = new ArrayList<>();
allArr_off.addAll(movie_korea_off);
allArr_off.addAll(movie_foreign_off);

int movie_total_on = allArr_on.size();
int page_total = (movie_total_on - 1) / listSize + 1;
int start = (cpmovie_l - 1) * listSize;
int end = Math.min(start + listSize, movie_total_on);
ArrayList<MovieDTO> movie_page = new ArrayList<>();
for (int i = start; i < end; i++) {
	if (i < allArr_on.size()) {
		movie_page.add(allArr_on.get(i));
	}
}

int movie_total_off = allArr_off.size();
int page_total_off = (movie_total_off - 1) / listSize + 1;
int start_off = (cpoff_ls - 1) * listSize;
int end_off = Math.min(start_off + listSize, movie_total_off);
ArrayList<MovieDTO> movie_page_off = new ArrayList<>();
for (int i = start_off; i < end_off; i++) {
	if (i < allArr_off.size()) {
		movie_page_off.add(allArr_off.get(i));
	}
}

ArrayList<MovieDTO> movie_page_genre = null;
int page_total_genre = 0;
if (u_id != null && !u_id.isEmpty()) {
	int movie_total_genre = mdao.getMoviegenreCount(u_id);
	page_total_genre = (movie_total_genre - 1) / listSize + 1;

	movie_page_genre = mdao.getMoviegenreList(u_id, cpgenre_ls, listSize); 
}

int movie_total_korea = movie_korea_on.size();
int page_total_korea = (movie_total_korea - 1) / listSize + 1;
int start_korea = (cpkorea_ls - 1) * listSize;
int end_korea = Math.min(start_korea + listSize, movie_total_korea);
ArrayList<MovieDTO> movie_page_korea = new ArrayList<>();
for (int i = start_korea; i < end_korea; i++) {
	if (i < movie_korea_on.size()) {
		movie_page_korea.add(movie_korea_on.get(i));
	}
}
int movie_total_foreign = movie_foreign_on.size();
int page_total_foreign = (movie_total_foreign - 1) / listSize + 1;
int start_foreign = (cpforeign_ls - 1) * listSize;
int end_foreign = Math.min(start_foreign + listSize, movie_total_foreign);
ArrayList<MovieDTO> movie_page_foreign = new ArrayList<>();
for (int i = start_foreign; i < end_foreign; i++) {
	if (i < movie_foreign_on.size()) {
		movie_page_foreign.add(movie_foreign_on.get(i));
	}
}
%>
<body class="movie-list">
	<%@ include file="/header.jsp"%>
	<main>
		<section>
			<article>
				<fieldset>
					<h2>영화목록보기 (개봉작)</h2>
					<table id="movielisttable">
						<thead>
						</thead>
						<tbody>
							<%
							if (movie_page.isEmpty()) {
							%>
							<tr>
								<td colspan="1" align="center">등록된 영화가 없습니다</td>
							</tr>
							<%
							} else {
							%>
							<tr>

								<td width="80" align="center" valign="middle">
									<%
									if (cpmovie_l > 1) {
									%> <a
									href="movieList.jsp?movie_ls=<%=cpmovie_l - 1%>&off_ls=<%=cpoff_ls%>&genre_ls=<%=cpgenre_ls%>&korea_ls=<%=cpkorea_ls%>&foreign_ls=<%=cpforeign_ls%>"><img
										src="/fvsb/img/arrowsL.png" width="20"></a> <%
 									}
 									%>
								</td>

								<%
								for (MovieDTO mdto : movie_page) {
									int m_idx = mdto.getM_idx();
									double avgScore = rdao.getAvgScore(m_idx);
									String score = df.format(avgScore);
								%>
								<td class="movielist"><a
									href="movieDetail.jsp?m_idx=<%=m_idx%>"> <img
										src="<%=mdto.getM_img()%>">
								</a>

									<div>
										<%=mdto.getM_name()%></div>

									<div>
										평점 :
										<%=score%></div></td>
								<%
								}
								%>

								<td width="80" align="center" valign="middle">
									<%
									if (cpmovie_l < page_total) {
									%> <a
									href="movieList.jsp?movie_ls=<%=cpmovie_l + 1%>&off_ls=<%=cpoff_ls%>&genre_ls=<%=cpgenre_ls%>&korea_ls=<%=cpkorea_ls%>&foreign_ls=<%=cpforeign_ls%>">
										<img src="/fvsb/img/arrowsR.png" width="20">
								</a> <%
 								}
 								%>
								</td>
							</tr>
							<%
							}
							%>
						</tbody>
					</table>
				</fieldset>

				<fieldset>
					<h2>개봉 예정작 (국내/해외)</h2>
					<table id="movielisttable">
						<thead></thead>
						<tbody>
							<%
							if (movie_page_off.isEmpty()) {
							%>
							<tr>
								<td colspan="1" align="center">등록된 개봉 예정작이 없습니다</td>
							</tr>
							<%
							} else {
							%>
							<tr>

								<td width="80" align="center" valign="middle">
									<%
									if (cpoff_ls > 1) {
									%> <a
									href="movieList.jsp?movie_ls=<%=cpmovie_l%>&off_ls=<%=cpoff_ls - 1%>&genre_ls=<%=cpgenre_ls%>&korea_ls=<%=cpkorea_ls%>&foreign_ls=<%=cpforeign_ls%>"><img
										src="/fvsb/img/arrowsL.png" width="20"></a> <%
 									}
 									%>
								</td>

								<%
								for (MovieDTO mdto : movie_page_off) {
									int m_idx = mdto.getM_idx();
								%>
								<td class="movielist"><a
									href="movieDetail.jsp?m_idx=<%=m_idx%>"> <img
										src="<%=mdto.getM_img()%>">
								</a>
									<div>
										<%=mdto.getM_name()%></div>
									<div>
										개봉 예정일:
										<%=mdto.getM_date()%></div>
										<div>
										<%
										String dday = mdto.getM_date().substring(0, 4) + mdto.getM_date().substring(5, 7)
										+ mdto.getM_date().substring(8);
										int d_day = Integer.parseInt(dday);
										%>
										D-<%=d_day-now%>
										</div></td>
								<%
								}
								%>

								<td width="80" align="center" valign="middle">
									<%
									if (cpoff_ls < page_total_off) {
									%> <a
									href="movieList.jsp?movie_ls=<%=cpmovie_l%>&off_ls=<%=cpoff_ls + 1%>&genre_ls=<%=cpgenre_ls%>&korea_ls=<%=cpkorea_ls%>&foreign_ls=<%=cpforeign_ls%>">
										<img src="/fvsb/img/arrowsR.png" width="20">
								</a> <%
 									}
									 %>
								</td>

							</tr>
							<%
							}
							%>
						</tbody>
					</table>
				</fieldset>
				<%
				if (u_id == null || u_id.isEmpty()) {
				%>
				<fieldset>
					<h2>추천 영화</h2>
					<table id="randommovietable">
						<thead></thead>
						<tbody>
							<%
							if (allArr_on != null && allArr_on.size() > 0) {
								int randomIndex = (int) (Math.random() * allArr_on.size());
								MovieDTO mdto = allArr_on.get(randomIndex);

								int m_idx = mdto.getM_idx();
								double avgScore = rdao.getAvgScore(m_idx);
								String score = df.format(avgScore);
							%>
							<tr>
								<td class="movielist"><a
									href="movieDetail.jsp?m_idx=<%=m_idx%>"> <img
										src="<%=mdto.getM_img()%>">
								</a>
									<div>
										<%=mdto.getM_name()%></div>
									<div>
										평점:
										<%=score%>
									</div></td>
							</tr>
							<%
							} else {
							%>
							<tr>
								<td align="center">추천할 영화가 없습니다.</td>
							</tr>
							<%
							}
							%>
						</tbody>
					</table>
				</fieldset>
				<%
				} else {
				%>

				<fieldset>
					<h2>사용자 맞춤별 장르 영화 (개봉작 중)</h2>
					<table id="movielisttable">
						<thead>
						</thead>
						<tbody>
							<%
							if (movie_page_genre == null || movie_page_genre.size() == 0) {
							%>
							<tr>
								<td colspan="1" align="center">등록된 영화가 없습니다</td>
							</tr>
							<%
							} else {
							%>
							<tr>

								<td width="80" align="center" valign="middle">
									<%
									if (cpgenre_ls > 1) {
									%> <a
									href="movieList.jsp?movie_ls=<%=cpmovie_l%>&off_ls=<%=cpoff_ls%>&genre_ls=<%=cpgenre_ls - 1%>&korea_ls=<%=cpkorea_ls%>&foreign_ls=<%=cpforeign_ls%>"><img
										src="/fvsb/img/arrowsL.png" width="20"></a> <%
 									}
 									%>
								</td>

								<%
								for (MovieDTO mdto : movie_page_genre) {
									int m_idx = mdto.getM_idx();
									double avgScore = rdao.getAvgScore(m_idx);
									String score = df.format(avgScore);
								%>
								<td class="movielist"><a
									href="movieDetail.jsp?m_idx=<%=m_idx%>"> <img
										src="<%=mdto.getM_img()%>">
								</a>
									<div>
										<%=mdto.getM_name()%></div>
									<div>
										평점 :
										<%=score%></div></td>
								<%
								}
								%>

								<td width="80" align="center" valign="middle">
									<%
									if (cpgenre_ls < page_total_genre) {
									%> <a
									href="movieList.jsp?movie_ls=<%=cpmovie_l%>&off_ls=<%=cpoff_ls%>&genre_ls=<%=cpgenre_ls + 1%>&korea_ls=<%=cpkorea_ls%>&foreign_ls=<%=cpforeign_ls%>">
										<img src="/fvsb/img/arrowsR.png" width="20">
								</a> <%
 									}
									 %>
								</td>

							</tr>
							<%
							}
							%>
						</tbody>
					</table>
				</fieldset>
				<%
				}
				%>

				<fieldset>
					<h2>국내영화</h2>
					<table id="movielisttable">
						<thead>
						</thead>
						<tbody>
							<%
							if (movie_page_korea.isEmpty()) {
							%>
							<tr>
								<td colspan="1" align="center">등록된 국내영화 개봉작이 없습니다</td>
							</tr>
							<%
							} else {
							%>
							<tr>

								<td width="80" align="center" valign="middle">
									<%
									if (cpkorea_ls > 1) {
									%> <a
									href="movieList.jsp?movie_ls=<%=cpmovie_l%>&off_ls=<%=cpoff_ls%>&genre_ls=<%=cpgenre_ls%>&korea_ls=<%=cpkorea_ls - 1%>&foreign_ls=<%=cpforeign_ls%>"><img
										src="/fvsb/img/arrowsL.png" width="20"></a> <%
 									}
 									%>
								</td>

								<%
								for (MovieDTO mdto : movie_page_korea) {
									int m_idx = mdto.getM_idx();
									double avgScore = rdao.getAvgScore(m_idx);
									String score = df.format(avgScore);
								%>
								<td class="koreamovielist"><a
									href="movieDetail.jsp?m_idx=<%=m_idx%>"> <img
										src="<%=mdto.getM_img()%>">
								</a>

									<div><%=mdto.getM_name()%></div>

									<div>
										평점 :
										<%=score%></div></td>
								<%
								}
								%>

								<td width="80" align="center" valign="middle">
									<%
									if (cpkorea_ls < page_total_korea) {
									%> <a
									href="movieList.jsp?movie_ls=<%=cpmovie_l%>&off_ls=<%=cpoff_ls%>&genre_ls=<%=cpgenre_ls%>&korea_ls=<%=cpkorea_ls + 1%>&foreign_ls=<%=cpforeign_ls%>">
										<img src="/fvsb/img/arrowsR.png" width="20">
								</a> <%
 									}
									%>
								</td>

							</tr>
							<%
							}
							%>
						</tbody>
					</table>
				</fieldset>

				<fieldset>
					<h2>해외영화</h2>
					<table id="movielisttable">
						<thead>
						</thead>
						<tbody>
							<%
							if (movie_page_foreign == null || movie_page_foreign.size() == 0) {
							%>
							<tr>
								<td colspan="1" align="center">등록된 해외영화가 없습니다</td>
							</tr>
							<%
							} else {
							%>
							<tr>

								<td width="80" align="center" valign="middle">
									<%
									if (cpforeign_ls > 1) {
									%> <a
									href="movieList.jsp?movie_ls=<%=cpmovie_l%>&off_ls=<%=cpoff_ls%>&genre_ls=<%=cpgenre_ls%>&korea_ls=<%=cpkorea_ls%>&foreign_ls=<%=cpforeign_ls - 1%>"><img
										src="/fvsb/img/arrowsL.png" width="20"></a> <%
								 }
 								%>
								</td>

								<%
								for (MovieDTO mdto : movie_page_foreign) {
									int m_idx = mdto.getM_idx();
									double avgScore = rdao.getAvgScore(m_idx);
									String score = df.format(avgScore);
								%>
								<td class="foreignmovielist"><a
									href="movieDetail.jsp?m_idx=<%=m_idx%>"> <img
										src="<%=mdto.getM_img()%>">
								</a>

									<div><%=mdto.getM_name()%></div>
									<div>
										평점 :
										<%=score%>
									</div></td>
								<%
								}
								%>

								<td width="80" align="center" valign="middle">
									<%
									if (cpforeign_ls < page_total_foreign) {
									%> <a
									href="movieList.jsp?movie_ls=<%=cpmovie_l%>&off_ls=<%=cpoff_ls%>&genre_ls=<%=cpgenre_ls%>&korea_ls=<%=cpkorea_ls%>&foreign_ls=<%=cpforeign_ls + 1%>">
										<img src="/fvsb/img/arrowsR.png" width="20">
								</a> <%
 								}
 								%>
								</td>

							</tr>
							<%
							}
							%>
						</tbody>
					</table>
				</fieldset>
			</article>
		</section>
	</main>
	<%@ include file="/footer.jsp"%>


</body>
</html>