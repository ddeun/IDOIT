package com.idoit.auth;

import java.util.Collections;
import java.util.Map;

import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.oauth2.client.userinfo.DefaultOAuth2UserService;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserRequest;
import org.springframework.security.oauth2.core.user.DefaultOAuth2User;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Service;
import org.springframework.security.authentication.DisabledException;

import com.idoit.dao.MemberDAO;
import com.idoit.dto.MemberDTO;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class CustomOAuth2UserService extends DefaultOAuth2UserService {

    private final MemberDAO memberDAO;
    private final PasswordEncoder passwordEncoder;

    @Override
    public OAuth2User loadUser(OAuth2UserRequest userRequest) {

        OAuth2User oAuth2User = super.loadUser(userRequest);
        Map<String, Object> attrs = new java.util.HashMap<>(oAuth2User.getAttributes());

        String provider = userRequest.getClientRegistration().getRegistrationId(); // kakao
        String providerId = String.valueOf(attrs.get("id"));

        // 닉네임 추출
        String nickname = null;

        Map<String, Object> kakaoAccount = (Map<String, Object>) attrs.get("kakao_account");
        if (kakaoAccount != null) {
            Map<String, Object> profile = (Map<String, Object>) kakaoAccount.get("profile");
            if (profile != null) nickname = (String) profile.get("nickname");
        }
        if (nickname != null) attrs.put("nickname", nickname);

        // DB 조회
        MemberDTO member = memberDAO.findByProvider(provider, providerId);

        // 없으면 자동가입 (mapper insert에서 기본값 처리하는 버전)
        if (member == null) {
            MemberDTO dto = new MemberDTO();
            dto.setMprovider(provider);
            dto.setMproviderId(providerId);

            dto.setMemail(provider + "_" + providerId + "@idoit.social");
            dto.setMpasswd(passwordEncoder.encode("SOCIAL_LOGIN"));
            dto.setMname(nickname != null ? nickname : "kakao_" + providerId);

            memberDAO.insertSocialMember(dto);
            member = memberDAO.findByProvider(provider, providerId);
        }
        
        // ✅ 상태 체크 (탈퇴/정지)
        if (member.getMstatus() != null) {
            if ("WITHDRAWN".equalsIgnoreCase(member.getMstatus())) {
                throw new DisabledException("탈퇴한 회원");
            }
            if ("BLOCKED".equalsIgnoreCase(member.getMstatus())) {
                throw new DisabledException("비활성화(정지) 회원");
            }
        }

        return new DefaultOAuth2User(
            Collections.singleton(new SimpleGrantedAuthority(member.getMauth())),
            attrs,
            "nickname"
        );
        
    }
}
