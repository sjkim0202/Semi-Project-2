<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="com.five.users.*"%>
<jsp:useBean id="rdao" class="com.five.review.ReviewDAO" scope="session"></jsp:useBean>
<jsp:useBean id="udao" class="com.five.users.UsersDAO"></jsp:useBean>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>리뷰 작성</title>
<link rel="stylesheet" type="text/css" href="/fvsb/css/mainLayout.css">
<link rel="stylesheet" type="text/css" href="/fvsb/css/reviewLayout.css">
<link rel="icon" type="image/png" href="/fvsb/img/fvsb.png">
</head>
<%
String m_idx_s = request.getParameter("m_idx");
int m_idx = Integer.parseInt(m_idx_s);
String sid = (String) session.getAttribute("sid");
if (sid == null || sid.equals("")) {
%>
<script>
	window.alert("로그인이 필요합니다.");
	location.href="reviewList.jsp?m_idx=<%=m_idx%>";
	</script>
<%
return;
}
UsersDTO udto = udao.getUserById(sid);
int u_idx = udao.getUserById(sid).getU_idx();
if (rdao.selectReview(u_idx, m_idx)) {
%>
<script>
	window.alert("이미 리뷰를 남겼습니다.");
	location.href="reviewList.jsp?m_idx=<%=m_idx%>";
</script>
<%
} else {
%>
<body class="review-write">
	<main>
		<section>
			<article>
				<form name="review" action="reviewWrite_ok.jsp?m_idx=<%=m_idx%>"
					method="post">
					<fieldset>
						<legend>리뷰 작성</legend>
						<table>
							<tr>
								<td>작성자:<%=udto.getU_name()%>
								</td>
							</tr>
							<tr>
								<td><label>별점:</label> <select name="r_score">
										<option value="5">★★★★★</option>
										<option value="4">★★★★</option>
										<option value="3">★★★</option>
										<option value="2">★★</option>
										<option value="1">★</option>
								</select></td>
							</tr>
							<tr>
								<td>제목:<input type="text" name="r_title">
							</tr>
							<tr>
								<td><textarea rows="20" cols="90" name="r_comment"></textarea>
								</td>
							</tr>
							<tr>
								<td><input type="submit" value="리뷰작성"> <input
									type="reset" value="다시작성"></td>
							</tr>
							<tr>
								<td colspan="2"><a href="reviewList.jsp?m_idx=<%=m_idx%>">뒤로</a></td>
							</tr>
						</table>
					</fieldset>
				</form>
			</article>
		</section>
	</main>
</body>
</html>
<%
}
%>