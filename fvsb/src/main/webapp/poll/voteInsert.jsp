<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.five.vote.*"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>투표 처리</title>
<link rel="stylesheet" type="text/css" href="/fvsb/css/mainLayout.css">
<link rel="stylesheet" type="text/css" href="/fvsb/css/voteLayout.css">
<link rel="icon" type="image/png" href="/fvsb/img/fvsb.png">
</head>
<%
request.setCharacterEncoding("UTF-8");

String u_id = (String) session.getAttribute("sid");
String pollId_s = request.getParameter("poll_id");
String mIdx_s = request.getParameter("m_idx");

String message = "잘못된 접근입니다.";
String statusClass = "error";
boolean success = false;

if (u_id == null) {
	message = "로그인 후 이용 가능합니다.";
} else if (pollId_s == null || mIdx_s == null || pollId_s.equals("") || mIdx_s.equals("")) {
	message = "잘못된 접근입니다.";
} else {
	try {
		int poll_id = Integer.parseInt(pollId_s);
		int m_idx = Integer.parseInt(mIdx_s);

		VoteDAO vdao = new VoteDAO();
		int u_idx = vdao.findIdx(u_id);

		boolean already = vdao.hasUserVoted(poll_id, u_idx);
		if (already) {
	message = "이미 투표하셨습니다.";
		} else {
	VoteDTO dto = new VoteDTO();
	dto.setPoll_id(poll_id);
	dto.setM_idx(m_idx);
	dto.setU_idx(u_idx);

	int result = vdao.insertVote(dto);
	if (result > 0) {
		message = "투표가 완료되었습니다!";
		statusClass = "success";
		success = true;
	} else {
		message = "투표에 실패했습니다.";
	}
		}
	} catch (Exception e) {
		message = "처리 중 오류가 발생했습니다.";
		e.printStackTrace();
	}
}
%>

<body class="vote-insert">
	<%@ include file="/header.jsp"%>

	<main>
		<section>
			<h2>투표 처리 결과</h2>

			<article class="vote-result-card">
				<div class="result-status <%=statusClass%>">
					<div class="status-icon">
						<%
						if (success) {
						%>
						<span>✓</span>
						<%
						} else {
						%>
						<span>✕</span>
						<%
						}
						%>
					</div>
					<div class="status-message">
						<%=message%>
					</div>
				</div>

				<div class="btn-group">
					<%
					if (success) {
					%>
					<a
						href="voteResult.jsp?poll_id=<%=request.getParameter("poll_id")%>"
						class="btn-primary result-link">결과 보기</a>
					<%
					}
					%>
					<a href="pollList.jsp" class="btn-cancel">목록으로</a>
				</div>
			</article>
		</section>
	</main>

	<%@ include file="/footer.jsp"%>
</body>
</html>
