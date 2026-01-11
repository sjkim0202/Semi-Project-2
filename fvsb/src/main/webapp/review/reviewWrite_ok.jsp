<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%request.setCharacterEncoding("UTF-8");%>
<jsp:useBean id="rdao" class="com.five.review.ReviewDAO" scope="session"></jsp:useBean> 
<%
String sid= (String)session.getAttribute("sid");
String r_title= request.getParameter("r_title");
String r_score_s=request.getParameter("r_score");
String r_comment= request.getParameter("r_comment");
String m_idx_s= request.getParameter("m_idx");

int r_score=Integer.parseInt(r_score_s);
int m_idx=Integer.parseInt(m_idx_s);
int result=rdao.reviewWrite(sid, r_title, r_score, r_comment, m_idx);

if(r_title==null || r_title.equals("")){
	%>
	<script>
	window.alert("내용을 입력하세요");
	location.href="reviewWrite.jsp?m_idx=<%=m_idx %>";
	</script>
	<%
}else{
String msg=result>0?"글쓰기 성공!":"글쓰기 실패!";
%>
<script>
window.alert("<%=msg%>");
window.opener.location.reload();
location.href="reviewList.jsp?m_idx=<%=m_idx %>";
</script>
<%
}%>