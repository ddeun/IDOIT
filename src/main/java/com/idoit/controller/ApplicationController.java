package com.idoit.controller;

import java.util.List;

import org.springframework.security.core.Authentication;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.idoit.dto.ApplicationDTO;
import com.idoit.dto.Job_postingDTO;
import com.idoit.dto.ResumeDTO;
import com.idoit.service.ApplicationService;
import com.idoit.service.Job_postingService;
import com.idoit.service.ResumeService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class ApplicationController {

    private final ApplicationService applicationService;
    private final Job_postingService jobPostingService;
    private final ResumeService resumeService;

    // ✅ 내 지원내역 (유저가 합격/불합격 "통보" 받는 화면)
    // URL: /application/my
    @GetMapping("/application/my")
    public String myApplications(Authentication auth, Model model) {
        if (auth == null) return "redirect:/member/login";

        int mno = getLoginMno(auth);

        List<ApplicationDTO> list = applicationService.findByMno(mno);
        model.addAttribute("list", list);

        // JSP에서 메시지 보여주고 싶으면 사용 가능
        // model.addAttribute("msg", ""); 
        return "application/my";
    }

    // ✅ 지원서 페이지 (이력서 선택)
    @GetMapping("/application/applyform")
    public String applyForm(@RequestParam("jno") int jno,
                            Authentication auth,
                            Model model,
                            RedirectAttributes ra) {

        if (auth == null) return "redirect:/member/login";

        int mno = getLoginMno(auth);

        // 이미 지원했으면 상세로 돌려보내기
        if (applicationService.exists(mno, jno)) {
            ra.addFlashAttribute("msg", "이미 지원한 공고입니다.");
            return "redirect:/job_posting/detail/" + jno;
        }

        Job_postingDTO item = jobPostingService.detail(jno);
        List<ResumeDTO> resumes = resumeService.findByMno(mno);

        model.addAttribute("item", item);
        model.addAttribute("resumes", resumes);

        return "application/applyform";
    }

    // ✅ 지원 제출 (이력서 선택 optional)
    @PostMapping("/application/apply")
    public String apply(@RequestParam("jno") int jno,
                        @RequestParam(value = "rno", required = false) Integer rno,
                        Authentication auth,
                        RedirectAttributes ra) {

        if (auth == null) return "redirect:/member/login";

        int mno = getLoginMno(auth);

        boolean ok;
        if (rno == null) {
            ok = applicationService.apply(mno, jno);
        } else {
            ok = applicationService.applyWithResume(mno, jno, rno);
        }

        ra.addFlashAttribute("msg", ok ? "지원이 완료되었습니다." : "이미 지원한 공고입니다.");
        return "redirect:/application/success?jno=" + jno;
    }

    // ✅ 지원 완료 페이지
    @GetMapping("/application/success")
    public String success(@RequestParam("jno") int jno, Model model) {
        model.addAttribute("jno", jno);
        return "application/success";
    }

    // ✅ 카카오/일반 로그인 mno 통일 (카카오만)
    private int getLoginMno(Authentication auth) {
        if (auth == null) throw new IllegalStateException("로그인 정보가 없습니다.");

        String name = auth.getName();

        // 1) 일반 로그인: auth.getName() = memail
        if (name != null && name.contains("@")) {
            return jobPostingService.getMnoByMemail(name);
        }

        // 2) 카카오 로그인: auth.getName() = nickname → OAuth2User.id로 memail 재구성
        Object principal = auth.getPrincipal();
        if (principal instanceof OAuth2User oAuth2User) {
            Object idObj = oAuth2User.getAttribute("id"); // kakao id
            if (idObj != null) {
                String providerId = String.valueOf(idObj);
                String memail = "kakao_" + providerId + "@idoit.social";
                return jobPostingService.getMnoByMemail(memail);
            }
        }

        throw new IllegalStateException("로그인 사용자 식별 실패");
    }
}
