package com.five.review;
import java.sql.*;
import java.util.*;
import com.five.movie.*;
public class ReviewDAO {
	private Connection conn;
	private PreparedStatement ps;
	private ResultSet rs;
	public ReviewDAO() {
	}
	
	//목록 관련 메서드
	public ArrayList<ReviewDTO> reviewList(int cp, int ls, int m_idx){
		try {
			conn=com.five.db.FiveDB.getConn();
			int start=(cp-1)*ls+1;
			int end=cp*ls;
			String sql = 
				    "SELECT * FROM (SELECT ROWNUM as rnum, a.* FROM (SELECT * FROM review WHERE m_idx=? ORDER BY r_idx DESC) a) b WHERE rnum BETWEEN ? AND ?";
			ps=conn.prepareStatement(sql);
			ps.setInt(1, m_idx);
			ps.setInt(2, start);
			ps.setInt(3,end);
			rs=ps.executeQuery();
			ArrayList<ReviewDTO> arr=new ArrayList<ReviewDTO>();
			while(rs.next()) {
				int r_idx=rs.getInt("r_idx");
				int u_idx=rs.getInt("u_idx");
				String r_title=rs.getString("r_title");
				int r_score=rs.getInt("r_score");
				String r_comment=rs.getString("r_comment");
				java.sql.Date r_date=rs.getDate("r_date");
				int r_like=rs.getInt("r_like");
				ReviewDTO dto=new ReviewDTO(r_idx, u_idx, m_idx, r_title, r_score, r_comment, r_date, r_like);
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
				e.printStackTrace();
			}
		}
	}
	
	//게시글 등록관련 메서드
		public int reviewWrite(String sid,String r_title, int r_score, String r_comment, int m_idx) {
			try {
				conn=com.five.db.FiveDB.getConn();
				int u_idx=getU_idx(sid);
				String sql="insert into review values(review_idx.nextval,?,?,?,?,?,sysdate,?)";
				ps=conn.prepareStatement(sql);
				ps.setInt(1, u_idx);
				ps.setInt(2, m_idx);
				ps.setString(3,r_title);
				ps.setInt(4,r_score);
				ps.setString(5,r_comment);
				ps.setInt(6,0);
				int count=ps.executeUpdate();
				return count;
			}catch (Exception e) {
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
	//총게시글수
	public int getTotalCnt(int m_idx) {
		try {
			conn=com.five.db.FiveDB.getConn();
			String sql="select count(*) from review where m_idx=?";
			ps=conn.prepareStatement(sql);
			ps.setInt(1, m_idx);
			rs=ps.executeQuery();
			rs.next();
			int count=rs.getInt(1);
			return count;
		}catch (Exception e) {
			return 0;
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
	
	//본문 관련 메서드
	public ReviewDTO reviewComment(int r_idx) {
		try {
			conn=com.five.db.FiveDB.getConn();
			String sql="select * from review where r_idx=?";
			ps=conn.prepareStatement(sql);
			ps.setInt(1, r_idx);
			rs=ps.executeQuery();
			ReviewDTO dto=null;
			if(rs.next()) {
				int u_idx=rs.getInt("u_idx");
				int m_idx=rs.getInt("m_idx");
				String r_title=rs.getString("r_title");
				int r_score=rs.getInt("r_score");
				String r_comment=rs.getString("r_comment");
				java.sql.Date r_date=rs.getDate("r_date");
				int r_like=rs.getInt("r_like");
				dto=new ReviewDTO(r_idx, u_idx, m_idx, r_title, r_score, r_comment, r_date, r_like);
			}
			return dto;
		}catch (Exception e) {
			e.printStackTrace();
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
	//삭제 관련 메서드
	public int reviewDelete(int r_idx) {
		try {
			conn=com.five.db.FiveDB.getConn();
			String sql="delete from review where r_idx=?";
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
	
	//나이 평균 구하기
	public int avgAge(int m_idx) {
		try {
			conn=com.five.db.FiveDB.getConn();
			String sql="select u_year from users,review where users.u_idx=review.u_idx and review.m_idx=?";
			ps=conn.prepareStatement(sql);
			ps.setInt(1, m_idx);
			rs=ps.executeQuery();
			ArrayList<Integer> arr=new ArrayList<Integer>();
			while(rs.next()) {
				int result=Integer.parseInt(rs.getString(1));
				arr.add(result);
			}
			Calendar now=Calendar.getInstance();
			int y=now.get(Calendar.YEAR);
			int avg=0;
			int sum=0;
			int count=0;
			ArrayList<Integer> dif = new ArrayList<Integer>();
			for(int result:arr) {
				int diff=y-result;
				sum+=diff;
				count++;
			}
			avg=sum/count;
			return avg;
		}catch (Exception e) {
			return -1;
		}finally {
			try {
				if(rs!=null)rs.close();
				if(ps!=null)ps.close();
				if(conn!=null)conn.close();
			}catch (Exception e) {
			}
		}
	}
	//성별 평균 구하기(여자)
		public int getWomen(int m_idx) {
			try {
				conn=com.five.db.FiveDB.getConn();
				String sql="select count(distinct u_sex) from users,review where users.u_idx=review.u_idx and m_idx=? and u_sex='F'";
				ps=conn.prepareStatement(sql);
				ps.setInt(1, m_idx);
				rs=ps.executeQuery();
				int result=0;
				if(rs.next()) {
					result=rs.getInt(1);
				}
				return result;
			}catch (Exception e) {
				return -1;
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
	
	//성별 평균 구하기(전체 인원수)
	public int getCount(int m_idx) {
		try {
			conn=com.five.db.FiveDB.getConn();
			String sql="select count(distinct u_id) from users inner join review on users.u_idx=review.u_idx where m_idx=?";
			ps=conn.prepareStatement(sql);
			ps.setInt(1, m_idx);
			rs=ps.executeQuery();
			int result=0;
			if(rs.next()) {
				result=rs.getInt(1);
			}
			return result;
		}catch (Exception e) {
			return -1;
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
	//좋아요 삭제
	public int reviewLikeDelete(int r_idx) {
		try {
			conn=com.five.db.FiveDB.getConn();
			String sql="update review set r_like=r_like-1 where r_idx=?";
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

	//좋아요 누르기
	public void selectRlike(int r_idx ) {
		try {
			conn=com.five.db.FiveDB.getConn();
			String sql="update review set r_like=r_like+1 where r_idx=?";
			ps=conn.prepareStatement(sql);
			ps.setInt(1, r_idx);
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
	//최근리뷰 조회
	public ReviewDTO selectReview(int u_idx) {
		try {
			conn=com.five.db.FiveDB.getConn();
			String sql="select * from review where u_idx=? order by r_date desc";
			ps=conn.prepareStatement(sql);
			ps.setInt(1, u_idx);
			rs=ps.executeQuery();
			ReviewDTO dto=null;
			if(rs.next()) {
				int r_idx=rs.getInt("r_idx");
				int m_idx=rs.getInt("m_idx");
				String r_title=rs.getString("r_title");
				int r_score=rs.getInt("r_score");
				String r_comment=rs.getString("r_comment");
				java.sql.Date r_date=rs.getDate("r_date");
				int r_like=rs.getInt("r_like");
				dto=new ReviewDTO(r_idx, u_idx, m_idx, r_title, r_score, r_comment, r_date, r_like);
			}
			return dto;
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
	//r_like
	public int getR_like(String sid ) {
		try {
			conn=com.five.db.FiveDB.getConn();
			String sql="SELECT DISTINCT T1.u_year FROM users T1 INNER JOIN review T2 ON T1.u_idx = T2.u_idx WHERE T2.m_idx =?";
			ps=conn.prepareStatement(sql);
			ps.setString(1, sid);
			rs=ps.executeQuery();
			int result=0;
			if(rs.next()) {
				result=rs.getInt(1);
			}
			return result;
		}catch (Exception e) {
			return -1;
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
	//u_name불러오기
	public String getWriter(int u_idx) {
		try {
			conn=com.five.db.FiveDB.getConn();
			String sql="select u_name from users where u_idx=?";
			ps=conn.prepareStatement(sql);
			ps.setInt(1, u_idx);
			rs=ps.executeQuery();
			String u_name="";
			if(rs.next()) {
				u_name=rs.getString("u_name");
			}
			return u_name;
		}catch (Exception e) {
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
	//u_idx불러오기
	public int getU_idx(String sid) {
		try {
			String sql="select u_idx from users where u_id=?";
			ps=conn.prepareStatement(sql);
			ps.setString(1, sid);
			rs=ps.executeQuery();
			int u_idx=0;
			if(rs.next()) {
				u_idx=rs.getInt("u_idx");
			}
			return u_idx;
		}catch (Exception e) {
			return -1;
		}finally {
			try {
				if(rs!=null)rs.close();
				if(ps!=null)ps.close();
			}catch (Exception e) {
				e.printStackTrace();
			}
		}
	}
	//u_id불러오기
		public String getU_id(int u_idx) {
			try {
				conn=com.five.db.FiveDB.getConn();
				String sql="select u_id from users where u_idx=?";
				ps=conn.prepareStatement(sql);
				ps.setInt(1,u_idx);
				rs=ps.executeQuery();
				String result="";
				if(rs.next()) {
					result=rs.getString(1);
				}
				return result;
			}catch (Exception e) {
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
	//r_idx얻기
	public int getR_idx(int u_idx) {
		try {
			conn=com.five.db.FiveDB.getConn();
			String sql="select r_idx from review where u_idx=?";
			ps=conn.prepareStatement(sql);
			ps.setInt(1, u_idx);
			rs=ps.executeQuery();
			int r_idx=0;
			if(rs.next()) {
				r_idx=rs.getInt("r_idx");
			}
			return r_idx;
		}catch (Exception e) {
			return -1;
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
	//m_name얻기(movie)
	public String getM_name(int m_idx) {
		try {
			conn=com.five.db.FiveDB.getConn();
			String sql="select m_name from movie where m_idx=?";
			ps=conn.prepareStatement(sql);
			ps.setInt(1, m_idx);
			rs=ps.executeQuery();
			String result="";
			if(rs.next()) {
				result=rs.getString(1);
			}
			return result;
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
	public double getAvgScore(int m_idx) {
	    try {
	        conn = com.five.db.FiveDB.getConn();
	        String sql = "SELECT AVG(r_score) FROM review WHERE m_idx=?";
	        ps = conn.prepareStatement(sql);
	        ps.setInt(1, m_idx);
	        rs = ps.executeQuery();
	        
	        double avgScore = 0.0;
	        if (rs.next()) {
	            avgScore = rs.getDouble(1);
	        }
	        return avgScore;
	    } catch (Exception e) {
	        e.printStackTrace();
	        return 0.0;
	    } finally {
	        try {
	            if (rs != null) rs.close();
	            if (ps != null) ps.close();
	            if (conn != null) conn.close();
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	    }
	}
	//리뷰 썼는지?
	public boolean selectReview(int u_idx, int m_idx) {
		try {
			conn=com.five.db.FiveDB.getConn();
			String sql="select * from review where u_idx=? and m_idx=?";
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
	public ArrayList<ReviewDTO> likeAward(){
		try {
			conn=com.five.db.FiveDB.getConn();
			String sql="select * from review order by r_like desc";
			ps=conn.prepareStatement(sql);
			rs=ps.executeQuery();
			ArrayList<ReviewDTO> arr=new ArrayList<ReviewDTO>();
			while(rs.next()) {
				int r_idx=rs.getInt("r_idx");
				int u_idx=rs.getInt("u_idx");
				int m_idx=rs.getInt("m_idx");
				String r_title=rs.getString("r_title");
				int r_score=rs.getInt("r_score");
				String r_comment=rs.getString("r_comment");
				java.sql.Date r_date=rs.getDate("r_date");
				int r_like=rs.getInt("r_like");
				ReviewDTO dto=new ReviewDTO(r_idx, u_idx, m_idx, r_title, r_score, r_comment, r_date, r_like);
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
	public MovieDTO movieAward(int m_idx){
		try {
			conn=com.five.db.FiveDB.getConn();
			String sql="select * from movie where m_idx=?";
			ps=conn.prepareStatement(sql);
			ps.setInt(1, m_idx);
			rs=ps.executeQuery();
			MovieDTO dto=null;
			while(rs.next()) {
				String m_name=rs.getString("m_name");
				java.sql.Date m_date=rs.getDate("m_date");
				String m_limit = rs.getString("m_limit");
				String m_pd=rs.getString("m_pd");
				String m_img=rs.getString("m_img");
				String m_story=rs.getString("m_story");
				dto=new MovieDTO(m_idx, m_name, m_name, m_limit, m_pd, m_pd, m_img, m_story);
			}
			return dto;
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
	
	public ArrayList<MovieDTO> reviewAward(){
		try {
			conn=com.five.db.FiveDB.getConn();
			String sql="SELECT * FROM movie ORDER BY (SELECT count(*) FROM review WHERE review.m_idx = movie.m_idx) DESC";
			ps=conn.prepareStatement(sql);
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
	//리뷰 많이 쓴 사람 u_idx
	public int bestU_idx() {
		try {
			conn=com.five.db.FiveDB.getConn();
			String sql="SELECT DISTINCT u_idx FROM review WHERE u_idx IN (SELECT u_idx FROM review GROUP BY u_idx HAVING COUNT(*) = (SELECT MAX(review_count) FROM (SELECT COUNT(*) AS review_count FROM review GROUP BY u_idx)))";
			ps=conn.prepareStatement(sql);
			rs=ps.executeQuery();
			int u_idx=0;
			if(rs.next()) {
				u_idx=rs.getInt(1);
			}
			return u_idx;
		}catch (Exception e) {
			return -1;
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
	public int bestCount() {
		try {
			conn=com.five.db.FiveDB.getConn();
			String sql="SELECT distinct count(*) as rcount FROM review GROUP BY u_idx HAVING count(*) = (SELECT MAX(cnt) FROM (SELECT count(*) as cnt FROM review GROUP BY u_idx) temp)";
			ps=conn.prepareStatement(sql);
			rs=ps.executeQuery();
			int count=0;
			if(rs.next()) {
				count=rs.getInt(1);
			}
			return count;
		}catch (Exception e) {
			return -1;
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
		public boolean isReview() {
			try {
				conn=com.five.db.FiveDB.getConn();
				String sql="select * from review";
				ps=conn.prepareStatement(sql);
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
}