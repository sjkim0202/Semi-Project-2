package com.five.review_like;

public class Review_likeDTO {
	private int u_idx,r_idx;

	public Review_likeDTO(int u_idx, int r_idx) {
		super();
		this.u_idx = u_idx;
		this.r_idx = r_idx;
	}

	public int getU_idx() {
		return u_idx;
	}

	public void setU_idx(int u_idx) {
		this.u_idx = u_idx;
	}

	public int getR_idx() {
		return r_idx;
	}

	public void setR_idx(int r_idx) {
		this.r_idx = r_idx;
	}
	
	
}
