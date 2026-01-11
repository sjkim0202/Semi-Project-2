package com.five.genre;
import java.sql.*;
import java.util.*;
import javax.naming.*;
import javax.sql.*;
public class GenreDAO {

	private Connection conn;
	private PreparedStatement ps;
	private ResultSet rs;
	
	public GenreDAO() {
		
	}
	
	/** 1. 전체 장르 목록 조회*/
	public List<Integer> getGenreIdx(String[] genreNames) {
        List<Integer> genreList = new ArrayList<>();
        
        try {
            conn = com.five.db.FiveDB.getConn();

            for (String g_name : genreNames) {
                int g_idx = -1;
                String sql = "SELECT g_idx FROM genre WHERE g_name = ?";
                ps = conn.prepareStatement(sql);
                ps.setString(1, g_name);
                rs = ps.executeQuery();

                if (rs.next()) {
                    g_idx = rs.getInt("g_idx");
                }
                rs.close();
                ps.close();
                genreList.add(g_idx);
            }
            return genreList;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            try {
                if(rs != null) rs.close();
                if(ps != null) ps.close();
                if(conn != null) conn.close();
            } catch (Exception e2) {
                e2.printStackTrace();
            }
        }
    }
	
	public List<GenreDTO> getAllGenres() {
		List<GenreDTO> lists = new ArrayList<>();
		String sql = "SELECT g_idx, g_name FROM genre ORDER BY g_idx ASC";
		
		try {
			conn = com.five.db.FiveDB.getConn();
			ps = conn.prepareStatement(sql);
			rs = ps.executeQuery();
			
			while(rs.next()) {
				GenreDTO dto = new GenreDTO();
				dto.setG_idx(rs.getInt("g_idx"));
				dto.setG_name(rs.getString("g_name"));
				lists.add(dto);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (rs != null) rs.close();
				if (ps != null) ps.close();
				if (conn != null) conn.close();
			} catch (Exception e2) {}
		}
		return lists;
	}
	
	public int getGidxByName(String g_name) {
		int g_idx=0;
		Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
		String sql = "SELECT g_idx FROM genre WHERE g_name = ?";
		
		try {
			conn = com.five.db.FiveDB.getConn();
			ps = conn.prepareStatement(sql);
			ps.setString(1, g_name);
			rs = ps.executeQuery();
			
			if(rs.next()) {
				g_idx = rs.getInt("g_idx");
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (rs != null) rs.close();
				if (ps != null) ps.close();
				if (conn != null) conn.close();
			} catch (Exception e2) {}
		}
		return g_idx;
	}
	
}
