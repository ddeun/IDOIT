package com.idoit.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.idoit.dto.ResumeCareerDTO;
import com.idoit.dto.ResumeDTO;
import com.idoit.dto.ResumeEducationDTO;
import com.idoit.dto.ResumeOtherDTO;
import com.idoit.dto.ResumeProjectDTO;
import com.idoit.dto.ResumeTrainingDTO;

@Mapper
public interface ResumeDAO {
    List<ResumeDTO> findByMno(int mno);
    ResumeDTO findOne(int rno);
    ResumeDTO findOneByOwner(@Param("rno") int rno, @Param("mno") int mno);
    ResumeDTO findPublicForCompany(int rno);
    int insertResume(ResumeDTO dto);
    int updateResume(ResumeDTO dto);
    int deleteResume(@Param("rno") int rno, @Param("mno") int mno);
    int deleteApplicationsByResume(int rno);

    // 기술스택
    void deleteSkills(@Param("rno") int rno);
    void insertSkills(@Param("rno") int rno,
                      @Param("skills") List<String> skills);

    List<String> findSkillNames(@Param("rno") int rno);
    // 학력사항
    void deleteEducation(@Param("rno") int rno);
    void insertEducation(@Param("rno") int rno, @Param("eduList") List<ResumeEducationDTO> eduList);
    List<ResumeEducationDTO> findEducationByRno(@Param("rno") int rno);
    // 경력
    void deleteCareer(@Param("rno") int rno);
    void insertCareer(@Param("rno") int rno, @Param("careerList") List<ResumeCareerDTO> careerList);
    List<ResumeCareerDTO> findCareerByRno(@Param("rno") int rno);
    // 프로젝트
    void deleteProject(@Param("rno") int rno);
    void insertProject(@Param("rno") int rno, @Param("projectList") List<ResumeProjectDTO> projectList);
    List<ResumeProjectDTO> findProjectByRno(@Param("rno") int rno);
    // 기타자격증
    void deleteOther(@Param("rno") int rno);
    void insertOther(@Param("rno") int rno, @Param("otherList") List<ResumeOtherDTO> otherList);
    List<ResumeOtherDTO> findOtherByRno(@Param("rno") int rno);
    // 교육
    void deleteTraining(@Param("rno") int rno);
    void insertTraining(@Param("rno") int rno, @Param("trainingList") List<ResumeTrainingDTO> trainingList);
    List<ResumeTrainingDTO> findTrainingByRno(@Param("rno") int rno);
}
