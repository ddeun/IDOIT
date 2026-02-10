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
import com.idoit.service.ApplicationService;
import com.idoit.service.Job_postingService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class CompanyApplicationController {

    private final ApplicationService applicationService;
    private final Job_postingService jobPostingService;

    /** ✅ 기업용: 특정 공고(jno) 지원자 목록 (내 회사 공고만) */
    @GetMapping("/company/applications")
    public String applicantsByPosting(@RequestParam("jno") int jno,
                                      Authentication auth,
                                      Model model,
                                      RedirectAttributes ra) {

        if (auth == null) return "redirect:/member/login";

        // 기업 권한 방어
        boolean isCompany = auth.getAuthorities().stream()
                .anyMatch(a -> a.getAuthority().equals("ROLE_COMPANY"));
        if (!isCompany) return "redirect:/member/login";

        int companyMno = getLoginMno(auth);

        // ✅ 내 회사 공고인지 검증 + 공고 정보 가져오기 (title 표시용)
        Job_postingDTO posting;
        try {
            posting = jobPostingService.detailOwnedByMno(companyMno, jno);
        } catch (Exception e) {
            ra.addFlashAttribute("msg", "내 회사 공고만 조회할 수 있습니다.");
            return "redirect:/company/postings";
        }

        // ✅ 해당 공고 지원자만
        List<ApplicationDTO> list = applicationService.findApplicantsByJnoOwned(jno, companyMno);

        model.addAttribute("posting", posting);
        model.addAttribute("jno", jno);
        model.addAttribute("list", list);

        return "company/application_manage";
    }

    /** ✅ 기업용: 합격/불합격 처리 (수정 후 같은 공고 화면으로 복귀) */
    @PostMapping("/application/company/status")
    public String updateStatus(@RequestParam("ano") int ano,
                               @RequestParam("status") String status,
                               @RequestParam("jno") int jno,
                               Authentication auth,
                               RedirectAttributes ra) {

        if (auth == null) return "redirect:/member/login";

        boolean isCompany = auth.getAuthorities().stream()
                .anyMatch(a -> a.getAuthority().equals("ROLE_COMPANY"));
        if (!isCompany) return "redirect:/member/login";

        // status 값 방어
        if (!"합격".equals(status) && !"불합격".equals(status)) {
            ra.addFlashAttribute("msg", "잘못된 상태값입니다.");
            return "redirect:/company/applications?jno=" + jno;
        }

        applicationService.updateStatus(ano, status);
        ra.addFlashAttribute("msg", "상태가 변경되었습니다: " + status);

        // ✅ 같은 공고의 지원자 목록으로 돌아가기
        return "redirect:/company/applications?jno=" + jno;
    }

    /** ✅ 로그인한 기업 mno 뽑기 (일반/카카오 소셜 모두) */
    private int getLoginMno(Authentication auth) {
        if (auth == null) throw new IllegalStateException("로그인 필요");

        String name = auth.getName();

        // 1) 일반 로그인: auth.getName() = memail
        if (name != null && name.contains("@")) {
            return jobPostingService.getMnoByMemail(name);
        }

        // 2) 카카오 로그인: OAuth2User.id로 memail 재구성
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
}
