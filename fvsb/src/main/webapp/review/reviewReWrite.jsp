<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="com.five.users.*"%>
<jsp:useBean id="rdao" class="com.five.review.ReviewDAO" scope="session"></jsp:useBean>
<jsp:useBean id="udao" class="com.five.users.UsersDAO"></jsp:useBean>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>댓글 작성</title>
<link rel="stylesheet" type="text/css" href="/fvsb/css/mainLayout.css">
<link rel="stylesheet" type="text/css" href="/fvsb/css/reviewLayout.css">
<link rel="icon" type="image/png" href="/fvsb/img/fvsb.png">
</head>
<%
String sid = (String) session.getAttribute("sid");
UsersDTO udto = udao.getUserById(sid);
String cp = request.getParameter("cp");
String m_idx = request.getParameter("m_idx");
String r_idx = request.getParameter("r_idx");
int u_idx = udao.getUserById(sid).getU_idx();
String dap="1";
%>
<body class="review-rewrite">
	<main>
		<section>
			<article>
				<form name="review" action="reviewReWrite_ok.jsp" method="post">
				<input type="hidden" name="cp" value=<%=cp %>>
				<input type="hidden" name="m_idx" value=<%=m_idx %>>
				<input type="hidden" name="r_idx" value=<%=r_idx %>>
				<input type="hidden" name="u_idx" value=<%=u_idx %>>
					<fieldset>
						<legend>댓글 작성</legend>
						<table>
							<tr>
								<td>작성자:<%=udto.getU_name()%>
								</td>
							</tr>
							<tr>
								<td><textarea rows="20" cols="90" name="rc_comment"></textarea>
								</td>
							</tr>
							<tr>
								<td><input type="submit" value="댓글작성"> <input type="reset" value="다시작성"></td>
							</tr>
							<tr>
								<td colspan="2"><a href="/fvsb/review/reviewComment.jsp?dap=<%=dap%>&cp=<%=cp %>&m_idx=<%=m_idx %>&r_idx=<%=r_idx %>&u_idx=<%=u_idx%>">뒤로</a>
								</td>
							</tr>
						</table>
					</fieldset>
				</form>
			</article>
		</section>
	</main>
</body>
</html>
