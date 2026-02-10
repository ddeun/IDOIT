package com.idoit.service;

import java.util.List;

import com.idoit.dto.MemberDTO;
import com.idoit.dto.ResumeCareerDTO;
import com.idoit.dto.ResumeDTO;
import com.idoit.dto.ResumeEducationDTO;
import com.idoit.dto.ResumeOtherDTO;
import com.idoit.dto.ResumeProjectDTO;
import com.idoit.dto.ResumeTrainingDTO;

public interface ResumeService {
    List<ResumeDTO> findByMno(int mno);
    
    ResumeDTO findOneByOwner(int rno, int mno);

    int insertResume(ResumeDTO dto, 
            List<String> rsname,
            List<ResumeEducationDTO> eduList,
            List<ResumeCareerDTO> careerList,
            List<ResumeProjectDTO> projectList,
            List<ResumeOtherDTO> otherList,
            List<ResumeTrainingDTO> trainingList);
    int updateResume(ResumeDTO dto, List<String> rsname
    		, List<ResumeEducationDTO> eduList
    		, List<ResumeCareerDTO> careerList
    		, List<ResumeProjectDTO> projectList
    		, List<ResumeOtherDTO> otherList
    		, List<ResumeTrainingDTO> trainingList);

    List<String> findSkillNames(int rno);
    int deleteResume(int rno, int mno);
    List<ResumeEducationDTO> findEducationByRno(int rno);
    List<ResumeCareerDTO> findCareerByRno(int rno);
    List<ResumeProjectDTO> findProjectByRno(int rno);
    List<ResumeOtherDTO> findOtherByRno(int rno);
    List<ResumeTrainingDTO> findTrainingByRno(int rno);
    
    MemberDTO getMemberInfo(String memail);
    
    ResumeDTO findPublicForCompany(int rno);

}
