<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.five.users.UsersDTO"%>
<%@ page import="com.five.users.UsersDAO"%>
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

// 1. 페이징 변수 설정 및 초기화
int pageSize = 5;
int blockSize = 5;

String pageNumStr = request.getParameter("pageNum");
if (pageNumStr == null || pageNumStr.equals("")) {
	pageNumStr = "1";
}

int currentPage = Integer.parseInt(pageNumStr);
int startRow = (currentPage - 1) * pageSize + 1;
int endRow = currentPage * pageSize;

// 2. DAO를 이용한 데이터 조회
UsersDAO dao = new UsersDAO();
int totalCount = 0;
List<UsersDTO> userList = null;

try {
	totalCount = dao.getTotalUserCount();
	userList = dao.getUserList(startRow, endRow);
} catch (Exception e) {
	e.printStackTrace();
	userList = new ArrayList<>();
}

// 3. 페이징 계산
int pageCount = (int) Math.ceil((double) totalCount / pageSize);
int startPage = (int) ((currentPage - 1) / blockSize) * blockSize + 1;
int endPage = startPage + blockSize - 1;
if (endPage > pageCount) {
	endPage = pageCount;
}

// 4. 로그인된 사용자 ID (삭제 버튼 처리에 사용)
String currentUserId = (String) session.getAttribute("sid");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 관리 목록</title>
<link rel="stylesheet" type="text/css" href="/fvsb/css/mainLayout.css">
<link rel="stylesheet" type="text/css" href="/fvsb/css/adminLayout.css">
<link rel="icon" type="image/png" href="/fvsb/img/fvsb.png">
</head>
<body>

	<%@include file="/header.jsp"%>
	<main>
		<section>
			<h2>회원 관리 목록</h2>

			<div>
				<article>
					<table>
						<thead>
							<tr>
								<th>번호</th>
								<th>아이디</th>
								<th>이름</th>
								<th>성별</th>
								<th>나이</th>
								<th>가입일</th>
								<th>장르</th>
								<th>사진</th>
								<th>삭제</th>
							</tr>
						</thead>

						<tbody>
							<%
							// userList 변수를 request.getAttribute 없이 바로 사용합니다.
							int colspanCount = 9;
							if (userList == null || userList.isEmpty()) { //
							%>
							<tr>
								<td colspan="<%=colspanCount%>">등록된 사용자가 없습니다.</td>
							</tr>
							<%
							} else {
							for (UsersDTO dto : userList) {
								boolean isSelf = (currentUserId != null && currentUserId.equals(dto.getU_id())); // [cite: 29]
							%>
							<tr>
								<td><%=dto.getU_idx()%></td>
								<td><%=dto.getU_id()%></td>
								<td><%=dto.getU_name()%></td>
								<td><%="M".equals(dto.getU_sex()) ? "남" : "여"%></td>
								<td><%=dto.getU_year()%></td>
								<td><%=dto.getU_date()%></td>
								<td>
									<%
									List<String> userGenres = dto.getGenre();
									if (userGenres != null && !userGenres.isEmpty()) {
										for (int j = 0; j < userGenres.size(); j++) {
											out.print(userGenres.get(j));
											if (j < userGenres.size() - 1) {
										out.print(", ");
											}
										}
									} else {
										out.print("-");
									}
									%>
								</td>
								<td><img
									src="<%=request.getContextPath()%>/users/usersimg/<%=dto.getU_img()%>"
									style="width: 50px; height: 50px;"></td>

								<td>
									<%
									if (!isSelf) {
									%>
									<button type="button"
										onclick="openDelete('<%=dto.getU_id()%>');">삭제</button> <%
 										} else {
 											out.print("—");
 										}
 									%>
								</td>
							</tr>
							<%
							}
							}
							%>
						</tbody>
					</table>
				</article>
			</div>
			<hr>
			<div class="pagination">
				<%
				// 페이징 처리 로직 
				if (startPage > blockSize) {
					// 이전 블록으로 이동
				%>
				<a class="page_link" href="usersList.jsp?pageNum=<%=startPage - 1%>">이전</a>
				<%
				}

				for (int i = startPage; i <= endPage; i++) {
				if (i == currentPage) {
					// 현재 페이지
				%>
				<span class="current_page"><%=i%></span>
				<%
				} else {
				// 다른 페이지
				%>
				<a class="page_link" href="usersList.jsp?pageNum=<%=i%>"><%=i%></a>
				<%
				}
				}

				if (endPage < pageCount) {
				// 다음 블록으로 이동
				%>
				<a class="page_link" href="usersList.jsp?pageNum=<%=endPage + 1%>">다음</a>
				<%
				}
				%>
			</div>


		</section>
	</main>
	<%@include file="/footer.jsp"%>
	<script>
		function openDelete(uId) {
			if (confirm('정말 삭제하시겠습니까?')) {
				location.href = '/fvsb/admin/adminDelete.jsp?u_id=' + uId;
			}
		}
	</script>
</body>
</html>