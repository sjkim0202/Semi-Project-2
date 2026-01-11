<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import ="com.five.users.*" %>
<jsp:useBean id="mldao" class="com.five.movie_like.Movie_likeDAO"></jsp:useBean>
<jsp:useBean id="udao" class="com.five.users.UsersDAO"></jsp:useBean>
<%
String sid=(String)session.getAttribute("sid");
if(sid==null || sid.equals("")){
	%>
	<script>
	window.alert("로그인 후 이용가능합니다.");
	window.self.close();
	</script>
	<%
    return;
}
UsersDTO dto = udao.getUserById(sid);
int u_idx=dto.getU_idx();
String m_idx_s=request.getParameter("m_idx");
int m_idx=Integer.parseInt(m_idx_s);
if(mldao.isM_like(u_idx, m_idx)){//좋아요 있다
		mldao.reviewLikeDelete(u_idx, m_idx);
	%>
	<script>
	location.href="movieDetail.jsp?&m_idx=<%=m_idx %>";
	</script>
	<%
}else{//좋아요 없다
	mldao.setM_like(u_idx, m_idx);
	%>
	<script>
	location.href="movieDetail.jsp?&m_idx=<%=m_idx %>";
	</script>
	<%
}
%>