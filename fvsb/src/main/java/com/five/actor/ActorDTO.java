package com.five.actor;

public class ActorDTO {
	private int a_idx;
	private String a_name;
	private String a_age;
	private String a_country, a_img;
	
	public ActorDTO() {
		// TODO Auto-generated constructor stub
	}

	public ActorDTO(int a_idx, String a_name, String a_age, String a_country, String a_img) {
		super();
		this.a_idx = a_idx;
		this.a_name = a_name;
		this.a_age = a_age;
		this.a_country = a_country;
		this.a_img = a_img;
	}

	public int getA_idx() {
		return a_idx;
	}

	public void setA_idx(int a_idx) {
		this.a_idx = a_idx;
	}

	public String getA_name() {
		return a_name;
	}

	public void setA_name(String a_name) {
		this.a_name = a_name;
	}

	public String getA_age() {
		return a_age;
	}

	public void setA_age(String a_age) {
		this.a_age = a_age;
	}

	public String getA_country() {
		return a_country;
	}

	public void setA_country(String a_country) {
		this.a_country = a_country;
	}

	public String getA_img() {
		return a_img;
	}

	public void setA_img(String a_img) {
		this.a_img = a_img;
	}
	
	
}
