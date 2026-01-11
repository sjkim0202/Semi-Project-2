package com.five.movie_like;
import java.sql.*;
import java.util.ArrayList;

import com.five.movie.MovieDTO;

public class Movie_likeDAO {
	private Connection conn;
	private PreparedStatement ps;
	private ResultSet rs;
	public Movie_likeDAO() {
		// TODO Auto-generated constructor stub
	}
	public boolean isM_like(int u_idx) {
		try {
			conn=com.five.db.FiveDB.getConn();
			String sql="select * from movie_like where u_idx=?";
			ps=conn.prepareStatement(sql);
			ps.setInt(1, u_idx);
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
		public boolean isM_like(int u_idx,int m_idx ) {
			try {
				conn=com.five.db.FiveDB.getConn();
				String sql="select * from movie_like where u_idx=? and m_idx=?";
				ps=conn.prepareStatement(sql);
				ps.setInt(1, u_idx);
				ps.setInt(2, m_idx);
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
			public void setM_like(int u_idx,int m_idx) {
				try {
					conn=com.five.db.FiveDB.getConn();
					String sql="insert into movie_like values(?,?)";
					ps=conn.prepareStatement(sql);
					ps.setInt(1, u_idx);
					ps.setInt(2, m_idx);
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
			
			public int reviewLikeDelete(int u_idx, int m_idx) {
				try {
					conn=com.five.db.FiveDB.getConn();
					String sql="delete from movie_like where u_idx=? and m_idx=?";
					ps=conn.prepareStatement(sql);
					ps.setInt(1,u_idx);
					ps.setInt(2,m_idx);
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
			public int movieDelete(int m_idx) {
				try {
					conn=com.five.db.FiveDB.getConn();
					String sql="delete from movie_like where m_idx=?";
					ps=conn.prepareStatement(sql);
					ps.setInt(1,m_idx);
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
			public ArrayList<MovieDTO> mlSelect(int u_idx){
				try {
					conn=com.five.db.FiveDB.getConn();
					String sql="select * from movie,movie_like where movie.m_idx=movie_like.m_idx and u_idx=?";
					ps=conn.prepareStatement(sql);
					ps.setInt(1, u_idx);
					rs=ps.executeQuery();
					ArrayList<MovieDTO> arr=new ArrayList<MovieDTO>();
					while(rs.next()) {
						int m_idx=rs.getInt("m_idx");
						String m_name=rs.getString("m_name");
						java.sql.Date m_date=rs.getDate("m_date");
						String m_limit = rs.getString("m_limit");
						String m_pd=rs.getString("m_pd");
						String m_img=rs.getString("m_img");
						String m_story=rs.getString("m_story");
						MovieDTO dto= new MovieDTO(m_idx, m_name, m_name, m_limit, m_pd, m_pd, m_img, m_story);
						arr.add(dto);
					}
					return arr;
				}catch (Exception e) {
					return null;
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
}
