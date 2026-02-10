package com.idoit.dao;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.idoit.dto.MemberDTO;

@Mapper
public interface MemberDAO {
	int insertMember(MemberDTO member);
	MemberDTO findByMemail(String memail);
	int existsByMemail(String memail);
	MemberDTO findByProvider(@Param("provider") String provider,
            @Param("providerId") String providerId);
	void insertSocialMember(MemberDTO dto);
	void updateMemberInfo(MemberDTO dto);
	void deleteMember(int mno);
	MemberDTO selectMemberByMno(int mno);
	MemberDTO passwordCheck(
            @Param("mno") int mno,
            @Param("mpasswd") String mpasswd
        );
	public MemberDTO findByMid(String memail); // 로그인용 조회
	
	MemberDTO findByMno(int mno);
}
