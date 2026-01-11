package com.five.review_comments;
import java.sql.*;
public class Review_commentsDTO {
	private int rc_idx,r_idx,u_idx;
	private String rc_comment;
	private Date rc_date;
	public Review_commentsDTO(int rc_idx, int r_idx, int u_idx, String rc_comment, Date rc_date) {
		super();
		this.rc_idx = rc_idx;
		this.r_idx = r_idx;
		this.u_idx = u_idx;
		this.rc_comment = rc_comment;
		this.rc_date = rc_date;
	}
	public int getRc_idx() {
		return rc_idx;
	}
	public void setRc_idx(int rc_idx) {
		this.rc_idx = rc_idx;
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
	public String getRc_comment() {
		return rc_comment;
	}
	public void setRc_comment(String rc_comment) {
		this.rc_comment = rc_comment;
	}
	public Date getRc_date() {
		return rc_date;
	}
	public void setRc_date(Date rc_date) {
		this.rc_date = rc_date;
	}
	
	
}
