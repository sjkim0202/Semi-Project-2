<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@page import="com.five.users.UsersDAO"%>
<%@page import="com.five.users.UsersDTO"%>
<%@page import="com.five.review.*"%>
<%@page import="com.five.movie.*"%>
<jsp:useBean id="udao" class="com.five.users.UsersDAO"></jsp:useBean>
<jsp:useBean id="rdao" class="com.five.review.ReviewDAO"></jsp:useBean>
<jsp:useBean id="mldao" class="com.five.movie_like.Movie_likeDAO"></jsp:useBean>

<%
String sessionId = (String) session.getAttribute("sid");
if(sessionId==null || sessionId.equals("")){
	%>
	<script>
	window.alert("로그인 후 이용가능합니다.");
	window.self.close();
	</script>
	<%
    return;
}
String cp = request.getParameter("cp");
if (cp == null || cp.equals("")) {
	cp = "0";
}
String m_idx_s = request.getParameter("m_idx");
int m_idx=0;
if (m_idx_s == null || m_idx_s.equals("")) {
	m_idx_s = "0";
}else{
	m_idx=Integer.parseInt(m_idx_s);
}
String u_idx_s = request.getParameter("u_idx");
int u_idx = 0;
if (u_idx_s == null || u_idx_s.equals("")) {
	u_idx_s = "0";
} else {
	u_idx = Integer.parseInt(u_idx_s);
}
String u_id = rdao.getU_id(u_idx);
sessionId = u_id;
ReviewDTO dto = rdao.selectReview(u_idx);

UsersDTO userInfo = null;
List<String> genreList = null;

if (sessionId == null || sessionId.isEmpty()) {
	response.sendRedirect("/fvsb/main.jsp");
	return;
}

try {
	userInfo = udao.getUserInfo(sessionId);
	genreList = udao.getUserGenres(sessionId);

} catch (Exception e) {
	e.printStackTrace();

}

if (userInfo == null) {
	response.sendRedirect("/fvsb/main.jsp");
}

String genreString = "";
if (genreList != null && !genreList.isEmpty()) {
	genreString = String.join(", ", genreList);
} else {
	// 장르가 없을 때만 '선택된 장르 없음'으로 설정
	genreString = "선택된 장르 없음";
}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>마이페이지 <%=userInfo.getU_name()%>님
</title>
<link rel="stylesheet" type="text/css" href="/fvsb/css/mainLayout.css">
<link rel="stylesheet" type="text/css" href="/fvsb/css/reviewLayout.css">
<link rel="icon" type="image/png" href="/fvsb/img/fvsb.png">
</head>
<body class="review-info">
<main>
	<section>
        <label>
        <%
        if(cp.equals("0")){
        	%>
        <a href="#" onclick="show()" class="btn-back">뒤로</a></label>
        	<%
        }else{
        %>
        <a href="/fvsb/review/reviewList.jsp?cp=<%=cp%>&m_idx=<%=m_idx%>" class="btn-back">뒤로</a></label>
        <%} %>
		<h2><%=userInfo.getU_name()%>님의 마이페이지
		</h2>
		<div class="profile-header">
			<div class="profile-avatar">
				<img
					src="<%=request.getContextPath()%>/users/usersimg/<%=userInfo.getU_img()%>"
					alt="프로필 사진">
			</div>

			<div class="profile-text">
				<h3><%=userInfo.getU_name()%></h3>
				<p><%=userInfo.getU_id()%></p>
			</div>
		</div>
        
		<article>
			<table>
				<thead>
					<tr>
						<th colspan="2">회원 정보</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<th>아이디</th>
						<td><%=userInfo.getU_id()%></td>
					</tr>
					<tr>
						<th>이름</th>
						<td><%=userInfo.getU_name()%></td>
					</tr>
					<tr>
						<th>성별</th>
						<td><%="M".equals(userInfo.getU_sex()) ? "남" : "여"%></td>
					</tr>
					<tr>
						<th>출생연도</th>
						<td><%=userInfo.getU_year()%></td>
					</tr>
					<tr>
						<th>가입일</th>
						<td><%=userInfo.getU_date()%></td>
					</tr>
					<tr>
						<th>선호 장르</th>
						<td><%=genreString%></td>
					</tr>
				</tbody>
			</table>
		</article>
		<br>
		<%
		if(mldao.isM_like(u_idx)){
			%>
		<article>
			<table>
				<thead>
                    <tr>
						<th colspan="3"><%=userInfo.getU_name()%>님의 찜 영화 목록</th>
					</tr>
					<tr><%
					ArrayList<MovieDTO> arr=mldao.mlSelect(u_idx);
					int count=0;
					for(MovieDTO mdto:arr){
						++count;
					%>
						<td>
						<img src="/fvsb/movie/<%=mdto.getM_img() %>" width="150"><br><%=mdto.getM_name() %>
						</td>
						<%
						if(count%3==0){
							%>
							</tr>
							<tr>
						<%}
					} %>
					</tr>
				</thead>
			</table>
		</article>
			<%
		}
		%>
        
		<article id="review-article">
			<table>
				<thead>
                    <tr>
						<th colspan="4"><%=userInfo.getU_name()%>님의 최근 리뷰</th>
					</tr>
				</thead>
				<tbody>
					<tr>
				<%
				if(dto==null){
					%>
					<td colspan="4">작성된 리뷰가 없습니다.</td>
					<%
				}else{
				%>
						<th>번호</th>
						<td><%=dto.getR_idx()%></td>
						<th>작성날짜</th>
						<td><%=dto.getR_date()%></td>
					</tr>
					<tr>
						<th>작성자</th>
						<td><%=rdao.getWriter(dto.getU_idx())%></td>
						<th>좋아요</th>
						<td><%=dto.getR_like()%></td>
					</tr>
					<tr>
						<th>제목</th>
						<td colspan="3"><%=dto.getR_title()%></td>
					</tr>
					<tr height="200">
						<td colspan="4" align="left" valign="top"><%=dto.getR_comment().replaceAll("\n", "<br>")%>
						</td>
					</tr>
					<tr>
						<th colspan="4">점수 <%
						int scor = dto.getR_score();
						String score = "";
						switch (scor) {
						case 1:
							score = "★";
							break;
						case 2:
							score = "★★";
							break;
						case 3:
							score = "★★★";
							break;
						case 4:
							score = "★★★★";
							break;
							default:
						case 5:
							score = "★★★★★";
						}
						%> <%=score%></th>
						<%} %>
					</tr>
				</tbody>
			</table>
			
		</article>
        
	</section>
</main>
</body>
<script>
function show(){
window.self.close();
}
</script>
</html>