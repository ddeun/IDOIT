package com.idoit.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.idoit.dto.CompanyDTO;

@Mapper
public interface CompanyDAO {

    // 기존(남겨도 됨)
    CompanyDTO findByMno(@Param("mno") int mno);

    // ✅ 추가: 한 계정(mno)에 여러 회사
    List<CompanyDTO> listByMno(@Param("mno") int mno);

    // ✅ 추가: 소유 검증(내 mno 소유 회사가 맞는지)
    int countOwned(@Param("mno") int mno, @Param("cno") int cno);

    // ✅ 추가: updateform용 (선택된 회사 1개 표시)
    CompanyDTO findOwnedCompany(@Param("mno") int mno, @Param("cno") int cno);
    
    void insertCompany(CompanyDTO company);
    CompanyDTO findByCbizno(String cbizno);
    
    int updateOwned(CompanyDTO company);
}
