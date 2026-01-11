package com.five.qna;

import java.sql.*;
import java.sql.Date;
import java.util.*;

public class QnaDAO {
	private Connection conn;
	private PreparedStatement ps;
	private ResultSet rs;

	public QnaDAO() {
	}

	public int getMaxRef() { // ref 마지막값 반환 메서드
		try {
			String sql = "select max(q_ref) from qna";
			ps = conn.prepareStatement(sql);
			rs = ps.executeQuery();
			int ref = 0;
			if (rs.next()) {
				ref = rs.getInt(1);
			}
			return ref;
		} catch (Exception e) {
			e.printStackTrace();
			return 0;
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (ps != null)
					ps.close();
			} catch (Exception e2) {
				e2.printStackTrace();
			}
		}
	}

	public int qnaWrite(QnaDTO dto) { // 게시글 등록 관련 메서드
		try {
			conn = com.five.db.FiveDB.getConn();
			int ref = getMaxRef();
			String sql = "insert into qna values(qna_idx.nextval,?,?,?,sysdate,?,0,0)";
			ps = conn.prepareStatement(sql);
			ps.setInt(1, (dto.getU_idx()));
			ps.setString(2, dto.getQ_title());
			ps.setString(3, dto.getQ_comment());
			ps.setInt(4, ref + 1);
			int count = ps.executeUpdate();
			return count;
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

	public ArrayList<QnaDTO> qnaList(int cp, int ls) {
		try {
			conn = com.five.db.FiveDB.getConn();
			int start = (cp - 1) * ls + 1;
			int end = cp * ls;

			String sql = "select * from (" + "  select rownum as rnum, a.* " + "  from ("
					+ "    select q.q_idx, q.u_idx, u.u_name, " + "           q.q_title, q.q_comment, q.q_date, "
					+ "           q.q_ref, q.q_lev, q.q_step " + "    from qna q "
					+ "    join users u on q.u_idx = u.u_idx " + "    order by q.q_ref desc, q.q_step asc" + "  ) a"
					+ ") q " + "where rnum >= ? and rnum <= ?";

			ps = conn.prepareStatement(sql);
			ps.setInt(1, start);
			ps.setInt(2, end);
			rs = ps.executeQuery();

			ArrayList<QnaDTO> arr = new ArrayList<QnaDTO>();
			while (rs.next()) {
				int q_idx = rs.getInt("q_idx");
				int u_idx = rs.getInt("u_idx");
				String u_name = rs.getString("u_name"); // ★ 작성자 이름
				String q_title = rs.getString("q_title");
				String q_comment = rs.getString("q_comment");
				Date q_date = rs.getDate("q_date");
				int q_ref = rs.getInt("q_ref");
				int q_lev = rs.getInt("q_lev");
				int q_step = rs.getInt("q_step");

				QnaDTO dto = new QnaDTO(q_idx, u_idx, u_name, q_title, q_comment, q_date, q_ref, q_lev, q_step);
				arr.add(dto);
			}
			return arr;
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
				e2.printStackTrace();
			}
		}
	}

	public QnaDTO qnaContent(int q_idx) {
		try {
			conn = com.five.db.FiveDB.getConn();
			String sql = "select q.q_idx, q.u_idx, u.u_name, " + "       q.q_title, q.q_comment, q.q_date, "
					+ "       q.q_ref, q.q_lev, q.q_step " + "from qna q " + "join users u on q.u_idx = u.u_idx "
					+ "where q.q_idx = ?";
			ps = conn.prepareStatement(sql);
			ps.setInt(1, q_idx);
			rs = ps.executeQuery();

			QnaDTO dto = null;
			if (rs.next()) {
				int u_idx = rs.getInt("u_idx");
				String u_name = rs.getString("u_name"); // ★
				String q_title = rs.getString("q_title");
				String q_comment = rs.getString("q_comment");
				Date q_date = rs.getDate("q_date");
				int q_ref = rs.getInt("q_ref");
				int q_lev = rs.getInt("q_lev");
				int q_step = rs.getInt("q_step");

				dto = new QnaDTO(q_idx, u_idx, u_name, q_title, q_comment, q_date, q_ref, q_lev, q_step);
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
				e2.printStackTrace();
			}
		}
	}

	public void updateStep(int q_ref, int q_step) {
		try {
			String sql = "update qna set q_step = q_step + 1 where q_ref = ? and q_step >= ?";
			ps = conn.prepareStatement(sql);
			ps.setInt(1, q_ref);
			ps.setInt(2, q_step);
			ps.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (ps != null)
					ps.close();
			} catch (Exception e2) {
				e2.printStackTrace();
			}
		}
	}

	public int qnaReWrite(QnaDTO dto) { // 답변 글쓰기 등록 관련 메서드
		try {
			conn = com.five.db.FiveDB.getConn();
			updateStep(dto.getQ_ref(), dto.getQ_step() + 1);
			String sql = "insert into qna values(qna_idx.nextval,?,?,?,sysdate,?,?,?)";
			ps = conn.prepareStatement(sql);
			ps.setInt(1, dto.getU_idx());
			ps.setString(2, dto.getQ_title());
			ps.setString(3, dto.getQ_comment());
			ps.setInt(4, dto.getQ_ref());
			ps.setInt(5, dto.getQ_lev() + 1);
			ps.setInt(6, dto.getQ_step() + 1);
			int count = ps.executeUpdate();
			return count;
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

	public int getTotalCnt() {
		try {
			conn = com.five.db.FiveDB.getConn();
			String sql = "select count(*) from qna";
			ps = conn.prepareStatement(sql);
			rs = ps.executeQuery();
			rs.next();
			int count = rs.getInt(1);
			return count == 0 ? 1 : count;
		} catch (Exception e) {
			e.printStackTrace();
			return 1;
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (ps != null)
					ps.close();
				if (conn != null)
					conn.close();
			} catch (Exception e2) {
				e2.printStackTrace();
			}
		}
	}

	public int getParentWriterByRef(int q_ref) {
		Connection conn = null;
		PreparedStatement ps = null;
		ResultSet rs = null;

		try {
			conn = com.five.db.FiveDB.getConn();
			String sql = "select u_idx from qna where q_ref = ? and q_lev = 0";
			ps = conn.prepareStatement(sql);
			ps.setInt(1, q_ref);
			rs = ps.executeQuery();
			if (rs.next()) {
				return rs.getInt("u_idx");
			}
			return -1; // 부모글이 없으면 -1
		} catch (Exception e) {
			e.printStackTrace();
			return -1;
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (ps != null)
					ps.close();
				if (conn != null)
					conn.close();
			} catch (Exception e2) {
				e2.printStackTrace();
			}
		}
	}

	public int qnaDelete(int q_idx) {
		try {
			conn = com.five.db.FiveDB.getConn();

			// 1. 해당 글의 q_ref, q_lev 조회
			String selectSql = "select q_ref, q_lev from qna where q_idx = ?";
			ps = conn.prepareStatement(selectSql);
			ps.setInt(1, q_idx);
			rs = ps.executeQuery();

			int q_ref = 0;
			int q_lev = 0;
			if (rs.next()) {
				q_ref = rs.getInt("q_ref");
				q_lev = rs.getInt("q_lev");
			} else {
				// 글이 없으면 삭제할게 없으니까 0
				return 0;
			}
			rs.close();
			ps.close();

			int count = 0;

			if (q_lev == 0) {
				// 2-1. 원글인 경우: 같은 q_ref를 가진 스레드 전체 삭제
				String deleteThreadSql = "delete from qna where q_ref = ?";
				ps = conn.prepareStatement(deleteThreadSql);
				ps.setInt(1, q_ref);
				count = ps.executeUpdate();
			} else {
				// 2-2. 답글인 경우: 해당 글만 삭제
				String deleteOneSql = "delete from qna where q_idx = ?";
				ps = conn.prepareStatement(deleteOneSql);
				ps.setInt(1, q_idx);
				count = ps.executeUpdate();
			}

			return count;

		} catch (Exception e) {
			e.printStackTrace();
			return -1;
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (ps != null)
					ps.close();
				if (conn != null)
					conn.close();
			} catch (Exception e2) {
				e2.printStackTrace();
			}
		}
	}

}
