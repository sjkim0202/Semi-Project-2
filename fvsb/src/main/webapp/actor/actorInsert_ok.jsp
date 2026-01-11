<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@ page import="com.five.actor.ActorDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
    request.setCharacterEncoding("UTF-8");
	
	//저장경로
    String savepath = request.getRealPath("/actor/actorimg");

   
    MultipartRequest mr = new MultipartRequest(
            request,
            savepath,                
            10 * 1024 * 1024,         
            "UTF-8",
            new DefaultFileRenamePolicy() 
    );

    String a_name    = mr.getParameter("a_name");
    String a_age     = mr.getParameter("a_age");
    String a_country = mr.getParameter("a_country");

    String a_img = mr.getFilesystemName("a_img");
    
    String imgPath = "actorimg/"+a_img;

    ActorDAO dao = new ActorDAO();
    int cnt = dao.actorInsert(a_name, a_age, a_country, imgPath);

    String msg = cnt > 0 ? "배우 등록 성공!" : "배우 등록 실패!";
%>

    <script>
        <% if (cnt > 0) { %>
            alert("배우가 등록되었습니다!");
                location.href="../admin/admin.jsp";
        <% } else { %>
            alert("등록 실패! 다시 시도해주세요.");
            location.href = "actorInsert.jsp";
        <% } %>
</script>
