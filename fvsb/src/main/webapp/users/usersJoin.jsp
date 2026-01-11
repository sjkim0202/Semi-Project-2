<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원가입</title>
<link rel="stylesheet" type="text/css" href="/fvsb/css/mainLayout.css">
<link rel="stylesheet" type="text/css" href="/fvsb/css/usersLayout.css">
<link rel="icon" type="image/png" href="/fvsb/img/fvsb.png">
<script>
	function openIdCheck() {
		window.open('/fvsb/users/idCheck.jsp', 'idCheck','width=450,height=350')
	}
</script>
</head>
<body class="users-join">
	<%@ include file="/header.jsp"%>
	<main>
		<section>
			<h2>회 원 가 입</h2>
			<article>
				<form name="usersJoin" action="usersJoin_ok.jsp" method="post"
					enctype="multipart/form-data">
					<fieldset>
						<legend>회원가입</legend>
						<table>
							<tr>
								<th>ID</th>
								<td><input type="text" name="u_id" readonly> <input
									type="hidden" name="hiddenid" id="id"> <input
									type="button" value="ID확인" id="idcheck"></td>
							</tr>
							<tr>
								<th>비밀번호</th>
								<td><input type="password" name="u_pwd" required></td>
							</tr>
							<tr>
								<th>이름</th>
								<td><input type="text" name="u_name" placeholder="6글자 이내"></td>
							</tr>

							<tr>
								<th>성별</th>
								<td><input type="radio" id="male" name="u_sex" value="M"
									required> <label for="male">남</label> <input
									type="radio" id="female" name="u_sex" value="F" required>
									<label for="female">여</label></td>

							</tr>

							<tr>
								<th>출생연도</th>
								<td><select name="u_year" id="u_year">
										<%
										for (int year = 2025; year >= 1900; year--) {
										%>
										<option value="<%=year%>"><%=year%></option>
										<%
										}
										%>
								</select></td>
							</tr>

							<tr>
								<th rowspan="2">장르</th>
								<td><input type="checkbox" value="액션" name="genre">액션
									<input type="checkbox" value="범죄" name="genre">범죄 <input
									type="checkbox" value="SF" name="genre">SF <input
									type="checkbox" value="코미디" name="genre">코미디 <input
									type="checkbox" value="로맨스" name="genre">로맨스 <input
									type="checkbox" value="스릴러" name="genre">스릴러</td>
							</tr>
							<tr>
								<td><input type="checkbox" value="공포" name="genre">공포
									<input type="checkbox" value="전쟁" name="genre">전쟁 <input
									type="checkbox" value="스포츠" name="genre">스포츠 <input
									type="checkbox" value="판타지" name="genre">판타지 <input
									type="checkbox" value="음악/뮤지컬" name="genre">음악/뮤지컬 <input
									type="checkbox" value="멜로" name="genre">멜로</td>
							</tr>

							<tr>
								<th>이미지</th>
								<td><input type="file" name="u_img"></td>
							</tr>

							<tr>
								<td colspan="2" align="center"><input type="submit"
									value="회원가입"> <input type="reset" value="취소"></td>
							</tr>

						</table>
					</fieldset>
				</form>
			</article>
		</section>
	</main>
	<%@ include file="/footer.jsp"%>
</body>

<script>
	var idcheck = document.getElementById('idcheck');
	idcheck.addEventListener('click', function() {
		openIdCheck();
	});
</script>
</html>