<%@page import="java.text.DecimalFormat"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.five.review.*"%>
<jsp:useBean id="rdao" class="com.five.review.ReviewDAO"></jsp:useBean>

<%
String m_idx_s = request.getParameter("m_idx");
int m_idx = Integer.parseInt(m_idx_s);
//총게시글수
int totalCnt = rdao.getTotalCnt(m_idx);
//보여줄 리스트,게시글수
int listSize = 5;
int pageSize = 5;
String cp_s = request.getParameter("cp");
if (cp_s == null || cp_s.equals("")) {
	cp_s = "1";
}
int cp = Integer.parseInt(cp_s);

int totalPage = totalCnt / listSize + 1;
if (totalCnt % listSize == 0 && totalCnt != 0)
	totalPage--;
if (totalPage == 0) {
	totalPage = 1;
}

int userGroup = cp / pageSize;
if (cp % pageSize == 0 && cp != 0)
	userGroup--;

DecimalFormat df = new DecimalFormat("0.0");
//연령대
int age = rdao.avgAge(m_idx);
double totalGender = rdao.getCount(m_idx);
double women_c = rdao.getWomen(m_idx);
double women = (women_c / totalGender) * 100;
double men_c = totalGender - women_c;
double men = (men_c / totalGender) * 100;
String w_result = df.format(women);
String m_result = df.format(men);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title><%=rdao.getM_name(m_idx)%>리뷰게시판</title>
<link rel="stylesheet" type="text/css" href="/fvsb/css/reviewLayout.css">
<link rel="icon" type="image/png" href="/fvsb/img/fvsb.png">
</head>
<body class="review-list">
	<main>
		<section>
			<h2><%=rdao.getM_name(m_idx)%>
				리뷰 게시판
			</h2>

			<!-- 상단 정보 영역 (평균 연령/성비) -->
			<div class="table-header">
				<div class="review-summary">
					<%
					if (age > 0) {
					%>
					평균 연령대
					<%=age%>
					| 남녀 성비 여자:
					<%=w_result%>% 남자:
					<%=m_result%>%
					<%
					} else {
					%>
					등록된 리뷰가 없습니다.
					<%
					}
					%>
				</div>
				<div class="right-actions">
					<button type="button" class="write-btn"
						onclick="location.href='reviewWrite.jsp?m_idx=<%=m_idx%>'">글쓰기</button>
				</div>
			</div>

			<article>
				<table>
					<thead>
						<tr>
							<th>번호</th>
							<th>제목</th>
							<th>작성자</th>
							<th>날짜</th>
							<th>점수</th>
							<th>좋아요</th>
						</tr>
					</thead>
					<tbody>
						<%
						ArrayList<ReviewDTO> arr = rdao.reviewList(cp, listSize, m_idx);
						if (arr == null || arr.size() == 0) {
						%>
						<tr>
							<td colspan="6" align="center">등록된 게시글이 없습니다.</td>
						</tr>
						<%
						} else {
						for (ReviewDTO dto : arr) {
						%>
						<tr>
							<td><%=dto.getR_idx()%></td>
							<td><a
								href="reviewComment.jsp?cp=<%=cp%>&m_idx=<%=m_idx%>&r_idx=<%=dto.getR_idx()%>&u_idx=<%=dto.getU_idx()%>">
									<%=dto.getR_title()%>
							</a></td>
							<td><a
								href="/fvsb/review/reviewInfo.jsp?m_idx=<%=m_idx%>&u_idx=<%=dto.getU_idx()%>&cp=<%=cp%>">
									<%=rdao.getWriter(dto.getU_idx())%>
							</a></td>
							<td><%=dto.getR_date()%></td>
							<%
							int scor = dto.getR_score();
							String score = "";
							switch (scor) {
							case 1:
								score = "★";
								break;
							case 2:
								score = "★★";
								break;
							case 3:
								score = "★★★";
								break;
							case 4:
								score = "★★★★";
								break;
							case 5:
								score = "★★★★★";
							}
							%>
							<td><%=score%></td>
							<td><%=dto.getR_like()%></td>
						</tr>
						<%
						}
						}
						%>
					</tbody>
				</table>
			</article>

			<!-- 페이징 영역 -->
			<div class="pagination">
				<%
				if (userGroup != 0) {
				%>
				<a class="page_link"
					href="reviewList.jsp?m_idx=<%=m_idx%>&cp=<%=(userGroup - 1) * pageSize + pageSize%>">&lt;&lt;</a>
				<%
				}
				for (int i = userGroup * pageSize + 1; i <= userGroup * pageSize + pageSize; i++) {
				if (i > totalPage)
					break;
				if (i == cp) {
				%>
				<span class="current_page"><%=i%></span>
				<%
				} else {
				%>
				<a class="page_link"
					href="reviewList.jsp?m_idx=<%=m_idx%>&cp=<%=i%>"><%=i%></a>
				<%
				}
				}
				if (userGroup != (totalPage / pageSize) - (totalPage % pageSize == 0 ? 1 : 0)) {
				%>
				<a class="page_link"
					href="reviewList.jsp?m_idx=<%=m_idx%>&cp=<%=(userGroup + 1) * pageSize + 1%>">&gt;&gt;</a>
				<%
				}
				%>
			</div>

		</section>
	</main>
</body>
</html>