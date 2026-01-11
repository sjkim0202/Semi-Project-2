package com.five.review_like;
import java.sql.*;
public class Review_likeDAO {
	private Connection conn;
	private PreparedStatement ps;
	private ResultSet rs;
	public Review_likeDAO() {
		// TODO Auto-generated constructor stub
	}
	//좋아요 확인
	public boolean isR_like(int u_idx,int r_idx ) {
		try {
			conn=com.five.db.FiveDB.getConn();
			String sql="select * from review_like where u_idx=? and r_idx=?";
			ps=conn.prepareStatement(sql);
			ps.setInt(1, u_idx);
			ps.setInt(2, r_idx);
			rs=ps.executeQuery();
			return rs.next();
		}catch (Exception e) {
			return false;
		}finally {
			try {
				if(rs!=null)rs.close();
				if(ps!=null)ps.close();
				if(conn!=null)conn.close();
			}catch (Exception e) {
				// TODO: handle exception
			}
		}
	}
		//좋아요 누르기
		public void setR_like(int u_idx,int r_idx) {
			try {
				conn=com.five.db.FiveDB.getConn();
				String sql="insert into review_like values(?,?)";
				ps=conn.prepareStatement(sql);
				ps.setInt(1, u_idx);
				ps.setInt(2, r_idx);
				int count=ps.executeUpdate();
			}catch (Exception e) {
			}finally {
				try {
					if(ps!=null)ps.close();
					if(conn!=null)conn.close();
				}catch (Exception e) {
					// TODO: handle exception
				}
			}
		}
		
		//삭제 관련 메서드(reviewLike)
		public int reviewLikeDelete(int r_idx, int u_idx) {
			try {
				conn=com.five.db.FiveDB.getConn();
				String sql="delete from review_like where r_idx=? and u_idx=?";
				ps=conn.prepareStatement(sql);
				ps.setInt(1,r_idx);
				ps.setInt(2,u_idx);
				int count=ps.executeUpdate();
				return count;
			}catch (Exception e) {
				return -1;
			}finally {
				try {
					if(ps!=null)ps.close();
					if(conn!=null)conn.close();
				}catch (Exception e) {
					// TODO: handle exception
				}
			}
		}
		//삭제 관련 메서드
		public int reviewDelete(int r_idx) {
			try {
				conn=com.five.db.FiveDB.getConn();
				String sql="delete from review_like where r_idx=?";
				ps=conn.prepareStatement(sql);
				ps.setInt(1,r_idx);
				int count=ps.executeUpdate();
				return count;
			}catch (Exception e) {
				return -1;
			}finally {
				try {
					if(ps!=null)ps.close();
					if(conn!=null)conn.close();
				}catch (Exception e) {
					// TODO: handle exception
				}
			}
		}
}
