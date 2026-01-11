<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import ="com.five.users.*" %>
<jsp:useBean id="udao" class="com.five.users.UsersDAO"></jsp:useBean>
<jsp:useBean id="mldao" class="com.five.movie_like.Movie_likeDAO"></jsp:useBean>
<jsp:useBean id="mdao" class="com.five.movie.MovieDAO"></jsp:useBean>

<%
int m_idx =Integer.parseInt(request.getParameter("m_idx"));

String sid=(String)session.getAttribute("sid");
UsersDTO dto = udao.getUserById(sid);
int u_idx=dto.getU_idx();
if(mldao.isM_like(u_idx, m_idx)){
	mldao.movieDelete(m_idx);
}

int result =mdao.movieDelete(m_idx);
int result2= mdao.moviegenreDelete(m_idx);

String msg=result>0?"영화삭제":"해당 영화가 없음";
%>

<script> 
window.alert('<%=msg%>');
location.href="movieAllList.jsp";
</script>