<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>배우 등록</title>
<link rel="stylesheet" type="text/css" href="/fvsb/css/actorLayout.css">
<link rel="icon" type="image/png" href="/fvsb/img/fvsb.png">
<script>
	function closeWindow() {
		// 팝업으로 열렸으면 그냥 닫기
		if (window.opener && !window.opener.closed) {
			window.close();
		} else {
			// 팝업이 아니고 그냥 페이지로 온 경우 → 이전 페이지로 이동
			history.back();
		}
	}
</script>
</head>
<body class="actor-insert-popup">
	<h2>배우 등록</h2>
	<form action="actorInsertPopup_ok.jsp" method="post"
		enctype="multipart/form-data">
		<table>
			<tr>
				<th>이름</th>
				<td><input type="text" name="a_name"></td>
			</tr>

			<tr>
								<th>출생연도</th>
								<td><select name="a_age" id="a_age">
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
				<th>국가</th>
				<td><select name="a_country">
						<option value="kr">한국</option>
						<option value="us">미국</option>
				</select></td>
			</tr>

			<tr>
				<th>배우 사진</th>
				<td><input type="file" name="a_img"></td>
			</tr>

			<tr>
				<td colspan="2" align="center"><input type="submit" value="등록">
					<input type="reset" value="초기화"> <input type="button"
					value="창 닫기" onclick="closeWindow()"></td>
			</tr>
		</table>
	</form>
</body>
</html>