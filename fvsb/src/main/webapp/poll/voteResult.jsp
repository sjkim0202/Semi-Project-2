<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.five.vote.*"%>
<%@ page import="com.five.movie.*"%>

<%
request.setCharacterEncoding("UTF-8");

String pollId_s = request.getParameter("poll_id");
if (pollId_s == null || pollId_s.equals("")) {
%>
<script>
	window.alert("잘못된 접근입니다.");
</script>
<%
return;
}
int poll_id = Integer.parseInt(pollId_s);

CreatePollDAO pdao = new CreatePollDAO();
CreatePollDTO poll = pdao.getPollById(poll_id);
if (poll == null) {
%>
<script>
	window.alert("존재하지 않는 투표입니다.");
</script>
<%
return;
}

VoteDAO vdao = new VoteDAO();
ArrayList<VoteResultDTO> resultList = vdao.getVoteResultByPoll(poll_id);

MovieDAO mdao = new MovieDAO();
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>투표 결과</title>
<link rel="stylesheet" type="text/css" href="/fvsb/css/mainLayout.css">
<link rel="stylesheet" type="text/css" href="/fvsb/css/voteLayout.css">
<link rel="icon" type="image/png" href="/fvsb/img/fvsb.png">
</head>
<body class="poll-result">
	<%@ include file="/header.jsp"%>

	<main>
		<section>
			<h2>영화 투표 결과</h2>
			<article class="poll-result-card">
				<div class="poll-info">
					<p>
						기간:
						<%=poll.getStartDate()%>
						~
						<%=poll.getEndDate()%></p>
				</div>

				<div class="result-table-wrapper">
					<table class="result-table" border="1" cellpadding="5"
						cellspacing="0">
						<thead>
							<tr>
								<th>순위</th>
								<th>영화 제목</th>
								<th>득표수</th>
							</tr>
						</thead>
						<tbody>
							<%
							if (resultList == null || resultList.isEmpty()) {
							%>
							<tr>
								<td colspan="3" class="empty-msg">아직 투표 데이터가 없습니다.</td>
							</tr>
							<%
							} else {
							int rank = 1;
							for (VoteResultDTO r : resultList) {
								int m_idx = r.getM_idx();
								MovieDTO mdto = mdao.movieView(m_idx);
							%>
							<tr>
								<td class="rank"><%=rank++%></td>
								<td class="movie-title"><%=mdto != null ? mdto.getM_name() : ("영화번호 " + m_idx)%></td>
								<td class="vote-count"><%=r.getCount()%></td>
							</tr>
							<%
							}
							}
							%>
						</tbody>
					</table>
				</div>

				<div class="btn-group">
					<a href="pollList.jsp" class="btn-primary">투표 목록으로</a>
				</div>
			</article>
		</section>
	</main>

	<%@ include file="/footer.jsp"%>
</body>
</html>
