<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="com.five.review.*"%>
<%@page import="com.five.review_comments.*"%>
<%@ page import="com.five.users.*"%>
<%@ page import="java.util.*"%>
<jsp:useBean id="rdao" class="com.five.review.ReviewDAO"></jsp:useBean>
<jsp:useBean id="udao" class="com.five.users.UsersDAO"></jsp:useBean>
<jsp:useBean id="rldao" class="com.five.review_like.Review_likeDAO"></jsp:useBean>
<jsp:useBean id="rcdao"
	class="com.five.review_comments.Review_commentsDAO"></jsp:useBean>

<!DOCTYPE html>
<%
String cp = request.getParameter("cp");
String m_idx = request.getParameter("m_idx");
String r_idx_s = request.getParameter("r_idx");
String u_idx_s = request.getParameter("u_idx");
String dap = request.getParameter("dap");

if (r_idx_s == null || r_idx_s.equals(""))
	r_idx_s = "0";
if (u_idx_s == null || u_idx_s.equals(""))
	u_idx_s = "0";
if (dap == null || u_idx_s.equals(""))
	dap = "0";

int r_idx = Integer.parseInt(r_idx_s);
int u_idx = Integer.parseInt(u_idx_s);

String sid = (String) session.getAttribute("sid");
if (sid == null || sid.equals("")) {
%>
<script>
window.alert("로그인 후 이용가능합니다.");
location.href="/fvsb/review/reviewList.jsp?cp=<%=cp%>";
</script>
<%
return;
}

UsersDTO udto = udao.getUserById(sid);
String u_ad = udto.getU_ad();
String u_name = udto.getU_name();

ReviewDTO dto = rdao.reviewComment(r_idx);
if (dto == null) {
%>
<script>
window.alert("잘못된 접근입니다.");
</script>
<%
return;
}

String src = "/fvsb/review/reviewimg/heart_2.png";
if (rldao.isR_like(udao.getUserById(sid).getU_idx(), r_idx)) {
src = "/fvsb/review/reviewimg/heart.png";
}

ArrayList<Review_commentsDTO> arr = rcdao.commentRC(r_idx);
%>
<html>
<head>
<meta charset="UTF-8">
<title>리뷰 상세</title>
<link rel="stylesheet" type="text/css" href="/fvsb/css/reviewLayout.css">
<link rel="icon" type="image/png" href="/fvsb/img/fvsb.png">
</head>

<body class="review-comment">
	<main>
		<section>

			<!-- 본글 -->
			<article class="review-main">
				<table>
					<tr>
						<th>번호</th>
						<td><%=dto.getR_idx()%></td>
						<th>작성날짜</th>
						<td><%=dto.getR_date()%></td>
					</tr>
					<tr>
						<th>작성자</th>
						<td><%=rdao.getWriter(dto.getU_idx())%></td>
						<th>좋아요</th>
						<%if(dap.equals("2")){
							%>
						<td><%=dto.getR_like()%>
							<%
						}else{%>
						<td><a href="reviewLike_ok.jsp?cp=<%=cp%>&m_idx=<%=m_idx%>&r_idx=<%=r_idx%>&u_idx=<%=udto.getU_idx()%>">
								<img src="<%=src%>" width="30" class="like-btn"> <%=dto.getR_like()%>
						</a><%} %></td>
					</tr>
					<tr>
						<th>제목</th>
						<td colspan="3"><%=dto.getR_title()%></td>
					</tr>
					<tr>
						<td colspan="4" style="padding-top: 15px;"><%=dto.getR_comment().replaceAll("\n", "<br>")%></td>
					</tr>
					<tr>
						<th>점수</th>
						<td colspan="3">
							<%
							int scor = dto.getR_score();
							String score = "★★★★★".substring(0, scor);
							%> <%=score%>
						</td>
					</tr>
				</table>

				<!-- 하단 버튼 -->
				<div class="bottom-btns">
				<%
				if(dap.equals("2")){
				%>
					<button type="button" class="gray-btn" onclick="goBack()">이전으로</button><%
				}else{
				%>
					<button type="button" onclick="goReply()">댓글달기</button>
					<%
					if (udto.getU_idx() == dto.getU_idx() || u_ad.equals("admin")) {
					%>
					<button type="button" onclick="goDelete()">삭제</button>
					<%
					}
					if(dap.equals("0")){
					%>
					<button type="button" class="gray-btn" onclick="goBack()">이전으로</button>
					<%						
					}else{%>
					<button type="button" class="gray-btn" onclick="goMok()">목록으로</button>
					<%}}
					%>
				</div>
			</article>

			<!-- 댓글 -->
			<%
			if (arr != null && arr.size() > 0) {
			%>
			<hr class="comment-divider">
			<label>댓글 목록</label>
			<article class="comments-section">
				<table>
					<%
					for (Review_commentsDTO rcdto : arr) {
					%>
					<tr>
						<td>작성자: <%=rdao.getWriter(rcdto.getU_idx())%></td>
						<td>작성날짜: <%=rcdto.getRc_date()%></td>
					</tr>
					<tr>
						<td colspan="2" class="comment-content"><%=rcdto.getRc_comment().replaceAll("\n", "<br>")%>
							<%
							if(!dap.equals("2")){
							if (rdao.getWriter(rcdto.getU_idx()).equals(u_name) || u_ad.equals("admin")) {
							%>
							<a
							href="reviewReDelete_ok.jsp?cp=<%=cp%>&m_idx=<%=m_idx%>&r_idx=<%=r_idx%>&rc_idx=<%=rcdto.getRc_idx()%>">삭제</a>
							<%
							}}
							%></td>
					</tr>
					<%
					}
					%>
				</table>
			</article>
			<%
			}
			%>

		</section>
	</main>

	<script>
function goBack() {
  history.back();
}
function goReply() {
  location.href="reviewReWrite.jsp?cp=<%=cp%>&r_idx=<%=r_idx%>&m_idx=<%=m_idx%>";
}
function goDelete() {
  if (confirm("리뷰를 삭제하시겠습니까?")) {
    location.href="reviewDelete_ok.jsp?m_idx=<%=m_idx%>&r_idx=<%=r_idx%>&u_idx=<%=u_idx%>";
			}
		}
function goMok(){
	  location.href="reviewList.jsp?cp=<%=cp%>&m_idx=<%=m_idx%>";
}
	</script>

</body>
</html>
