package com.idoit.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.idoit.dto.Job_postingDTO;

@Mapper
public interface Job_postingDAO {
    int count(Map<String, Object> param);
    List<Job_postingDTO> list(Map<String, Object> param);

    Job_postingDTO detail(@Param("jno") int jno);

    void insert(Job_postingDTO dto);

    Job_postingDTO detailOwnedByCno(@Param("jno") int jno, @Param("cno") int cno);

    int update(Job_postingDTO dto);

    int deleteOwnedByCno(@Param("jno") int jno, @Param("cno") int cno);
    
    List<Job_postingDTO> findPending();
    
    int approve(long jno);
    int reject(long jno);
    
    List<Job_postingDTO> selectFeatured();  // 메인 슬라이더용 3개
    List<Job_postingDTO> selectLatest10();  // 메인 리스트 10개
    
    // ✅ (추가) 내 공고 카운트/리스트: 로그인한 기업 mno 기준
    int countByCompanyOwner(Map<String, Object> param);
    List<Job_postingDTO> listByCompanyOwner(Map<String, Object> param);
    
    int softDeleteOwnedByCno(@Param("jno") int jno, @Param("cno") int cno);

}
