package com.idoit.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.idoit.dto.MemberDTO;

@Mapper
public interface AdminDAO {
    List<MemberDTO> findPersonalMembers();
    
    void updateRole(@Param("memail") String memail,
            @Param("role") String role);
    void updateMemberStatus(@Param("mno") Long mno,
            @Param("mstatus") String mstatus);

    void withdrawMember(@Param("mno") Long mno);

}
