package com.five.bbs;

import java.sql.Date;

public class BbsDTO {

	private int b_idx;
	private int u_idx;
	private String b_title;
	private String b_comment;
	private Date b_date;
	private int b_ref;
	private int b_lev;
	private int b_step;
	private int b_readnum;
	
	private String u_name;
	private String u_ad;

	public BbsDTO() {
	}

	public BbsDTO(int b_idx, int u_idx, String b_title, String b_comment, Date b_date, int b_ref, int b_lev,
			int b_step, int b_readnum) {
		super();
		this.b_idx = b_idx;
		this.u_idx = u_idx;
		this.b_title = b_title;
		this.b_comment = b_comment;
		this.b_date = b_date;
		this.b_ref = b_ref;
		this.b_lev = b_lev;
		this.b_step = b_step;
		this.b_readnum = b_readnum;
	}

	public BbsDTO(int b_idx, int u_idx, String u_name, String u_ad,  String b_title, String b_comment, Date b_date, int b_ref,
			int b_lev, int b_step, int b_readnum) {
		this(b_idx, u_idx, b_title, b_comment, b_date, b_ref, b_lev, b_step, b_readnum);
		this.u_name = u_name;
		this.u_ad = u_ad;
	}
	
	public int getB_idx() {
		return b_idx;
	}

	public void setB_idx(int b_idx) {
		this.b_idx = b_idx;
	}

	public int getU_idx() {
		return u_idx;
	}

	public void setU_idx(int u_idx) {
		this.u_idx = u_idx;
	}

	public String getB_title() {
		return b_title;
	}

	public void setB_title(String b_title) {
		this.b_title = b_title;
	}

	public String getB_comment() {
		return b_comment;
	}

	public void setB_comment(String b_comment) {
		this.b_comment = b_comment;
	}

	public Date getB_date() {
		return b_date;
	}

	public void setB_date(Date b_date) {
		this.b_date = b_date;
	}

	public int getB_ref() {
		return b_ref;
	}

	public void setB_ref(int b_ref) {
		this.b_ref = b_ref;
	}

	public int getB_lev() {
		return b_lev;
	}

	public void setB_lev(int b_lev) {
		this.b_lev = b_lev;
	}

	public int getB_step() {
		return b_step;
	}

	public void setB_step(int b_step) {
		this.b_step = b_step;
	}

	public int getB_readnum() {
		return b_readnum;
	}

	public void setB_readnum(int b_readnum) {
		this.b_readnum = b_readnum;
	}
	public String getU_name() {
		return u_name;
	}

	public void setU_name(String u_name) {
		this.u_name = u_name;
	}

	public String getU_ad() {
		return u_ad;
	}

	public void setU_ad(String u_ad) {
		this.u_ad = u_ad;
	}
	

}
