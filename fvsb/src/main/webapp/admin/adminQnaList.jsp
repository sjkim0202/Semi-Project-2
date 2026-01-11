<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.five.qna.QnaDTO"%>
<%@ page import="com.five.qna.QnaDAO"%>
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
QnaDAO dao = new QnaDAO();
int totalCount = 0;
List<QnaDTO> qnaList = null;

try {
	totalCount = dao.getTotalCnt(); // 전체 QnA 글 수
	qnaList = dao.qnaList(currentPage, pageSize); // 현재 페이지 QnA 목록
} catch (Exception e) {
	e.printStackTrace();
	qnaList = new ArrayList<>();
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
<title>문의 관리 목록</title>
<link rel="stylesheet" type="text/css" href="/fvsb/css/mainLayout.css">
<link rel="icon" type="image/png" href="/fvsb/img/fvsb.png">
<link rel="stylesheet" type="text/css" href="/fvsb/css/adminLayout.css">
</head>
<body>

	<%@include file="/header.jsp"%>
	<main>
		<section>
			<h2>문의 관리 목록</h2>

			<div>
				<article>
					<table>
						<thead>
							<tr>
								<th>번호</th>
								<th>제목</th>
								<th>작성자</th>
								<th>작성일</th>
								<th>유형</th>
								<th>삭제</th>
							</tr>
						</thead>

						<tbody>
							<%
							int colspanCount = 6;
							if (qnaList == null || qnaList.isEmpty()) {
							%>
							<tr>
								<td colspan="<%=colspanCount%>">등록된 QnA가 없습니다.</td>
							</tr>
							<%
							} else {
							for (QnaDTO dto : qnaList) {
								// q_lev == 0 : 질문, 그 외 : 답변
								String typeLabel = (dto.getQ_lev() == 0) ? "질문" : "답변";
							%>
							<tr>
								<td><%=dto.getQ_idx()%></td>
								<td><%=dto.getQ_title()%></td>
								<td><%=dto.getU_name()%></td>
								<td><%=dto.getQ_date()%></td>
								<td><%=typeLabel%></td>
								<td>
									<button type="button"
										onclick="openDelete('<%=dto.getQ_idx()%>');">삭제</button>
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
					href="adminQnaList.jsp?pageNum=<%=startPage - 1%>">이전</a>
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
				<a class="page_link" href="adminQnaList.jsp?pageNum=<%=i%>"><%=i%></a>
				<%
				}
				}

				if (endPage < pageCount) {
				// 다음 블록으로 이동
				%>
				<a class="page_link"
					href="adminQnaList.jsp?pageNum=<%=endPage + 1%>">다음</a>
				<%
				}
				}
				%>
			</div>

		</section>
	</main>
	<%@include file="/footer.jsp"%>
	<script>
		function openDelete(qIdx) {
			if (confirm('정말 삭제하시겠습니까?')) {
				location.href = '/fvsb/admin/qnaDelete.jsp?q_idx=' + qIdx;
			}
		}
	</script>
</body>
</html>
