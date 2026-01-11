<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.five.vote.*"%>
<%@ page import="com.five.movie.*"%>
<%@ page import="com.five.users.*"%>
<jsp:useBean id="udao" class="com.five.users.UsersDAO"></jsp:useBean>

<%
request.setCharacterEncoding("UTF-8");

String u_id = (String) session.getAttribute("sid");

if (u_id == null) {
%>
<script>
	window.alert("로그인 후 이용 가능합니다.");
	location.href = '/fvsb/main.jsp';
</script>
<%
return;
}

UsersDTO loginUser = udao.getUserInfo(u_id);
if (loginUser == null) {
%>
<script>
	window.alert("유효하지 않은 사용자입니다.");
	location.href = '/fvsb/main.jsp';
</script>
<%
return;
}
String auth = loginUser.getU_ad();
if (auth == null)
auth = "user";
boolean isAdmin = "admin".equals(auth);

String pollId_s = request.getParameter("poll_id");
if (pollId_s == null || pollId_s.equals("")) {
%>
<script>
	window.alert("잘못된 접근입니다");
	location.href = 'voteList.jsp';
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
	location.href = 'voteList.jsp';
</script>
<%
return;
}

// 중복투표 체크
VoteDAO vdao = new VoteDAO();
int u_idx = vdao.findIdx(u_id);
boolean already = vdao.hasUserVoted(poll_id, u_idx);

// 영화 목록
MovieDAO mdao = new MovieDAO();
ArrayList<MovieDTO> movieList = mdao.getMovieList();
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>투표하기</title>
<link rel="stylesheet" type="text/css" href="/fvsb/css/mainLayout.css">
<link rel="stylesheet" type="text/css" href="/fvsb/css/voteLayout.css">
<link rel="icon" type="image/png" href="/fvsb/img/fvsb.png">
</head>
<body class="poll-vote">
	<%@ include file="/header.jsp"%>

	<main>
		<section>
			<h2>영화 투표</h2>

			<article class="poll-vote-card">
				<div class="poll-info">
					<div class="poll-period">
						기간:
						<%=poll.getStartDate()%>
						~
						<%=poll.getEndDate()%>
					</div>
				</div>

				<%
				if (already) {
				%>
				<div class="vote-status already-voted">
					<p class="status-message">이미 이 투표에 참여하셨습니다.</p>
					<div class="btn-group">
						<a href="voteResult.jsp?poll_id=<%=poll_id%>"
							class="btn-primary result-link">결과 보기</a>
					</div>
				</div>
				<%
				} else if (isAdmin) {
				%>
				<div class="vote-status admin-view">
					<p class="status-message">관리자님은 투표 참여가 불가합니다.</p>
					<div class="btn-group">
						<a href="voteResult.jsp?poll_id=<%=poll_id%>"
							class="btn-primary result-link">결과 보기</a>
					</div>
				</div>
				<%
				} else {
				%>
				<form action="voteInsert.jsp" method="post" class="vote-form">
					<input type="hidden" name="poll_id" value="<%=poll_id%>">

					<div class="form-group">
						<label>영화를 선택하세요</label>
						<%
						if (movieList == null || movieList.size() == 0) {
						%>
						<div class="empty-state">등록된 영화가 없습니다.</div>
						<%
						} else {
						%>
						<div class="movie-list">
							<%
							for (MovieDTO mdto : movieList) {
							%>
							<label class="movie-option"> <input type="radio"
								name="m_idx" value="<%=mdto.getM_idx()%>" required> <span
								class="movie-name"><%=mdto.getM_name()%></span>
							</label>
							<%
							}
							%>
						</div>
						<%
						}
						%>
					</div>

					<div class="btn-group">
						<a href="pollList.jsp" class="btn-cancel">목록</a>
						<button type="submit" class="btn-primary">투표하기</button>
					</div>
				</form>
				<%
				}
				%>
			</article>
		</section>
	</main>

	<%@ include file="/footer.jsp"%>
</body>
</html>
