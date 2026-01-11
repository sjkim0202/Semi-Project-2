<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.five.bbs.*"%>
<%@ page import="java.util.*"%>
<jsp:useBean id="bdao" class="com.five.bbs.BbsDAO" scope="session" />

<%
String sid = (String) session.getAttribute("sid");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>자유게시판</title>
<link rel="stylesheet" type="text/css" href="/fvsb/css/mainLayout.css">
<link rel="stylesheet" type="text/css" href="/fvsb/css/bbsLayout.css">
<link rel="icon" type="image/png" href="/fvsb/img/fvsb.png">
<script>
	function bbsWrite() {
		location.href = "/fvsb/bbs/bbsWrite.jsp";
	}
</script>
</head>
<%
int totalCnt = bdao.getTotalCnt();
int listSize = 5;
int pageSize = 5;

String cp_s = request.getParameter("cp");
if (cp_s == null || cp_s.equals("")) {
	cp_s = "1";
}

int cp = Integer.parseInt(cp_s);

int totalPage = totalCnt / listSize + 1;
if (totalCnt % listSize == 0)
	totalPage--;

int userGroup = cp / pageSize;
if (cp % pageSize == 0)
	userGroup--;
%>
<body class="bbs-list">
	<%@ include file="/header.jsp"%>

	<main>
		<section>
			<h2>자 유 게 시 판</h2>

			<!-- 글쓰기 버튼을 테이블 위로 -->
			<div class="write-btn-wrapper">
				<a href="bbsWrite.jsp">글쓰기</a>
			</div>

			<article>
				<table>
					<thead>
						<tr>
							<th>번호</th>
							<th>제목</th>
							<th>작성자</th>
							<th>날짜</th>
							<th>조회수</th>
						</tr>
					</thead>

					<tbody>
						<%
						ArrayList<BbsDTO> arr = bdao.bbsList(cp, listSize);
						if (arr == null || arr.size() == 0) {
						%>
						<tr>
							<td colspan="5">등록된 글 없음</td>
						</tr>
						<%
						} else {
						for (BbsDTO dto : arr) {
						%>
						<tr>
							<td>
								<%
								if ("admin".equals(dto.getU_ad())) {
								%> [공지] <%
								} else {
								%> <%=dto.getB_idx()%> <%
 								}
 								%>
							</td>
							<td>
								<%
								for (int z = 0; z < dto.getB_lev(); z++) {
									out.println("&nbsp;&nbsp;&nbsp;");
								}
								%><a href="bbsContent.jsp?idx=<%=dto.getB_idx()%>"><%=dto.getB_title()%></a>
							</td>
							<td>
							<a href="#" onclick="openCenterPopup('/fvsb/review/reviewInfo.jsp?&u_idx=<%=dto.getU_idx() %>', 'popup', 750, 500); return false;">
							<%=dto.getU_name()%></a></td>
							<td><%=dto.getB_date()%></td>
							<td><%=dto.getB_readnum()%></td>
						</tr>
						<%
						}
						}
						%>
					</tbody>

					<tfoot>
						<tr>
							<td colspan="5" align="center">
								<%
								if (userGroup != 0) {
								%> <a
								href="bbsList.jsp?cp=<%=(userGroup - 1) * pageSize + pageSize%>">&lt;&lt;</a>
								<%
								}
								for (int i = userGroup * pageSize + 1; i <= userGroup * pageSize + pageSize; i++) {
								%> &nbsp;&nbsp; <a href="bbsList.jsp?cp=<%=i%>"><%=i%></a>&nbsp;&nbsp;
								<%
								if (i == totalPage) {
									break;
								}
								}
								if (userGroup != (totalPage / pageSize) - (totalPage % pageSize == 0 ? 1 : 0)) {
								%> <a href="bbsList.jsp?cp=<%=(userGroup + 1) * pageSize + 1%>">&gt;&gt;</a>
								<%
								}
								%>
							</td>
						</tr>
					</tfoot>
				</table>
			</article>
		</section>
	</main>
	<%@ include file="/footer.jsp"%>
</body>
<script>
function openCenterPopup(url, title, w, h) {
    var screenW = screen.width;
    var screenH = screen.height;
    
    var left = (screenW / 2) - (w / 2);
    var top = (screenH / 2) - (h / 2);
    
    var features = 'width=' + w + 
                   ', height=' + h + 
                   ', top=' + top + 
                   ', left=' + left + 
                   ', scrollbars=yes, resizable=no'; // 스크롤바, 크기 변경 여부 추가
    
    window.open(url, title, features);
}
</script>
</html>