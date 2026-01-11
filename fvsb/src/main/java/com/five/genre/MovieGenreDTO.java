package com.five.genre;

public class MovieGenreDTO {
	private int mg_idx, m_idx,g_idx;
	public MovieGenreDTO() {
		// TODO Auto-generated constructor stub
	}
	public MovieGenreDTO(int mg_idx, int m_idx, int g_idx) {
		super();
		this.mg_idx = mg_idx;
		this.m_idx = m_idx;
		this.g_idx = g_idx;
	}
	public int getMg_idx() {
		return mg_idx;
	}
	public void setMg_idx(int mg_idx) {
		this.mg_idx = mg_idx;
	}
	public int getM_idx() {
		return m_idx;
	}
	public void setM_idx(int m_idx) {
		this.m_idx = m_idx;
	}
	public int getG_idx() {
		return g_idx;
	}
	public void setG_idx(int g_idx) {
		this.g_idx = g_idx;
	}
	
}
