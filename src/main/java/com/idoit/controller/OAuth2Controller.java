package com.idoit.controller;

import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import com.idoit.dao.MemberDAO;
import com.idoit.dto.MemberDTO;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class OAuth2Controller {

    private final MemberDAO memberDAO;

    @GetMapping("/oauth2/success")
    public String oauth2Success(@AuthenticationPrincipal OAuth2User oAuth2User) {
        Object idObj = oAuth2User.getAttribute("id");
        String providerId = String.valueOf(idObj);

        MemberDTO member = memberDAO.findByProvider("kakao", providerId);

        if (member == null) return "redirect:/member/join"; // or 원하는 처리

        boolean needSocialEdit =
                "000-0000-0000".equals(member.getMtel()) ||
                "00000".equals(member.getMzipcode()) ||
                "소셜로그인".equals(member.getMaddr());

        return needSocialEdit ? "redirect:/member/mypage/social-edit" : "redirect:/";
    }

}

