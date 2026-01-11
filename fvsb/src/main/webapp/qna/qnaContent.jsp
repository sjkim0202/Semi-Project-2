<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.five.qna.*"%>
<%@ page import="com.five.users.*"%>
<%
request.setCharacterEncoding("UTF-8");
%>
<jsp:useBean id="qdao" class="com.five.qna.QnaDAO" scope="session" />
<jsp:useBean id="udao" class="com.five.users.UsersDAO" scope="session" />

<%
int idx = Integer.parseInt(request.getParameter("idx"));
QnaDTO dto = qdao.qnaContent(idx);
if (idx == 0 || dto == null) {
%>
<script>
    window.alert("잘못된 접근");
    location.href = "qnaList.jsp";
</script>
<%
return;
}

// 🔹 세션에서 로그인 아이디 가져오기
String sid = (String) session.getAttribute("sid");
if (sid == null) {
%>
<script>
    window.alert("로그인 후 이용 가능합니다.");
    location.href = "qnaList.jsp";
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
    location.href = "qnaList.jsp";
</script>
<%
return;
}

int loginIdx = udto.getU_idx();
String u_ad = udto.getU_ad(); // admin 여부

// ======================= 🔥 권한 체크 핵심 🔥 =========================

// 1. 관리자 여부
boolean isAdmin = (u_ad != null) && "admin".equals(u_ad);

// 2. 이 글이 속한 스레드(q_ref)의 부모글 작성자 u_idx
int parentWriterIdx = qdao.getParentWriterByRef(dto.getQ_ref());

// 3. 현재 로그인 유저가 부모글 작성자인지
boolean isOwner = (loginIdx == parentWriterIdx);

// 4. 관리자도 아니고, 부모글 작성자도 아니면 막기
if (!isAdmin && !isOwner) {
%>
<script>
    window.alert("해당 문의글에 대한 열람 권한이 없습니다.");
    location.href = "qnaList.jsp";
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
<link rel="stylesheet" type="text/css" href="/fvsb/css/qnaLayout.css">
<link rel="icon" type="image/png" href="/fvsb/img/fvsb.png">
<script>
    function goBack() {
        location.href = '/fvsb/qna/qnaList.jsp';
    }
    function goReWrite() {
        location.href = 'qnaReWrite.jsp?q_title=<%=dto.getQ_title()%>&q_ref=<%=dto.getQ_ref()%>&q_lev=<%=dto.getQ_lev()%>&q_step=<%=dto.getQ_step()%>';
	}
</script>
</head>
<body class="qna-content">
	<%@ include file="/header.jsp"%>

	<main>
		<section>
			<h2>자유게시판 본문보기</h2>
			<article>
				<table>
					<thead>
						<tr>
							<th>번호</th>
							<td><%=dto.getQ_idx()%></td>
							<th>제목</th>
							<td><%=dto.getQ_title()%></td>
						</tr>
						<tr>
							<th>작성자</th>
							<td><%=dto.getU_name()%></td>
							<th>날짜</th>
							<td><%=dto.getQ_date()%></td>
						</tr>
					</thead>
					<tbody>
						<tr height="200">
							<th>내용</th>
							<td colspan="3" align="center"><%=dto.getQ_comment().replaceAll("\n", "<br>")%></td>
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
