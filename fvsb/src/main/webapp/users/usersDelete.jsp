<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.five.users.UsersDAO" %>
<jsp:useBean id="udao" class="com.five.users.UsersDAO"></jsp:useBean>

<%
    String sessionId = (String)session.getAttribute("sid"); // 세션 ID가 곧 targetId입니다.
    String targetId = sessionId;
    
    int result = 0;
    String msg = "";

    String realPath = application.getRealPath("/users/usersimg");
    
    // 1. 세션 유효성 검사
    if (targetId != null && !targetId.isEmpty()) {
        try {
            // 2. DAO를 통해 삭제 실행
            result = udao.usersDelete(targetId,realPath);
            
            if (result > 0) {
                session.invalidate(); // 강제 로그아웃 처리
                msg = "탈퇴 처리가 완료되었습니다.";
            } else {
                msg = "탈퇴 처리 중 오류 발생 (데이터 없음)";
            }
        } catch (Exception e) {
            e.printStackTrace();
            msg = "서버 오류로 인해 탈퇴에 실패했습니다.";
        }
    } else {
        msg = "로그인 정보가 유효하지 않습니다.";
    }
    
    String contextPath = request.getContextPath();
%>
<script>
    var message = '<%=msg%>';
    var mainPageUrl = '<%= contextPath %>/main.jsp';
    
    // 3. 알림창 표시 및 메인 페이지 이동 (요구사항)
    window.alert(message);
    window.location.href = mainPageUrl;
</script>