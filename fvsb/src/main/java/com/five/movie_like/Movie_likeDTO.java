package com.five.movie_like;

public class Movie_likeDTO {
	private int u_idx,m_idx;
	
	public Movie_likeDTO(int u_idx, int m_idx) {
		super();
		this.u_idx = u_idx;
		this.m_idx = m_idx;
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
	
	
}
