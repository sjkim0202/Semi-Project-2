package com.five.actor;

import java.sql.*;
import java.util.*;


public class MovieActorDAO {
	private Connection conn;
	private PreparedStatement ps;
	private ResultSet rs;

	public MovieActorDAO() {
	}

	public int insertMovieActors(int m_idx, List<Integer> a_idxList) {
		int count = 0;

		try {
			conn = com.five.db.FiveDB.getConn();
			String sql = "INSERT INTO movie_actor (ma_idx, m_idx, a_idx) " + "VALUES (movie_actor_idx.nextval, ?, ?)";
			ps = conn.prepareStatement(sql);

			for (int a_idx : a_idxList) {
				ps.setInt(1, m_idx);
				ps.setInt(2, a_idx);
				count += ps.executeUpdate();
			}

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

	// 영화 디테일에서 출연배우 출력
	public ArrayList<ActorDTO> getActorsByMovie(int m_idx) {
		ArrayList<ActorDTO> actorlist = new ArrayList<>();
		try {
			conn = com.five.db.FiveDB.getConn();

			String sql = "select a.a_idx, a.a_name, a.a_img " + "from actor a "
					+ "join movie_actor ma on a.a_idx = ma.a_idx " + "where ma.m_idx =? order by ma.a_idx desc";

			ps = conn.prepareStatement(sql);
			ps.setInt(1, m_idx);
			rs = ps.executeQuery();
			while (rs.next()) {
				ActorDTO adto = new ActorDTO();
				adto.setA_idx(rs.getInt("a_idx"));
				adto.setA_name(rs.getString("a_name"));
				adto.setA_img(rs.getString("a_img"));
				actorlist.add(adto);
			}
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
				// TODO: handle exception
			}
		}
		return actorlist;
	}
}