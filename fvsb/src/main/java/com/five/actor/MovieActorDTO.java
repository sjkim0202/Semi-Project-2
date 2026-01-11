package com.five.actor;

public class MovieActorDTO {
	private int ma_idx, m_idx,a_idx;

	public MovieActorDTO(int ma_idx, int m_idx, int a_idx) {
		super();
		this.ma_idx = ma_idx;
		this.m_idx = m_idx;
		this.a_idx = a_idx;
	}

	public int getMa_idx() {
		return ma_idx;
	}

	public void setMa_idx(int ma_idx) {
		this.ma_idx = ma_idx;
	}

	public int getM_idx() {
		return m_idx;
	}

	public void setM_idx(int m_idx) {
		this.m_idx = m_idx;
	}

	public int getA_idx() {
		return a_idx;
	}

	public void setA_idx(int a_idx) {
		this.a_idx = a_idx;
	}
	
	
}
