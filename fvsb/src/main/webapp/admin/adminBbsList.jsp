<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.five.bbs.BbsDTO"%>
<%@ page import="com.five.bbs.BbsDAO"%>
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
int pageSize = 5; // 한 페이지에 보여줄 글 수
int blockSize = 5; // 페이지 번호 블록 크기

String pageNumStr = request.getParameter("pageNum");
if (pageNumStr == null || pageNumStr.equals("")) {
	pageNumStr = "1";
}

int currentPage = Integer.parseInt(pageNumStr);

// 2. DAO를 이용한 데이터 조회
BbsDAO dao = new BbsDAO();
int totalCount = 0;
List<BbsDTO> bbsList = null;

try {
	totalCount = dao.getTotalCnt(); // 전체 글 수
	bbsList = dao.bbsList(currentPage, pageSize); // 현재 페이지 글 목록
} catch (Exception e) {
	e.printStackTrace();
	bbsList = new ArrayList<>();
}

// 3. 페이징 계산
int pageCount = (int) Math.ceil((double) totalCount / pageSize); // 총 페이지 수
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
<title>자유 관리 목록</title>
<link rel="stylesheet" type="text/css" href="/fvsb/css/mainLayout.css">
<link rel="icon" type="image/png" href="/fvsb/img/fvsb.png">
<link rel="stylesheet" type="text/css" href="/fvsb/css/adminLayout.css">
</head>
<body>

	<%@include file="/header.jsp"%>
	<main>
		<section>
			<h2>자유 관리 목록</h2>

			<div>
				<article>
					<table>
						<thead>
							<tr>
								<th>번호</th>
								<th>제목</th>
								<th>작성자</th>
								<th>작성일</th>
								<th>조회수</th>
								<th>작성자권한</th>
								<th>삭제</th>
							</tr>
						</thead>

						<tbody>
							<%
							int colspanCount = 7;
							if (bbsList == null || bbsList.isEmpty()) {
							%>
							<tr>
								<td colspan="<%=colspanCount%>">등록된 게시글이 없습니다.</td>
							</tr>
							<%
							} else {
							for (BbsDTO dto : bbsList) {
							%>
							<tr>
								<td><%=dto.getB_idx()%></td>
								<td><%=dto.getB_title()%></td>
								<td><%=dto.getU_name()%></td>
								<td><%=dto.getB_date()%></td>
								<td><%=dto.getB_readnum()%></td>
								<td><%=dto.getU_ad()%></td>
								<td>
									<button type="button"
										onclick="openDelete('<%=dto.getB_idx()%>');">삭제</button>
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

				if (pageCount > 0) {

					if (startPage > blockSize) {
						// 이전 블록으로 이동
				%>
				<a class="page_link"
					href="adminBbsList.jsp?pageNum=<%=startPage - 1%>">이전</a>
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
				<a class="page_link" href="adminBbsList.jsp?pageNum=<%=i%>"><%=i%></a>
				<%
				}
				}

				if (endPage < pageCount) {
				// 다음 블록으로 이동
				%>
				<a class="page_link"
					href="adminBbsList.jsp?pageNum=<%=endPage + 1%>">다음</a>
				<%
				}
				}
				%>
			</div>

		</section>
	</main>
	<%@include file="/footer.jsp"%>
	<script>
		function openDelete(bIdx) {
			if (confirm('정말 삭제하시겠습니까?')) {
				location.href = '/fvsb/admin/bbsDelete.jsp?b_idx=' + bIdx;
			}
		}
	</script>
</body>
</html>
