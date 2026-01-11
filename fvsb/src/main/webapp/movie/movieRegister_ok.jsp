<%@page import="java.util.Arrays"%>
<%@page import="java.util.List"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.*" %>
<%@ page import="com.oreilly.servlet.*" %>
<%@ page import="com.five.movie.*" %>
<%@ page import="com.five.genre.*" %>
<%@ page import="com.five.actor.*" %>

<jsp:useBean id="mdto" class="com.five.movie.MovieDTO"></jsp:useBean>
<jsp:useBean id="mdao" class="com.five.movie.MovieDAO"></jsp:useBean>
<jsp:useBean id="gdao" class="com.five.genre.GenreDAO"></jsp:useBean>
<jsp:useBean id="adao" class="com.five.actor.ActorDAO"></jsp:useBean>
<jsp:useBean id="mgdao" class="com.five.genre.MovieGenreDAO"></jsp:useBean>
<jsp:useBean id="madao" class="com.five.actor.MovieActorDAO"></jsp:useBean>

<% 
    int m_idx = -1;
    boolean isSuccess = false;

    try {
        String savepath = request.getRealPath("/movie/movieimg");
        int size = 10485760;
       
        MultipartRequest mr = new MultipartRequest(request, savepath, size, "utf-8",
                new DefaultFileRenamePolicy());
        String m_name = mr.getParameter("m_name");
        String m_date = mr.getParameter("m_date");
        String m_limit =mr.getParameter("m_limit");   
        String m_pd = mr.getParameter("m_pd");
        String m_country = mr.getParameter("m_country");
        String m_story = mr.getParameter("m_story");
        String stfile = mr.getFilesystemName("m_img");
        String m_img = mr.getOriginalFileName("m_img");
        String[] genreNames = mr.getParameterValues("genre");
        
        
        String imgPath = "movieimg/"+stfile;
        mdto.setM_name(m_name);
        mdto.setM_date(m_date);
        mdto.setM_limit(m_limit);
        mdto.setM_pd(m_pd);
        mdto.setM_country(m_country);
        mdto.setM_img(imgPath);
        mdto.setM_story(m_story);
        m_idx = mdao.registerMovieAndGetIdx(mdto);
        
        if (m_idx > 0) {
            if (genreNames != null && genreNames.length > 0) {
                List<Integer> genreList = gdao.getGenreIdx(genreNames);
                mgdao.insertMovieGenres(m_idx, genreList);
            }
            isSuccess = true;
        }

    } catch (Exception e) {
        e.printStackTrace();
        isSuccess = false;
    }
%>
    
<script>
<%
String nextUrl = "/fvsb/actor/movieActorSelect.jsp"; 
if (m_idx > 0) {
    nextUrl += "?m_idx=" + m_idx;
}
%>
    <% if (isSuccess) { %>
        window.alert('영화 등록 완료, 배우를 등록해주세요');
        location.href="<%=nextUrl %>";
    <% } else { %>
        window.alert('영화 등록 중 오류가 발생했습니다.');
    <% } %>
</script>