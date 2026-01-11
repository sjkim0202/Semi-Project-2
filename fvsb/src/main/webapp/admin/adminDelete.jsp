<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.five.users.UsersDAO" %>
<jsp:useBean id="dao" class="com.five.users.UsersDAO"></jsp:useBean>

<%
    String targetId = request.getParameter("u_id"); // URL 파라미터에서 삭제할 ID를 가져옵니다.
    int result = 0;
    String realPath = application.getRealPath("/users/usersimg");
    String msg="삭제 실패";
    // 1. 대상 ID 유효성 검사
    if (targetId != null && !targetId.isEmpty()) {
        try {
            // 2. DAO를 통해 삭제 실행
            result = dao.usersDelete(targetId,realPath);
        	if(result>0){
        		msg = "삭제하였습니다";
        	}
        } catch (Exception e) {
            e.printStackTrace();
            msg="삭제 중 데이터베이스 오류 발생";
            // DB 오류 발생 시 result는 0 이하일 수 있습니다.
        }
    } 
    
    String pageUrl="/fvsb/admin/usersList.jsp";
%>
<script>
	window.alert('<%=msg%>');
    window.location.href = '<%=pageUrl%>';
   
</script>