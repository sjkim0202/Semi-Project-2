<%@page import="java.time.LocalDate"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" %>
<%@ page import="com.oreilly.servlet.*"%>
<%@ page import="java.io.*"%>
<%
request.setCharacterEncoding("utf-8");
%>
<jsp:useBean id="udto" class="com.five.users.UsersDTO"></jsp:useBean>
<jsp:useBean id="udao" class="com.five.users.UsersDAO"></jsp:useBean>
<%
int result = 0;
String msg = "가입실패";
String uploadDirectory = "/users/usersimg"; // 파일을 저장할 웹 접근 경로 (예: /fvsb/img)
int maxPostSize = 10 * 1024 * 1024; 
String encoding = "UTF-8";

// 파일을 저장할 서버의 실제 경로
String saveDirectory = application.getRealPath(uploadDirectory);

String[] genre = null;

try {
	MultipartRequest mr = new com.oreilly.servlet.MultipartRequest(request, saveDirectory, maxPostSize, encoding,
	new DefaultFileRenamePolicy() // 파일명 중복 방지
	);
	
	String u_name = mr.getParameter("u_name");
	int maxLength = 6;
	if (u_name != null && u_name.length() >maxLength){
	%>
		<script>
			alert("이름은 최대 <%=maxLength%>글자까지 입력가능");
			history.back();
		</script>
	<%
		return;
	}
	
	genre = mr.getParameterValues("genre");

	String originname = mr.getFilesystemName("u_img");
	String finalname = (originname != null) ? originname : "default.png";

	udto.setU_id(mr.getParameter("u_id"));
	udto.setU_pwd(mr.getParameter("u_pwd"));
	udto.setU_name(mr.getParameter("u_name"));
	udto.setU_sex(mr.getParameter("u_sex"));

	String uYear = mr.getParameter("u_year");
	if (uYear != null && !uYear.isEmpty()) {
		udto.setU_year(Integer.parseInt(uYear));
	}
	udto.setU_ad(mr.getParameter("u_ad"));
	udto.setU_img(finalname);

	result = udao.usersJoin(udto, genre);
	msg = result > 0 ? "가입완료" : "가입실패 (DB 오류)";

} catch (IOException e) {
	System.out.println("IOException: 파일 업로드 오류 발생. " + e.getMessage()); 
	msg = "파일 업로드 실패: 크기가 너무 크거나 서버 오류입니다.";
} catch (NumberFormatException e) {
	System.out.println("NumberFormatException: 나이 입력 오류. " + e.getMessage());
	msg = "나이 입력오류";
} catch (Exception e) {
	System.out.println("Exception: DB 처리 중 오류 발생. " + e.getMessage());
	msg = "DB 처리 중 알 수 없는 오류 발생.";
}
%>
<script>
    window.alert('<%=msg%>');
	location.href = '/fvsb/main.jsp';
</script>