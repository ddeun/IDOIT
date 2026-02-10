package com.idoit.dto;

import lombok.Data;

@Data
public class SearchResultRow {
    private String type;      // JOB / BOARD / INTERVIEW / NOTICE / FAQ
    private long pk;          // 각 테이블 PK
    private String title;
    private String content;

    private String hlTitle;   // 하이라이트된 제목(없으면 title)
    private String hlContent; // 하이라이트된 내용(없으면 content 일부)
}
