package com.five.review;
import java.sql.*;
public class ReviewDTO {
	private int r_idx,u_idx,m_idx;
	private String r_title;
	private int r_score;
	private String r_comment;
	private Date r_date;
	private int r_like;
	
	public ReviewDTO(int r_idx, int u_idx, int m_idx, String r_title, int r_score, String r_comment, Date r_date,
			int r_like) {
		super();
		this.r_idx = r_idx;
		this.u_idx = u_idx;
		this.m_idx = m_idx;
		this.r_title = r_title;
		this.r_score = r_score;
		this.r_comment = r_comment;
		this.r_date = r_date;
		this.r_like = r_like;
	}
	
	public int getR_idx() {
		return r_idx;
	}
	public void setR_idx(int r_idx) {
		this.r_idx = r_idx;
	}
	public int getU_idx() {
		return u_idx;
	}
	public void setU_idx(int u_idx) {
		this.u_idx = u_idx;
	}
	public int getM_idx() {
		return m_idx;
	}
	public void setM_idx(int m_idx) {
		this.m_idx = m_idx;
	}
	public String getR_title() {
		return r_title;
	}
	public void setR_title(String r_title) {
		this.r_title = r_title;
	}
	public int getR_score() {
		return r_score;
	}
	public void setR_score(int r_score) {
		this.r_score = r_score;
	}
	public String getR_comment() {
		return r_comment;
	}
	public void setR_comment(String r_comment) {
		this.r_comment = r_comment;
	}
	public Date getR_date() {
		return r_date;
	}
	public void setR_date(Date r_date) {
		this.r_date = r_date;
	}
	public int getR_like() {
		return r_like;
	}
	public void setR_like(int r_like) {
		this.r_like = r_like;
	}
	
	
	
}
