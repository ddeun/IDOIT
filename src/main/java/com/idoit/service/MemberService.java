package com.idoit.service;

import com.idoit.dto.MemberDTO;

public interface MemberService {
	void join(MemberDTO member);
    boolean isEmailDuplicate(String memail);
}
