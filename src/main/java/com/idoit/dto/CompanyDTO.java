package com.idoit.dto;

import java.util.Date;
import lombok.Data;

@Data
public class CompanyDTO {
    private Integer cno;
    private String cname;

    private String cbizno;
    private String czipcode;   
    private String caddr;
    private String caddrdetail;

    private String cpage;
    private String ccontent;
    private String cimage;

    private Date ccreate;
    private Date cupdate;

    private Integer mno;
    private String cestablish;   
}
