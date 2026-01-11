<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%request.setCharacterEncoding("UTF-8");%>
<jsp:useBean id="rcdao" class="com.five.review_comments.Review_commentsDAO" scope="session"></jsp:useBean> 
<%
String sid= (String)session.getAttribute("sid");
String rc_comment= request.getParameter("rc_comment");
String cp=request.getParameter("cp");
String m_idx=request.getParameter("m_idx");
String r_idx_s=request.getParameter("r_idx");
String u_idx_s=request.getParameter("u_idx");
int r_idx=Integer.parseInt(r_idx_s);
int u_idx=Integer.parseInt(u_idx_s);
String dap="1";

if(rc_comment==null || rc_comment.equals("")){
	%>
	<script>
	window.alert("내용을 입력하세요");
	location.href="reviewReWrite.jsp?cp=<%=cp %>&r_idx=<%=r_idx%>&u_idx=<%=u_idx %>&m_idx=<%=m_idx %>";
	</script>
	<%
}else{
int result=rcdao.reviewWrite(r_idx, u_idx, rc_comment);
String msg=result>0?"댓글쓰기 성공!":"댓글쓰기 실패!";
%>
<script>
window.alert("<%=msg%>");
location.href="reviewComment.jsp?cp=<%=cp %>&r_idx=<%=r_idx%>&u_idx=<%=u_idx %>&m_idx=<%=m_idx %>&dap=<%=dap%>";
</script>
<%
}%>