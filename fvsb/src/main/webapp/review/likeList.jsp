<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.five.users.*"%>
<%@ page import="com.five.movie.*"%>
<jsp:useBean id="udao" class="com.five.users.UsersDAO"></jsp:useBean>
<jsp:useBean id="mldao" class="com.five.movie_like.Movie_likeDAO"></jsp:useBean>
<%
String sid = (String) session.getAttribute("sid");

UsersDTO dto = udao.getUserById(sid);

int u_idx = dto.getU_idx();
boolean hasLikes = mldao.isM_like(u_idx);
ArrayList<MovieDTO> arr = null;
if (hasLikes) {
	arr = mldao.mlSelect(u_idx);
}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>찜 영화 목록</title>
<link rel="stylesheet" type="text/css" href="/fvsb/css/reviewLayout.css">
<link rel="icon" type="image/png" href="/fvsb/img/fvsb.png">
</head>
<body class="like-list">
	<h2><%=dto.getU_name()%>님의 찜 영화 목록
	</h2>

	<div class="movie-container">
		<%
		if (hasLikes && arr != null && arr.size() > 0) {
		%>
		<div class="movie-grid">
			<%
			for (MovieDTO mdto : arr) {
			%>
			<div class="movie-card">
				<a href="javascript:void(0);" onclick="show(<%=mdto.getM_idx()%>)">
					<img src="/fvsb/movie/<%=mdto.getM_img()%>"
					alt="<%=mdto.getM_name()%>">
					<div class="movie-title"><%=mdto.getM_name()%></div>
				</a>
			</div>
			<%
			}
			%>
		</div>
		<%
		} else {
		%>
		<div class="movie-empty">아직 찜한 영화가 없습니다.</div>
		<%
		}
		%>
	</div>
	<div class="btn-area">
		<button type="button" class="btn-close" onclick="window.close();">닫기</button>
	</div>
</body>
<script>
function show(m_idx_val) {
	window.opener.location.href = "/fvsb/movie/movieDetail.jsp?m_idx=" + m_idx_val;
	window.close();
}
</script>
</html>