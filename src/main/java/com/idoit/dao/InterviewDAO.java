package com.idoit.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.idoit.dto.InterviewDTO;

@Mapper
public interface InterviewDAO {
    List<InterviewDTO> list(Map<String, Object> param);
    InterviewDTO detail(int ino);
    int increaseView(int ino);

    int insert(InterviewDTO dto);

    int update(InterviewDTO dto);   
    int delete(int ino);           
}
