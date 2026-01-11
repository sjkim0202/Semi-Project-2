package com.five.genre;

public class UserGenreDTO {

	private int ug_idx; // PK
	private int u_idx;  // 회원 FK
	private int g_idx;
	
	public UserGenreDTO() {
	
	}

	public UserGenreDTO(int ug_idx, int u_idx, int g_idx) {
		super();
		this.ug_idx = ug_idx;
		this.u_idx = u_idx;
		this.g_idx = g_idx;
	}

	public int getUg_idx() {
		return ug_idx;
	}

	public void setUg_idx(int ug_idx) {
		this.ug_idx = ug_idx;
	}

	public int getU_idx() {
		return u_idx;
	}

	public void setU_idx(int u_idx) {
		this.u_idx = u_idx;
	}

	public int getG_idx() {
		return g_idx;
	}

	public void setG_idx(int g_idx) {
		this.g_idx = g_idx;
	}

	


}
