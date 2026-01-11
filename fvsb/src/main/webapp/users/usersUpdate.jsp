<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="com.five.users.UsersDAO"%>
<%@page import="com.five.users.UsersDTO"%>
<%@page import="java.util.*"%>
<jsp:useBean id="udao" class="com.five.users.UsersDAO"></jsp:useBean>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>정보 수정 결과</title>
<link rel="stylesheet" type="text/css" href="/fvsb/css/mainLayout.css">
<link rel="stylesheet" type="text/css" href="/fvsb/css/usersLayout.css">
<link rel="icon" type="image/png" href="/fvsb/img/fvsb.png">
<%
// 1. 세션 확인 
String sessionId = (String) session.getAttribute("sid");
if (sessionId == null || sessionId.isEmpty()) { // 
	response.sendRedirect(request.getContextPath() + "/main.jsp"); // 경로 수정
	return;
}

// 2. 사용자 정보 및 장르 조회 
UsersDTO userInfo = null;
List<String> genreList = null;

try {
	userInfo = udao.getUserInfo(sessionId); // 
	genreList = udao.getUserGenres(sessionId); // 
} catch (Exception e) {
	e.printStackTrace();
}

// 3. 사용자 정보 유효성 확인 
if (userInfo == null) { // 
	response.sendRedirect(request.getContextPath() + "/main.jsp"); // 경로 수정
	return;
}

// 4. 장르 문자열 생성 
String genreString = "";
if (genreList != null && !genreList.isEmpty()) {
	genreString = String.join(",", genreList);
}
%>
</head>
<body class="users-update">
	<%@ include file="/header.jsp"%>
	<main>
		<section>
			<h2>회원정보수정</h2>
			<article>
				<form name="usersUpdate" action="usersUpdate_ok.jsp" method="post"
					enctype="multipart/form-data">
					<fieldset>
						<legend>정보수정</legend>
						<table>
							<tr>
								<th>ID</th>
								<td><input type="text" name="u_id"
									value="<%=userInfo.getU_id()%>" readonly></td>
							</tr>
							<tr>
								<th>비밀번호</th>
								<td><input type="password" name="u_pwd"
									placeholder="********" readonly> <input type="button"
									value="비밀번호 변경" onclick="openPwdChange()"></td>
							</tr>
							<tr>
								<th>이름</th>
								<td><input type="text" name="u_name"
									value="<%=userInfo.getU_name()%>"></td>
							</tr>

							<tr>
								<th>성별</th>
								<td>
									<%
									// userInfo 변수를 직접 사용합니다.
									String userSex = userInfo.getU_sex();
									%> <input type="radio" id="male" name="u_sex" value="M"
									<%=userSex.equals("M") ? "checked" : ""%> required> <label
									for="male">남</label> <input type="radio" id="female"
									name="u_sex" value="F"
									<%=userSex.equals("F") ? "checked" : ""%> required> <label
									for="female">여</label>
								</td>
							</tr>


							<tr>
								<th>출생연도</th>
								<td><select name="u_year" id="u_year">
										<%
										int userYear = userInfo.getU_year();
										for (int year = 2025; year >= 1900; year--) {
											String selected = (year == userYear) ? "selected" : "";
										%>
										<option value="<%=year%>" <%=selected%>><%=year%></option>
										<%
										}
										%>
								</select></td>
							</tr>
							<%
							String[] firstLine = {"액션", "범죄", "SF", "코미디", "로맨스", "스릴러"};
							String[] secondLine = {"공포", "전쟁", "스포츠", "판타지", "음악/뮤지컬", "멜로"};
							%>

							<tr>
								<th rowspan="2">장르</th>
								<td>
									<%
									for (String genre : firstLine) {
										String checked = genreString.contains(genre) ? "checked" : "";
									%> <input type="checkbox" value="<%=genre%>" name="genre"
									<%=checked%>><%=genre%> <%
									 }
									 %>
								</td>
							</tr>
							<tr>
								<td>
									<%
									for (String genre : secondLine) {
										String checked = genreString.contains(genre) ? "checked" : "";
									%> <input type="checkbox" value="<%=genre%>" name="genre"
									<%=checked%>><%=genre%> <%
 									}
 									%>
								</td>
							</tr>
							<tr>
								<th>이미지</th>
								<td><input type="file" name="u_img"></td>
							</tr>
							<tr>
								<td colspan="2" align="center"><input type="submit"
								value="정보 수정"> <input type="button" value="취소"
								onclick="location.href='usersInfo.jsp'"></td>
								</tr>
						</table>
					</fieldset>
				</form>
			</article>
		</section>
	</main>
	<script>
		function openPwdChange() {
			window.open('pwdCheck.jsp','pwdChangePopup','width=450, height=350');
		}
	</script>
	<%@ include file="/footer.jsp"%>
</body>
</html>