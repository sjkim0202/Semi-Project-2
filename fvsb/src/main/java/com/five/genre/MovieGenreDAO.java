package com.five.genre;

import java.sql.*;
import java.util.List;

public class MovieGenreDAO {
    private Connection conn;
    private PreparedStatement ps;
    private ResultSet rs;

    public MovieGenreDAO() {
    }
    public int insertMovieGenres(int m_idx, List<Integer> g_idxList) {
        int count= 0;
        try {
            conn = com.five.db.FiveDB.getConn();

            String sql = "INSERT INTO movie_genre (mg_idx, m_idx, g_idx) "
                       + "VALUES (movie_genre_idx.nextval, ?, ?)";
            ps = conn.prepareStatement(sql);

            for (int g_idx : g_idxList) {
                ps.setInt(1, m_idx);
                ps.setInt(2, g_idx);
                count += ps.executeUpdate(); 
            }
            
            return count; 
            
        } catch (Exception e) {
            e.printStackTrace();
            return -1;
        } finally {
            try {
                if(ps != null) ps.close();
                if(conn != null) conn.close();
            } catch (Exception e2) {
                e2.printStackTrace();
            }
        }
    }
}