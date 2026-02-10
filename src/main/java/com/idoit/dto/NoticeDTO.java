package com.idoit.dto;

import java.util.Date;

import lombok.Data;

@Data
public class NoticeDTO {
    private Integer nno;
    private String ntitle;
    private String ncontent;
    private String npin; // Y / N
    private Date ndate;
}
