<%@page import="java.text.DecimalFormat"%>
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
<jsp:useBean id="rdao" class="com.five.review.ReviewDAO"></jsp:useBean>
<jsp:useBean id="mldao" class="com.five.movie_like.Movie_likeDAO"></jsp:useBean>

<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">
<title>영화 상세 정보</title>
<link rel="stylesheet" type="text/css" href="/fvsb/css/mainLayout.css">
<link rel="stylesheet" type="text/css" href="/fvsb/css/movieLayout.css">
<link rel="icon" type="image/png" href="/fvsb/img/fvsb.png">

</head>
<%
int m_idx = Integer.parseInt(request.getParameter("m_idx"));
MovieDTO mdto = mdao.movieView(m_idx);
ArrayList<String> genreList = mdao.getMovieGenres(m_idx);
ArrayList<String> actorList = mdao.getMovieActors(m_idx);
ArrayList<MovieDTO> movieList = mdao.getMovieList();
String u_id = (String) session.getAttribute("sid");
String src = "/fvsb/review/reviewimg/like_2.png";
if (u_id == null || u_id.equals("")) {
	//src = "0";
	src = "/fvsb/review/reviewimg/like_2.png";
} else {
	if (mldao.isM_like(udao.getUserById(u_id).getU_idx(), m_idx)) {
		src = "/fvsb/review/reviewimg/like.png";
	}
}
UsersDTO dto = null;

DecimalFormat df = new DecimalFormat("0.0");
double avgScore = rdao.getAvgScore(m_idx);
String score = df.format(avgScore);

int review_total = rdao.getTotalCnt(m_idx);

int u_age = 0;
if (u_id != null && !u_id.isEmpty()) {
	dto = udao.getUserById(u_id);
	if (dto != null) {
		u_age = LocalDate.now().getYear() - dto.getU_year();
	}
}

String limit = mdto.getM_limit();
%>
<body class="movie-detail">
	<%@ include file="/header.jsp"%>
	<main>
		<!-- 영화 헤더 -->
		<div class="movie-header">
			<div class="movie-poster">
				<img src="<%=mdto.getM_img()%>" alt="<%=mdto.getM_name()%>">
			</div>

			<div class="movie-info">
				<h1 class="movie-title"><%=mdto.getM_name()%></h1>

				<div class="movie-meta">
					<span><%=mdto.getM_date().substring(0, 4)%></span> <span><%=mdto.getM_country()%></span>
					<span>
						<%
						if (genreList != null && !genreList.isEmpty()) {
							out.print(String.join(", ", genreList));
						} else {
							out.print("장르 정보 없음");
						}
						%>
					</span> <span>감독 <%=mdto.getM_pd()%></span> <span>
						<%
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
					</span>
				</div>

				<!-- 별점 + 버튼 라인 -->
				<div class="movie-rating-actions">
					<div class="movie-rating">
						<div class="rating-stars">
							<%
							if (avgScore == 5.0) {
							%><img src="/fvsb/img/rating5.png">
							<%
							} else if (avgScore >= 4.5) {
							%><img src="/fvsb/img/rating4half.png">
							<%
							} else if (avgScore >= 4.0) {
							%><img src="/fvsb/img/rating4.png">
							<%
							} else if (avgScore >= 3.5) {
							%><img src="/fvsb/img/rating3half.png">
							<%
							} else if (avgScore >= 3.0) {
							%><img src="/fvsb/img/rating3.png">
							<%
							} else if (avgScore >= 2.5) {
							%><img src="/fvsb/img/rating2half.png">
							<%
							} else if (avgScore >= 2.0) {
							%><img src="/fvsb/img/rating2.png">
							<%
							} else if (avgScore >= 1.5) {
							%><img src="/fvsb/img/rating1half.png">
							<%
							} else if (avgScore >= 1.0) {
							%><img src="/fvsb/img/rating1.png">
							<%
							} else if (avgScore >= 0.5) {
							%><img src="/fvsb/img/rating0half.png">
							<%
							} else {
							%><img src="/fvsb/img/rating0.png">
							<%
							}
							%>
						</div>
						<span class="rating-text"><%=score%></span> <span
							class="rating-count">(<%=review_total%>명 평가)
						</span>
					</div>

					<div class="movie-actions">
						<%
						int year = LocalDate.now().getYear();
						int month = LocalDate.now().getMonthValue();
						int day = LocalDate.now().getDayOfMonth();
						int now = year * 10000 + month * 100 + day;

						String m_date_s = mdto.getM_date().substring(0, 4) + mdto.getM_date().substring(5, 7) + mdto.getM_date().substring(8);
						int m_date = Integer.parseInt(m_date_s);

						boolean isReleased = (now >= m_date);

						if (isReleased) {
							if (u_id == null || u_id.isEmpty()) {
						%>
							<a href="" class="btn-like" id="listBt4">
								<img src="<%=src%>"> <span>찜하기</span>
							</a>
						<button type="button" class="btn-review" id="listBt2">리뷰
							게시판</button>
						<%
						} else {
						boolean access = false;

						if ("ALL".equals(limit)) {
							access = true;
						} else if ("12".equals(limit)) {
							if (u_age >= 12)
								access = true;
						} else if ("15".equals(limit)) {
							if (u_age >= 15)
								access = true;
						} else {
							if (u_age >= 19)
								access = true;
						}
						if (access) {
							if (!src.equals("0")) {
								%>
								<a href="movieLike_ok.jsp?m_idx=<%=m_idx%>" class="btn-like">
									<img src="<%=src%>"> <span>찜하기</span>
								</a>
								<%
								}
						%>
						<button type="button" class="btn-review" id="listBt">리뷰
							게시판</button>
						<%
						} else {
							if (!src.equals("0")) {
								%>
								<a href="" class="btn-like" id="listBt5">
									<img src="<%=src%>"> <span>찜하기</span>
								</a>
								<%
								}
						%>
						<button type="button" class="btn-review" id="listBt3">리뷰
							게시판</button>
						<%
						}
						}
						}

						
						%>
					</div>
				</div>

				<!-- 줄거리 -->
				<div class="movie-story">
					<%=mdto.getM_story()%>
				</div>
			</div>
		</div>

		<!-- 출연 배우 -->
		<div class="movie-cast">
			<h2 class="section-title">출연 배우</h2>
			<div class="cast-grid">
				<%
				ArrayList<ActorDTO> actorlist = madao.getActorsByMovie(m_idx);
				if (actorlist == null || actorlist.isEmpty()) {
				%>
				<div class="cast-empty">등록된 배우가 없습니다</div>
				<%
				} else {
				for (ActorDTO adto : actorlist) {
					int a_idx = adto.getA_idx();
					String imgUrl = "/fvsb/actor/" + adto.getA_img();
				%>
				<div class="cast-card">
					<a href="/fvsb/actor/actorMovieList.jsp?a_idx=<%=a_idx%>"> <img
						src="<%=imgUrl%>" alt="<%=adto.getA_name()%>">
						<div class="cast-name"><%=adto.getA_name()%></div>
					</a>
				</div>
				<%
				}
				}
				%>
			</div>
		</div>
	</main>
	<%@ include file="/footer.jsp"%>
</body>
<script>
   var listBt = document.getElementById('listBt');
   if (listBt) {
      listBt.addEventListener('click', function() {
         openCenterPopup('/fvsb/review/reviewList.jsp?m_idx=' + <%=m_idx%>, 'review', 750, 500);
      });
   }
   var listBt2 = document.getElementById('listBt2');
   if (listBt2) {
      listBt2.addEventListener('click', function() {
         window.alert('리뷰게시판은 로그인 후에 이용해주세요');
      });
   }

   var listBt3 = document.getElementById('listBt3');
   if (listBt3) {
      listBt3.addEventListener('click', function() {
         window.alert('해당 영화의 연령 제한으로 인해 리뷰 게시판에 접근할 수 없음');
      });
   }
   var listBt4 = document.getElementById('listBt4');
   if (listBt4) {
      listBt4.addEventListener('click', function() {
         window.alert('찜하기는 로그인 후에 이용해주세요');
      });
   }
   var listBt5 = document.getElementById('listBt5');
   if (listBt5) { 	
      listBt5.addEventListener('click', function() {
         window.alert('해당 영화의 연령 제한으로 인해 찜하기 불가능');
      });
   }
   
   function openCenterPopup(url, title, w, h) {
       var screenW = screen.width;
       var screenH = screen.height;
       
       var left = (screenW / 2) - (w / 2);
       var top = (screenH / 2) - (h / 2);
       
       var features = 'width=' + w + 
                      ', height=' + h + 
                      ', top=' + top + 
                      ', left=' + left + 
                      ', scrollbars=yes, resizable=no';
       
       window.open(url, title, features);
   }
</script>
</html>