package com.idoit.dto;

import java.sql.Date;
import java.util.List;

import lombok.Data;

@Data
public class ResumeDTO {

    private int rno;          // PK
    private String rtitle;    // 이력서 제목
    private String rjobrole;  // 희망 직무
    private String rsummary;  // 자기소개 요약
    private Date rcreate;     // 작성일
    private Date rupdate;     // 수정일
    private int mno;          // 작성자 (member FK)
    private String rimage;
    
    private List<String> rsname; // 기술스택 이름들
    private List<ResumeEducationDTO> eduList;
    private List<ResumeCareerDTO> careerList;
    private List<ResumeProjectDTO> projectList;
    private List<ResumeOtherDTO> otherList;
    private List<ResumeTrainingDTO> trainingList;
}
