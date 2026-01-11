package com.five.notification;

import java.sql.*;
import java.util.*;

public class NotificationDAO {

	private Connection conn;
	private PreparedStatement ps;
	private ResultSet rs;

	public NotificationDAO() {
	}

	/** 알림 생성 */
	public int insertNotification(NotificationDTO dto) {
		int result = -1;
		try {
			conn = com.five.db.FiveDB.getConn();
			String sql = "insert into notification "
					+ "(n_idx, u_idx, from_u_idx, n_type, target_id, n_message, n_read, n_date) "
					+ "values (notification_idx.nextval, ?, ?, ?, ?, ?, 'N', sysdate)";
			ps = conn.prepareStatement(sql);
			ps.setInt(1, dto.getU_idx());
			ps.setInt(2, dto.getFrom_u_idx());
			ps.setString(3, dto.getN_type());
			ps.setInt(4, dto.getTarget_id());
			ps.setString(5, dto.getN_message());
			result = ps.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
			result = -1;
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
		return result;
	}

	/** 특정 유저의 안 읽은 알림 개수 */
	public int getUnreadCount(int u_idx) {
		int count = 0;
		try {
			conn = com.five.db.FiveDB.getConn();
			String sql = "select count(*) cnt " + "from notification " + "where u_idx = ? and n_read = 'N'";
			ps = conn.prepareStatement(sql);
			ps.setInt(1, u_idx);
			rs = ps.executeQuery();
			if (rs.next()) {
				count = rs.getInt("cnt");
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
				e2.printStackTrace();
			}
		}
		return count;
	}

	/** 특정 유저의 알림 목록 (최신순) */
	public List<NotificationDTO> getNotificationList(int u_idx) {
		List<NotificationDTO> list = new ArrayList<>();
		try {
			conn = com.five.db.FiveDB.getConn();
			String sql = "select * from notification " + "where u_idx = ? " + "order by n_date desc";
			ps = conn.prepareStatement(sql);
			ps.setInt(1, u_idx);
			rs = ps.executeQuery();

			while (rs.next()) {
				NotificationDTO dto = new NotificationDTO();
				dto.setN_idx(rs.getInt("n_idx"));
				dto.setU_idx(rs.getInt("u_idx"));
				dto.setFrom_u_idx(rs.getInt("from_u_idx"));
				dto.setN_type(rs.getString("n_type"));
				dto.setTarget_id(rs.getInt("target_id"));
				dto.setN_message(rs.getString("n_message"));
				dto.setN_read(rs.getString("n_read"));
				dto.setN_date(rs.getDate("n_date"));
				list.add(dto);
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
				e2.printStackTrace();
			}
		}
		return list;
	}

	/** 특정 유저의 알림 전체 읽음 처리 */
	public int markAllRead(int u_idx) {
		int result = 0;
		try {
			conn = com.five.db.FiveDB.getConn();
			String sql = "update notification " + "set n_read = 'Y' " + "where u_idx = ? and n_read = 'N'";
			ps = conn.prepareStatement(sql);
			ps.setInt(1, u_idx);
			result = ps.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
			result = -1;
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
		return result;
	}

	/** 개별 알림 읽음 처리 (선택사항) */
	public int markRead(int n_idx) {
		int result = 0;
		try {
			conn = com.five.db.FiveDB.getConn();
			String sql = "update notification set n_read = 'Y' where n_idx = ?";
			ps = conn.prepareStatement(sql);
			ps.setInt(1, n_idx);
			result = ps.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
			result = -1;
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
		return result;
	}

	public int deleteNotification(int n_idx, int u_idx) {
		int result = 0;
		try {
			conn = com.five.db.FiveDB.getConn();
			String sql = "delete from notification where n_idx = ? and u_idx = ?";
			ps = conn.prepareStatement(sql);
			ps.setInt(1, n_idx);
			ps.setInt(2, u_idx);
			result = ps.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
			result = -1;
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
		return result;
	}
}
