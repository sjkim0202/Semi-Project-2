<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="com.five.users.UsersDAO"%>
<%@page import="com.five.users.UsersDTO"%>
<%@page import="com.oreilly.servlet.multipart.*"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@page import="java.util.*"%>
<%@page import="java.io.*"%>
<jsp:useBean id="udao" class="com.five.users.UsersDAO"></jsp:useBean>
<%
request.setCharacterEncoding("UTF-8");
String savePath = request.getServletContext().getRealPath("/users/usersimg");
int size = 10 * 1024 * 1024;

MultipartRequest mr = new MultipartRequest(request, savePath, size, "UTF-8", new DefaultFileRenamePolicy());

//1. 폼 데이터 추출
String u_id = mr.getParameter("u_id");
String u_name = mr.getParameter("u_name");
String u_sex = mr.getParameter("u_sex");
String u_yearStr = mr.getParameter("u_year");
String u_pwd = mr.getParameter("u_pwd"); // 새로 입력된 비밀번호
String[] genre = mr.getParameterValues("genre");

int maxLength = 6;
if (u_name != null && u_name.length() > maxLength) {
%>
<script>
		window.alert("이름은 최대 <%=maxLength%>글자까지 입력가능");
		history.back();
	</script>
<%
return;
}
int u_year = 0;
try {
u_year = Integer.parseInt(u_yearStr);
} catch (NumberFormatException e) {
}

String u_img = mr.getFilesystemName("u_img");

if (u_img == null) {
UsersDTO oldDto = udao.getUserInfo(u_id);
if (oldDto != null) {
	u_img = oldDto.getU_img();
}
}

UsersDTO dto = new UsersDTO();
dto.setU_id(u_id);
dto.setU_name(u_name);
dto.setU_sex(u_sex);
dto.setU_year(u_year);
dto.setU_img(u_img);

String msg = "";
String location = "";

int updateResult = udao.usersUpdate(dto, genre, u_pwd);

if (updateResult == 1) {
session.setAttribute("sname", u_name);
msg = "정보 수정이 완료되었습니다. 마이페이지로 이동합니다.";
location = "usersInfo.jsp";
} else if (updateResult == -1) {
msg = "데이터베이스 오류가 발생했습니다. 잠시 후 다시 시도해 주세요.";
location = "usersInfo.jsp";
} else {
msg = "회원 정보 수정에 실패했습니다.";
location = "usersInfo.jsp";
}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>정보 수정 결과</title>
</head>
<body>
	<script>
    window.alert('<%=msg%>');
    location.href='<%=location%>';
	</script>
</body>
</html>
