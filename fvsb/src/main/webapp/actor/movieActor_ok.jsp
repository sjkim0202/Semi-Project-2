<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<jsp:useBean id="adao" class="com.five.actor.ActorDAO" />
<jsp:useBean id="madao" class="com.five.actor.MovieActorDAO" />


<%
    request.setCharacterEncoding("UTF-8");

    int m_idx = Integer.parseInt(request.getParameter("m_idx"));
    String[] actorNames = request.getParameterValues("actor");
    
    
    if (m_idx > 0) {
        if (actorNames != null && actorNames.length > 0) {
        	List<Integer> actorIds = adao.getActorIdx(actorNames);
          	madao.insertMovieActors(m_idx, actorIds);
        }
    
    if (m_idx > 0) {
        out.println("<script>alert('배우 등록 완료'); location.href='/fvsb/admin/admin.jsp';</script>");
    } else {
        out.println("<script>alert('등록 실패'); history.back();</script>");
    }
    }
%>
