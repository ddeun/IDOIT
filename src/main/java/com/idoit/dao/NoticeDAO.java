package com.idoit.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.idoit.dto.NoticeDTO;

@Mapper
public interface NoticeDAO {
    List<NoticeDTO> selectNoticeList();
    NoticeDTO selectNotice(int nno);
    void insertNotice(NoticeDTO dto);
    void updateNotice(NoticeDTO dto);
    void deleteNotice(int nno);
    
    NoticeDTO selectPrevNotice(int nno);
    NoticeDTO selectNextNotice(int nno);
}