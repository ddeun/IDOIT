package com.idoit.controller;

import org.springframework.security.core.Authentication;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import com.idoit.dao.MemberDAO;
import com.idoit.dto.MemberDTO;
import com.idoit.service.MemberService;

@Controller
public class MemberController {
	
    private final MemberService memberService;
    private final MemberDAO memberDAO;
    
    public MemberController(MemberService memberService, MemberDAO memberDAO) {
        this.memberService = memberService;
        this.memberDAO = memberDAO;
    }

    @RequestMapping("/member/login")
    public String login() {
        return "member/login";
    }

    @GetMapping("/member/join")
    public String joinForm() {
        return "member/join";
    }

    @PostMapping("/member/join")
    public String join(MemberDTO member) {
        member.setMtype("PERSONAL");
        member.setMauth("ROLE_USER");
        member.setMstatus("ACTIVE");

        memberService.join(member);
        return "redirect:/member/login";
    }
    
    private MemberDTO getLoginMember(Authentication authentication) {
        Object principal = authentication.getPrincipal();

        // 소셜 로그인
        if (principal instanceof org.springframework.security.oauth2.core.user.OAuth2User oAuth2User) {
            Object idObj = oAuth2User.getAttribute("id"); // Long일 수 있음
            String providerId = String.valueOf(idObj);
            return memberDAO.findByProvider("kakao", providerId);
        }

        // 일반 로그인
        String email = authentication.getName();
        return memberDAO.findByMemail(email);
    }
    
    @GetMapping("/member/mypage")
    public String mypage(Authentication authentication, Model model) {

        Object principal = authentication.getPrincipal();
        MemberDTO member;

        if (principal instanceof org.springframework.security.oauth2.core.user.OAuth2User oAuth2User) {
        	Object idObj = oAuth2User.getAttribute("id"); 
            String providerId = String.valueOf(idObj);  
            member = memberDAO.findByProvider("kakao", providerId);
        } else {
            String email = authentication.getName();
            member = memberDAO.findByMemail(email);
        }

        model.addAttribute("member", member);
        return "member/mypage"; // /WEB-INF/views/member/mypage.jsp
    }
    
    @GetMapping("/member/mypage/edit")
    public String mypageEdit(Authentication authentication, Model model) {
        MemberDTO member = getLoginMember(authentication);
        model.addAttribute("member", member);
        return "member/mypage_edit";
    }
    @PostMapping("/member/mypage/edit")
    public String mypageEditSubmit(MemberDTO form, Authentication authentication) {
        MemberDTO me = getLoginMember(authentication);  // 로그인한 사람 DB정보

        form.setMno(me.getMno());       // 수정 대상 고정
        memberDAO.updateMemberInfo(form);

        return "redirect:/member/mypage";
    }
    @GetMapping("/member/mypage/social-edit")
    public String socialEdit(Authentication authentication, Model model) {
    	Object principal = authentication.getPrincipal();

        // ✅ 소셜 로그인 아니면 막기(메인/마이페이지로 보내기)
        if (!(principal instanceof OAuth2User oAuth2User)) {
            return "redirect:/member/mypage"; // 또는 "/"
        }

        Long id = oAuth2User.getAttribute("id");
        String providerId = String.valueOf(id);
        MemberDTO member = memberDAO.findByProvider("kakao", providerId);

        model.addAttribute("member", member);
        return "member/mypage_social_edit";
    }

    @PostMapping("/member/mypage/social-edit")
    public String socialEditSubmit(MemberDTO form, Authentication authentication) {
    	 Object principal = authentication.getPrincipal();

    	    if (!(principal instanceof OAuth2User oAuth2User)) {
    	        return "redirect:/member/mypage";
    	    }

    	    Long id = oAuth2User.getAttribute("id");
    	    String providerId = String.valueOf(id);
    	    MemberDTO me = memberDAO.findByProvider("kakao", providerId);

    	    form.setMno(me.getMno());
    	    memberDAO.updateMemberInfo(form);

    	    return "redirect:/member/mypage";
    }
    
    @PostMapping("/member/mypage/withdraw")
    public String withdraw(Authentication authentication,
                           jakarta.servlet.http.HttpServletRequest request,
                           jakarta.servlet.http.HttpServletResponse response) {

        MemberDTO me = getLoginMember(authentication);
        if (me == null) {
            return "redirect:/";
        }

        // DB 삭제
        memberDAO.deleteMember(me.getMno());

        // 세션 무효화
        request.getSession().invalidate();

        // 시큐리티 로그아웃
        try {
            request.logout();
        } catch (Exception e) {
            e.printStackTrace();
        }

        // 홈으로
        return "redirect:/";
    }
    
    @RequestMapping("/member/jusopopup")
    public String jusopopup() {
        return "member/jusopopup";
    }
    
    @RequestMapping("/member/mypage/jusopopup")
    public String mypage_jusopopup() {
        return "member/jusopopup";
    }
    
    @RequestMapping("/member/mypage/social-edit/jusopopup")
    public String socal_jusopopup() {
        return "member/jusopopup";
    }
}
