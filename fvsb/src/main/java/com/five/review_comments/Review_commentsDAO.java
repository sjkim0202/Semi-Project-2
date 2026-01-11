package com.five.review_comments;

import java.sql.*;
import java.util.*;

import com.five.notification.NotificationDAO;
import com.five.notification.NotificationDTO;

public class Review_commentsDAO {
	Connection conn;
	PreparedStatement ps;
	ResultSet rs;

	public Review_commentsDAO() {
		// TODO Auto-generated constructor stub
	}

	// 답글(u_idx > 답글 유저, r_idx > 게시글 번호)
	public int reviewWrite(int r_idx, int u_idx, String rc_comment) {
		int count = -1;
		try {
			conn = com.five.db.FiveDB.getConn();
			conn.setAutoCommit(false); // 트랜잭션 시작

			// 1) 댓글 INSERT
			String sql = "insert into review_comments " + "values(review_comments_idx.nextval, ?, ?, ?, sysdate)";
			ps = conn.prepareStatement(sql);
			ps.setInt(1, r_idx);
			ps.setInt(2, u_idx);
			ps.setString(3, rc_comment);
			count = ps.executeUpdate();
			ps.close();

			// 2) 원 리뷰 작성자 u_idx 조회 (양진유 추가)
			int writerUidx = 0;
			sql = "select u_idx from review where r_idx = ?";
			ps = conn.prepareStatement(sql);
			ps.setInt(1, r_idx);
			rs = ps.executeQuery();
			if (rs.next()) {
				writerUidx = rs.getInt("u_idx");
			}
			rs.close();
			ps.close();

			// 3) 알림 생성 (자기 자신에게는 알림 X) (양진유 추가)
			if (writerUidx != 0 && writerUidx != u_idx) {
				NotificationDAO ndao = new NotificationDAO();
				NotificationDTO ndto = new NotificationDTO();
				ndto.setU_idx(writerUidx); // 알림 받는 유저
				ndto.setFrom_u_idx(u_idx); // 댓글 단 유저
				ndto.setN_type("REVIEW_COMMENT");
				ndto.setTarget_id(r_idx);
				ndto.setN_message("회원님의 리뷰에 새 댓글이 달렸습니다.");

				int nResult = ndao.insertNotification(ndto);
				if (nResult <= 0) {
					throw new Exception("알림 생성 실패");
				}
			}

			conn.commit();
		} catch (Exception e) {
			e.printStackTrace();
			try {
				if (conn != null)
					conn.rollback();
			} catch (Exception e2) {
			}
			count = -1;
		} finally {
			try {
				if (rs != null)
					rs.close();
			} catch (Exception e) {
			}
			try {
				if (ps != null)
					ps.close();
			} catch (Exception e) {
			}
			try {
				if (conn != null)
					conn.close();
			} catch (Exception e) {
			}
		}
		return count;
	}

	// rc table 조회
	public ArrayList<Review_commentsDTO> commentRC(int r_idx) {
		try {
			conn = com.five.db.FiveDB.getConn();
			String sql = "select * from review_comments where r_idx=? order by rc_idx desc";
			ps = conn.prepareStatement(sql);
			ps.setInt(1, r_idx);
			rs = ps.executeQuery();
			ArrayList<Review_commentsDTO> arr = new ArrayList<Review_commentsDTO>();
			while (rs.next()) {
				int rc_idx = rs.getInt("rc_idx");
				int u_idx = rs.getInt("u_idx");
				String rc_comment = rs.getString("rc_comment");
				java.sql.Date rc_date = rs.getDate("rc_date");
				Review_commentsDTO dto = new Review_commentsDTO(rc_idx, r_idx, u_idx, rc_comment, rc_date);
				arr.add(dto);
			}
			return arr;
		} catch (Exception e) {
			return null;
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (ps != null)
					ps.close();
				if (conn != null)
					conn.close();
			} catch (Exception e) {
				// TODO: handle exception
			}
		}
	}

	// 삭제 관련 메서드
	public int rcDelete(int rc_idx) {
		try {
			conn = com.five.db.FiveDB.getConn();
			String sql = "delete from review_comments where rc_idx=?";
			ps = conn.prepareStatement(sql);
			ps.setInt(1, rc_idx);
			int count = ps.executeUpdate();
			return count;
		} catch (Exception e) {
			return -1;
		} finally {
			try {
				if (ps != null)
					ps.close();
				if (conn != null)
					conn.close();
			} catch (Exception e) {
				// TODO: handle exception
			}
		}
	}
}
