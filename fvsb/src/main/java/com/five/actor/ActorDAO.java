package com.five.actor;

//import java.io.File;
import java.sql.*;
import java.util.*;

import com.five.genre.UserGenreDAO;
import com.five.movie.MovieDTO;
import com.five.users.UsersDTO;

public class ActorDAO {
	Connection conn;
	PreparedStatement ps;
	ResultSet rs;

	// o
	public int getMaxRef() {
		try {
			String sql = "select max(ref) from actor";
			ps = conn.prepareStatement(sql);
			rs = ps.executeQuery();
			int ref = 0;
			if (rs.next()) {
				ref = rs.getInt("a_ref");
			}
			return ref;
		} catch (Exception e) {
			e.printStackTrace();
			return -1;
		} finally {
			try {
				if (rs != null)
					rs.close();
				if (ps != null)
					ps.close();
			} catch (Exception e) {
			}
		}
	}

	// o
	public List<Integer> getActorIdx(String[] actorNames) {
		List<Integer> actorList = new ArrayList<>();

		try {
			conn = com.five.db.FiveDB.getConn();

			for (String a_name : actorNames) {
				int a_idx = -1;
				String sql = "select a_idx from actor WHERE a_name = ?";
				ps = conn.prepareStatement(sql);
				ps.setString(1, a_name);
				rs = ps.executeQuery();

				if (rs.next()) {
					a_idx = rs.getInt("a_idx");
				}
				rs.close();
				ps.close();
				actorList.add(a_idx);
			}
			return actorList;
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

	// o
	public int getTotalCnt() {
		try {
			conn = com.five.db.FiveDB.getConn();
			String sql = "select count(*) from actor";
			ps = conn.prepareStatement(sql);
			rs = ps.executeQuery();
			rs.next();
			int count = rs.getInt(1);
			return count == 0 ? 1 : count;
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
			} catch (Exception e) {

			}
		}
	}

	// o
	public ArrayList<ActorDTO> actorList(int cp, int ls) {
		try {
			conn = com.five.db.FiveDB.getConn();
			int start = (cp - 1) * ls + 1;
			int end = cp * ls;
//         String sql = "SELECT a_idx, a_name, a_age, a_country, a_img FROM actor ORDER BY a_idx ASC";
			String sql = "SELECT * FROM ( " + "   SELECT rownum rnum, a.* FROM ( "
					+ "       SELECT a_idx, a_name, a_age, a_country, a_img " + "       FROM actor "
					+ "       ORDER BY a_idx ASC " + "   ) a " + ") WHERE rnum >= ? AND rnum <= ?";
			ps = conn.prepareStatement(sql);
			ps.setInt(1, start);
			ps.setInt(2, end);
			rs = ps.executeQuery();
			ArrayList<ActorDTO> arr = new ArrayList<ActorDTO>();
			while (rs.next()) {
				int a_idx = rs.getInt("a_idx");
				String a_name = rs.getString("a_name");
				String a_age = rs.getString("a_age");
				String a_country = rs.getString("a_country");
				String a_img = rs.getString("a_img");
				ActorDTO dto = new ActorDTO(a_idx, a_name, a_age, a_country, a_img);
				arr.add(dto);
			}
			return arr;
		} catch (Exception e) {
			System.out.println("actorListErr");
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
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}

	// o
	public ArrayList<ActorDTO> actorList() {
		try {
			conn = com.five.db.FiveDB.getConn();
			String sql = "select * from actor order by a_name asc";
			ps = conn.prepareStatement(sql);
			rs = ps.executeQuery();
			ArrayList<ActorDTO> arr = new ArrayList<ActorDTO>();
			while (rs.next()) {
				int idx = rs.getInt("a_idx");
				String a_name = rs.getString("a_name");
				String a_age = rs.getString("a_age");
				String a_country = rs.getString("a_country");
				String a_img = rs.getString("a_img");
				ActorDTO dto = new ActorDTO(idx, a_name, a_age, a_country, a_img);
				arr.add(dto);
			}
			return arr;
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("actorListNoArguErr");
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
				e.printStackTrace();
			}
		}
	}

	// o
	public int actorInsert(String a_name, String a_age, String a_country, String a_img) {
		int cnt = 0;

		try {
			conn = com.five.db.FiveDB.getConn();
			String sql = "INSERT INTO actor VALUES(actor_idx.nextval, ?, ?, ?, ?)";
			ps = conn.prepareStatement(sql);

			ps.setString(1, a_name);
			ps.setString(2, a_age);
			ps.setString(3, a_country);
			ps.setString(4, a_img);

			cnt = ps.executeUpdate();
			return cnt;
		} catch (Exception e) {
			System.out.println("actorInsertErr");
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
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}

	public ArrayList<MovieDTO> getMoviesByActor(int a_idx) {
		try {
			conn = com.five.db.FiveDB.getConn();

			String sql = "select m.m_idx, m.m_name, m.m_img, m.m_date " + "from movie_actor ma "
					+ "join movie m on ma.m_idx = m.m_idx " + "where ma.a_idx = ?";

			ps = conn.prepareStatement(sql);
			ps.setInt(1, a_idx);
			rs = ps.executeQuery();

			ArrayList<MovieDTO> arr = new ArrayList<MovieDTO>();

			while (rs.next()) {
				MovieDTO dto = new MovieDTO();
				dto.setM_idx(rs.getInt("m_idx"));
				dto.setM_name(rs.getString("m_name"));
				dto.setM_img(rs.getString("m_img"));
				dto.setM_date(rs.getString("m_date"));
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
			} catch (Exception ex) {
			}
		}
	}

	public int getKrCountry(String country) {
		try {
			int count = 0;
			conn = com.five.db.FiveDB.getConn();
			String sql = "select count(*) from actor where a_country=?";
			ps = conn.prepareStatement(sql);
			ps.setString(1, country);
			rs=ps.executeQuery();
			if (rs.next()) {
				count = rs.getInt(1);
			}
			return count;
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("getKrCountrySQLErr");
			return -1;
		} finally {
			try {
				if(rs!=null)rs.close();
				if(ps!=null)ps.close();
				if(conn!=null)conn.close();
			}catch (Exception e) {
				e.printStackTrace();
				System.out.println("getKrCountryNotClose");
			}
		}
	}

	public int getNotKrCountry(String country) {
		try {
			int count = 0;
			conn = com.five.db.FiveDB.getConn();
			String sql = "select count(*) from actor where a_country !=?";
			ps=conn.prepareStatement(sql);
			ps.setString(1, country);
			rs=ps.executeQuery();
			if(rs.next()) {
				count = rs.getInt(1);
			}
			return count;
		}catch (Exception e) {
			e.printStackTrace();
			System.out.println("getNotKrCountrySQLErr");
			return -1;
		}finally {
			try {
				if(rs!=null)rs.close();
				if(ps!=null)ps.close();
				if(conn!=null)conn.close();
			}catch (Exception e) {
				e.printStackTrace();
				System.out.println("getNotKrCountryNotClose");
			}
		}
	}
	
	public ArrayList<ActorDTO> actorListByCountry(String country,int cp,int listSize){
		try {
			conn=com.five.db.FiveDB.getConn();
			int start = (cp-1) * listSize + 1;
			int end  = cp * listSize;
			
			String sql = "select * from ( "+
			"	select rownum as rnum, a.* from ( " +
			"		select * from actor " +
			"		where a_country =? " +
			"		order by a_idx desc " +
			"		) a "+
			") " +
			"where rnum >=? and rnum <=?";
			ps=conn.prepareStatement(sql);
			ps.setString(1, country);
			ps.setInt(2, start);
			ps.setInt(3, end);
			
			rs=ps.executeQuery();
			ArrayList<ActorDTO> arr = new ArrayList<ActorDTO>();
			while(rs.next()) {
				ActorDTO dto = new ActorDTO();
				dto.setA_idx(rs.getInt("a_idx"));
				dto.setA_name(rs.getString("a_name"));
				dto.setA_age(rs.getString("a_age"));
				dto.setA_country(rs.getString("a_country"));
				dto.setA_img(rs.getString("a_img"));
				arr.add(dto);
			}
			return arr;
		}catch (Exception e) {
			e.printStackTrace();
			System.out.println("actorListByCountryErr");
			return null;
		}finally {
			try {
				if(rs!=null)rs.close();
				if(ps!=null)ps.close();
				if(conn!=null)conn.close();
			}catch (Exception e) {
				e.printStackTrace();
			}
		}
	}
	
	public ArrayList<ActorDTO> actorListNotCountry(String country,int cp,int listSize){
		try {
			conn=com.five.db.FiveDB.getConn();
			int start = (cp-1) * listSize + 1;
			int end  = cp * listSize;
			
			String sql = "select * from ( "+
			"	select rownum as rnum, a.* from ( " +
			"		select * from actor " +
			"		where a_country !=? " +
			"		order by a_idx desc " +
			"		) a "+
			") " +
			"where rnum >=? and rnum <=?";
			ps=conn.prepareStatement(sql);
			ps.setString(1, country);
			ps.setInt(2, start);
			ps.setInt(3, end);
			
			rs=ps.executeQuery();
			ArrayList<ActorDTO> arr = new ArrayList<ActorDTO>();
			while(rs.next()) {
				ActorDTO dto = new ActorDTO();
				dto.setA_idx(rs.getInt("a_idx"));
				dto.setA_name(rs.getString("a_name"));
				dto.setA_age(rs.getString("a_age"));
				dto.setA_country(rs.getString("a_country"));
				dto.setA_img(rs.getString("a_img"));
				arr.add(dto);
			}
			return arr;
		}catch (Exception e) {
			e.printStackTrace();
			System.out.println("actorListByCountryErr");
			return null;
		}finally {
			try {
				if(rs!=null)rs.close();
				if(ps!=null)ps.close();
				if(conn!=null)conn.close();
			}catch (Exception e) {
				e.printStackTrace();
			}
		}
	}
	
	//배우 몇명인지 카운트
	   public int getTotalActorCount() {
	        try {
	            conn = com.five.db.FiveDB.getConn();
	            String sql = "SELECT COUNT(*) FROM actor";
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
	                if (rs != null) rs.close();
	                if (ps != null) ps.close();
	                if (conn != null) conn.close();
	            } catch (Exception e2) {}
	        }
	    }
	
	
	/** 배우 페이지 목록 조회 */
	public List<ActorDTO> getActorList(int start, int end) {
	    List<ActorDTO> lists = new ArrayList<>();

	    try {
	        conn = com.five.db.FiveDB.getConn();

	        String sql =
	                "SELECT * FROM ( " +
	                "   SELECT ROWNUM rnum, a.* " +
	                "   FROM actor a " +
	                "   ORDER BY a_idx DESC " +
	                ") " +
	                "WHERE rnum >= ? AND rnum <= ?";

	        ps = conn.prepareStatement(sql);
	        ps.setInt(1, start);
	        ps.setInt(2, end);

	        rs = ps.executeQuery();

	        while (rs.next()) {
	            ActorDTO dto = new ActorDTO();
	            dto.setA_idx(rs.getInt("a_idx"));
	            dto.setA_name(rs.getString("a_name"));
	            dto.setA_age(rs.getString("a_age"));
	            dto.setA_country(rs.getString("a_country"));
	            dto.setA_img(rs.getString("a_img"));

	            lists.add(dto);
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	    } finally {
	        try {
	            if (rs != null) rs.close();
	            if (ps != null) ps.close();
	            if (conn != null) conn.close();
	        } catch (Exception e2) {
	        }
	    }

	    return lists;
	}
	
	public int deleteActor(int a_idx) {
		try {
			conn=com.five.db.FiveDB.getConn();
			String sql = "delete from actor where a_idx=?";
			ps=conn.prepareStatement(sql);
			ps.setInt(1, a_idx);
			int count = ps.executeUpdate();
			return count;
		}catch (Exception e) {
			e.printStackTrace();
			System.out.println("deleteActorErr");
			return -1;
		}finally {
			try {
				if(ps!=null)ps.close();
				if(conn!=null)conn.close();
			}catch (Exception e) {
				e.printStackTrace();
			}
		}
	}

	
	/*
	 * public int insertMovieActors(int m_idx, String[] actorArr) {
	 * 
	 * try { conn = com.five.db.FiveDB.getConn(); String sql =
	 * "INSERT INTO movie_actor (ma_idx, m_idx, a_idx) VALUES (movie_actor_idx.nextval, ?, ?)"
	 * ; ps = conn.prepareStatement(sql);
	 * 
	 * for (String a_idx : actorArr) { ps.setInt(1, m_idx); ps.setInt(2,
	 * Integer.parseInt(a_idx)); }
	 * 
	 * int count = ps.executeUpdate(); return count;
	 * 
	 * } catch (Exception e) { e.printStackTrace(); return 0; } finally { try { if
	 * (ps != null) ps.close(); if (conn != null) conn.close(); } catch (Exception
	 * ex) { } } }
	 */

}
