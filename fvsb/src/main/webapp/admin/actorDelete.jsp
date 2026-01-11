<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.five.actor.ActorDAO"%>

<%
    request.setCharacterEncoding("UTF-8");

    String aIdxStr = request.getParameter("a_idx");
    
    int a_idx = 0;
    int result = 0;
    
    a_idx = Integer.parseInt(aIdxStr);

    ActorDAO dao = new ActorDAO();
    result = dao.deleteActor(a_idx);
  %>
    <script>
    <% if (result > 0) { %>
        alert("삭제가 완료되었습니다.");
    <% } else { %>
        alert("삭제에 실패했습니다.");
    <% } %>

    location.href = "actorList.jsp";
</script>

         
     
