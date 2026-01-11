package com.five.genre;

import java.sql.*;
import java.util.*;
import javax.naming.*;
import javax.sql.*;

public class UserGenreDAO {

	private Connection conn;
	private PreparedStatement ps;
	private ResultSet rs;
	
	public UserGenreDAO() {
		
	}
	
	public List<String> getGenresByUIdx(int u_idx) {
		List<String> genreNames = new ArrayList<>();
		// SQL: 연결 테이블(USER_GENRE)과 마스터 테이블(GENRE)을 조인
		String sql = "SELECT g.g_name FROM genre g JOIN user_genre ug "
				   + "ON g.g_idx = ug.g_idx WHERE ug.u_idx = ?";
		
		try {
			conn = com.five.db.FiveDB.getConn();
			ps = conn.prepareStatement(sql);
			ps.setInt(1, u_idx);
			rs = ps.executeQuery();
			
			while(rs.next()) {
				// 장르 이름(String)만 리스트에 담아 반환
				genreNames.add(rs.getString("g_name"));
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
		return genreNames;
	}
	
	public int insertUserGenre(int u_idx, int g_idx) {
        
        Connection conn = null;
        PreparedStatement ps = null;
        int count = 0;
        String sql = "INSERT INTO user_genre (ug_idx, u_idx, g_idx) "
                    + "VALUES (user_genre_idx.NEXTVAL, ?, ?)"; 

        try {
            conn = com.five.db.FiveDB.getConn();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, u_idx);
            ps.setInt(2, g_idx);
            count = ps.executeUpdate();
            return count;

        } catch (Exception e) {
            e.printStackTrace();
            return -1;
        } finally {
            try {
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (Exception e2) {}
        }
    }
}

