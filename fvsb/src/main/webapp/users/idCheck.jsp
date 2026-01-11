<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>ID 검사</title>
<link rel="stylesheet" type="text/css" href="/fvsb/css/usersLayout.css">
<link rel="icon" type="image/png" href="/fvsb/img/fvsb.png">
</head>
<body class = "idcheck">
	<h2>ID확인</h2>
	<main>
		<form name="idcheck" action="idCheck_ok.jsp">
			<fieldset>
				<legend>중복검사</legend>
				<label>ID</label> <input type="text" name="u_id"
					placeholder="3글자 이상 입력해주세요"> <input type="submit"
					value="ID확인">
			</fieldset>
		</form>
	</main>
</body>
</html>