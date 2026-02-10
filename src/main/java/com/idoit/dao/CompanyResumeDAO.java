package com.idoit.dao;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.idoit.dto.CompanyResumeViewDTO;

@Mapper
public interface CompanyResumeDAO {

    CompanyResumeViewDTO findResumeByAnoOwned(@Param("ano") int ano,
                                             @Param("companyMno") int companyMno);
}
