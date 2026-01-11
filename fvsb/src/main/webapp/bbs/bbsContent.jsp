
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.five.bbs.*"%>
<%@ page import="com.five.users.*"%>
<%
request.setCharacterEncoding("UTF-8");
%>
<jsp:useBean id="bdao" class="com.five.bbs.BbsDAO" scope="session" />
<jsp:useBean id="udao" class="com.five.users.UsersDAO" scope="session" />
<%
//🔹 세션에서 로그인 아이디 가져오기
String sid = (String) session.getAttribute("sid");
if (sid == null) {
%>
<script>
 window.alert("로그인 후 이용 가능합니다.");
 location.href = "bbsList.jsp";
</script>
<%
return;
}
int idx = Integer.parseInt(request.getParameter("idx"));
BbsDTO dto = bdao.bbsContent(idx);
if (idx == 0 || dto == null) {
%>
<script>
    window.alert("잘못된 접근");
    location.href = "bbsList.jsp";
</script>
<%
return;
}

// 🔹 로그인 유저 정보 조회
UsersDTO udto = udao.getUserById(sid);
if (udto == null) {
%>
<script>
    window.alert("회원 정보가 올바르지 않습니다.");
    location.href = "bbsList.jsp";
</script>
<%
return;
}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>본문 내용</title>
<link rel="stylesheet" type="text/css" href="/fvsb/css/mainLayout.css">
<link rel="stylesheet" type="text/css" href="/fvsb/css/bbsLayout.css">
<link rel="icon" type="image/png" href="/fvsb/img/fvsb.png">
<script>
	function goBack() {
		location.href = '/fvsb/bbs/bbsList.jsp';
	}
	function goReWrite() {
		location.href = 'bbsReWrite.jsp?b_title=<%=dto.getB_title()%>&b_ref=<%=dto.getB_ref()%>&b_lev=<%=dto.getB_lev()%>&b_step=<%=dto.getB_step()%>';
	}
</script>
</head>
<body class="bbs-content">
	<%@ include file="/header.jsp"%>

	<main>
		<section>
			<h2>자유게시판 본문보기</h2>
			<article>
				<table>
					<thead>
						<tr>
							<th>번호</th>
							<td>
								<%
								if ("admin".equals(dto.getU_ad())) {
								%> [공지] <%
								} else {
								%> <%=dto.getB_idx()%> <%
 								}
 								%>
							</td>
							<th>제목</th>
							<td><%=dto.getB_title()%></td>
						</tr>
						<tr>
							<th>작성자</th>
							<td><%=dto.getU_name()%></td>
							<th>날짜</th>
							<td><%=dto.getB_date()%></td>
						</tr>
					</thead>
					<tbody>
						<tr height="200">
							<th>내용</th>
							<td colspan="3" align="center"><%=dto.getB_comment().replaceAll("\n", "<br>")%></td>
						</tr>
						<tr>
							<td colspan="4" align="center"><input type="button"
								value="목록으로" onclick="goBack()"> <input type="button"
								value="답변작성" onclick="goReWrite()"></td>
						</tr>
					</tbody>
				</table>
			</article>
		</section>
	</main>
	<%@ include file="/footer.jsp"%>
</body>
</html>
