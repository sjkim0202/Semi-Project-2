package com.five.vote;

import java.sql.Date;

public class CreatePollDTO {

    private int poll_id;
    private Date startDate;
    private Date endDate;	
    private String poll_name;

    public CreatePollDTO() {}

    public String getPoll_name() {
		return poll_name;
	}

	public void setPoll_name(String poll_name) {
		this.poll_name = poll_name;
	}

	public int getPoll_id() {
        return poll_id;
    }

    public void setPoll_id(int poll_id) {
        this.poll_id = poll_id;
    }

    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }
}
