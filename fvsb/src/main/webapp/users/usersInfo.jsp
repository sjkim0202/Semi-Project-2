<%@page import="java.time.LocalDate"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.five.users.UsersDAO"%>
<%@ page import="com.five.users.UsersDTO"%>
<%@ page import="java.util.*"%>
<jsp:useBean id="udao" class="com.five.users.UsersDAO"></jsp:useBean>

<%
String sessionId = (String) session.getAttribute("sid");

UsersDTO userInfo = null;
List<String> genreList = null;

if (sessionId == null || sessionId.isEmpty()) {

	response.sendRedirect("/fvsb/index.jsp");
	return;
}

try {
	userInfo = udao.getUserInfo(sessionId);
	genreList = udao.getUserGenres(sessionId);

} catch (Exception e) {
	e.printStackTrace();

}

if (userInfo == null) {
	response.sendRedirect("/fvsb/main.jsp");
}

String genreString = "";
if (genreList != null && !genreList.isEmpty()) {
	genreString = String.join(", ", genreList);
} else {
	// 장르가 없을 때만 '선택된 장르 없음'으로 설정
	genreString = "선택된 장르 없음";
}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>마이페이지 <%=userInfo.getU_name()%>님
</title>
<link rel="stylesheet" type="text/css" href="/fvsb/css/mainLayout.css">
<link rel="stylesheet" type="text/css" href="/fvsb/css/usersLayout.css">
<link rel="icon" type="image/png" href="/fvsb/img/fvsb.png">
</head>
<body class="users-info">
<%@include file="/header.jsp"%>
<main>
	<section>
		<!--  <h2><%=userInfo.getU_name()%>님의 마이페이지
		</h2>-->
		<div class="profile-header">
			<div class="profile-avatar">
				<img
					src="<%=request.getContextPath()%>/users/usersimg/<%=userInfo.getU_img()%>"
					alt="프로필 사진">
			</div>

			<div class="profile-text">
				<h3><%=userInfo.getU_name()%></h3>
				<p><%=userInfo.getU_id()%></p>
			</div>
		</div>
		<article>
			<table>
				<thead>
					<tr>
						<th colspan="2">회원 정보</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<th>아이디</th>
						<td><%=userInfo.getU_id()%></td>
					</tr>
					<tr>
						<th>이름</th>
						<td><%=userInfo.getU_name()%></td>
					</tr>
					<tr>
						<th>성별</th>
						<td><%="M".equals(userInfo.getU_sex()) ? "남" : "여"%></td>
					</tr>
					<tr>
						<th>출생연도 / 나이</th>
						<td><%=userInfo.getU_year()%> / 만 <%=LocalDate.now().getYear()-userInfo.getU_year()%>세</td>
					</tr>
					<tr>
						<th>가입일</th>
						<td><%=userInfo.getU_date()%></td>
					</tr>
					<tr>
						<th>선호 장르</th>
						<td><%=genreString%></td>
					</tr>

					<tr>
						<td colspan="2" align="center">
							<button onclick="location.href='usersUpdate.jsp'">정보 수정</button>
							<button onclick="confirmDelete()">회원 탈퇴</button>
						</td>
					</tr>
				</tbody>
			</table>
		</article>
	</section>
</main>
<script>
	function confirmDelete() {
		if (confirm('탈퇴하시겠습니까?')) {
			location.href = 'usersDelete.jsp';
		}
	}
</script>
</body>
</html>