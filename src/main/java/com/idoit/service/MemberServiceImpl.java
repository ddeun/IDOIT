package com.idoit.service;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.idoit.dao.MemberDAO;
import com.idoit.dto.MemberDTO;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class MemberServiceImpl implements MemberService{
	private final MemberDAO memberDAO;
    private final PasswordEncoder passwordEncoder;
    
    @Override
    public void join(MemberDTO member) {
        
    	if(memberDAO.existsByMemail(member.getMemail()) > 0) {
    		throw new IllegalArgumentException("이미 사용 중인 이메일 입니다.");
    	}
    	String encodedPw = passwordEncoder.encode(member.getMpasswd());
        member.setMpasswd(encodedPw);
        
        memberDAO.insertMember(member);
    }
    
    @Override
    public boolean isEmailDuplicate(String memail) {
        return memberDAO.existsByMemail(memail) > 0;
    }

}
