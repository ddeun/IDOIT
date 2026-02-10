package com.idoit.auth;

import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.idoit.dao.MemberDAO;
import com.idoit.dto.MemberDTO;

@Service
public class CustomUserDetailsService implements UserDetailsService {

    private final MemberDAO memberDAO;
    private final PasswordEncoder passwordEncoder;

    public CustomUserDetailsService(MemberDAO memberDAO,
                                    PasswordEncoder passwordEncoder) {
        this.memberDAO = memberDAO;
        this.passwordEncoder = passwordEncoder;
    }

    @Override
    public UserDetails loadUserByUsername(String memail)
            throws UsernameNotFoundException {

        MemberDTO member = memberDAO.findByMemail(memail);

        if (member == null) {
            throw new UsernameNotFoundException("존재하지 않는 사용자");
        }

        String role = (member.getMauth() == null ? "ROLE_USER" : member.getMauth())
                .trim().toUpperCase();
        System.out.println("✅ status = [" + member.getMstatus() + "]");

        boolean disabled =
                "WITHDRAWN".equalsIgnoreCase(member.getMstatus())
             || "withdrawn".equalsIgnoreCase(member.getMstatus())
             || "BLOCKED".equalsIgnoreCase(member.getMstatus());

        return User.withUsername(member.getMemail())
                .password(member.getMpasswd())
                .authorities(new SimpleGrantedAuthority(role))
                .disabled(disabled)   // ✅ 여기서 막힘
                .build();
    }
}
