<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.five.qna.QnaDAO" %>
<jsp:useBean id="dao" class="com.five.qna.QnaDAO"></jsp:useBean>

<%
    // URL 파라미터에서 삭제할 QnA 글 번호를 가져옵니다.
    String qIdxParam = request.getParameter("q_idx");
    int result = 0;

    if (qIdxParam != null && !qIdxParam.isEmpty()) {
        try {
            int q_idx = Integer.parseInt(qIdxParam);
            // DAO를 통해 삭제 실행 (qnaDelete는 네가 DAO에 구현해야 함)
            result = dao.qnaDelete(q_idx);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    String contextPath = request.getContextPath();
%>
<script>
    // 삭제 완료 후 QnA 관리자 목록으로 이동
    window.location.href = '<%= contextPath %>/admin/adminQnaList.jsp';
</script>
