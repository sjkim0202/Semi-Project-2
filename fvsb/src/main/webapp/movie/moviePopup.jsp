<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.five.movie.*"%>
<%@ page import="java.util.*"%>

<%
request.setCharacterEncoding("UTF-8");

String date = request.getParameter("date"); // "YYYY-MM-DD"
List<MovieDTO> moviesForDate = new ArrayList<MovieDTO>();

if (date != null && date.length() > 0) {
	// "YYYY-MM"
	String yearMonth = (date.length() >= 7) ? date.substring(0, 7) : null;

	if (yearMonth != null) {
		MovieDAO mdao = new MovieDAO();
		Map<String, List<MovieDTO>> map = mdao.getMoviesByMonth(yearMonth);

		if (map != null && map.get(date) != null) {
	moviesForDate = map.get(date);
		}
	}
}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title><%=(date == null ? "영화 목록" : date + " 개봉 영화")%></title>
<link rel="stylesheet" type="text/css" href="/fvsb/css/mainLayout.css">
<link rel="stylesheet" type="text/css" href="/fvsb/css/movieLayout.css">
<link rel="icon" type="image/png" href="/fvsb/img/fvsb.png">
</head>
<body class="movie-popup">
	<div class="popup-wrapper">
		<h2><%=(date == null ? "선택된 날짜 없음" : date + " 개봉 영화")%></h2>

		<div class="popup-desc">
			<%=(date == null ? "달력에서 날짜를 다시 선택해주세요." : "해당 날짜에 개봉한 영화 목록입니다.")%>
		</div>

		<%
		if (date != null && !date.trim().isEmpty()) {
			if (moviesForDate == null || moviesForDate.isEmpty()) {
		%>
		<div class="popup-empty">해당 날짜에 개봉한 영화가 없습니다.</div>
		<%
		} else {
		%>
		<ul class="popup-movie-list">
			<%
			for (MovieDTO dto : moviesForDate) {
				int mid = dto.getM_idx();
				String title = dto.getM_name();
				if (title == null)
					title = "(제목 없음)";

				String detailUrl = "/fvsb/movie/moviePreviewPopup.jsp?m_idx=" + mid;
			%>
			<li><a href="<%=detailUrl%>"><%=title%></a></li>
			<%
			}
			%>
		</ul>
		<%
		}
		}
		%>

		<div class="popup-btn-area">
			<button type="button" onclick="window.close();">닫기</button>
		</div>
	</div>
</body>
<script>
	window.onload = function() {
		window.resizeTo(450, 550);
	};

	var closeBt = document.querySelector('.popup-btn-area button');
	if (closeBt) {
		closeBt.addEventListener('click', function() {
			window.close();
		});
	}
</script>
</html>