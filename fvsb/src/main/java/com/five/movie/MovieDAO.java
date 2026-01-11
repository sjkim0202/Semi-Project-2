package com.five.movie;

import java.sql.*;
import java.util.*;

public class MovieDAO {
	private Connection conn;
	private PreparedStatement ps;
	private ResultSet rs;

	public MovieDAO() {
	}

	// 1. 영화 등록 및 인덱스 가져오기
	public int registerMovieAndGetIdx(MovieDTO dto) {
		int m_idx = -1;
		try {
			conn = com.five.db.FiveDB.getConn();

			String sqlInsert = "INSERT INTO movie (m_idx, m_name, m_date, m_limit, m_pd, m_country, m_img, m_story) "
					+ "VALUES (movie_idx.nextval, ?, ?, ?, ?, ?, ?,?)";

			ps = conn.prepareStatement(sqlInsert);
			ps.setString(1, dto.getM_name());
			ps.setString(2, dto.getM_date());
			ps.setString(3, dto.getM_limit());
			ps.setString(4, dto.getM_pd());
			ps.setString(5, dto.getM_country());
			ps.setString(6, dto.getM_img());
			ps.setString(7, dto.getM_story());

			ps.executeUpdate();
			ps.close();

			String sqlGetIdx = "SELECT movie_idx.currval AS m_idx FROM dual";
			ps = conn.prepareStatement(sqlGetIdx);
			rs = ps.executeQuery();

			if (rs.next()) {
				m_idx = rs.getInt("m_idx");
			}
			return m_idx;
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

	// 2. 영화 목록 전체 불러오기
	public ArrayList<MovieDTO> getMovieList() {
		try {
			conn = com.five.db.FiveDB.getConn();
			String sql = "select * from movie order by m_name asc";
			ps = conn.prepareStatement(sql);
			rs = ps.executeQuery();

			ArrayList<MovieDTO> arr = new ArrayList<MovieDTO>();

			while (rs.next()) {
				int m_idx = rs.getInt("m_idx");
				String m_name = rs.getString("m_name");
				String m_date = rs.getString("m_date");
				String m_limit = rs.getString("m_limit");
				String m_pd = rs.getString("m_pd");
				String m_country = rs.getString("m_country");
				String m_story = rs.getString("m_story");
				String m_img = rs.getString("m_img");
				MovieDTO dto = new MovieDTO(m_idx, m_name, m_date, m_limit, m_pd, m_country, m_img, m_story);
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
    
    // 3. 사용자 맞춤 영화 목록 (페이징 적용)
    public ArrayList<MovieDTO> getMoviegenreList(String u_id, int cp, int listSize) {
        try {
            conn = com.five.db.FiveDB.getConn();
            int start = (cp - 1) * listSize + 1;
            int end = cp * listSize;

            String sql = "SELECT * FROM ( "
                       + "    SELECT ROWNUM AS rnum, M.* FROM ( "
                       + "        SELECT M.* FROM movie M "
                       + "        JOIN movie_genre MG ON M.m_idx = MG.m_idx "
                       + "        JOIN user_genre UG ON MG.g_idx = UG.g_idx "
                       + "        JOIN users U ON UG.u_idx = U.u_idx "
                       + "        WHERE U.u_id = ? "
                       + "        GROUP BY M.m_idx, M.m_name, M.m_date, M.m_limit, M.m_pd, M.m_country, M.m_img, M.m_story "
                       + "        ORDER BY M.m_date DESC, M.m_idx DESC "
                       + "    ) M "
                       + ") "
                       + "WHERE rnum >= ? AND rnum <= ?";

            ps = conn.prepareStatement(sql);
            ps.setString(1, u_id);
            ps.setInt(2, start);
            ps.setInt(3, end);
            rs = ps.executeQuery();

            ArrayList<MovieDTO> genrearr = new ArrayList<>();

            while (rs.next()) {
                int m_idx = rs.getInt("m_idx");
                String m_name = rs.getString("m_name");
                String m_date = rs.getString("m_date");
                String m_limit = rs.getString("m_limit");
                String m_pd = rs.getString("m_pd");
                String m_country = rs.getString("m_country");
                String m_story = rs.getString("m_story");
                String m_img = rs.getString("m_img");

                MovieDTO dto = new MovieDTO(m_idx, m_name, m_date, m_limit, m_pd, m_country, m_img, m_story);
                genrearr.add(dto);
            }
            return genrearr;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (Exception e2) {
                e2.printStackTrace();
            }
        }
    }

	// 3-1. 사용자 맞춤 영화 전체 개수 조회
	public int getMoviegenreCount(String u_id) {
	    try {
	        int count = 0;
	        conn = com.five.db.FiveDB.getConn();
	        String sql = "SELECT COUNT(DISTINCT M.m_idx) FROM movie M "
	                   + "JOIN movie_genre MG ON M.m_idx = MG.m_idx "
	                   + "JOIN user_genre UG ON MG.g_idx = UG.g_idx "
	                   + "JOIN users U ON UG.u_idx = U.u_idx "
	                   + "WHERE U.u_id = ?";
	        
	        ps = conn.prepareStatement(sql);
	        ps.setString(1, u_id);
	        rs = ps.executeQuery();
	        
	        if (rs.next()) {
	            count = rs.getInt(1);
	        }
	        return count;
	    } catch (Exception e) {
	        e.printStackTrace();
	        return -1;
	    } finally {
	        try {
	            if (rs != null) rs.close();
	            if (ps != null) ps.close();
	            if (conn != null) conn.close();
	        } catch (Exception e2) {
	        }
	    }
	}
    
	// 4. 영화 상세 조회
	public MovieDTO movieView(int m_idx) {
		MovieDTO mdto = null;
		try {
			conn = com.five.db.FiveDB.getConn();
			String sql = "select * from movie where m_idx=?";
			ps = conn.prepareStatement(sql);
			ps.setInt(1, m_idx);
			rs = ps.executeQuery();

			if (rs.next()) {
				mdto = new MovieDTO();
				mdto.setM_img(rs.getString("m_img"));
				mdto.setM_story(rs.getString("m_story"));
				mdto.setM_name(rs.getString("m_name"));
				mdto.setM_limit(rs.getString("m_limit"));
				mdto.setM_country(rs.getString("m_country"));
				mdto.setM_date(rs.getString("m_date"));
				mdto.setM_pd(rs.getString("m_pd"));
			}
			return mdto;
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

	// 5.영화 장르 목록 조회
	public ArrayList<String> getMovieGenres(int m_idx) {
		ArrayList<String> genreList = new ArrayList<>();
		try {
			conn = com.five.db.FiveDB.getConn();
			String sql = "SELECT G.g_name " + "FROM movie_genre MG JOIN genre G ON MG.g_idx = G.g_idx "
					+ "WHERE MG.m_idx = ?";
			ps = conn.prepareStatement(sql);
			ps.setInt(1, m_idx);
			rs = ps.executeQuery();

			while (rs.next()) {
				genreList.add(rs.getString("g_name"));
			}
			return genreList;
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

	// 6. 배우 목록 조회
	public ArrayList<String> getMovieActors(int m_idx) {
		ArrayList<String> actorList = new ArrayList<>();
		try {
			conn = com.five.db.FiveDB.getConn();
			String sql = "SELECT A.a_name " + "FROM movie_actor MA JOIN actor A ON MA.a_idx = A.a_idx "
					+ "WHERE MA.m_idx = ?";
			ps = conn.prepareStatement(sql);
			ps.setInt(1, m_idx);
			rs = ps.executeQuery();

			while (rs.next()) {
				actorList.add(rs.getString("a_name"));
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

	// 7. 해외 영화 목록 (페이징 적용)
	public ArrayList<MovieDTO> getForeignMovieListPage(int cp, int listSize) {
	    try {
	        conn = com.five.db.FiveDB.getConn();
	        int start = (cp - 1) * listSize + 1;
	        int end = cp * listSize;

	        String sql = "SELECT * FROM ( " +
	                     "    SELECT ROWNUM as rnum, m.* FROM ( " +
	                     "        SELECT * FROM movie WHERE m_country != 'korea' " +
	                     "        ORDER BY m_date DESC, m_idx DESC " +
	                     "    ) m " +
	                     ") " +
	                     "WHERE rnum >=? AND rnum <=?";
	        
	        ps = conn.prepareStatement(sql);
	        ps.setInt(1, start);
	        ps.setInt(2, end);

	        rs = ps.executeQuery();
	        ArrayList<MovieDTO> countryArr = new ArrayList<>();

	        while (rs.next()) {
	            int m_idx = rs.getInt("m_idx");
	            String m_name = rs.getString("m_name");
	            String m_date = rs.getString("m_date");
	            String m_limit = rs.getString("m_limit");
	            String m_pd = rs.getString("m_pd");
	            String m_country = rs.getString("m_country");
	            String m_story = rs.getString("m_story");
	            String m_img = rs.getString("m_img");

	            MovieDTO dto = new MovieDTO(m_idx, m_name, m_date, m_limit, m_pd, m_country, m_img, m_story);
	            countryArr.add(dto);
	        }
	        return countryArr;
	    } catch (Exception e) {
	        e.printStackTrace();
	        return null;
	    } finally {
	        try {
	            if (rs != null) rs.close();
	            if (ps != null) ps.close();
	            if (conn != null) conn.close();
	        } catch (Exception e2) {
	            e2.printStackTrace();
	        }
	    }
	}
	
	// 7-1. 해외 영화 전체 개수 조회
	public int getForeignMovieCount() {	
	    try {
	        int count = 0;
	        conn = com.five.db.FiveDB.getConn();
	        String sql = "SELECT COUNT(*) FROM movie WHERE m_country != 'korea'";
	        ps = conn.prepareStatement(sql);
	        rs = ps.executeQuery();
	        if (rs.next()) {
	            count = rs.getInt(1);
	        }
	        return count;
	    } catch (Exception e) {
	        e.printStackTrace();
	        return -1;
	    } finally {
	        try {
	            if (rs != null) rs.close();
	            if (ps != null) ps.close();
	            if (conn != null) conn.close();
	        } catch (Exception e2) {
	        }
	    }
	}

	// 8. 국내 영화 목록 (페이징 적용)
	public ArrayList<MovieDTO> getKoreaMovieListPage(int cp, int listSize) {
	    try {
	        conn = com.five.db.FiveDB.getConn();
	        int start = (cp - 1) * listSize + 1;
	        int end = cp * listSize;

	        String sql = "SELECT * FROM ( " +
	                     "    SELECT ROWNUM as rnum, m.* FROM ( " +
	                     "        SELECT * FROM movie WHERE m_country = 'korea' " +
	                     "        ORDER BY m_date DESC, m_idx DESC " +
	                     "    ) m " +
	                     ") " +
	                     "WHERE rnum >=? AND rnum <=?";
	        
	        ps = conn.prepareStatement(sql);
	        ps.setInt(1, start);
	        ps.setInt(2, end);

	        rs = ps.executeQuery();
	        ArrayList<MovieDTO> koreamovieArr = new ArrayList<>();

	        while (rs.next()) {
	            int m_idx = rs.getInt("m_idx");
	            String m_name = rs.getString("m_name");
	            String m_date = rs.getString("m_date");
	            String m_limit = rs.getString("m_limit");
	            String m_pd = rs.getString("m_pd");
	            String m_country = rs.getString("m_country");
	            String m_story = rs.getString("m_story");
	            String m_img = rs.getString("m_img");

	            MovieDTO dto = new MovieDTO(m_idx, m_name, m_date, m_limit, m_pd, m_country, m_img, m_story);
	            koreamovieArr.add(dto);
	        }
	        return koreamovieArr;
	    } catch (Exception e) {
	        e.printStackTrace();
	        return null;
	    } finally {
	        try {
	            if (rs != null) rs.close();
	            if (ps != null) ps.close();
	            if (conn != null) conn.close();
	        } catch (Exception e2) {
	            e2.printStackTrace();
	        }
	    }
	}
	
	// 8-1. 국내 영화 전체 개수 조회
	public int getKoreaMovieCount() {
	    try {
	        int count = 0;
	        conn = com.five.db.FiveDB.getConn();
	        String sql = "SELECT COUNT(*) FROM movie WHERE m_country = 'korea'";
	        ps = conn.prepareStatement(sql);
	        rs = ps.executeQuery();
	        if (rs.next()) {
	            count = rs.getInt(1);
	        }
	        return count;
	    } catch (Exception e) {
	        e.printStackTrace();
	        return -1;
	    } finally {
	        try {
	            if (rs != null) rs.close();
	            if (ps != null) ps.close();
	            if (conn != null) conn.close();
	        } catch (Exception e2) {
	        }
	    }
	}

	public ArrayList<MovieDTO> getMoviesByActor(int a_idx) {
		ArrayList<MovieDTO> list = new ArrayList<>();

		try {
			conn = com.five.db.FiveDB.getConn();

			String sql = "select m.m_idx, m.m_name, m.m_img, m.m_date " + "from movie_actor ma "
					+ "join movie m on ma.m_idx = m.m_idx " + "where ma.a_idx = ? " + "order by m.m_idx desc";

			ps = conn.prepareStatement(sql);
			ps.setInt(1, a_idx);
			rs = ps.executeQuery();

			while (rs.next()) {
				MovieDTO dto = new MovieDTO();
				dto.setM_idx(rs.getInt("m_idx"));
				dto.setM_name(rs.getString("m_name"));
				dto.setM_img(rs.getString("m_img"));
				dto.setM_date(rs.getString("m_date"));
				list.add(dto);
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
			}
		}

		return list;
	}

	public Map<String, List<MovieDTO>> getMoviesByMonth(String yearMonth) {
		Map<String, List<MovieDTO>> map = new HashMap<>();

		try {
			conn = com.five.db.FiveDB.getConn();
			String startDate = yearMonth + "-01";
			String endDate = yearMonth + "-31";

			String sql = "select * from movie where m_date between ? and ? order by m_date, m_idx";

			ps = conn.prepareStatement(sql);
			ps.setString(1, startDate);
			ps.setString(2, endDate);
			rs = ps.executeQuery();

			while (rs.next()) {
				int m_idx = rs.getInt("m_idx");
				String m_name = rs.getString("m_name");
				String m_date = rs.getString("m_date");
				String m_limit = rs.getString("m_limit");
				String m_pd = rs.getString("m_pd");
				String m_country = rs.getString("m_country");
				String m_story = rs.getString("m_story");
				String m_img = rs.getString("m_img");

				MovieDTO dto = new MovieDTO(m_idx, m_name, m_date, m_limit, m_pd, m_country, m_img, m_story);

				List<MovieDTO> list = map.get(m_date);
				if (list == null) {
					list = new ArrayList<>();
					map.put(m_date, list);
				}
				list.add(dto);
			}

			return map;
		} catch (Exception e) {
			e.printStackTrace();
			return map;
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

	// 영화 삭제
	public int movieDelete(int m_idx) {
		try {
			conn = com.five.db.FiveDB.getConn();
			String sql2 = "delete movie where m_idx=? ";
			ps = conn.prepareStatement(sql2);
			ps.setInt(1, m_idx);
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

			}
		}
	}

	// 영화 장르 삭제
	public int moviegenreDelete(int m_idx) {
		try {
			conn = com.five.db.FiveDB.getConn();
			String sql = "delete movie_genre where m_idx=? ";
			ps = conn.prepareStatement(sql);
			ps.setInt(1, m_idx);
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

			}
		}
	}

	// 영화 페이징 (기존 전체 개봉작 목록에서 사용)
	public ArrayList<MovieDTO> movieListpage(int cp,int listSize){
		try {
	        conn = com.five.db.FiveDB.getConn();
	        int start = (cp - 1) * listSize + 1;
	        int end = cp * listSize;

	        String sql = "SELECT * FROM ( " +
	                     "    SELECT ROWNUM as rnum, m.* FROM ( " +
	                     "        SELECT * FROM movie " +
	                     "        ORDER BY m_date DESC, m_idx DESC " +
	                     "    ) m " +
	                     ") " +
	                     "WHERE rnum >=? AND rnum <=?";
	        
	        ps = conn.prepareStatement(sql);
	        ps.setInt(1, start);
	        ps.setInt(2, end);

	        rs = ps.executeQuery();
	        ArrayList<MovieDTO> arr = new ArrayList<MovieDTO>();
			while(rs.next()) {
				MovieDTO dto = new MovieDTO();
				dto.setM_idx(rs.getInt("m_idx"));
				dto.setM_name(rs.getString("m_name"));
				dto.setM_date(rs.getString("m_date"));
				dto.setM_limit(rs.getString("m_limit"));
				dto.setM_pd(rs.getString("m_pd"));
				dto.setM_country(rs.getString("m_country"));
				dto.setM_img(rs.getString("m_img"));
				dto.setM_story(rs.getString("m_story"));		
				arr.add(dto);
			}
			return arr;
		}catch (Exception e) {
			e.printStackTrace();
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

	public int getMoviecount() {
		try {
			int count =0;
			conn=com.five.db.FiveDB.getConn();
			String sql =  "select count(*) from movie";
			ps = conn.prepareStatement(sql);
			rs=ps.executeQuery();
			if(rs.next()) {
				count = rs.getInt(1);
			}return count;
		} catch (Exception e) {
			e.printStackTrace();
			return -1;
		}finally {
			try {
				if(rs!=null)rs.close();
				if(ps!=null)ps.close();
				if(conn!=null)conn.close();
			} catch (Exception e2) {
			}
		}
	}
}