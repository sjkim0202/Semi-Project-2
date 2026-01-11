<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@ page import="com.five.actor.ActorDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%
request.setCharacterEncoding("UTF-8");

// 저장경로
String savepath = request.getRealPath("/actor/actorimg");
java.io.File uploadDir = new java.io.File(savepath);
if (!uploadDir.exists()) {
    uploadDir.mkdirs();  
}
MultipartRequest mr = new MultipartRequest(request, savepath, 10 * 1024 * 1024, "UTF-8", new DefaultFileRenamePolicy());

String a_name = mr.getParameter("a_name");
String a_age = mr.getParameter("a_age");
String a_country = mr.getParameter("a_country");

String a_img = mr.getFilesystemName("a_img");
String imgPath = "actorimg/" + a_img;

ActorDAO dao = new ActorDAO();
int cnt = dao.actorInsert(a_name, a_age, a_country, imgPath);

String msg = cnt > 0 ? "배우 등록 성공!" : "배우 등록 실패!";
%>

<script>
	
<%if (cnt > 0) {%>
	alert("배우가 등록되었습니다!");

	// 팝업으로 열렸다고 가정
	if (window.opener && !window.opener.closed) {
		// 부모창 새로고침 (배우 목록 갱신되도록)
		window.opener.location.reload();
	}
	// 팝업 닫기
	window.close();
<%} else {%>
	alert("등록 실패! 다시 시도해주세요.");
	// 팝업 안에서 다시 입력폼으로 돌아가기
	history.back();
<%}%>
	
</script>
