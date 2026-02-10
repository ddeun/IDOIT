package com.idoit.dto;

import java.util.Date;
import lombok.Data;

@Data
public class InterviewDTO {
    private int ino;
    private int mno;

    private String ititle;
    private String isummary;
    private String icontent;

    private String iimagePath;
    private String icategory;
    private String itags;

    private int iview;
    private int ireadmin;

    private Date icreate;
    private Date iupdate;
}
