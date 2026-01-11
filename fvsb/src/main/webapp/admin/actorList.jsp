<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.five.actor.ActorDAO"%>
<%@ page import="com.five.actor.ActorDTO"%>
<%
// --- 관리자 권한 체크 (sid 기준) ---
String sid = (String) session.getAttribute("sid"); // 로그인할 때 세션에 넣어둔 아이디

boolean isAdmin = false;

if (sid != null) {
	try {
		UsersDAO udao = new UsersDAO();
		UsersDTO udto = udao.getUserById(sid); // u_id로 조회하는 메서드 이미 있음

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
	window.alert('관리자만 접근 가능합니다.');
	location.href = '/fvsb/main.jsp';
</script>
<%
return;
}

// 1. 페이징 변수
int pageSize = 5; // 한 페이지에 보여줄 배우 수
int blockSize = 5; // 페이지 블록 크기

String pageNumStr = request.getParameter("pageNum");
if (pageNumStr == null || pageNumStr.equals("")) {
	pageNumStr = "1";
}

int currentPage = Integer.parseInt(pageNumStr);
int startRow = (currentPage - 1) * pageSize + 1;
int endRow = currentPage * pageSize;

// 2. DAO를 이용한 데이터 조회
ActorDAO dao = new ActorDAO();
int totalCount = 0;
List<ActorDTO> actorList = null;

try {
	totalCount = dao.getTotalActorCount(); // 전체 배우 수
	actorList = dao.getActorList(startRow, endRow); // 현재 페이지 배우 목록
} catch (Exception e) {
	e.printStackTrace();
	actorList = new ArrayList<ActorDTO>();
}

// 3. 페이징 계산
int pageCount = (int) Math.ceil((double) totalCount / pageSize);
int startPage = (int) ((currentPage - 1) / blockSize) * blockSize + 1;
int endPage = startPage + blockSize - 1;
if (endPage > pageCount) {
	endPage = pageCount;
}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>배우 조회 목록</title>
<link rel="stylesheet" type="text/css" href="/fvsb/css/mainLayout.css">
<link rel="icon" type="image/png" href="/fvsb/img/fvsb.png">
<link rel="stylesheet" type="text/css" href="/fvsb/css/adminLayout.css">

</head>
<body>
	<%@include file="/header.jsp"%>

	<main>
		<section>
			<h2>배우 조회 목록</h2>
			<!-- 글쓰기 버튼 (필요시) -->
			<div class="table-header">
				<button type="button" class="write-btn"
					onclick="location.href='/fvsb/actor/actorInsert.jsp'">배우
					추가</button>
			</div>

			<article>
				<table>
					<thead>
						<tr>
							<th>번호</th>
							<th>이름</th>
							<th>출생년도</th>
							<th>국가</th>
							<th>사진</th>
							<th>삭제</th>
						</tr>
					</thead>
					<tbody>
						<%
						int colspanCount = 6; // 컬럼 수에 맞게 6으로 수정
						if (actorList == null || actorList.isEmpty()) {
						%>
						<tr>
							<td colspan="<%=colspanCount%>">등록된 배우가 없습니다.</td>
						</tr>
						<%
						} else {
						for (ActorDTO dto : actorList) {
							String imgPath = "/fvsb/actor/" + dto.getA_img();
						%>
						<tr>
							<td><%=dto.getA_idx()%></td>
							<td><%=dto.getA_name()%></td>
							<td><%=dto.getA_age()%>년</td>
							<td><%=dto.getA_country()%></td>
							<td><img src="<%=imgPath%>"
								style="width: 50px; height: 50px;"></td>
							<td>
								<button type="button"
									onclick="openDelete('<%=dto.getA_idx()%>');">삭제</button>
							</td>
						</tr>
						<%
						}
						}
						%>
					</tbody>

				</table>
			</article>
			<hr>
			<div class="pagination">
				<%
				// 이전 블록
				if (startPage > blockSize) {
				%>
				<a class="page_link" href="actorList.jsp?pageNum=<%=startPage - 1%>">이전</a>
				<%
				}

				// 페이지 번호들
				for (int i = startPage; i <= endPage; i++) {
				if (i == currentPage) {
				%>
				<span class="current_page"><%=i%></span>
				<%
				} else {
				%>
				<a class="page_link" href="actorList.jsp?pageNum=<%=i%>"><%=i%></a>
				<%
				}
				}

				// 다음 블록
				if (endPage < pageCount) {
				%>
				<a class="page_link" href="actorList.jsp?pageNum=<%=endPage + 1%>">다음</a>
				<%
				}
				%>
			</div>

		</section>
	</main>
	<%@include file="/footer.jsp"%>
	<script>
		function openDelete(aIdx) {
			if (confirm('정말 삭제하시겠습니까?')) {
				location.href = '/fvsb/admin/actorDelete.jsp?a_idx=' + aIdx;
			}
		}
	</script>

</body>
</html>
