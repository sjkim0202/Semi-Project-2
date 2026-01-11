package com.five.bbs;

import java.sql.*;
import java.sql.Date;
import java.util.*;

public class BbsDAO {
	private Connection conn;
	private PreparedStatement ps;
	private ResultSet rs;

	public BbsDAO() {
	}

	public int getMaxRef() { // ref 마지막값 반환 메서드
		try {
			String sql = "select max(b_ref) from bbs";
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
					ps.close(); // 밑의 bbsWrite가 conn을 사용하기 때문에 닫지 않음
			} catch (Exception e2) {
				e2.printStackTrace();
			}
		}
	}

	public int bbsWrite(BbsDTO dto) { // 게시글 등록 관련 메서드
		try {
			conn = com.five.db.FiveDB.getConn();
			int ref = getMaxRef();
			String sql = "insert into bbs values(bbs_idx.nextval,?,?,?,sysdate,?,0,0,0)";
			ps = conn.prepareStatement(sql);
			ps.setInt(1, (dto.getU_idx()));
			ps.setString(2, dto.getB_title());
			ps.setString(3, dto.getB_comment());
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

	public ArrayList<BbsDTO> bbsList(int cp, int ls) {
		try {
			conn = com.five.db.FiveDB.getConn();
			int start = (cp - 1) * ls + 1;
			int end = cp * ls;

			String sql = "select * from (" + "  select rownum as rnum, a.* " + "  from ("
					+ "    select b.b_idx, b.u_idx, u.u_name, u_ad, " + "           b.b_title, b.b_comment, b.b_date, "
					+ "           b.b_ref, b.b_lev, b.b_step, b.b_readnum " + "    from bbs b "
					+ "    join users u on b.u_idx = u.u_idx " + "    order by "
					+ "           case when u.u_ad = 'admin' then 0 else 1 end, " + "           b.b_ref desc, "
					+ "           b.b_step asc" + "  ) a" + ") b " + "where rnum >= ? and rnum <= ?";

			ps = conn.prepareStatement(sql);
			ps.setInt(1, start);
			ps.setInt(2, end);
			rs = ps.executeQuery();

			ArrayList<BbsDTO> arr = new ArrayList<BbsDTO>();
			while (rs.next()) {
				int b_idx = rs.getInt("b_idx");
				int u_idx = rs.getInt("u_idx");
				String u_name = rs.getString("u_name"); // ★ 작성자 이름
				String u_ad = rs.getString("u_ad");
				String b_title = rs.getString("b_title");
				String b_comment = rs.getString("b_comment");
				Date b_date = rs.getDate("b_date");
				int b_ref = rs.getInt("b_ref");
				int b_lev = rs.getInt("b_lev");
				int b_step = rs.getInt("b_step");
				int b_readnum = rs.getInt("b_readnum");

				BbsDTO dto = new BbsDTO(b_idx, u_idx, u_name, u_ad, b_title, b_comment, b_date, b_ref, b_lev, b_step,
						b_readnum);
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

	public void updateReadnum(int b_idx) {
		try {
			conn = com.five.db.FiveDB.getConn();
			String sql = "update bbs set b_readnum = b_readnum + 1 where b_idx = ?";
			ps = conn.prepareStatement(sql);
			ps.setInt(1, b_idx);
			ps.executeUpdate();
			conn.commit();
		} catch (Exception e) {
			e.printStackTrace();
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

	public BbsDTO bbsContent(int b_idx) {
		updateReadnum(b_idx); // 조회수 증가
		try {
			conn = com.five.db.FiveDB.getConn();
			String sql = "select b.b_idx, b.u_idx, u.u_name, u.u_ad, " + "       b.b_title, b.b_comment, b.b_date, "
					+ "       b.b_ref, b.b_lev, b.b_step, b.b_readnum " + "from bbs b "
					+ "join users u on b.u_idx = u.u_idx " + "where b.b_idx = ?";
			ps = conn.prepareStatement(sql);
			ps.setInt(1, b_idx);
			rs = ps.executeQuery();

			BbsDTO dto = null;
			if (rs.next()) {
				int u_idx = rs.getInt("u_idx");
				String u_name = rs.getString("u_name");
				String u_ad = rs.getString("u_ad");
				String b_title = rs.getString("b_title");
				String b_comment = rs.getString("b_comment");
				Date b_date = rs.getDate("b_date");
				int b_ref = rs.getInt("b_ref");
				int b_lev = rs.getInt("b_lev");
				int b_step = rs.getInt("b_step");
				int b_readnum = rs.getInt("b_readnum");
				dto = new BbsDTO(b_idx, u_idx, u_name, u_ad, b_title, b_comment, b_date, b_ref, b_lev, b_step,
						b_readnum);
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

	public void updateStep(int b_ref, int b_step) {
		try {
			String sql = "update bbs set b_step = b_step + 1 where b_ref = ? and b_step >= ?";
			ps = conn.prepareStatement(sql);
			ps.setInt(1, b_ref);
			ps.setInt(2, b_step);
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

	public int bbsReWrite(BbsDTO dto) { // 답변 글쓰기 등록 관련 메서드
		try {
			conn = com.five.db.FiveDB.getConn();
			updateStep(dto.getB_ref(), dto.getB_step() + 1);
			String sql = "insert into bbs values(bbs_idx.nextval,?,?,?,sysdate,?,?,?,0)";
			ps = conn.prepareStatement(sql);
			ps.setInt(1, dto.getU_idx());
			ps.setString(2, dto.getB_title());
			ps.setString(3, dto.getB_comment());
			ps.setInt(4, dto.getB_ref());
			ps.setInt(5, dto.getB_lev() + 1);
			ps.setInt(6, dto.getB_step() + 1);
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
			String sql = "select count(*) from bbs";
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

	public int bbsDelete(int b_idx) {
		try {
			conn = com.five.db.FiveDB.getConn();

			// 1. 해당 글의 ref, lev 조회
			String selectSql = "select b_ref, b_lev from bbs where b_idx = ?";
			ps = conn.prepareStatement(selectSql);
			ps.setInt(1, b_idx);
			rs = ps.executeQuery();

			int b_ref = 0;
			int b_lev = 0;
			if (rs.next()) {
				b_ref = rs.getInt("b_ref");
				b_lev = rs.getInt("b_lev");
			} else {
				// 글이 존재하지 않으면 0 리턴
				return 0;
			}
			rs.close();
			ps.close();

			int count = 0;

			if (b_lev == 0) {
				// 2-1. 원글인 경우: 같은 ref를 가진 스레드 전체 삭제
				String deleteThreadSql = "delete from bbs where b_ref = ?";
				ps = conn.prepareStatement(deleteThreadSql);
				ps.setInt(1, b_ref);
				count = ps.executeUpdate();
			} else {
				// 2-2. 답글인 경우: 해당 글만 삭제 (또는 이후에 범위 삭제 로직으로 확장 가능)
				String deleteOneSql = "delete from bbs where b_idx = ?";
				ps = conn.prepareStatement(deleteOneSql);
				ps.setInt(1, b_idx);
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
