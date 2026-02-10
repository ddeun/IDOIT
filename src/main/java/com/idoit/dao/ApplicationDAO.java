package com.idoit.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.idoit.dto.ApplicationDTO;

@Mapper
public interface ApplicationDAO {

    int exists(@Param("mno") int mno,
               @Param("jno") int jno);

    int insert(@Param("mno") int mno,
               @Param("jno") int jno);

    int insertWithResume(@Param("mno") int mno,
                         @Param("jno") int jno,
                         @Param("rno") Integer rno);

    List<ApplicationDTO> findByMno(@Param("mno") int mno);

    // ✅ (수정) 기업용: 내 회사 공고의 지원자만
    List<ApplicationDTO> findByJnoOwned(@Param("jno") int jno,
                                        @Param("mno") int mno);

    int updateStatus(@Param("ano") int ano,
                     @Param("astatus") String astatus);

    int delete(@Param("ano") int ano,
               @Param("mno") int mno);
}
