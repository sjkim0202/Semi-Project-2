package com.five.vote;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Date;
import java.util.ArrayList;

public class CreatePollDAO {

	Connection conn;
	PreparedStatement ps;
	ResultSet rs;
	
	//투표 생성
    public int createPoll(CreatePollDTO dto) {
        try {
        	if(dto.getStartDate()!=null && dto.getEndDate()!=null) {
        		long startDate = dto.getStartDate().getTime();
        		long endDate = dto.getEndDate().getTime();
        		if(endDate<startDate) {
        			System.out.println("종료일이 시작일 보다 빠름 ");
        			return -1;
        		}
        	}
            conn = com.five.db.FiveDB.getConn();
            String sql = "insert into create_poll(poll_id,poll_name,startDate,endDate)"
            		+ "values(seq_vote_poll.nextval,?,?,?)";
            ps = conn.prepareStatement(sql);
            ps.setString(1, dto.getPoll_name());
            ps.setDate(2, dto.getStartDate());
            ps.setDate(3, dto.getEndDate());

            int count = ps.executeUpdate();
            return count;
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("createPoll error");
            return -1;
        } finally {
            try {
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (Exception e) {}
        }
    }

    //투표 목록 조회
    public ArrayList<CreatePollDTO> getAllPolls() {
        ArrayList<CreatePollDTO> list = new ArrayList<CreatePollDTO>();
        try {
            conn = com.five.db.FiveDB.getConn();
            String sql = "select * from create_poll "
            		+ "order by poll_id desc";
            
            ps = conn.prepareStatement(sql);	
            rs = ps.executeQuery();

            while (rs.next()) {
                CreatePollDTO dto = new CreatePollDTO();
                dto.setPoll_id(rs.getInt("poll_id"));
                dto.setPoll_name(rs.getString("poll_name"));
                dto.setStartDate(rs.getDate("startDate"));
                dto.setEndDate(rs.getDate("endDate"));
                list.add(dto);
            }
            return list;
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("getAllPolls error");
            return null;
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (Exception e) {}
        }
        
    }

    //투표 하나만 조회
    public CreatePollDTO getPollById(int poll_id) {
    	CreatePollDTO dto = null;
        try {
            conn = com.five.db.FiveDB.getConn();
 
            String sql = "select poll_id,poll_name,startDate,endDate from create_poll where poll_id=?";
            
            ps = conn.prepareStatement(sql);
            ps.setInt(1, poll_id);
            rs = ps.executeQuery();

            if (rs.next()) {
                dto = new CreatePollDTO();
                dto.setPoll_id(rs.getInt("poll_id"));
                dto.setPoll_name(rs.getString("poll_name"));
                dto.setStartDate(rs.getDate("startDate"));
                dto.setEndDate(rs.getDate("endDate"));
            }
            return dto;
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("getPollById error");
            return null;
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (Exception e) {}
        }
    }

    // 진행중인 투표 겟
    public CreatePollDTO getCurrentPoll() {
   
        CreatePollDTO dto = null;

        try {
            conn = com.five.db.FiveDB.getConn();
            
            String sql ="select poll_id,poll_name,startDate,endDate from create_poll where startDate <= sysdate and endDate >= sysdate";
            
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();

            if (rs.next()) {
                dto = new CreatePollDTO();
                dto.setPoll_id(rs.getInt("poll_id"));
                dto.setPoll_name(rs.getString("poll_name"));
                dto.setStartDate(rs.getDate("startDate"));
                dto.setEndDate(rs.getDate("endDate"));
            }
            return dto;
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("getCurrentPoll error");
            return null;
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (Exception e) {}
        } 
    }
    
 // 현재 진행중인 투표만 조회
    public ArrayList<CreatePollDTO> getCurrentPollList() {
        ArrayList<CreatePollDTO> list = new ArrayList<>();

        try {
            conn = com.five.db.FiveDB.getConn();

            String sql =
                "select poll_id, poll_name, startDate, endDate "
                + " from create_poll " +
                " order by poll_id desc";

            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();

            while (rs.next()) {
                CreatePollDTO dto = new CreatePollDTO();
                dto.setPoll_id(rs.getInt("poll_id"));
                dto.setPoll_name(rs.getString("poll_name"));
                dto.setStartDate(rs.getDate("startDate"));
                dto.setEndDate(rs.getDate("endDate"));
                list.add(dto);
            }

            return list;

        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("getCurrentPollList error");
            return null;

        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (conn != null) conn.close();
            } catch (Exception e) {}
        }
    }

    
}
