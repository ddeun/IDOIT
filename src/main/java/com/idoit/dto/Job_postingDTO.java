package com.idoit.dto;

import java.util.Date;
import java.util.List;

import org.springframework.format.annotation.DateTimeFormat;

import lombok.Data;

@Data
public class Job_postingDTO {
    private Integer jno;
    private String jtitle;
    private String jposition;
    private String jcareer;
    private String jemployment;
    private String jlocation;
    private String jsal;
    private String jcontent;

    // ✅ input type="date" (yyyy-MM-dd) 바인딩용
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date jdeadline;

    private String jlink;
    private String jstatus;
    private Date jcreate;
    private Date jupdate;

    private Integer cno;

    // ✅ DB 저장용(JSON 문자열)
    private String jcategories;  // 예: ["서버/백엔드 개발자","DBA"]
    private String jskills;      // 예: ["/images/skills/java.png","/images/skills/spring.png"]

    // ✅ 뷰 편의용(컨트롤러에서 set)
    private List<String> categories;

    private String cname;
    private String cimage;

    // list 썸네일
    private String thumb;
    
    // ✅ (추가) 공고별 지원자 수
    private Integer applyCnt;
}
