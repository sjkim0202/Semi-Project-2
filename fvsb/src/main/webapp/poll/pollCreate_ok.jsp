<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.five.vote.*" %>
<%@ page import="java.sql.Date" %>

<%
    request.setCharacterEncoding("UTF-8");

    String role = (String)session.getAttribute("sid");
    /* if (role == null || !"admin".equals(role)) {
        out.println("관리자만 접근 가능합니다.");
        return;
    } */

    String startDate_s = request.getParameter("startDate"); 
    String endDate_s   = request.getParameter("endDate");
	String poll_name = request.getParameter("poll_name");
    if (startDate_s == null || endDate_s == null ||
        startDate_s.equals("") || endDate_s.equals("")) {
        %>
        	<script>
        		window.alert("날짜를 모두 입력하세요.");
        		location.href = '/fvsb/poll/pollCreate.jsp';
        	</script>
        <%
        return;
    }

    Date startDate = Date.valueOf(startDate_s);
    Date endDate   = Date.valueOf(endDate_s);

    long start = startDate.getTime();
    long end = endDate.getTime();
    
    if(end < start){
    	%>
    		<script>
    			window.alert("날짜를 다시 확인해 주세요.");
    			location.href = '/fvsb/poll/pollCreate.jsp';
    		</script>
    	<%
    	return;
    }
    CreatePollDTO dto = new CreatePollDTO();
    dto.setStartDate(startDate);
    dto.setEndDate(endDate);
    dto.setPoll_name(poll_name);

    CreatePollDAO dao = new CreatePollDAO();
    int result = dao.createPoll(dto);

    if (result > 0) {
        response.sendRedirect("pollList.jsp");
    } else {
        %>
        	<script>
        		window.alert("투표 생성에 실패했습니다.");
        	</script>
        <%
    }
%>
