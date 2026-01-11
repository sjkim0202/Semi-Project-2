<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.five.users.*"%>
<%@ page import="com.five.vote.*"%>

<jsp:useBean id="udao" class="com.five.users.UsersDAO" />

<%
request.setCharacterEncoding("UTF-8");

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

UsersDTO loginUser = udao.getUserInfo(sid);
if (loginUser == null) {
%>
<script>
	window.alert("유효하지 않은 사용자입니다.");
</script>
<%
return;
}

String auth = loginUser.getU_ad();
if (auth == null)
auth = "user";

boolean isAdmin = "admin".equals(auth);
boolean isUser = "user".equals(auth);

CreatePollDAO pdao = new CreatePollDAO();

ArrayList<CreatePollDTO> allPollList = null;
if (isAdmin) {
allPollList = pdao.getAllPolls();
}
ArrayList<CreatePollDTO> currentPollList = null;
if (isUser) {
currentPollList = pdao.getCurrentPollList();
}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>영화 투표 목록</title>
<link rel="stylesheet" type="text/css" href="/fvsb/css/mainLayout.css">
<link rel="stylesheet" type="text/css" href="/fvsb/css/voteLayout.css">
<link rel="icon" type="image/png" href="/fvsb/img/fvsb.png">
</head>
<body class="poll-list">
	<%@ include file="/header.jsp"%>

	<main>
		<section>
			<h2>영화 투표</h2>

			<%
			if (isAdmin) {
			%>
			<div class="write-btn-wrapper">
				<a href="pollCreate.jsp">새 투표 생성</a>
			</div>

			<article>
				<table>
					<thead>
						<tr>
							<th>번호</th>
							<th>투표명</th>
							<th>기간</th>
							<th>상세</th>
						</tr>
					</thead>
					<tbody>
						<%
						if (allPollList == null || allPollList.size() == 0) {
						%>
						<tr>
							<td colspan="4">등록된 투표가 없습니다.</td>
						</tr>
						<%
						} else {
						for (CreatePollDTO dto : allPollList) {
						%>
						<tr>
							<td><%=dto.getPoll_id()%></td>
							<td><%=dto.getPoll_name()%></td>
							<td><%=dto.getStartDate()%> ~ <%=dto.getEndDate()%></td>
							<td><a href="voteResult.jsp?poll_id=<%=dto.getPoll_id()%>"
								class="result-link"> 결과 보기 </a></td>
						</tr>
						<%
						}
						}
						%>
					</tbody>
				</table>
			</article>

			<%
			} else if (isUser) {
			%>
			<article>
				<h3>현재 진행중인 투표</h3>

				<%
				if (currentPollList == null || currentPollList.size() == 0) {
				%>
				<p>현재 진행 중인 투표가 없습니다.</p>
				<%
				} else {
				for (CreatePollDTO poll : currentPollList) {
				%>
				<div class="poll-item">
					<p class="poll-title">
						투표명:
						<%=poll.getPoll_name()%></p>
					<p class="poll-period">
						기간:
						<%=poll.getStartDate()%>
						~
						<%=poll.getEndDate()%></p>

					<a href="voteForm.jsp?poll_id=<%=poll.getPoll_id()%>"
						class="vote-link">투표하기</a> <a
						href="voteResult.jsp?poll_id=<%=poll.getPoll_id()%>"
						class="result-link">결과 보기</a>
				</div>
				<%
				}
				}
				%>
			</article>
			<%
			} else {
			%>
			<p>투표 화면을 볼 권한이 없습니다.</p>
			<%
			}
			%>
		</section>
	</main>

	<%@ include file="/footer.jsp"%>
</body>
</html>