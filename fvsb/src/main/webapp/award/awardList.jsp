<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.five.review.*"%>
<%@ page import="com.five.users.*"%>
<%@ page import="com.five.movie.*"%>
<jsp:useBean id="rdao" class="com.five.review.ReviewDAO"></jsp:useBean>
<jsp:useBean id="udao" class="com.five.users.UsersDAO"></jsp:useBean>
<%
String sid = (String) session.getAttribute("sid");
int u_idx = rdao.bestU_idx();
String u_id_1 = rdao.getU_id(u_idx);
UsersDTO udto_1 = udao.getUserById(u_id_1);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>FVSB 어워즈</title>
<link rel="stylesheet" type="text/css" href="/fvsb/css/mainLayout.css">
<link rel="stylesheet" type="text/css" href="/fvsb/css/awardLayout.css">
<link rel="icon" type="image/png" href="/fvsb/img/fvsb.png">
</head>
<body class="award-list">
	<%@ include file="/header.jsp"%>
	<main>
		<section>
			<h2>🏆FVSB 어워즈🏆</h2>
			<article>
				<div class="content-wrapper">
					<div class="review-lists">

						<table>
							<tr>
								<th>좋아요 👍<br>많은 리뷰 💬<br>Top3
								</th>
								<%
								ArrayList<ReviewDTO> arr = rdao.likeAward();
								if (arr == null || arr.size() == 0) {
								%>
							
							<tr>
								<td colspan="4" align="center">등록된 게시글이 없습니다.</td>
							</tr>
							<%
							} else {
							int count = 0;
							for (ReviewDTO dto : arr) {
								if (count < 3) {
									count++;
									String u_id = rdao.getU_id(dto.getU_idx());
									UsersDTO udto = udao.getUserById(u_id);
									MovieDTO mdto = rdao.movieAward(dto.getM_idx());
							%>
							<td><a
								href="/fvsb/movie/movieDetail.jsp?m_idx=<%=dto.getM_idx()%>">
									<img src="/fvsb/movie/<%=mdto.getM_img()%>" alt="영화포스터"
									width="150">
									<div><%=mdto.getM_name()%></div>
							</a> <a href="#"
								onclick="openCenterPopup('/fvsb/review/reviewText.jsp?r_idx=<%=dto.getR_idx()%>', 'popup', 750, 500); return false;">
									<div><%=udto.getU_name()%>:&nbsp;
										<%
										String r_comments = dto.getR_comment();
										String result = "";
										if (r_comments.length() > 20) {
											result = r_comments.substring(0, 20) + "...";
										} else {
											result = r_comments;
										}
										%>
										<%=result%></div>
									<div>
										<%
										int scor = dto.getR_score();
										String score = "";
										switch (scor) {
											case 1 :
												score = "★";
												break;
											case 2 :
												score = "★★";
												break;
											case 3 :
												score = "★★★";
												break;
											case 4 :
												score = "★★★★";
												break;
											case 5 :
												score = "★★★★★";
										}
										%>
										<div>
											점수:
											<%=score%>&nbsp;좋아요:&nbsp;<%=dto.getR_like()%></div>
							</a></td>
							<%
							}
							}
							}
							%>
						</table>
						<br>
						<table>
							<tr>
								<th>리뷰 💬<br>많은 영화 🎬<br>Top3
								</th>
								<%
								if(rdao.isReview()){
									ArrayList<MovieDTO> mArr = rdao.reviewAward();
									if (mArr == null || mArr.size() == 0) {
									%>
								
								<tr>
									<td colspan="6" align="center">등록된 게시글이 없습니다.</td>
								</tr>
								<%
								} else {
								int count = 0;
								for (MovieDTO dto : mArr) {
									if (count < 3) {
										count++;
								%>
								<td><a
									href="/fvsb/movie/movieDetail.jsp?m_idx=<%=dto.getM_idx()%>">
										<img src="/fvsb/movie/<%=dto.getM_img()%>" alt="영화포스터"
										width="150">
										<div><%=dto.getM_name()%></div>
								</a></td>
								<%
								}
								}
								}
								}else{
									%>
									
									<tr>
										<td colspan="6" align="center">등록된 게시글이 없습니다.</td>
									</tr>
									<%
								}
							%>
						</table>
					</div>

					<table class="best-reviewer-table">
						<tr>
							<th>베스트<br>리뷰어</th>
						</tr>
						<tr>
						<%
						if(udto_1==null){
							%>
								<td class="no-reviewer">아직 베스트 리뷰어가 없습니다. 어서 리뷰를 써보세요!</td>
							<%
						}else{
						%>
							<td><a href="#"
								onclick="openCenterPopup('/fvsb/review/reviewInfo.jsp?&u_idx=<%=u_idx%>', 'popup', 750, 500); return false;">
									<img src="/fvsb/users/usersimg/<%=udto_1.getU_img()%>"
									width="200">
							</a></td>
						</tr>
						<tr>
							<td><%=udto_1.getU_name()%>님</a><br>리뷰 개수: <%=rdao.bestCount()%>개</a></td>
						<%} %>
						</tr>
					</table>
				</div>
			</article>
		</section>
	</main>
	<%@ include file="/footer.jsp"%>
</body>
<script>
function openCenterPopup(url, title, w, h) {
    var screenW = screen.width;
    var screenH = screen.height;
    
    var left = (screenW / 2) - (w / 2);
    var top = (screenH / 2) - (h / 2);
    
    var features = 'width=' + w + 
                   ', height=' + h + 
                   ', top=' + top + 
                   ', left=' + left + 
                   ', scrollbars=yes, resizable=no'; // 스크롤바, 크기 변경 여부 추가
    
    window.open(url, title, features);
}
</script>
</html>