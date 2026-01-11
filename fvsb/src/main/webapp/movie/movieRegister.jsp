<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" type="text/css" href="/fvsb/css/mainLayout.css">
<link rel="stylesheet" type="text/css" href="/fvsb/css/movieLayout.css">
<link rel="icon" type="image/png" href="/fvsb/img/fvsb.png">
</head>

<body class="movie-form">
	<%@ include file="/header.jsp"%>
	<main>
		<section>
			<article>
				<form name="movieRegister" action="movieRegister_ok.jsp"
					method="post" enctype="multipart/form-data">
					<h2>영화 등록하기</h2>
					<table id="movieregistertable">
						<tbody>
							<tr>
								<td>영화 포스터</td>
								<td><input type="file" value="영화이미지" name="m_img"></td>
							</tr>
							<tr>
								<td>영화 제목</td>
								<td><input type="text" name="m_name"></td>
							</tr>
							<tr>
								<td>개봉날짜</td>
								<td><input type="date" name="m_date"></td>
							</tr>
							<tr>
								<td>관람기준</td>
								<td><select name="m_limit" id="m_limit">
										<option value="ALL">모든 연령
										<option value="12">12세 이상
										<option value="15">15세 이상
										<option value="19">청소년 관람불가
								</select></td>
							</tr>
							<tr>
								<td>감독</td>
								<td><input type="text" name="m_pd"></td>
							</tr>
							<tr>
								<td rowspan="2">장르</td>
								<td class="genre-cell"><span class="genre-item"> <input
										type="checkbox" id="genreAction" name="genre" value="액션">
										<label for="genreAction">액션</label>
								</span> <span class="genre-item"> <input type="checkbox"
										id="genreCrime" name="genre" value="범죄"> <label
										for="genreCrime">범죄</label>
								</span> <span class="genre-item"> <input type="checkbox"
										id="genreSF" name="genre" value="SF"> <label
										for="genreSF">SF</label>
								</span> <span class="genre-item"> <input type="checkbox"
										id="genreComedy" name="genre" value="코미디"> <label
										for="genreComedy">코미디</label>
								</span> <span class="genre-item"> <input type="checkbox"
										id="genreRomance" name="genre" value="로맨스"> <label
										for="genreRomance">로맨스</label>
								</span> <span class="genre-item"> <input type="checkbox"
										id="genreThriller" name="genre" value="스릴러"> <label
										for="genreThriller">스릴러</label>
								</span></td>
							</tr>
							<tr>
								<td class="genre-cell"><span class="genre-item"> <input
										type="checkbox" id="genreHorror" name="genre" value="공포">
										<label for="genreHorror">공포</label>
								</span> <span class="genre-item"> <input type="checkbox"
										id="genreWar" name="genre" value="전쟁"> <label
										for="genreWar">전쟁</label>
								</span> <span class="genre-item"> <input type="checkbox"
										id="genreSports" name="genre" value="스포츠"> <label
										for="genreSports">스포츠</label>
								</span> <span class="genre-item"> <input type="checkbox"
										id="genreFantasy" name="genre" value="판타지"> <label
										for="genreFantasy">판타지</label>
								</span> <span class="genre-item"> <input type="checkbox"
										id="genreMusical" name="genre" value="음악/뮤지컬"> <label
										for="genreMusical">음악/뮤지컬</label>
								</span> <span class="genre-item"> <input type="checkbox"
										id="genreMelo" name="genre" value="멜로"> <label
										for="genreMelo">멜로</label>
								</span></td>

							</tr>
							<tr>
								<td>국가</td>
								<td><select name="m_country"><option value="korea">한국</option>
										<option value="china">중국</option>
										<option value="japan">일본</option>
										<option value="usa">미국</option>
										<option value="uk">영국</option>
								</select></td>
							</tr>
							<tr>
								<td>줄거리</td>
								<td><textarea name="m_story"></textarea></td>
							</tr>
							<tr>
								<td colspan="2"><input type="submit" value="추가"> <input
									type="reset" value="다시작성"></td>
							</tr>
						</tbody>
					</table>
				</form>
			</article>
		</section>
	</main>
	<%@ include file="/footer.jsp"%>
</body>
</html>