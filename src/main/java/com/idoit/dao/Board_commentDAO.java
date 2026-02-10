package com.idoit.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.idoit.dto.Board_commentDTO;

@Mapper
public interface Board_commentDAO {
    List<Board_commentDTO> selectCommentList(int bno);
    int insertComment(Board_commentDTO dto);
    int updateComment(Board_commentDTO dto);
    int deleteComment(int bcno);
    int deleteCommentByBoard(int bno);
}
