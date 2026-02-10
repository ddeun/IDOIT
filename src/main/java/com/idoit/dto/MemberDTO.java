package com.idoit.dto;

import java.sql.Date;

import lombok.Data;

@Data
public class MemberDTO {
	private int mno;
	private String mtype;
	private String memail;
	private String mpasswd;
	private String mname;
	private String mgender;
	private Date mbirth;
	private String mtel;
	private String mzipcode;
	private String maddr;
	private String maddrdetail;
	private String mstatus;
	private Date mcreate;
	private Date mupdate;
	private String mauth;
	private String mprovider;
	private String mproviderId;
	private Long cno;
}
