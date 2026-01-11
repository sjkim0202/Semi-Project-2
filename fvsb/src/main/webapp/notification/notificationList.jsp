<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.five.users.*"%>
<%@ page import="com.five.notification.*"%>
<%@ page import="java.util.*"%>
<jsp:useBean id="udao" class="com.five.users.UsersDAO"></jsp:useBean>
<jsp:useBean id="ndao" class="com.five.notification.NotificationDAO"></jsp:useBean>

<%
String sid = (String) session.getAttribute("sid");
if (sid == null || sid.equals("")) {
%>
<script>
	alert("로그인 후 이용 가능합니다.");
	window.close();
</script>
<%
return;
}

UsersDTO udto = udao.getUserById(sid);
if (udto == null) {
%>
<script>
	alert("유저 정보를 찾을 수 없습니다.");
	window.close();
</script>
<%
return;
}

int u_idx = udto.getU_idx();
String dap="2";
List<NotificationDTO> nList = ndao.getNotificationList(u_idx);
// 팝업을 열었을 때 전체 읽음 처리
ndao.markAllRead(u_idx);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>알림</title>
<link rel="stylesheet" type="text/css" href="/fvsb/css/notificationLayout.css">
<link rel="icon" type="image/png" href="/fvsb/img/fvsb.png">
<script>
	function goTarget(url) {
		window.location.href = url; // 팝업 자체에서 이동
	}
	function deleteNoti(n_idx) {
	    if (!confirm("이 알림을 삭제하시겠습니까?")) return;
	    window.location.href = "/fvsb/notification/notificationDelete.jsp?n_idx=" + n_idx;
	}
</script>
</head>
<body class="notification-list">
	<h2>알림</h2>

	<div class="noti-container">
		<%
		if (nList == null || nList.size() == 0) {
		%>
		<div class="noti-empty">알림이 없습니다.</div>
		<%
		} else {
		%>
		<table>
			<tr>
				<th style="width: 60%;">내용</th>
				<th style="width: 25%;">날짜</th>
				<th style="width: 15%;">삭제</th>
			</tr>
			<%
			for (NotificationDTO ndto : nList) {
				String msg = ndto.getN_message();
				String link = "#";
				if ("REVIEW_COMMENT".equals(ndto.getN_type())) {
					link = "/fvsb/review/reviewComment.jsp?r_idx=" + ndto.getTarget_id()+"&dap="+dap;
				}
			%>
			<tr id="row_<%=ndto.getN_idx()%>">
				<td><a href="javascript:void(0);" class="noti-link"
					onclick="goTarget('<%=link%>');"><%=msg%></a></td>
				<td><%=ndto.getN_date()%></td>
				<td>
					<button type="button" class="btn-del"
						onclick="deleteNoti(<%=ndto.getN_idx()%>);">삭제</button>
				</td>
			</tr>
			<%
			}
			%>
		</table>
		<%
		}
		%>
	</div>

	<div class="btn-area">
		<button type="button" class="btn-close" onclick="closePopup();">닫기</button>
	</div>
</body>
<script>
	function closePopup() {
		if (window.opener && !window.opener.closed) {
			window.opener.location.reload(); // 부모창 새로고침
		}
		window.close(); // 팝업 닫기
	}
</script>
</html>
