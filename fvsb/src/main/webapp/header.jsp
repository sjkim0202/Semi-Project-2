<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ page import="com.five.users.UsersDAO"%>
<%@ page import="com.five.users.UsersDTO"%>
<%@ page import="com.five.notification.NotificationDAO"%>
<%@ page import="java.util.*"%>
<jsp:useBean id="headerUdao" class="com.five.users.UsersDAO"></jsp:useBean>
<jsp:useBean id="headerUdto" class="com.five.users.UsersDTO"></jsp:useBean>
<jsp:useBean id="headerNdao" class="com.five.notification.NotificationDAO"></jsp:useBean>
<jsp:useBean id="headerVdao" class="com.five.vote.CreatePollDAO"></jsp:useBean>   
<%
String sname = (String) session.getAttribute("sname");
String h_sid = (String) session.getAttribute("sid");

boolean isAdminH = false;
int loginUidx = 0;
int notiCount = 0;

if (h_sid != null && !h_sid.equals("")) {
   try {
      // 아이디로 유저 정보 가져오기
      headerUdto = headerUdao.getUserById(h_sid);
      if (headerUdto != null) {
   loginUidx = headerUdto.getU_idx();
   // 관리자 여부
   if ("admin".equals(headerUdto.getU_ad())) {
      isAdminH = true;
   }
   // 이름이 세션에 없으면 DTO에서 가져와서 세션에 다시 세팅해도 됨
   if (sname == null || sname.equals("")) {
      sname = headerUdto.getU_name();
      session.setAttribute("sname", sname);
   }

   // 알림 개수 조회
   notiCount = headerNdao.getUnreadCount(loginUidx);
      }
   } catch (Exception e) {
      e.printStackTrace();
   }
}
%>
<header>
   <div class="header-top">
      <div class="logo">
         <a href="/fvsb/main.jsp"> <img src="/fvsb/img/new_logo.png" alt="로고">
         </a>
      </div>
      <div class="nav-links">
         <%
         if (sname == null) {
         %>
         <a href="/fvsb/main.jsp">홈</a> <a href="/fvsb/users/usersJoin.jsp">회원가입</a>
         <a href="/fvsb/users/login.jsp">로그인</a>
         <%
         } else {
         %>
         <%
         if (isAdminH) {
         %>
         <a href="/fvsb/admin/admin.jsp">🔑</a>
         <%
         }
         %>
         <!-- 하트 아이콘 -->
         <a href="#"
            onclick="window.open('/fvsb/review/likeList.jsp','notiPopup','width=500,height=600');"><img
            src="/fvsb/review/reviewimg/like_2.png" width="20"> </a>
         <!-- 알림 아이콘 -->
         <a href="javascript:void(0);"
            onclick="window.open('/fvsb/notification/notificationList.jsp','notiPopup','width=500,height=600,scrollbars=yes');"
            class="notification-icon"> <img src="/fvsb/img/bell.png"
            alt="알림"> <%
             if (notiCount > 0) {
             %> <span class="notification-badge"><%=notiCount%></span> <%
             }
             %>
         </a> <a href="/fvsb/users/usersInfo.jsp">📝MY</a> <a
            href="/fvsb/main.jsp">홈</a> <span class="user-info"><%=sname%>님</span>
         <a href="/fvsb/users/logout.jsp">로그아웃</a>
         <%
         }
         %>
      </div>
   </div>
   <hr>
   <nav class="main-submenu">
      <ul>
         <li><a href="/fvsb/movie/movieList.jsp">🎬MOVIE</a></li>
         <li><a href="/fvsb/actor/actor.jsp">🍿ACTOR</a></li>
         <li><a href="/fvsb/award/awardList.jsp">🏆AWARD</a></li>
         <li><a href="/fvsb/poll/pollList.jsp?poll_id=<%=headerVdao.getAllPolls()%>">🗳️VOTE</a></li>
         <li><a href="/fvsb/bbs/bbsList.jsp">💬BOARD</a></li>
         <li><a href="/fvsb/qna/qnaList.jsp">❓QNA</a></li>
      </ul>
   </nav>
</header>