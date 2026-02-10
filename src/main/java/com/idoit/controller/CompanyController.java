package com.idoit.controller;

import java.sql.Date;
import java.util.List;
import java.util.Map;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.idoit.dao.CompanyDAO;
import com.idoit.dto.CompanyDTO;
import com.idoit.dto.MemberDTO;
import com.idoit.service.Job_postingService;
import com.idoit.service.MemberService;

@Controller
public class CompanyController {
    private final MemberService memberService;
    private final CompanyDAO companyDAO;
    private final Job_postingService jobPostingService;

    public CompanyController(MemberService memberService, CompanyDAO companyDAO, Job_postingService jobPostingService) {
        this.memberService = memberService;
        this.companyDAO = companyDAO;
        this.jobPostingService = jobPostingService;
    }

    @GetMapping("/company/join")
    public String joinCompanyForm() {
        return "company/join";
    }

    @PostMapping("/company/join")
    public String joinCompany(MemberDTO member, CompanyDTO company) {
        member.setMtype("COMPANY");
        member.setMauth("ROLE_COMPANY");
        member.setMstatus("ACTIVE");

        if (member.getMname() == null || member.getMname().isBlank()) {
            member.setMname(company.getCname());
        }
        if (member.getMgender() == null) member.setMgender("NONE");
        if (member.getMtel() == null) member.setMtel("000-0000-0000");
        if (member.getMzipcode() == null) member.setMzipcode("00000");
        if (member.getMaddr() == null) member.setMaddr("기업");
        if (member.getMaddrdetail() == null) member.setMaddrdetail("기업");
        if (member.getMbirth() == null) member.setMbirth(Date.valueOf("1900-01-01"));

        memberService.join(member);

        int mno = member.getMno();
        company.setMno(mno);

        companyDAO.insertCompany(company);

        return "redirect:/member/login";
    }

    @PreAuthorize("hasRole('COMPANY')")
    @GetMapping("/company")
    public String companyHome() {
        return "redirect:/company/dashboard";
    }

    @PreAuthorize("hasRole('COMPANY')")
    @GetMapping("/company/dashboard")
    public String companyDashboard() {
        return "company/dashboard";
    }

    @PreAuthorize("hasRole('COMPANY')")
    @GetMapping("/company/postings")
    public String companyPostings(
            @RequestParam(value="q", required=false) String q,
            @RequestParam(value="page", defaultValue="1") int page,
            @RequestParam(value="size", defaultValue="20") int size,
            Authentication auth,
            Model model
    ) {
        if (q != null) q = q.trim();

        int mno = getLoginMno(auth);
        Map<String, Object> res = jobPostingService.listMyPostings(mno, q, page, size);

        model.addAttribute("q", q);
        model.addAttribute("page", res.get("page"));
        model.addAttribute("size", res.get("size"));
        model.addAttribute("total", res.get("total"));
        model.addAttribute("items", res.get("items"));

        return "company/posting_manage";
    }

    @PreAuthorize("hasRole('COMPANY')")
    @GetMapping("/company/mypage")
    public String companyMyPage(Authentication auth, Model model) {
        int mno = getLoginMno(auth);
        List<CompanyDTO> items = companyDAO.listByMno(mno);
        model.addAttribute("items", items);
        return "company/mypage";
    }

    @PreAuthorize("hasRole('COMPANY')")
    @GetMapping("/company/updateform")
    public String updateForm(@RequestParam("cno") int cno,
                             Authentication auth,
                             Model model) {
        int mno = getLoginMno(auth);

        CompanyDTO company = companyDAO.findOwnedCompany(mno, cno);
        if (company == null) {
            model.addAttribute("msg", "수정 권한이 없거나 회사가 존재하지 않습니다.");
            return "redirect:/company/mypage";
        }

        // ✅ JSP에서 ${c.xxx} 로 쓰게
        model.addAttribute("c", company);
        return "company/updateform";
    }

    // ✅ 부분 수정: 빈값이면 기존값 유지(merge)
    @PreAuthorize("hasRole('COMPANY')")
    @PostMapping("/company/update")
    public String update(CompanyDTO company,
                         Authentication auth,
                         RedirectAttributes ra) {

        int mno = getLoginMno(auth);
        company.setMno(mno);

        // ✅ DTO의 cno가 int라 null 체크가 안 됨 → 0/음수 방지
        if (company.getCno() <= 0) {
            ra.addFlashAttribute("msg", "cno가 올바르지 않습니다.");
            return "redirect:/company/mypage";
        }

        // 1) 기존 데이터(소유검증 포함)
        CompanyDTO origin = companyDAO.findOwnedCompany(mno, company.getCno());
        if (origin == null) {
            ra.addFlashAttribute("msg", "수정 권한이 없거나 회사가 존재하지 않습니다.");
            return "redirect:/company/mypage";
        }

        // 2) 빈값이면 기존값 유지 (문자열은 blank도 포함)
        if (isBlank(company.getCname())) company.setCname(origin.getCname());
        if (isBlank(company.getCbizno())) company.setCbizno(origin.getCbizno());
        if (isBlank(company.getCzipcode())) company.setCzipcode(origin.getCzipcode());
        if (isBlank(company.getCaddr())) company.setCaddr(origin.getCaddr());
        if (isBlank(company.getCaddrdetail())) company.setCaddrdetail(origin.getCaddrdetail());
        if (isBlank(company.getCpage())) company.setCpage(origin.getCpage());
        if (isBlank(company.getCcontent())) company.setCcontent(origin.getCcontent());

        // 이미지/설립일 같은건 폼에서 안 받으면 null로 들어올 수 있음 → 유지
        if (isBlank(company.getCimage())) company.setCimage(origin.getCimage());
        if (company.getCestablish() == null) company.setCestablish(origin.getCestablish());

        int updated = companyDAO.updateOwned(company);
        ra.addFlashAttribute("msg", updated > 0 ? "수정 완료" : "수정 실패");

        return "redirect:/company/mypage";
    }

    private boolean isBlank(String s) {
        return s == null || s.trim().isEmpty();
    }

    @RequestMapping("/company/jusopopup")
    public String jusopopup() {
        return "company/jusopopup";
    }

    private int getLoginMno(Authentication auth) {
        if (auth == null || auth.getName() == null || auth.getName().isBlank()) {
            throw new IllegalStateException("로그인 정보가 없습니다.");
        }
        return jobPostingService.getMnoByMemail(auth.getName());
    }
}

