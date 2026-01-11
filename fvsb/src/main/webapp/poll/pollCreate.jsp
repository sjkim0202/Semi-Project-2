<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.five.users.*"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>투표 생성</title>
<link rel="stylesheet" type="text/css" href="/fvsb/css/mainLayout.css">
<link rel="stylesheet" type="text/css" href="/fvsb/css/voteLayout.css">
<link rel="icon" type="image/png" href="/fvsb/img/fvsb.png">
</head>
<%
String sid = (String) session.getAttribute("sid");
boolean isAdmin = false;

if (sid != null) {
	try {
		UsersDAO udao = new UsersDAO();
		UsersDTO udto = udao.getUserById(sid);
		if (udto != null && "admin".equals(udto.getU_ad())) {
	isAdmin = true;
		}
	} catch (Exception e) {
		e.printStackTrace();
	}
}

if (!isAdmin) {
%>
<script>
	window.alert("관리자만 접근 가능합니다.");
	location.href = '/fvsb/main.jsp';
</script>
<%
return;
}
%>
<body class="poll-create">
	<%@ include file="/header.jsp"%>

	<main>
		<section>
			<h2>투표 생성</h2>

			<article class="poll-create-form">
				<form action="pollCreate_ok.jsp" method="post">
					<div class="form-group">
						<label for="poll_name">투표명</label> <input type="text"
							id="poll_name" name="poll_name" placeholder="이달의 투표 텍스트를 입력하세요"
							maxlength="100" required>
					</div>

					<div class="form-row">
						<div class="form-group">
							<label for="startDate">시작일</label> <input type="date"
								id="startDate" name="startDate" required>
						</div>
						<div class="form-group">
							<label for="endDate">종료일</label> <input type="date" id="endDate"
								name="endDate" required>
						</div>
					</div>

					<div class="form-buttons">
						<a href="pollList.jsp" class="btn-cancel">취소</a>
						<button type="submit" class="btn-submit">투표 생성</button>
					</div>
				</form>
			</article>
		</section>
	</main>

	<%@ include file="/footer.jsp"%>
</body>
</html>
