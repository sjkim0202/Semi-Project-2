<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.five.review.*" %>
<%@ page import="com.five.users.*" %>
<jsp:useBean id="rdao" class="com.five.review.ReviewDAO"></jsp:useBean>
<jsp:useBean id="rldao" class="com.five.review_like.Review_likeDAO"></jsp:useBean>
<jsp:useBean id="udao" class="com.five.users.UsersDAO"></jsp:useBean>
<%
String r_idx_s=request.getParameter("r_idx");
int r_idx=Integer.parseInt(r_idx_s);
ReviewDTO dto=rdao.reviewComment(r_idx);
String sid = (String)session.getAttribute("sid");
if (sid == null||sid.equals("")) {
	%>
	<script>
	window.alert("로그인 후 이용가능합니다.");
	window.self.close();
	location.href="/fvsb/award/awardList.jsp";
	</script>
	<%
    return;
}
String src="/fvsb/review/reviewimg/heart_2.png";
if(rldao.isR_like(udao.getUserById(sid).getU_idx(), r_idx)){
	src="/fvsb/review/reviewimg/heart.png";
}
UsersDTO udto=udao.getUserById(sid);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>어워드 리뷰</title>
<link rel="stylesheet" type="text/css" href="/fvsb/css/reviewLayout.css">
<link rel="icon" type="image/png" href="/fvsb/img/fvsb.png">
</head>
<body class="review-text">
<section>
	<article>
		<table>
			<tr>
				<th>번호</th>
				<td><%=dto.getR_idx() %></td>
				<th>작성날짜</th>
				<td><%=dto.getR_date() %></td>
			</tr>
			<tr>
				<th>작성자</th>
				<td><%=rdao.getWriter(dto.getU_idx()) %></td>
				<th>좋아요</th>
				<td><%=dto.getR_like() %></td>
			</tr>
			<tr>
				<th>제목</th>
				<td colspan="3"><%=dto.getR_title() %></td>
			</tr>
			<tr height="200">
					<td colspan="4" align="left" valign="top">
					<%=dto.getR_comment().replaceAll("\n", "<br>") %>
				</td>
			</tr>
			<tr>
				<th>점수
				<%
				int scor=dto.getR_score();
				String score="";
				switch(scor){
				case 1:score="★";break;
				case 2:score="★★";break;
				case 3:score="★★★";break;
				case 4:score="★★★★";break;
				case 5:score="★★★★★";
				}
				%>
				<%=score %></th>
				<td><a href="reviewReLike_ok.jsp?r_idx=<%=dto.getR_idx()%>&u_idx=<%=udto.getU_idx()%>">
				<img alt="likeimg" src="<%=src %>" width="35" id="like_img"><%=dto.getR_like() %></a></td>
				</tr>
			</table>
		</article>
	</section>
</body>
</html>