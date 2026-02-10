package com.idoit.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.idoit.dto.FaqDTO;

@Mapper
public interface FaqDAO {
    List<FaqDTO> selectAll();
    FaqDTO selectById(int fno);
    void insertFaq(FaqDTO dto);
    void updateFaq(FaqDTO dto);
    void deleteFaq(int fno);
    
    List<FaqDTO> searchFaq(
    		@Param("fcategory") String fcategory,
            @Param("keyword") String keyword
    	);
}
