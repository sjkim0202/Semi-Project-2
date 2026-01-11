package com.five.notification;

import java.sql.Date;

public class NotificationDTO {
	private int n_idx;
	private int u_idx;
	private int from_u_idx;
	private String n_type;
	private int target_id;
	private String n_message;
	private String n_read;
	private Date n_date;

	public NotificationDTO() {
	}

	public NotificationDTO(int n_idx, int u_idx, int from_u_idx, String n_type, int target_id, String n_message,
			String n_read, Date n_date) {
		this.n_idx = n_idx;
		this.u_idx = u_idx;
		this.from_u_idx = from_u_idx;
		this.n_type = n_type;
		this.target_id = target_id;
		this.n_message = n_message;
		this.n_read = n_read;
		this.n_date = n_date;
	}

	public int getN_idx() {
		return n_idx;
	}

	public void setN_idx(int n_idx) {
		this.n_idx = n_idx;
	}

	public int getU_idx() {
		return u_idx;
	}

	public void setU_idx(int u_idx) {
		this.u_idx = u_idx;
	}

	public int getFrom_u_idx() {
		return from_u_idx;
	}

	public void setFrom_u_idx(int from_u_idx) {
		this.from_u_idx = from_u_idx;
	}

	public String getN_type() {
		return n_type;
	}

	public void setN_type(String n_type) {
		this.n_type = n_type;
	}

	public int getTarget_id() {
		return target_id;
	}

	public void setTarget_id(int target_id) {
		this.target_id = target_id;
	}

	public String getN_message() {
		return n_message;
	}

	public void setN_message(String n_message) {
		this.n_message = n_message;
	}

	public String getN_read() {
		return n_read;
	}

	public void setN_read(String n_read) {
		this.n_read = n_read;
	}

	public Date getN_date() {
		return n_date;
	}

	public void setN_date(Date n_date) {
		this.n_date = n_date;
	}
}
