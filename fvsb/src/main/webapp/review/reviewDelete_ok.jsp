<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<jsp:useBean id="rdao" class="com.five.review.ReviewDAO"></jsp:useBean>
<jsp:useBean id="rldao" class="com.five.review_like.Review_likeDAO"></jsp:useBean>
<%
String m_idx_s=request.getParameter("m_idx");
String r_idx_s=request.getParameter("r_idx");
String u_idx_s=request.getParameter("u_idx");
int m_idx=Integer.parseInt(m_idx_s);
int r_idx=Integer.parseInt(r_idx_s);
int u_idx=Integer.parseInt(u_idx_s);
rldao.reviewDelete(r_idx);
int result=rdao.reviewDelete(r_idx);
if(result>0){
	%>
	<script>
	window.alert("리뷰 삭제 성공!");
	location.href="reviewList.jsp?m_idx=<%=m_idx %>&r_idx=<%=r_idx %>&u_idx=<%=u_idx %>";
	</script>
	<%
}else{
	%>
	<script>
	window.alert("리뷰 삭제 실패!");
	location.href="reviewComment.jsp?m_idx=<%=m_idx %>&r_idx=<%=r_idx %>&u_idx=<%=u_idx %>";
	</script>
	<%
}
%>