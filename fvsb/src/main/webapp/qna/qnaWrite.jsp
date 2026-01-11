<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.five.qna.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<jsp:useBean id="qdao" class="com.five.qna.QnaDAO" scope="session" />
<jsp:useBean id="qdto" class="com.five.qna.QnaDTO" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>문의 글쓰기</title>
<link rel="stylesheet" type="text/css" href="/fvsb/css/mainLayout.css">
<link rel="stylesheet" type="text/css" href="/fvsb/css/qnaLayout.css">
<link rel="icon" type="image/png" href="/fvsb/img/fvsb.png">
<script>
	function goBack() {
		location.href = '/fvsb/qna/qnaList.jsp';
	}
</script>
</head>
<body class="qna-write">
	<%@ include file="/header.jsp"%>
	<main>
		<section>
			<h2>문의게시판 글쓰기</h2>
			<article>
				<form name="qnaWrite" action="qnaWrite_ok.jsp" method="post">
					<table>
						<tr>
							<th colspan="2">작성자</th>
							<td colspan="2"><%=sname%></td>
						</tr>
						<tr>
							<th>제목</th>
							<td colspan="3" align="center"><input type="text"
								name="q_title" class="titletext"></td>
						</tr>
						<tr>
							<td colspan="4" align="center"><textarea name="q_comment"
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