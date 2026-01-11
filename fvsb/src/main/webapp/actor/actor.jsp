<%@page import="com.five.actor.ActorDTO"%>
<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<jsp:useBean id="adao" class="com.five.actor.ActorDAO"></jsp:useBean>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>배우 목록</title>
<link rel="stylesheet" type="text/css" href="/fvsb/css/mainLayout.css">
<link rel="stylesheet" type="text/css" href="/fvsb/css/actorLayout.css">
<link rel="icon" type="image/png" href="/fvsb/img/fvsb.png">
</head>

<%
String cpKr_s = request.getParameter("cpKr");
if (cpKr_s == null || cpKr_s.equals("")) {
    cpKr_s = "1";
}
int cpKr = Integer.parseInt(cpKr_s);

String cpFr_s = request.getParameter("cpFr");
if (cpFr_s == null || cpFr_s.equals("")) {
    cpFr_s = "1";
}
int cpFr = Integer.parseInt(cpFr_s);

int listSizeKr = 5;      // 국내 페이지 배우 수
int listSizeNotKr = 5;   // 해외 페이지 배우 수
int pageSize = 5;        // 그룹 수

// 국내 배우 전체 수/페이지 수
int totalCntKr = adao.getKrCountry("kr");
int totalPageKr = (totalCntKr - 1) / listSizeKr + 1;
int actorGroupKr = (cpKr - 1) / pageSize;

// 해외 배우 전체 수/페이지 수
int totalCntFr = adao.getNotKrCountry("kr");
int totalPageFr = (totalCntFr - 1) / listSizeNotKr + 1;
int actorGroupFr = (cpFr - 1) / pageSize;

ArrayList<ActorDTO> arrKr = adao.actorListByCountry("kr", cpKr, listSizeKr);
ArrayList<ActorDTO> arrFr = adao.actorListNotCountry("kr", cpFr, listSizeNotKr);
%>

<body class="actor-form">
    <%@include file="/header.jsp"%>
    <main>
        <section>
            <h2>배우 리스트</h2>
        </section>

        <article>
            <table style="margin: auto; text-align: center;">

                <!-- 국내 배우 -->
                <tr>
                    <td colspan="7" align="center">국내 배우</td>
                </tr>
                <tr>

                    <!-- 국내 왼쪽 화살표 -->
                    <td width="80" align="center" valign="middle">
                        <%
                        if (cpKr > 1) {
                        %>
                        <a href="actor.jsp?cpKr=<%=cpKr - 1%>&cpFr=<%=cpFr%>">
                            <img src="/fvsb/img/arrowsL.png" width="24">
                        </a>
                        <%
                        }
                        %>
                    </td>

                    <%
                    if (arrKr == null || arrKr.size() == 0) {
                    %>
                        <td colspan="3" align="center">등록된 국내 배우가 없습니다.</td>
                    <%
                    } else {
                        for (ActorDTO temp : arrKr) {
                            String imgUrl = "/fvsb/actor/" + temp.getA_img();
                    %>
                        <td align="center" style="padding: 20px;">
                            <a href="actorMovieList.jsp?a_idx=<%=temp.getA_idx()%>">
                                <img src="<%=imgUrl%>" width="150">
                            </a><br>
                            <div><%=temp.getA_name()%></div>
                            <div>출생연도 : <%=temp.getA_age()%>년</div>
                            <div>국적 : 한국</div>
                        </td>
                    <%
                        }
                    }
                    %>

                    <!-- 국내 오른쪽 화살표 -->
                    <td width="80" align="center" valign="middle">
                        <%
                        if (cpKr < totalPageKr) {
                        %>
                        <a href="actor.jsp?cpKr=<%=cpKr + 1%>&cpFr=<%=cpFr%>">
                            <img src="/fvsb/img/arrowsR.png" width="24">
                        </a>
                        <%
                        }
                        %>
                    </td>
                </tr>

                <!-- 국내 페이지 그룹 이동 -->
                <tr>
                    <td colspan="10" style="padding-top: 10px;">
                        <%
                        int lastGroupKr = (totalPageKr - 1) / pageSize;

                        // 이전 그룹
                        if (actorGroupKr > 0) {
                        %>
                        <a href="actor.jsp?cpKr=<%=actorGroupKr * pageSize%>&cpFr=<%=cpFr%>">
                            <img src="/fvsb/img/arrowsL.png" width="20">
                        </a>
                        <%
                        }

                        // 다음 그룹
                        if (actorGroupKr < lastGroupKr) {
                        %>
                        <a href="actor.jsp?cpKr=<%=(actorGroupKr + 1) * pageSize + 1%>&cpFr=<%=cpFr%>">
                            <img src="/fvsb/img/arrowsR.png" width="20">
                        </a>
                        <%
                        }
                        %>
                    </td>
                </tr>

                <!-- 해외 배우 제목 -->
                <tr>
                    <td colspan="7" align="center">해외 배우</td>
                </tr>

                <!-- 해외 배우 리스트 -->
                <tr>
                    <!-- 해외 왼쪽 화살표 -->
                    <td width="80" align="center" valign="middle">
                        <%
                        if (cpFr > 1) {
                        %>
                        <a href="actor.jsp?cpKr=<%=cpKr%>&cpFr=<%=cpFr - 1%>">
                            <img src="/fvsb/img/arrowsL.png" width="24">
                        </a>
                        <%
                        }
                        %>
                    </td>

                    <%
                    if (arrFr == null || arrFr.size() == 0) {
                    %>
                        <td colspan="3" align="center">등록된 해외 배우가 없습니다.</td>
                    <%
                    } else {
                        for (ActorDTO temp : arrFr) {
                            String imgUrl = "/fvsb/actor/" + temp.getA_img();
                    %>
                        <td align="center" style="padding: 20px;">
                            <a href="actorMovieList.jsp?a_idx=<%=temp.getA_idx()%>">
                                <img src="<%=imgUrl%>" width="150">
                            </a><br>
                            <div><%=temp.getA_name()%></div>
                            <div>출생연도 : <%=temp.getA_age()%>년</div>
                            <div>국적 : <%=temp.getA_country()%></div>
                        </td>
                    <%
                        }
                    }
                    %>

                    <!-- 해외 오른쪽 화살표 -->
                    <td width="80" align="center" valign="middle">
                        <%
                        if (cpFr < totalPageFr) {
                        %>
                        <a href="actor.jsp?cpKr=<%=cpKr%>&cpFr=<%=cpFr + 1%>">
                            <img src="/fvsb/img/arrowsR.png" width="24">
                        </a>
                        <%
                        }
                        %>
                    </td>
                </tr>

            </table>
        </article>

    </main>
    <%@include file="/footer.jsp"%>
</body>
</html>
