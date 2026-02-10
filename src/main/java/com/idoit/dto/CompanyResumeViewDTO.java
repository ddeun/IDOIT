package com.idoit.dto;

import java.util.Date;

import lombok.Data;

@Data
public class CompanyResumeViewDTO {

    // application
    private Integer ano;
    private String astatus;
    private Date adate;

    // job_posting
    private Integer jno;
    private String jtitle;

    // applicant(member)
    private Integer applicantMno;
    private String applicantName;
    private String applicantEmail;

    // resume
    private Integer rno;
    private String rtitle;
    private String rjobrole;
    private String rsummary;
    private Date rcreate;
    private Date rupdate;
}
