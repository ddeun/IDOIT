package com.idoit.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.idoit.dao.MemberDAO;
import com.idoit.dao.ResumeDAO;
import com.idoit.dto.MemberDTO;
import com.idoit.dto.ResumeCareerDTO;
import com.idoit.dto.ResumeDTO;
import com.idoit.dto.ResumeEducationDTO;
import com.idoit.dto.ResumeOtherDTO;
import com.idoit.dto.ResumeProjectDTO;
import com.idoit.dto.ResumeTrainingDTO;

@Service
public class ResumeServiceImpl implements ResumeService {

    private final ResumeDAO resumeDAO;

    public ResumeServiceImpl(ResumeDAO resumeDAO) {
        this.resumeDAO = resumeDAO;
    }

    @Override
    public List<ResumeDTO> findByMno(int mno) {
        return resumeDAO.findByMno(mno);
    }

    @Override
    public ResumeDTO findOneByOwner(int rno, int mno) {
        return resumeDAO.findOneByOwner(rno, mno);
    }

    @Override
    @Transactional
    public int insertResume(ResumeDTO dto, 
                            List<String> rsname,
                            List<ResumeEducationDTO> eduList,
                            List<ResumeCareerDTO> careerList,
                            List<ResumeProjectDTO> projectList,
                            List<ResumeOtherDTO> otherList,
                            List<ResumeTrainingDTO> trainingList) { 
    	
    	System.out.println("서비스 진입 - 제목: " + dto.getRtitle());
        System.out.println("이미지 경로 확인: " + dto.getRimage());
    	
        int result = resumeDAO.insertResume(dto); 
        int rno = dto.getRno();

        if (rsname != null && !rsname.isEmpty()) {
            resumeDAO.insertSkills(rno, rsname);
        }

        if (eduList != null && !eduList.isEmpty()) {
            resumeDAO.insertEducation(rno, eduList);
        }

        if (careerList != null && !careerList.isEmpty()) {
            resumeDAO.insertCareer(rno, careerList);
        }

        if (projectList != null && !projectList.isEmpty()) {
            resumeDAO.insertProject(rno, projectList);
        }

        if (otherList != null && !otherList.isEmpty()) {
            resumeDAO.insertOther(rno, otherList);
        }

        if (trainingList != null && !trainingList.isEmpty()) {
            resumeDAO.insertTraining(rno, trainingList);
        }

        return result;
    }

    @Override
    @Transactional
    public int updateResume(ResumeDTO dto
    						, List<String> rsname
    						,List<ResumeEducationDTO> eduList
    						,List<ResumeCareerDTO> careerList
    						,List<ResumeProjectDTO> projectList
    						, List<ResumeOtherDTO> otherList
    						, List<ResumeTrainingDTO> trainingList) {
        int result = resumeDAO.updateResume(dto);
        // 기술스택 
        resumeDAO.deleteSkills(dto.getRno()); 
        if (rsname != null && !rsname.isEmpty()) {
            resumeDAO.insertSkills(dto.getRno(), rsname);
        }
        // 학력사항
        resumeDAO.deleteEducation(dto.getRno());
        if (eduList != null && !eduList.isEmpty()) {
            resumeDAO.insertEducation(dto.getRno(), eduList);
        }
        // 경력
        resumeDAO.deleteCareer(dto.getRno());
        if (careerList != null && !careerList.isEmpty()) {
            resumeDAO.insertCareer(dto.getRno(), careerList);
        }
        // 프로젝트
        resumeDAO.deleteProject(dto.getRno());
        if (projectList != null && !projectList.isEmpty()) {
            // 프로젝트 객체들에 rno(외래키)를 심어줍니다.
            for (ResumeProjectDTO project : projectList) {
                project.setRno(dto.getRno());
            }
            resumeDAO.insertProject(dto.getRno(),projectList); // 리스트 통째로 넘기거나 반복문 처리
        }
        // 기타 자격증
        resumeDAO.deleteOther(dto.getRno());
        if (otherList != null && !otherList.isEmpty()) {
            resumeDAO.insertOther(dto.getRno(), otherList);
        }
        // 교육
        resumeDAO.deleteTraining(dto.getRno());
        if (trainingList != null && !trainingList.isEmpty()) {
            resumeDAO.insertTraining(dto.getRno(), trainingList);
        }
        return result;
    }
    
    @Override
    public List<ResumeEducationDTO> findEducationByRno(int rno) {
        return resumeDAO.findEducationByRno(rno);
    }

    @Override
    public List<ResumeCareerDTO> findCareerByRno(int rno) {
        return resumeDAO.findCareerByRno(rno);
    }

    @Override
    public List<String> findSkillNames(int rno) {
        return resumeDAO.findSkillNames(rno);
    }
    @Override
    public List<ResumeProjectDTO> findProjectByRno(int rno) {
        return resumeDAO.findProjectByRno(rno);
    }
    
    @Override
    public List<ResumeOtherDTO> findOtherByRno(int rno) {
        return resumeDAO.findOtherByRno(rno);
    }
    
    @Override
    public List<ResumeTrainingDTO> findTrainingByRno(int rno) {
        return resumeDAO.findTrainingByRno(rno);
    }

    @Override
    @Transactional
    public int deleteResume(int rno, int mno) {

        // ✅ 1) 지원내역(application) 먼저 삭제 (FK 자식)
        resumeDAO.deleteApplicationsByResume(rno);

        // ✅ 2) 이력서 하위 테이블 먼저 삭제
        resumeDAO.deleteSkills(rno);
        resumeDAO.deleteEducation(rno);
        resumeDAO.deleteCareer(rno);
        resumeDAO.deleteProject(rno);
        resumeDAO.deleteOther(rno);
        resumeDAO.deleteTraining(rno);

        // ✅ 3) 마지막에 resume 삭제
        return resumeDAO.deleteResume(rno, mno);
    }

    
    @Autowired
    private MemberDAO memberDAO; 

    @Override
    public MemberDTO getMemberInfo(String memail) {
        return memberDAO.findByMemail(memail); 
    }
    
    public ResumeDTO findOne(int rno) {
        return resumeDAO.findOne(rno); 
    }
    
    @Override
    public ResumeDTO findPublicForCompany(int rno) {
        return resumeDAO.findPublicForCompany(rno);
    }


}
