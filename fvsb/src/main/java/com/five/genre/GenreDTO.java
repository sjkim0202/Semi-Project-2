package com.five.genre;

public class GenreDTO {
	private int g_idx;
	private String g_name;

	public GenreDTO() {
	}

	public GenreDTO(int g_idx, String g_name) {
		super();
		this.g_idx = g_idx;
		this.g_name = g_name;
	}

	public int getG_idx() {
		return g_idx;
	}

	public void setG_idx(int g_idx) {
		this.g_idx = g_idx;
	}

	public String getG_name() {
		return g_name;
	}

	public void setG_name(String g_name) {
		this.g_name = g_name;
	}

}
