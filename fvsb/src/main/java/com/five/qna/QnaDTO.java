package com.five.qna;

import java.sql.Date;

public class QnaDTO {

	private int q_idx;
	private int u_idx;
	private String q_title;
	private String q_comment;
	private Date q_date;
	private int q_ref;
	private int q_lev;
	private int q_step;
	
	private String u_name;

	public QnaDTO() {
	}
	

	public QnaDTO(int q_idx, int u_idx, String q_title, String q_comment, Date q_date, int q_ref, int q_lev, int q_step) {
		super();
		this.q_idx = q_idx;
		this.u_idx = u_idx;
		this.q_title = q_title;
		this.q_comment = q_comment;
		this.q_date = q_date;
		this.q_ref = q_ref;
		this.q_lev = q_lev;
		this.q_step = q_step;
	}
	
	public QnaDTO(int q_idx, int u_idx, String u_name,String q_title, String q_comment, Date q_date, int q_ref, int q_lev, int q_step) {
		this(q_idx, u_idx, q_title, q_comment, q_date, q_ref, q_lev, q_step);
		this.u_name = u_name;
	}



	public int getQ_idx() {
		return q_idx;
	}

	public void setQ_idx(int q_idx) {
		this.q_idx = q_idx;
	}

	public int getU_idx() {
		return u_idx;
	}

	public void setU_idx(int u_idx) {
		this.u_idx = u_idx;
	}

	public String getQ_title() {
		return q_title;
	}

	public void setQ_title(String q_title) {
		this.q_title = q_title;
	}

	public String getQ_comment() {
		return q_comment;
	}

	public void setQ_comment(String q_comment) {
		this.q_comment = q_comment;
	}

	public Date getQ_date() {
		return q_date;
	}

	public void setQ_date(Date q_date) {
		this.q_date = q_date;
	}

	public int getQ_ref() {
		return q_ref;
	}

	public void setQ_ref(int q_ref) {
		this.q_ref = q_ref;
	}

	public int getQ_lev() {
		return q_lev;
	}

	public void setQ_lev(int q_lev) {
		this.q_lev = q_lev;
	}

	public int getQ_step() {
		return q_step;
	}

	public void setQ_step(int q_step) {
		this.q_step = q_step;
	}

	public String getU_name() {
		return u_name;
	}

	public void setU_name(String u_name) {
		this.u_name = u_name;
	}

	
}
