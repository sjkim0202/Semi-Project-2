package com.five.vote;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import com.five.users.UsersDTO;

public class VoteDAO {

	Connection conn;
	PreparedStatement ps;
	ResultSet rs;
	
    // 사용자 투표
    public int insertVote(VoteDTO dto) {
        try {
            conn = com.five.db.FiveDB.getConn();
            
            String sql ="insert into vote (vote_id,poll_id,m_idx,u_idx,voteDate)"
            		+ "values(seq_vote.nextval,?,?,?,sysdate)";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, dto.getPoll_id());
            ps.setInt(2, dto.getM_idx());
            ps.setInt(3, dto.getU_idx());

            int count = ps.executeUpdate();
            return count;
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("insertVote error");
            return -1;
        } finally {
            try {
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (Exception e) {}
        }
    }

    // 중복 투표 검사
    public boolean hasUserVoted(int poll_id, int u_idx) {

        boolean result = false;

        try {
            conn = com.five.db.FiveDB.getConn();
            
            String sql = "select count(*) from vote "
                    + "where poll_id = ? and u_idx = ?";
            
            ps = conn.prepareStatement(sql);
            ps.setInt(1, poll_id);
            ps.setInt(2, u_idx);
            rs = ps.executeQuery();

            if (rs.next()) {
                int cnt = rs.getInt(1);
                if (cnt > 0) {
                    result = true;
                }
            }
            return result;
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("hasUserVoted error");
            return false;
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (Exception e) {}
        }
       
    }

    // 영화별 득표수 결과 (m_idx, count) 리스트
    public ArrayList<VoteResultDTO> getVoteResultByPoll(int poll_id) {
       
        ArrayList<VoteResultDTO> list = new ArrayList<VoteResultDTO>();

        try {
            conn = com.five.db.FiveDB.getConn();
            
            String sql = "select m_idx, count(*) as cnt"
            		+ " from vote"
            		+ " where poll_id = ?"
            		+ " group by m_idx"
            		+ " order by cnt desc";
            
            ps = conn.prepareStatement(sql);
            ps.setInt(1, poll_id);
            rs = ps.executeQuery();

            while (rs.next()) {
                VoteResultDTO dto = new VoteResultDTO();
                dto.setPoll_id(poll_id);
                dto.setM_idx(rs.getInt("m_idx"));
                dto.setCount(rs.getInt("cnt"));
                list.add(dto);
            }
            return list;
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("getVoteResultByPoll error");
            return null;
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (Exception e) {}
        }
       
    }
    
    public int findIdx(String id) {
    	
    	try {
    		int idx = 0;
    		conn=com.five.db.FiveDB.getConn();
    		String sql= "select u_idx from users where u_id=?";
    		ps=conn.prepareStatement(sql);
    		ps.setString(1, id);
    		rs = ps.executeQuery();
    		if(rs.next()) {
    			idx = rs.getInt(1);
    		}
    		return idx;
    	}catch (Exception e) {
    		System.out.println("findIdxErr");
    		e.printStackTrace();
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
}
