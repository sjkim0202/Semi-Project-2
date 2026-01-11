<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<jsp:useBean id="rldao" class="com.five.review_like.Review_likeDAO"></jsp:useBean>
<jsp:useBean id="rdao" class="com.five.review.ReviewDAO"></jsp:useBean>
<%
String r_idx_s=request.getParameter("r_idx");
String u_idx_s=request.getParameter("u_idx");
int r_idx=Integer.parseInt(r_idx_s);
int u_idx=Integer.parseInt(u_idx_s);
if(rldao.isR_like(u_idx, r_idx)){//좋아요 있다
		rdao.reviewLikeDelete(r_idx);
		rldao.reviewLikeDelete(r_idx, u_idx);
	%>
	<script>
	window.opener.location.reload();
	location.href="reviewText.jsp?r_idx=<%=r_idx%>&u_idx=<%=u_idx %>";
	</script>
	<%
}else{//좋아요 없다
	rdao.selectRlike(r_idx);
	rldao.setR_like(u_idx, r_idx);
	%>
	<script>
	window.opener.location.reload();
	location.href="reviewText.jsp?r_idx=<%=r_idx%>&u_idx=<%=u_idx %>";
	</script>
	<%
}
%>