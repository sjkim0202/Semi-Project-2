<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.five.qna.*"%>
<%@ page import="java.util.*"%>
<jsp:useBean id="qdao" class="com.five.qna.QnaDAO" scope="session" />

<%
String sid = (String) session.getAttribute("sid");
if (sid == null) {
%>
<script>
	window.alert("로그인 후 이용 가능합니다.");
	location.href = "/fvsb/main.jsp";
</script>
<%
return;
}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>문의게시판</title>
<link rel="stylesheet" type="text/css" href="/fvsb/css/mainLayout.css">
<link rel="stylesheet" type="text/css" href="/fvsb/css/qnaLayout.css">
<link rel="icon" type="image/png" href="/fvsb/img/fvsb.png">
<script>
	function qnaWrite() {
		location.href = "/fvsb/qna/qnaWrite.jsp";
	}
</script>
</head>
<%
int totalCnt = qdao.getTotalCnt();
int listSize = 5;
int pageSize = 5;

String cp_s = request.getParameter("cp");
if (cp_s == null || cp_s.equals("")) {
	cp_s = "1";
}

int cp = Integer.parseInt(cp_s);

int totalPage = totalCnt / listSize + 1;
if (totalCnt % listSize == 0)
	totalPage--;

int userGroup = cp / pageSize;
if (cp % pageSize == 0)
	userGroup--;
%>
<body class="qna-list">
	<%@ include file="/header.jsp"%>

	<main>
		<section>
			<h2>문 의 게 시 판</h2>

			<!-- 글쓰기 버튼을 테이블 위로 -->
			<div class="write-btn-wrapper">
				<a href="qnaWrite.jsp">글쓰기</a>
			</div>

			<article>
				<table>
					<thead>
						<tr>
							<th>번호</th>
							<th>제목</th>
							<th>작성자</th>
							<th>날짜</th>
						</tr>
					</thead>

					<tbody>
						<%
						ArrayList<QnaDTO> arr = qdao.qnaList(cp, listSize);
						if (arr == null || arr.size() == 0) {
						%>
						<tr>
							<td colspan="4">등록된 글 없음</td>
						</tr>
						<%
						} else {
						for (QnaDTO dto : arr) {
						%>
						<tr>
							<td><%=dto.getQ_idx()%></td>
							<td>
								<%
								for (int z = 0; z < dto.getQ_lev(); z++) {
									out.print("&nbsp;&nbsp;&nbsp;");
								}
								%><a href="qnaContent.jsp?idx=<%=dto.getQ_idx()%>">🔒<%=dto.getQ_title()%></a>
							</td>
							<td><%=dto.getU_name()%></td>
							<td><%=dto.getQ_date()%></td>
						</tr>
						<%
						}
						}
						%>
					</tbody>

					<tfoot>
						<tr>
							<td colspan="4" align="center">
								<%
								if (userGroup != 0) {
								%> <a
								href="qnaList.jsp?cp=<%=(userGroup - 1) * pageSize + pageSize%>">&lt;&lt;</a>
								<%
								}
								for (int i = userGroup * pageSize + 1; i <= userGroup * pageSize + pageSize; i++) {
								%> &nbsp;&nbsp; <a href="qnaList.jsp?cp=<%=i%>"><%=i%></a>&nbsp;&nbsp;
								<%
								if (i == totalPage)
									break;
								}
								if (userGroup != (totalPage / pageSize) - (totalPage % pageSize == 0 ? 1 : 0)) {
								%> <a href="qnaList.jsp?cp=<%=(userGroup + 1) * pageSize + 1%>">&gt;&gt;</a>
								<%
								}
								%>
							</td>
						</tr>
					</tfoot>
				</table>
			</article>
		</section>
	</main>

	<%@ include file="/footer.jsp"%>
</body>
</html>
