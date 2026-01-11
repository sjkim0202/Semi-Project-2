<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>FVSB 팝업</title>
<link rel="stylesheet" type="text/css" href="/fvsb/css/popUpLayout.css">
<link rel="icon" type="image/png" href="/fvsb/img/fvsb.png">
</head>
<body class="fvsb-popup">
	<fieldset>
		<h1>FVSB 개설!!!</h1>
		<ul>
			<li>준상님과 <a href="javascript:void(0);"
				onclick="goParent('/fvsb/users/usersJoin.jsp');"> 회원 가입 하러가기 </a>
			</li>
			<li>성지님과 <a href="javascript:void(0);"
				onclick="goParent('/fvsb/movie/movieList.jsp');"> 영화 목록 보러가기 </a>
			</li>
			<li>원재님과 <a href="javascript:void(0);"
				onclick="goParent('/fvsb/actor/actor.jsp');"> 배우 목록 보러가기 </a>
			</li>
			<li>진유님과 <a href="javascript:void(0);"
				onclick="goParent('/fvsb/bbs/bbsList.jsp');"> 자유게시판 보러가기 </a>
			</li>
			<li>민영님과 <a href="javascript:void(0);"
				onclick="goParent('/fvsb/award/awardList.jsp');"> FVSB 어워즈 보러가기 </a>
			</li>
		</ul>
	</fieldset>

	<form name="popUpForm" action="popUp_ok.jsp" method="post">
		<div id="btarea">
			<div class="checkbox-wrapper">
				<input type="checkbox" id="popupck" name="popupck" value="on">
				<label for="popupck">오늘 하루 보지 않기</label>
			</div>
			<input type="submit" value="닫기">
		</div>
	</form>
	<script>
		function goParent(url) {
			if (window.opener && !window.opener.closed) {
				window.opener.location.href = url; // 부모창 주소 변경
			}
			window.close();
		}
	</script>
</body>
</html>