<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.five.bbs.BbsDAO" %>
<jsp:useBean id="dao" class="com.five.bbs.BbsDAO"></jsp:useBean>

<%
    // URL 파라미터에서 삭제할 게시글 번호를 가져옵니다.
    String bIdxParam = request.getParameter("b_idx");
    int result = 0;

    if (bIdxParam != null && !bIdxParam.isEmpty()) {
        try {
            int b_idx = Integer.parseInt(bIdxParam);
            // DAO를 통해 삭제 실행 (bbsDelete는 네가 DAO에 구현해야 함)
            result = dao.bbsDelete(b_idx);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    String contextPath = request.getContextPath();
%>
<script>
    // 삭제 완료 후 게시판 관리자 목록으로 이동
    window.location.href = '<%= contextPath %>/admin/adminBbsList.jsp';
</script>
