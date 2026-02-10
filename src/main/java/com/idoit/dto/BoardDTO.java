package com.idoit.dto;

import java.util.Date;

import lombok.Data;

@Data
public class BoardDTO {
	private int bno;
	private String btype;
	private String btitle;
	private String bwriter;
	private String bcontent;
	private String bimage;
	private int bview;
	private String bstatus;
	private Date bcreate;
	private Date bupdate;
	private int mno;
	
	private String realWriterName;
    private String realWriterEmail;
}
