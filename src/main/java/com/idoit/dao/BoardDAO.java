package com.idoit.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.idoit.dto.BoardDTO;

@Mapper
public interface BoardDAO {	
    List<BoardDTO> selectBoardList();
    List<BoardDTO> selectBoardListByType(String btype);
    BoardDTO selectBoard(int bno);
    int updateViewCount(int bno);
    int insertBoard(BoardDTO dto);
    int updateBoard(BoardDTO dto);
    int deleteBoard(int bno);
    
    List<BoardDTO> searchBoardList(
    		@Param("btype") String btype,
    		@Param("searchType") String searchType,
    		@Param("keyword") String keyword
    	);
}
