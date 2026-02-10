package com.idoit.dto;

import java.util.Date;

import lombok.Data;

@Data
public class Board_commentDTO {
	 private int bcno;          
	 private String bccontent;  
	 private String bcstatus;   
	 private Date bccreate;
	 private String bcsecret;
	 private int bno;           
	 private int mno;
	 
	 private String realWriterName;
	 private String realWriterEmail;

}
