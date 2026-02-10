package com.idoit.dto;

import java.util.Date;

import lombok.Data;

@Data
public class FaqDTO {
    private int fno;
    private String fcategory;
    private String fquestion;
    private String fanswer;
    private Date fcreate;
}
