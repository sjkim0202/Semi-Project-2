<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<jsp:useBean id="rcdao" class="com.five.review_comments.Review_commentsDAO"></jsp:useBean>
<%
String cp=request.getParameter("cp");
String rc_idx_s=request.getParameter("rc_idx");
String m_idx=request.getParameter("m_idx");
String r_idx=request.getParameter("r_idx");
String dap="1";
int rc_idx=Integer.parseInt(rc_idx_s);
int result=rcdao.rcDelete(rc_idx);
if(result>0){
	%>
	<script>
	window.alert("댓글 삭제 성공!");
	location.href="reviewComment.jsp?dap=<%=dap%>&cp=<%=cp%>&m_idx=<%=m_idx %>&r_idx=<%=r_idx %>";
	</script>
	<%
}else{
	%>
	<script>
	window.alert("댓글 삭제 실패!");
	location.href="reviewComment.jsp?dap=<%=dap%>&m_idx=<%=m_idx %>&r_idx=<%=r_idx %>";
	</script>
	<%
}
%>