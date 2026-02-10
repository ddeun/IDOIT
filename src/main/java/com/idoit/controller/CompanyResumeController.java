package com.idoit.controller;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

import com.idoit.dao.CompanyResumeDAO;
import com.idoit.dto.CompanyResumeViewDTO;
import com.idoit.service.Job_postingService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/company")
public class CompanyResumeController {

    private final CompanyResumeDAO companyResumeDAO;
    private final Job_postingService jobPostingService;
    private final com.idoit.dao.ResumeDAO resumeDAO;
    private final com.idoit.dao.MemberDAO memberDAO;
    private final com.idoit.service.ResumeService resumeService;


    @PreAuthorize("hasRole('COMPANY')")
    @GetMapping("/resume/{ano}")
    public String viewResume(@PathVariable("ano") int ano,
                             Authentication auth,
                             Model model) {

        int companyMno = getLoginMno(auth);

        System.out.println("[CompanyResume] loginMno=" + companyMno + ", ano=" + ano);

        CompanyResumeViewDTO dto = companyResumeDAO.findResumeByAnoOwned(ano, companyMno);

        System.out.println("[CompanyResume] dto=" + dto);

        if (dto == null) {
            model.addAttribute("msg", "해당 지원건이 없거나(ano 오류), 내 회사 공고 지원이 아닙니다.");
            return "company/resume_view";
        }

        // 지원할 때 rno를 선택 안 한 경우 or resume 테이블에 레코드가 없는 경우
        if (dto.getRno() == null) {
            model.addAttribute("msg", "이 지원건에는 연결된 이력서(rno)가 없습니다.");
            model.addAttribute("r", dto); // 그래도 공고/지원자 정보는 보여줄 수 있게
            return "company/resume_view";
        }

        model.addAttribute("r", dto);
        return "company/resume_view";
    }

    private int getLoginMno(Authentication auth) {
        if (auth == null) throw new IllegalStateException("로그인 필요");

        String name = auth.getName();
        if (name != null && name.contains("@")) {
            return jobPostingService.getMnoByMemail(name);
        }

        Object principal = auth.getPrincipal();
        if (principal instanceof OAuth2User oAuth2User) {
            Object idObj = oAuth2User.getAttribute("id");
            if (idObj != null) {
                String providerId = String.valueOf(idObj);
                String memail = "kakao_" + providerId + "@idoit.social";
                return jobPostingService.getMnoByMemail(memail);
            }
        }

        throw new IllegalStateException("로그인 사용자 식별 실패");
    }
    
    @PreAuthorize("hasRole('COMPANY')")
    @GetMapping("/resume/{ano}/detail")
    public String viewResumeDetailLikeUser(@PathVariable("ano") int ano,
                                           Authentication auth,
                                           Model model) {

        int companyMno = getLoginMno(auth);

        CompanyResumeViewDTO dto = companyResumeDAO.findResumeByAnoOwned(ano, companyMno);
        if (dto == null) {
            model.addAttribute("msg", "해당 지원건이 없거나 내 회사 공고 지원이 아닙니다.");
            return "company/resume_view";
        }
        if (dto.getRno() == null) {
            model.addAttribute("msg", "이 지원건에는 연결된 이력서(rno)가 없습니다.");
            model.addAttribute("r", dto);
            return "company/resume_view";
        }

        int rno = dto.getRno();
        int mno = dto.getApplicantMno();

        // ✅ resume/detail.jsp에서 쓰는 모델 그대로 채우기
        var resume = resumeDAO.findOne(rno);
        var member = memberDAO.findByMno(mno);

        model.addAttribute("resume", resume);
        model.addAttribute("member", member);

        model.addAttribute("skills", resumeService.findSkillNames(rno));
        model.addAttribute("educations", resumeService.findEducationByRno(rno));
        model.addAttribute("careers", resumeService.findCareerByRno(rno));
        model.addAttribute("projects", resumeService.findProjectByRno(rno));
        model.addAttribute("others", resumeService.findOtherByRno(rno));
        model.addAttribute("trainings", resumeService.findTrainingByRno(rno));

        // (선택) 화면 상단에 공고/지원번호 같은거 표시하고 싶으면 dto도 같이
        model.addAttribute("r", dto);

        // ✅ 기존 상세 페이지 그대로 사용
        return "resume/detail";
    }
}
