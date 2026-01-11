package com.five.users;
import java.util.*;
import java.sql.*;
import java.sql.Date;

public class UsersDTO {

	private int u_idx;
	private String u_id;
	private String u_pwd;
	private String u_name;
	private String u_sex;
	private int u_year;
	private Date u_date; // java.sql.Date 사용
	private String u_ad;
	private String u_img;
	private List<String> genre;
	
	public UsersDTO() {

	}

	public UsersDTO(int u_idx, String u_id, String u_pwd, String u_name, String u_sex, int u_year, Date u_date,
			String u_ad, String u_img,List<String> genre) {
		super();
		this.u_idx = u_idx;
		this.u_id = u_id;
		this.u_pwd = u_pwd;
		this.u_name = u_name;
		this.u_sex = u_sex;
		this.u_year = u_year;
		this.u_date = u_date;
		this.u_ad = u_ad;
		this.u_img = u_img;
		this.genre = genre;
	}

	
	public int getU_idx() {
		return u_idx;
	}

	public void setU_idx(int u_idx) {
		this.u_idx = u_idx;
	}

	public String getU_id() {
		return u_id;
	}

	public void setU_id(String u_id) {
		this.u_id = u_id;
	}

	public String getU_pwd() {
		return u_pwd;
	}

	public void setU_pwd(String u_pwd) {
		this.u_pwd = u_pwd;
	}

	public String getU_name() {
		return u_name;
	}

	public void setU_name(String u_name) {
		this.u_name = u_name;
	}

	public String getU_sex() {
		return u_sex;
	}

	public void setU_sex(String u_sex) {
		this.u_sex = u_sex;
	}

	public int getU_year() {
		return u_year;
	}

	public void setU_year(int u_year) {
		this.u_year = u_year;
	}

	public Date getU_date() {
		return u_date;
	}

	public void setU_date(Date u_date) {
		this.u_date = u_date;
	}

	public String getU_ad() {
		return u_ad;
	}

	public void setU_ad(String u_ad) {
		this.u_ad = u_ad;
	}

	public String getU_img() {
		return u_img;
	}

	public void setU_img(String u_img) {
		this.u_img = u_img;
	}
	public List<String> getGenre() {
		return genre;
	}

	public void setGenre(List<String> genre) {
		this.genre = genre;
	}

	

	

}
