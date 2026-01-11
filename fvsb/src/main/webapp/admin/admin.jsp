<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
// --- 관리자 권한 체크 (sid 기준) ---
String sid = (String) session.getAttribute("sid"); // 로그인할 때 세션에 넣어둔 아이디

boolean isAdmin = false;

if (sid != null) {
	try {
		UsersDAO udao = new UsersDAO();
		UsersDTO udto = udao.getUserById(sid); // u_id로 조회하는 메서드 이미 있음

		if (udto != null && "admin".equals(udto.getU_ad())) {
	isAdmin = true;
		}
	} catch (Exception e) {
		e.printStackTrace();
	}
}

if (!isAdmin) {
%>
<script>
	window.alert('관리자만 접근 가능합니다.');
	location.href = '/fvsb/main.jsp';
</script>
<%
return;
}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 페이지</title>
<link rel="stylesheet" type="text/css" href="/fvsb/css/mainLayout.css">
<link rel="icon" type="image/png" href="/fvsb/img/fvsb.png">
<link rel="stylesheet" type="text/css" href="/fvsb/css/adminLayout.css">
</head>
<body>
	<%@ include file="/header.jsp"%>
	<main>
		<section>
			<!-- 관리자 메뉴 버튼들 -->
			<div class="admin-menu-buttons">
				<input type="button" value="영화목록" id="goMovie"> <input
					type="button" value="배우목록" id="goActor"> <input
					type="button" value="유저목록" id="goUsers"> <input
					type="button" value="자유게시판목록" id="goBbs"> <input
					type="button" value="문의게시판목록" id="goQna"> <input
					type="button" value="투표생성" id="goVote">
			</div>

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

				<!-- 메모(일정) 영역 -->
				<div id="memo-area">
					<div id="label-date">날짜를 선택하세요</div>
					<textarea id="memo-text"></textarea>
					<br>
					<div class="memo-buttons">
						<button type="button" id="btn-save">메모 저장</button>
						<button type="button" id="btn-delete">메모 삭제</button>
					</div>
				</div>
			</article>
		</section>
	</main>
	<%@ include file="/footer.jsp"%>

	<script>
		// ===== 전역 변수 =====
		var today = new Date();
		var viewYear = today.getFullYear();
		var viewMonth = today.getMonth(); // 0~11

		var selectedDateKey = null; // "YYYY-MM-DD"

		var calendarBody = document.getElementById("calendar-body");
		var labelMonth = document.getElementById("label-month");
		var labelDate = document.getElementById("label-date");
		var memoText = document.getElementById("memo-text");

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

		function loadMemo(dateKey) {
			var memo = localStorage.getItem("memo_" + dateKey);
			if (memo == null) {
				return "";
			}
			return memo;
		}

		function saveMemo(dateKey, memo) {
			if (memo == null || memo.trim() === "") {
				localStorage.removeItem("memo_" + dateKey);
			} else {
				localStorage.setItem("memo_" + dateKey, memo);
			}
		}

		// 긴 메모 → 한 줄 요약(최대 10글자 정도)
		function makePreviewText(memo) {
			if (memo == null) {
				return "";
			}
			// 개행 제거
			memo = memo.replace(/\r/g, "");
			var idx = memo.indexOf("\n");
			if (idx !== -1) {
				memo = memo.substring(0, idx);
			}
			// 너무 길면 10글자만 표시
			if (memo.length > 10) {
				memo = memo.substring(0, 10) + "...";
			}
			return memo;
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

						var memo = loadMemo(key);
						var preview = makePreviewText(memo);

						attr = ' data-date="' + key + '"';

						cellHtml = "<div>" + dateNum + "</div>";
						if (preview !== "") {
							cellHtml += '<div class="memo-preview">' + preview
									+ "</div>";
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

			// 선택 정보 초기화
			labelDate.textContent = "날짜를 선택하세요";
			memoText.value = "";
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
					labelDate.textContent = key + " 일정";
					memoText.value = loadMemo(key);
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

		// ===== 이전/다음 달 버튼 =====
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

		// ===== 메모 저장 버튼 =====
		document.getElementById("btn-save").onclick = function() {
			if (selectedDateKey == null) {
				alert("먼저 날짜를 선택하세요.");
				return;
			}
			saveMemo(selectedDateKey, memoText.value);
			alert("저장되었습니다.");

			// 다시 그려서 미리보기 반영
			drawCalendar(viewYear, viewMonth);

			// 다시 선택 표시
			var tds = calendarBody.getElementsByTagName("td");
			var i;
			for (i = 0; i < tds.length; i++) {
				if (tds[i].getAttribute("data-date") === selectedDateKey) {
					tds[i].classList.add("selected");
				}
			}
			labelDate.textContent = selectedDateKey + " 일정";
			memoText.value = loadMemo(selectedDateKey);
		};
		// ===== 메모 삭제 버튼 ===== (메모 저장 버튼 아래에 추가)
		document.getElementById("btn-delete").onclick = function() {
			if (selectedDateKey == null) {
				alert("먼저 날짜를 선택하세요.");
				return;
			}

			if (confirm("정말 이 날짜의 메모를 삭제하시겠습니까?")) {
				saveMemo(selectedDateKey, ""); // 빈 문자열로 저장하면 삭제됨
				alert("삭제되었습니다.");

				// 다시 그려서 미리보기 제거
				drawCalendar(viewYear, viewMonth);

				// 다시 선택 표시
				var tds = calendarBody.getElementsByTagName("td");
				var i;
				for (i = 0; i < tds.length; i++) {
					if (tds[i].getAttribute("data-date") === selectedDateKey) {
						tds[i].classList.add("selected");
					}
				}
				labelDate.textContent = selectedDateKey + " 일정";
				memoText.value = "";
			}
		};

		// ===== 처음 페이지 로드 시 현재 달 표시 =====
		drawCalendar(viewYear, viewMonth);

		// ===== 기존 버튼 이동 =====
		document.getElementById("goMovie").onclick = function() {
			location.href = "/fvsb/admin/movieAllList.jsp";
		};
		document.getElementById("goActor").onclick = function() {
			location.href = "/fvsb/admin/actorList.jsp";
		};
		document.getElementById("goUsers").onclick = function() {
			location.href = "/fvsb/admin/usersList.jsp";
		};
		document.getElementById("goBbs").onclick = function() {
			location.href = "/fvsb/admin/adminBbsList.jsp";
		};
		document.getElementById("goQna").onclick = function() {
			location.href = "/fvsb/admin/adminQnaList.jsp";
		};
		document.getElementById("goVote").onclick = function() {
			location.href = "/fvsb/poll/pollCreate.jsp";
		};
	</script>
</body>
</html>