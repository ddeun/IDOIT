package com.idoit.dao;

import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import com.idoit.dto.IndexRow;

@Mapper
public interface SearchIndexDAO {
    List<IndexRow> selectJobPostingForIndex();
    List<IndexRow> selectInterviewForIndex();
    List<IndexRow> selectBoardForIndex();
    List<IndexRow> selectNoticeForIndex();
    List<IndexRow> selectFaqForIndex();
}
