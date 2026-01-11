<%@page import="javax.print.DocFlavor.STRING"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.five.bbs.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<jsp:useBean id="bdao" class="com.five.bbs.BbsDAO" scope="session" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>글쓰기</title>
<link rel="stylesheet" type="text/css" href="/fvsb/css/mainLayout.css">
<link rel="stylesheet" type="text/css" href="/fvsb/css/bbsLayout.css">
<link rel="icon" type="image/png" href="/fvsb/img/fvsb.png">
<script>
	function goBack() {
		location.href = '/fvsb/bbs/bbsList.jsp';
	}
</script>
</head>
<%
String title = request.getParameter("b_title");
String ref = request.getParameter("b_ref");
String lev = request.getParameter("b_lev");
String step = request.getParameter("b_step");

if (title == null)
	title = "";
if (ref == null || ref.equals("null") || ref.equals(""))
	ref = "0";
if (lev == null || lev.equals("null") || lev.equals(""))
	lev = "0";
if (step == null || step.equals("null") || step.equals(""))
	step = "0";
%>
<body class="bbs-rewrite">
	<%@ include file="/header.jsp"%>
	<main>
		<section>
			<h2>문의게시판 답변 글쓰기</h2>
			<article>
				<form name="bbsReWrite" action="bbsReWrite_ok.jsp" method="post">
					<input type="hidden" name="b_ref" value="<%=ref%>"> <input
						type="hidden" name="b_lev" value="<%=lev%>"> <input
						type="hidden" name="b_step" value="<%=step%>">
					<table>
						<tr>
							<th colspan="2">작성자</th>
							<td colspan="2"><%=sname%></td>
						</tr>
						<tr>
							<th>제목</th>
							<td colspan="3" align="center"><input type="text"
								name="b_title" value="답변 :  <%=title%>" class="titletext"
								readonly></td>
						</tr>
						<tr>
							<td colspan="4" align="center"><textarea name="b_comment"
									class="commentBox"></textarea></td>
						</tr>
						<tr>
							<td colspan="4" align="center"><input type="submit"
								value="글 올리기"> <input type="reset" value="다시 작성">
								<input type="button" value="목록으로" onclick="goBack()"></td>
						</tr>
					</table>
				</form>
			</article>
		</section>
	</main>
	<%@ include file="/footer.jsp"%>
</body>
</html>