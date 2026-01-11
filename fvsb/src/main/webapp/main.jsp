<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="com.five.movie.*"%>
<%@ page import="java.util.*"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>FVSB 영화리뷰커뮤니티</title>
<link rel="stylesheet" type="text/css" href="/fvsb/css/mainLayout.css">
<link rel="icon" type="image/png" href="/fvsb/img/fvsb.png">
</head>
<body class="main-page">
	<%@include file="header.jsp"%>
	<%
	// 오늘 기준 연/월
	Calendar cal = Calendar.getInstance();
	int currentYear = cal.get(Calendar.YEAR);
	int currentMonth = cal.get(Calendar.MONTH) + 1; // 1~12

	MovieDAO mdao = new MovieDAO();

	// 1년치 데이터 미리 로드 (현재 월 기준 -6개월 ~ +6개월)
	Map<String, List<MovieDTO>> allMovieMap = new HashMap<>();

	Calendar tempCal = Calendar.getInstance();
	tempCal.add(Calendar.MONTH, -6); // 6개월 전부터

	for (int i = 0; i < 13; i++) { // 13개월치 (6개월 전 ~ 6개월 후)
		int year = tempCal.get(Calendar.YEAR);
		int month = tempCal.get(Calendar.MONTH) + 1;
		String strMonth = (month < 10) ? "0" + month : String.valueOf(month);
		String yearMonth = year + "-" + strMonth;

		Map<String, List<MovieDTO>> monthData = mdao.getMoviesByMonth(yearMonth);
		allMovieMap.putAll(monthData);

		tempCal.add(Calendar.MONTH, 1); // 다음 달로
	}
	%>

	<!-- DB에서 가져온 1년치 영화 정보를 JS객체 movieMap으로 내려주기 -->
	<script>
        var movieMap = {};
    <%for (Map.Entry<String, List<MovieDTO>> entry : allMovieMap.entrySet()) {
	String dateKey = entry.getKey(); // "YYYY-MM-DD"
	List<MovieDTO> list = entry.getValue();%>
        movieMap["<%=dateKey%>"] = [
    <%for (int i = 0; i < list.size(); i++) {
	MovieDTO dto = list.get(i);
	String safeTitle = dto.getM_name() == null ? "" : dto.getM_name().replace("\"", "\\\"");%>
            { m_idx: <%=dto.getM_idx()%>, title: "<%=safeTitle%>" }<%=(i < list.size() - 1) ? "," : ""%>
    <%}%>
        ];
    <%}%>
    function getCookie(name) {
        const cookies = document.cookie.split(';');
        for (let i = 0; i < cookies.length; i++) {
            const c = cookies[i].trim();
            if (c.indexOf(name + '=') === 0) {
                return c.substring((name + '=').length, c.length);
            }
        }
        return null;
    }

    function openFvsbPopup() {
        const popupck = getCookie('popupck');
        if (popupck === 'on') {
            // 오늘 하루 보지 않기 선택한 상태 → 아예 팝업 안 띄움
            return;
        }

        window.open('/fvsb/popup/popUp.jsp', 'popup', 'width=400,height=400');
    }

    window.onload = function() {
        openFvsbPopup();   // 쿠키 보고 필요할 때만 팝업 오픈
    }
    </script>

	<main>
		<section>
			<article id="mainImg">
				<img alt="메인이미지" src="/fvsb/img/main.png">
			</article>
		</section>
		<section id="calendar-section">
			<!-- 달력 상단(월 이동) -->
			<div id="calendar-header">
				<button type="button" id="btn-prev">&lt;</button>
				<span id="label-month"></span>
				<button type="button" id="btn-next">&gt;</button>
			</div>

			<article>
				<table>
					<thead>
						<tr>
							<th>일</th>
							<th>월</th>
							<th>화</th>
							<th>수</th>
							<th>목</th>
							<th>금</th>
							<th>토</th>
						</tr>
					</thead>
					<tbody id="calendar-body">
						<!-- 자바스크립트로 채움 -->
					</tbody>
				</table>
			</article>
		</section>
		<section id="reserve-section">
			<article>
				<button type="button"
					onclick="window.open('https://cgv.co.kr/cnm/movieBook?NaPm=ct%3Dmifflyiq%7Cci%3Dcheckout%7Ctr%3Dds%7Ctrx%3Dnull%7Chk%3D21a6aec3841274fad9d989e2d6e50e39d021f647')">
					CGV</button>
				<button type="button"
					onclick="window.open('https://www.lottecinema.co.kr/NLCHS/Ticketing?NaPm=ct%3Dmifflg9g%7Cci%3Dcheckout%7Ctr%3Dds%7Ctrx%3Dnull%7Chk%3D7c070fc03984bad5ed36d574c84d9cba723ec57c')">
					롯데시네마</button>
				<button type="button"
					onclick="window.open('https://www.megabox.co.kr/booking?NaPm=ct%3Dmiffmdpf%7Cci%3Dcheckout%7Ctr%3Dds%7Ctrx%3Dnull%7Chk%3Da1e9842b5114a2a944441b1c88bce10fab36ebb4')">
					메가박스</button>
			</article>
		</section>
	</main>
	<%@include file="footer.jsp"%>
	<script>
        // ===== 전역 변수 =====
        var today = new Date();
        var viewYear = today.getFullYear();
        var viewMonth = today.getMonth(); // 0~11

        var selectedDateKey = null; // "YYYY-MM-DD"

        var calendarBody = document.getElementById("calendar-body");
        var labelMonth = document.getElementById("label-month");

        // ===== 유틸 함수 =====
        function makeDateKey(dateObj) {
            var y = dateObj.getFullYear();
            var m = dateObj.getMonth() + 1;
            var d = dateObj.getDate();

            if (m < 10) {
                m = "0" + m;
            }
            if (d < 10) {
                d = "0" + d;
            }

            return y + "-" + m + "-" + d; // 예: 2025-11-20
        }

        // ===== 달력 그리기 =====
        function drawCalendar(year, month) {
            // 상단 "YYYY년 M월"
            labelMonth.textContent = year + "년 " + (month + 1) + "월";

            // 이번 달 1일, 마지막 날
            var firstDayObj = new Date(year, month, 1);
            var lastDayObj = new Date(year, month + 1, 0);

            var firstWeekDay = firstDayObj.getDay(); // 0~6 (일~토)
            var lastDateNum = lastDayObj.getDate(); // 28~31

            // tbody 비우기
            calendarBody.innerHTML = "";

            var dateNum = 1;
            var week, day;

            // 최대 6주(6행)
            for (week = 0; week < 6; week++) {
                var rowHtml = "<tr>";

                // 7일(7열)
                for (day = 0; day < 7; day++) {
                    var cellHtml = "";
                    var attr = "";

                    // 첫 주의 경우 시작 요일 전까지 빈칸
                    if (week === 0 && day < firstWeekDay) {
                        // 빈 칸
                        cellHtml = "";
                    } else if (dateNum > lastDateNum) {
                        // 이번 달 날짜를 다 채웠으면 나머지도 빈칸
                        cellHtml = "";
                    } else {
                        // 실제 날짜
                        var cellDateObj = new Date(year, month, dateNum);
                        var key = makeDateKey(cellDateObj);

                        attr = ' data-date="' + key + '"';

                        // 날짜 숫자
                        cellHtml = "<div class='day-number'>" + dateNum + "</div>";

                        // 해당 날짜에 개봉 영화가 있으면 제목도 같이 표시
                        if (typeof movieMap !== 'undefined' && movieMap[key] && movieMap[key].length > 0) {
                            var movies = movieMap[key];
                            cellHtml += "<ul class='movie-list'>";

                            // 셀 안에 2~3개만 미리보기로 보여주기 (예: 최대 3개)
                            var maxShow = 3;
                            for (var i = 0; i < movies.length && i < maxShow; i++) {
                                var title = movies[i].title || "";
                                cellHtml += "<li>" + title + "</li>";
                            }

                            // 영화가 더 있으면 "+N"으로 표시
                            if (movies.length > maxShow) {
                                var moreCnt = movies.length - maxShow;
                                cellHtml += "<li class='more'>+" + moreCnt + " more</li>";
                            }

                            cellHtml += "</ul>";
                        }

                        dateNum = dateNum + 1;
                    }

                    rowHtml += "<td" + attr + ">" + cellHtml + "</td>";
                }

                rowHtml += "</tr>";
                calendarBody.innerHTML += rowHtml;
            }

            // 셀 클릭 이벤트 다시 설정
            setCellClickEvents();
        }

        // ===== 셀 클릭 이벤트 설정 =====
        function setCellClickEvents() {
            var tds = calendarBody.getElementsByTagName("td");
            var i;

            for (i = 0; i < tds.length; i++) {
                tds[i].onclick = function() {
                    var key = this.getAttribute("data-date");
                    if (!key) {
                        return; // 빈 칸
                    }

                    clearSelectedClass();
                    this.classList.add("selected");
                    selectedDateKey = key;

                    // 날짜 클릭 시 팝업 페이지 열기
                    var popupUrl = "/fvsb/movie/moviePopup.jsp?date=" + key;
                    var popupOptions = "width=320,height=200,left=800,top=350";
                    window.open(popupUrl, "moviePopup", popupOptions);
                };
            }
        }

        function clearSelectedClass() {
            var tds = calendarBody.getElementsByTagName("td");
            var i;
            for (i = 0; i < tds.length; i++) {
                tds[i].classList.remove("selected");
            }
        }

        // ===== 이전/다음 달 버튼 (페이지 리로드 없이 달력만 다시 그리기) =====
        document.getElementById("btn-prev").onclick = function() {
            viewMonth = viewMonth - 1;
            if (viewMonth < 0) {
                viewMonth = 11;
                viewYear = viewYear - 1;
            }
            drawCalendar(viewYear, viewMonth);
        };

        document.getElementById("btn-next").onclick = function() {
            viewMonth = viewMonth + 1;
            if (viewMonth > 11) {
                viewMonth = 0;
                viewYear = viewYear + 1;
            }
            drawCalendar(viewYear, viewMonth);
        };

        // ===== 처음 페이지 로드 시 현재 달 표시 =====
        drawCalendar(viewYear, viewMonth);
    </script>
</body>
</html>