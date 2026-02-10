package com.idoit.dto;

import java.util.Date;
import lombok.Data;

@Data
public class ApplicationDTO {
    private int ano;
    private String astatus;
    private Date adate;
    private Date aupdate;
    private int jno;
    private int rno;
    private int mno;

    // JOIN / 화면용
    private String jtitle;
    private String cname;
    private String mname;
}
