<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<jsp:useBean id="udao" class="com.five.users.UsersDAO"></jsp:useBean>
<%
String u_id = request.getParameter("u_id");
boolean error = false; //에러 초기값설정
String errorMessage = "";
int minLength = 3; // 3글자부터

// 1. null입력방지
if (u_id == null || u_id.trim().isEmpty()) {
	errorMessage = "아이디를 다시 입력해주세요.";
	error = true;
}
// ⭐ 2. 최소 길이 (3글자 이상) 
else if (u_id.length() < minLength) {
	errorMessage = minLength + "글자 이상 입력해주세요.";
	error = true;
}
// ⭐ 3. 한글 포함 여부 
else {
	boolean Korean = false;
	for (int i = 0; i < u_id.length(); i++) {
		char ch = u_id.charAt(i);
		// A. 완성형 한글 (AC00 ~ D7A3) : '가' ~ '힣'
		boolean charKorean = (ch >= '가' && ch <= '힣');

		// B. 낱개의 자음/모음  : ㄱ ~ ㅎ, ㅏ ~ ㅣ 등
		// 유니코드 범위: 3131 ~ 318E (이 영역에 낱개의 자음/모음이 포함됨)
		boolean oneKorean = (ch >= '\u3131' && ch <= '\u318E');

		if (charKorean || oneKorean) {
	Korean = true;
	break;
		}
	}

	if (Korean) {
		errorMessage = "ID에는 한글을 사용할 수 없습니다.";
		error = true;
	}
}

if (error) {
%>
<script>
	window.alert('<%=errorMessage%>');
	location.href='idCheck.jsp'; // 다시 검사 페이지로 돌아가게 함
</script>
<%
return; // 유효성 검사 실패 시 JSP 실행 종료
}
//유효성 검사 후 DAO 호출

boolean result = udao.idCheck(u_id);

if (result) {
%>
<script>
	window.alert('<%=u_id%>는 이미 가입되어있음');
	location.href='idCheck.jsp';
	</script>
<%
} else {
%>
<script>
	window.alert('<%=u_id%>는 사용 가능한 아이디입니다.');
	opener.document.usersJoin.u_id.value='<%=u_id%>';
	opener.document.usersJoin.hiddenid.value='<%=u_id%>';
	window.self.close();
</script>
<%
}
%>