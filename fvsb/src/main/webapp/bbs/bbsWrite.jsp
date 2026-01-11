<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.five.bbs.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<jsp:useBean id="bdao" class="com.five.bbs.BbsDAO" scope="session" />
<jsp:useBean id="bdto" class="com.five.bbs.BbsDTO" />
<%
String sid = (String) session.getAttribute("sid");
if (sid == null) {
%>
<script>
	window.alert("로그인 후 이용 가능합니다.");
	location.href = "/fvsb/bbs/bbsList.jsp";
</script>
<%
return;
}
%>
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
		location.href = 'bbsList.jsp';
	}
</script>
</head>
<body class="bbs-write">
	<%@ include file="/header.jsp"%>
	<main>
		<section>
			<h2>자유게시판 글쓰기</h2>
			<article>
				<form name="bbsWrite" action="bbsWrite_ok.jsp" method="post">
					<table>
						<tr>
							<th colspan="2">작성자</th>
							<td colspan="2"><%=sname%></td>
						</tr>
						<tr>
							<th>제목</th>
							<td colspan="3" align="center"><input type="text"
								name="b_title" class="titletext"></td>
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