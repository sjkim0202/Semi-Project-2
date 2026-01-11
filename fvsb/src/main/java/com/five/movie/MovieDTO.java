package com.five.movie;
import java.sql.*;

public class MovieDTO {
	private int m_idx;
	private String m_name,m_date;
	private String m_limit;
	private String m_pd,m_country,m_img,m_story;
	
public MovieDTO() {
}

public MovieDTO(int m_idx, String m_name, String m_date, String m_limit, String m_pd, String m_country, String m_img,
		String m_story) {
	super();
	this.m_idx = m_idx;
	this.m_name = m_name;
	this.m_date = m_date;
	this.m_limit = m_limit;
	this.m_pd = m_pd;
	this.m_country = m_country;
	this.m_img = m_img;
	this.m_story = m_story;
}

public int getM_idx() {
	return m_idx;
}

public void setM_idx(int m_idx) {
	this.m_idx = m_idx;
}

public String getM_name() {
	return m_name;
}

public void setM_name(String m_name) {
	this.m_name = m_name;
}

public String getM_date() {
	return m_date;
}

public void setM_date(String m_date) {
	this.m_date = m_date;
}

public String getM_limit() {
	return m_limit;
}

public void setM_limit(String m_limit) {
	this.m_limit = m_limit;
}

public String getM_pd() {
	return m_pd;
}

public void setM_pd(String m_pd) {
	this.m_pd = m_pd;
}

public String getM_country() {
	return m_country;
}

public void setM_country(String m_country) {
	this.m_country = m_country;
}

public String getM_img() {
	return m_img;
}

public void setM_img(String m_img) {
	this.m_img = m_img;
}

public String getM_story() {
	return m_story;
}

public void setM_story(String m_story) {
	this.m_story = m_story;
}



}