<%@page import="com.five.movie.MovieDTO"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:useBean id="mdao" class="com.five.movie.MovieDAO"></jsp:useBean>
<%
// --- 관리자 권한 체크 (sid 기준) ---
String sid = (String) session.getAttribute("sid"); // 로그인할 때 세션에 넣어둔 아이디

boolean isAdmin = false;

if (sid != null) {
	try {
		UsersDAO udao = new UsersDAO();
		UsersDTO udto = udao.getUserById(sid); // u_id로 조회하는 메서드 이미 있음

		if (udto != null && "admin".equals(udto.getU_ad())) {
	isAdmin = true;
		}
	} catch (Exception e) {
		e.printStackTrace();
	}
}

if (!isAdmin) {
%>
<script>
	window.alert('관리자만 접근 가능합니다.');
	location.href = '/fvsb/main.jsp';
</script>
<%
return;
}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>영화 관리 목록</title>
<link rel="stylesheet" type="text/css" href="/fvsb/css/mainLayout.css">
<link rel="icon" type="image/png" href="/fvsb/img/fvsb.png">
<link rel="stylesheet" type="text/css" href="/fvsb/css/adminLayout.css">
<style>
/* 영화 포스터 이미지 추가 스타일 */
article table tbody td img {
    width: 60px;
    height: 80px;
    object-fit: cover;
    border-radius: 4px;
}
</style>
</head>
<body>
	<%@include file="/header.jsp"%>
	<main>
		<section>
			<h2>영화 관리 목록</h2>
			
			<!-- 글쓰기 버튼 (필요시) -->
			<div class="table-header">
				<button type="button" class="write-btn"
					onclick="location.href='/fvsb/movie/movieRegister.jsp'">영화 추가</button>
			</div>
			
			<article>
				<%
				// 1. 전체 목록 먼저 불러옴 (DAO 수정 없음)
				ArrayList<MovieDTO> fullList = mdao.getMovieList();
				int totalCount = (fullList == null) ? 0 : fullList.size();

				// 2. 페이징 기본 설정
				int pageSize = 5; // 한 페이지에 보여줄 영화 수
				int blockSize = 5; // 한 번에 보여줄 페이지 번호 개수

				String pageNumStr = request.getParameter("pageNum");
				if (pageNumStr == null || pageNumStr.equals("")) {
					pageNumStr = "1";
				}
				int currentPage = Integer.parseInt(pageNumStr);

				// 3. 총 페이지 수 계산
				int pageCount = (totalCount == 0) ? 1 : (int) Math.ceil((double) totalCount / pageSize);

				if (currentPage > pageCount) {
					currentPage = pageCount;
				}

				// 4. 현재 페이지에서 사용할 인덱스 범위 계산 (0 기반 인덱스)
				int startIndex = (currentPage - 1) * pageSize; // 포함
				int endIndex = startIndex + pageSize; // 제외
				if (endIndex > totalCount) {
					endIndex = totalCount;
				}

				// 5. 페이지 블록 계산
				int startPage = (int) ((currentPage - 1) / blockSize) * blockSize + 1;
				int endPage = startPage + blockSize - 1;
				if (endPage > pageCount) {
					endPage = pageCount;
				}
				%>

				<table>
					<thead>
						<tr>
							<th>영화번호</th>
							<th>영화이름</th>
							<th>개봉날짜</th>
							<th>연령제한</th>
							<th>감독</th>
							<th>개봉국가</th>
							<th>이미지</th>
							<th>삭제</th>
						</tr>
					</thead>
					<tbody>
						<%
						int colspanCount = 8;
						if (fullList == null || totalCount == 0) {
						%>
						<tr>
							<td colspan="<%=colspanCount%>">등록된 영화가 없습니다.</td>
						</tr>
						<%
						} else {
						for (int i = startIndex; i < endIndex; i++) {
							MovieDTO mdto = fullList.get(i);
							String imgPath = "/fvsb/movie/" + mdto.getM_img();
						%>
						<tr>
							<td><%=mdto.getM_idx()%></td>
							<td><%=mdto.getM_name()%></td>
							<td><%=mdto.getM_date()%></td>
							<td><%=mdto.getM_limit()%></td>
							<td><%=mdto.getM_pd()%></td>
							<td><%=mdto.getM_country()%></td>
							<td><img src="<%=imgPath%>" alt="포스터"></td>
							<td>
								<button type="button"
									onclick="openDelete('<%=mdto.getM_idx()%>');">삭제</button>
							</td>
						</tr>
						<%
						}
						}
						%>
					</tbody>
				</table>
			</article>

			<hr>

			<div class="pagination">
				<%
				if (pageCount > 0) {

					if (startPage > blockSize) {
				%>
				<a class="page_link"
					href="movieAllList.jsp?pageNum=<%=startPage - 1%>">이전</a>
				<%
				}

				for (int i = startPage; i <= endPage; i++) {
				if (i == currentPage) {
				%>
				<span class="current_page"><%=i%></span>
				<%
				} else {
				%>
				<a class="page_link" href="movieAllList.jsp?pageNum=<%=i%>"><%=i%></a>
				<%
				}
				}

				if (endPage < pageCount) {
				%>
				<a class="page_link"
					href="movieAllList.jsp?pageNum=<%=endPage + 1%>">다음</a>
				<%
				}
				}
				%>
			</div>

		</section>
	</main>
	<%@include file="/footer.jsp"%>
	<script>
		function openDelete(mIdx) {
			if(confirm('정말 삭제하시겠습니까?')) {
				location.href = '/fvsb/admin/movieDelete.jsp?m_idx=' + mIdx;
			}
		}
	</script>
</body>
</html>