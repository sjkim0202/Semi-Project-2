package com.five.users;

import java.sql.*;
import java.util.*;
import javax.sql.*;
import javax.naming.*;
import java.sql.Date;

import com.five.genre.GenreDAO;
import com.five.genre.UserGenreDAO;
import com.oreilly.servlet.MultipartRequest;

public class UsersDAO {

	private Connection conn;
	private PreparedStatement ps;
	private ResultSet rs;

	public static final int NOT_ID = 1;
	static public final int NOT_PWD = 2;
	final static public int LOGIN_OK = 3;
	public static final int ERROR = -1;

	public UsersDAO() {
	}

	/** 회원가입 */
	public int usersJoin(UsersDTO dto, String[] genre) {
		Connection conn = null;
		PreparedStatement ps = null;
		int result = 0;
		GenreDAO gDao = new GenreDAO();

		String sql = "INSERT INTO users " + "(u_idx, u_id, u_pwd, u_name, u_sex, u_year, u_date,u_ad,u_img) "
				+ "VALUES (users_idx.NEXTVAL, ?, ?, ?, ?, ?, SYSDATE,'user', ?)";
		String insertGenreSql = "INSERT INTO user_genre (ug_idx, u_idx, g_idx) "
				+ "VALUES (user_genre_idx.NEXTVAL, users_idx.CURRVAL, ?)";

		try {
			conn = com.five.db.FiveDB.getConn();
			conn.setAutoCommit(false);

			ps = conn.prepareStatement(sql);
			ps.setString(1, dto.getU_id());
			String temp = com.five.javasecur.JavaDataSecurModule.getSHA256(dto.getU_pwd());
			ps.setString(2, temp);
			ps.setString(3, dto.getU_name());
			ps.setString(4, dto.getU_sex());
			ps.setInt(5, dto.getU_year());
			ps.setString(6, dto.getU_img());
			result = ps.executeUpdate();

			// USERS 삽입 성공 및 장르가 선택된 경우 2단계 진행
			if (result > 0 && genre != null && genre.length > 0) {

				ps.close();

				ps = conn.prepareStatement(insertGenreSql); // USER_GENRE SQL 사용

				for (String genreName : genre) { // gIdxStr 대신 genreName을 사용 (오해 방지)
					// 1. GenreDAO를 이용해 장르 이름을 ID로 조회합니다.
					int g_idx = gDao.getGidxByName(genreName);

					// 2. ID를 찾았을 경우에만 삽입을 진행합니다.
					if (g_idx > 0) {
						ps.setInt(1, g_idx); // ?에 g_idx 바인딩
						ps.executeUpdate(); // 장르 하나씩 삽입
					}
				}

			}
			conn.commit();
			return 1;
		} catch (Exception e) {
			e.printStackTrace();

			if (conn != null) {
				try {
					conn.rollback();
				} catch (SQLException rollbackEx) {
					rollbackEx.printStackTrace();
				}
			}
			return -1;

		} finally {
			try {
				if (conn != null)
					conn.setAutoCommit(true);
				if (ps != null)
					ps.close();
				if (conn != null)
					conn.close();
			} catch (Exception e2) {
			}
		}
	}

	/** ID 중복검사 */
	public boolean idCheck(String u_id) {
		try {
			conn = com.five.db.FiveDB.getConn();
			String sql = "select u_id from users where u_id = ?";
			ps = conn.prepareStatement(sql);
			ps.setString(1, u_id);
			rs = ps.executeQuery();
			return rs.next();
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (ps != null)
					ps.close();
				if (conn != null)
					conn.close();
			} catch (Exception e2) {
			}
		}
	}

	/** 로그인 체크 */
	public int loginCheck(String u_id, String u_pwd) {
		try {
			conn = com.five.db.FiveDB.getConn();
			String sql = "SELECT u_pwd FROM users WHERE u_id = ?";
			ps = conn.prepareStatement(sql);
			ps.setString(1, u_id);
			rs = ps.executeQuery();

			if (rs.next()) {

				String dbpwd = rs.getString(1);
				u_pwd = com.five.javasecur.JavaDataSecurModule.getSHA256(u_pwd);

				if (dbpwd.equals(u_pwd)) {
					return LOGIN_OK;
				} else {
					return NOT_PWD;
				}

			} else {
				return NOT_ID;
			}

		} catch (Exception e) {
			e.printStackTrace();
			return ERROR;
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (ps != null)
					ps.close();
				if (conn != null)
					conn.close();
			} catch (Exception e2) {
			}

		}
	}

	/** 유저정보 인가 체크 */
	public String getUserNameById(String u_id) {

		try {
			conn = com.five.db.FiveDB.getConn();
			String sql = "SELECT u_name FROM users WHERE u_id = ?";
			ps = conn.prepareStatement(sql);
			ps.setString(1, u_id);
			rs = ps.executeQuery();
			rs.next();
			return rs.getString(1);

		} catch (Exception e) {
			e.printStackTrace();
			return null;
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (ps != null)
					ps.close();
				if (conn != null)
					conn.close();
			} catch (Exception e2) {
			}

		}

	}

	// 유저 ID에 맞춰서 정보 가져오기 (양진유 추가)
	public UsersDTO getUserById(String u_id) {
		try {
			conn = com.five.db.FiveDB.getConn();
			String sql = "select * from users where u_id = ?";
			ps = conn.prepareStatement(sql);
			ps.setString(1, u_id);
			rs = ps.executeQuery();

			UsersDTO dto = null;
			if (rs.next()) {
				int u_idx = rs.getInt("u_idx");
				String u_pwd = rs.getString("u_pwd");
				String u_name = rs.getString("u_name");
				String u_sex = rs.getString("u_sex");
				int u_year = rs.getInt("u_year");
				Date u_date = rs.getDate("u_date");
				String u_ad = rs.getString("u_ad");
				String u_img = rs.getString("u_img");

				UserGenreDAO gDao = new UserGenreDAO();
				dto = new UsersDTO(u_idx, u_id, u_pwd, u_name, u_sex, u_year, u_date, u_ad, u_img, null);
				List<String> userGenres = gDao.getGenresByUIdx(u_idx);
				dto.setGenre(userGenres);
			}
			return dto;
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (ps != null)
					ps.close();
				if (conn != null)
					conn.close();
			} catch (Exception e2) {
			}

		}
	}

	/** 유저 조회 카운트 */
	public int getTotalUserCount() {
		try {
			conn = com.five.db.FiveDB.getConn();
			String sql = "SELECT COUNT(*) FROM users";
			ps = conn.prepareStatement(sql);
			rs = ps.executeQuery();
			if (rs.next()) {
				return rs.getInt(1);
			}
			return 0;
		} catch (Exception e) {
			e.printStackTrace();
			return 0;
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (ps != null)
					ps.close();
				if (conn != null)
					conn.close();
			} catch (Exception e2) {
			}

		}
	}

	/** 유저 페이지 목록 조회 */
	public List<UsersDTO> getUserList(int start, int end) {
		List<UsersDTO> lists = new ArrayList<>();
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		UserGenreDAO gDao = new UserGenreDAO();
		try {
			conn = com.five.db.FiveDB.getConn();
			String sql = "SELECT * FROM " + "    (SELECT ROWNUM rnum, u.* FROM users u ORDER BY u_idx desc) "
					+ "WHERE rnum >= ? AND rnum <= ? order by u_date DESC";
			ps = conn.prepareStatement(sql);
			ps.setInt(1, start);
			ps.setInt(2, end);
			rs = ps.executeQuery();

			while (rs.next()) {
				UsersDTO dto = new UsersDTO();
				int u_idx = rs.getInt("u_idx");
				dto.setU_idx(rs.getInt("u_idx"));
				dto.setU_id(rs.getString("u_id"));
				dto.setU_name(rs.getString("u_name"));
				dto.setU_sex(rs.getString("u_sex"));
				dto.setU_year(rs.getInt("u_year"));
				dto.setU_date(rs.getDate("u_date"));
				dto.setU_img(rs.getString("u_img"));
				List<String> userGenres = gDao.getGenresByUIdx(u_idx);
				dto.setGenre(userGenres);
				lists.add(dto);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (ps != null)
					ps.close();
				if (conn != null)
					conn.close();
			} catch (Exception e2) {
			}
		}
		return lists;
	}

	/** 회원 삭제 */
	public int usersDelete(String u_id, String realPath) {
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		int result = 0;
		int u_idx = 0;
		String u_img = null;

		try {
			conn = com.five.db.FiveDB.getConn();
			conn.setAutoCommit(false);

			// 1. u_idx, u_img 조회
			String selectIdxSql = "SELECT u_idx, u_img FROM users WHERE u_id = ?";
			ps = conn.prepareStatement(selectIdxSql);
			ps.setString(1, u_id);
			rs = ps.executeQuery();
			if (rs.next()) {
				u_idx = rs.getInt("u_idx");
				u_img = rs.getString("u_img");
			} else {
				// 해당 ID의 사용자가 없는 경우
				return 0;
			}
			rs.close();
			ps.close();

			// =================================
			// 2. 자유게시판(bbs) 글/답글 삭제
			// =================================
			String deleteBbsThreadSql = "DELETE FROM bbs " + "WHERE b_ref IN ( " + "   SELECT b_ref " + "   FROM bbs "
					+ "   WHERE u_idx = ? " + "     AND b_lev = 0 " + // 부모글
					")";

			ps = conn.prepareStatement(deleteBbsThreadSql);
			ps.setInt(1, u_idx);
			ps.executeUpdate();
			ps.close();

			// 이 유저가 다른 사람 글에 단 댓글/답글 삭제
			String deleteBbsByUserSql = "DELETE FROM bbs WHERE u_idx = ?";
			ps = conn.prepareStatement(deleteBbsByUserSql);
			ps.setInt(1, u_idx);
			ps.executeUpdate();
			ps.close();

			// =================================
			// 3. Q&A(qna) 글/답글 삭제
			// =================================
			String deleteQnaThreadSql = "DELETE FROM qna " + "WHERE q_ref IN ( " + "   SELECT q_ref " + "   FROM qna "
					+ "   WHERE u_idx = ? " + "     AND q_lev = 0 " + ")";

			ps = conn.prepareStatement(deleteQnaThreadSql);
			ps.setInt(1, u_idx);
			ps.executeUpdate();
			ps.close();

			String deleteQnaByUserSql = "DELETE FROM qna WHERE u_idx = ?";
			ps = conn.prepareStatement(deleteQnaByUserSql);
			ps.setInt(1, u_idx);
			ps.executeUpdate();
			ps.close();

			// =================================
			// 4. USER_GENRE 삭제
			// =================================
			String deleteGenreSql = "DELETE FROM user_genre WHERE u_idx = ?";
			ps = conn.prepareStatement(deleteGenreSql);
			ps.setInt(1, u_idx);
			ps.executeUpdate();
			ps.close();

			// =================================
			// 5. USERS 삭제
			// =================================
			String deleteUserSql = "DELETE FROM users WHERE u_id = ?";
			ps = conn.prepareStatement(deleteUserSql);
			ps.setString(1, u_id);
			result = ps.executeUpdate();
			ps.close();

			// =================================
			// 6. 프로필 이미지 파일 삭제
			// =================================
			if (u_img != null && !u_img.isEmpty() && !u_img.equals("default.jpg")) {
				java.io.File file = new java.io.File(realPath, u_img);
				if (file.exists()) {
					file.delete();
				}
			}

			conn.commit();

		} catch (Exception e) {
			e.printStackTrace();
			if (conn != null) {
				try {
					conn.rollback();
				} catch (Exception ex) {
					ex.printStackTrace();
				}
			}
			return -1; // 예외 났으면 -1 리턴

		} finally {
			try {
				if (rs != null)
					rs.close();
			} catch (Exception e2) {
			}
			try {
				if (ps != null)
					ps.close();
			} catch (Exception e2) {
			}
			try {
				if (conn != null) {
					conn.setAutoCommit(true);
					conn.close();
				}
			} catch (Exception e2) {
				e2.printStackTrace();
			}
		}

		return result;
	}

	/** 마이페이지 사용자 정보 조회 */

	public UsersDTO getUserInfo(String u_id) {
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		UsersDTO dto = null;

		String sql = "select * from users where u_id = ?";

		try {
			conn = com.five.db.FiveDB.getConn();
			if (conn == null) {
				System.err.println("디버그: FiveDB.getConn()에서 null 반환됨. DB 연결 실패.");
			}
			ps = conn.prepareStatement(sql);
			ps.setString(1, u_id);
			rs = ps.executeQuery();

			if (rs.next()) {
				dto = new UsersDTO();
				dto.setU_idx(rs.getInt("u_idx"));
				dto.setU_id(rs.getString("u_id"));
				dto.setU_name(rs.getString("u_name"));
				dto.setU_sex(rs.getString("u_sex"));
				dto.setU_year(rs.getInt("u_year"));
				dto.setU_date(rs.getDate("u_date"));
				dto.setU_ad(rs.getString("u_ad"));
				dto.setU_img(rs.getString("u_img"));

			}

		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (ps != null)
					ps.close();
				if (conn != null)
					conn.close();
			} catch (Exception e2) {
			}
		}
		return dto;
	}

	/** 마이페이지 사용자 장르 조회 */

	public List<String> getUserGenres(String u_id) {
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;
		List<String> userGenres = new ArrayList<>(); // 장르 이름을 담을 리스트

		// SQL: U_ID를 통해 U_IDX를 찾고, USER_GENRE를 JOIN하여 GENRE 이름을 가져오는 쿼리
		String sql = "SELECT g.g_name FROM genre g " + "JOIN user_genre ug ON g.g_idx = ug.g_idx "
				+ "JOIN users u ON ug.u_idx = u.u_idx " + "WHERE u.u_id = ?";

		try {
			conn = com.five.db.FiveDB.getConn();
			ps = conn.prepareStatement(sql);
			ps.setString(1, u_id);

			rs = ps.executeQuery();

			while (rs.next()) {
				userGenres.add(rs.getString("g_name")); // 장르 이름 리스트에 추가
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (ps != null)
					ps.close();
				if (conn != null)
					conn.close();
			} catch (Exception e2) {
			}
		}
		return userGenres;
	}

	public int usersUpdate(UsersDTO dto, String[] genre, String new_pwd) {
		Connection conn = null;
		PreparedStatement ps = null;
		int result = 0;
		GenreDAO gDao = new GenreDAO();
		int u_idx = 0;

		// 1. 사용자 정보 업데이트 SQL (비밀번호를 포함하지 않음)
		String updateSql = "UPDATE users SET u_name=?, u_sex=?, u_year=?, u_img=? WHERE u_id=?";

		// 2. 비밀번호 업데이트 SQL (새 비밀번호가 있을 때 사용)
		String updatePwdSql = "UPDATE users SET u_pwd=? WHERE u_id=?";

		// 3. U_IDX를 조회하는 SQL
		String selectIdxSql = "SELECT u_idx FROM users WHERE u_id = ?";

		// 4. 기존 장르를 삭제하는 SQL
		String deleteGenreSql = "DELETE FROM user_genre WHERE u_idx = ?";

		// 5. 새 장르를 삽입하는 SQL
		String insertGenreSql = "INSERT INTO user_genre (ug_idx, u_idx, g_idx) "
				+ "VALUES (user_genre_idx.NEXTVAL, ?, ?)";

		try {
			conn = com.five.db.FiveDB.getConn();
			conn.setAutoCommit(false); // 트랜잭션 시작

			// ------------------ (A) U_IDX 조회 ------------------
			ps = conn.prepareStatement(selectIdxSql);
			ps.setString(1, dto.getU_id());
			rs = ps.executeQuery();
			if (rs.next()) {
				u_idx = rs.getInt("u_idx");
			} else {
				return 0; // 사용자 ID가 존재하지 않음
			}
			rs.close();
			ps.close();

			if (new_pwd != null && !new_pwd.isEmpty()) {
				ps = conn.prepareStatement(updatePwdSql);
				// new_pwd를 암호화하여 저장
				String temp = com.five.javasecur.JavaDataSecurModule.getSHA256(new_pwd);
				ps.setString(1, temp);
				ps.setString(2, dto.getU_id());
				ps.executeUpdate();
				ps.close();
			}

			ps = conn.prepareStatement(updateSql);
			ps.setString(1, dto.getU_name());
			ps.setString(2, dto.getU_sex());
			ps.setInt(3, dto.getU_year());
			ps.setString(4, dto.getU_img());
			ps.setString(5, dto.getU_id());
			result = ps.executeUpdate();
			ps.close();

			if (result > 0) {
				// ------------------ (D) 기존 장르 삭제 ------------------
				ps = conn.prepareStatement(deleteGenreSql);
				ps.setInt(1, u_idx);
				ps.executeUpdate();
				ps.close();

				if (genre != null && genre.length > 0) {
					ps = conn.prepareStatement(insertGenreSql);

					for (String genreName : genre) {
						int g_idx = gDao.getGidxByName(genreName); // GenreDAO 필요

						if (g_idx > 0) {
							ps.setInt(1, u_idx); // u_idx 사용
							ps.setInt(2, g_idx); // g_idx 사용
							ps.executeUpdate();
						}
					}
				}
			}

			conn.commit();
			return 1;
		} catch (Exception e) {
			e.printStackTrace();
			if (conn != null) {
				try {
					conn.rollback();
				} catch (SQLException rollbackEx) {
					rollbackEx.printStackTrace();
				}
			}
			return -1;
		} finally {
			try {
				if (conn != null)
					conn.setAutoCommit(true);
				if (ps != null)
					ps.close();
				if (conn != null)
					conn.close();
				if (rs != null)
					rs.close();
			} catch (Exception e2) {
				e2.printStackTrace();
			}
		}
	}

	public int updateUserPassword(String u_id, String new_pwd) {
		Connection conn = null;
		PreparedStatement ps = null;
		int result = 0;
		String updatePwdSql = "update users set u_pwd=? where u_id=?";

		try {
			conn = com.five.db.FiveDB.getConn();
			String temp = com.five.javasecur.JavaDataSecurModule.getSHA256(new_pwd);

			ps = conn.prepareStatement(updatePwdSql);
			ps.setString(1, temp);
			ps.setString(2, u_id);

			result = ps.executeUpdate();

			return result;

		} catch (Exception e) {
			e.printStackTrace();
			return -1;
		} finally {
			try {
				if (ps != null)
					ps.close();
				if (conn != null)
					conn.close();
			} catch (Exception e2) {
				e2.printStackTrace();
			}
		}

	}

	// 유저 이름에 맞춰서 정보 가져오기 (양진유 추가)
	public UsersDTO getUserByName(String u_name) {
		try {
			conn = com.five.db.FiveDB.getConn();
			String sql = "select * from users where u_name = ?";
			ps = conn.prepareStatement(sql);
			ps.setString(1, u_name);
			rs = ps.executeQuery();

			UsersDTO dto = null;
			if (rs.next()) {
				int u_idx = rs.getInt("u_idx");
				String u_pwd = rs.getString("u_pwd");
				String u_id = rs.getString("u_id");
				String u_sex = rs.getString("u_sex");
				int u_year = rs.getInt("u_year");
				Date u_date = rs.getDate("u_date");
				String u_ad = rs.getString("u_ad");
				String u_img = rs.getString("u_img");
				UserGenreDAO gDao = new UserGenreDAO();
				dto = new UsersDTO(u_idx, u_id, u_pwd, u_name, u_sex, u_year, u_date, u_ad, u_img, null);
				List<String> userGenres = gDao.getGenresByUIdx(u_idx);
				dto.setGenre(userGenres);
			}
			return dto;
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (ps != null)
					ps.close();
				if (conn != null)
					conn.close();
			} catch (Exception e2) {
			}

		}
	}

}