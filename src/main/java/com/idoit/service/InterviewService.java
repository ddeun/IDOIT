package com.idoit.service;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.idoit.dao.InterviewDAO;
import com.idoit.dto.InterviewDTO;
import com.idoit.util.TxAfterCommit;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class InterviewService {

    private final InterviewDAO interviewDAO;
    private final SearchSyncService searchSyncService;

    @Transactional
    public int create(InterviewDTO dto) {
        interviewDAO.insert(dto); // selectKey로 ino 채워져 있어야 함
        int pk = dto.getIno();

        TxAfterCommit.run(() -> {
            try {
                searchSyncService.upsert(
                    "search_all",
                    "INTERVIEW",
                    (long) pk,
                    dto.getItitle(),
                    dto.getIcontent()
                );
            } catch (Exception e) {
                e.printStackTrace();
            }
        });

        return pk;
    }

    @Transactional
    public void update(InterviewDTO dto) {
        interviewDAO.update(dto);

        TxAfterCommit.run(() -> {
            try {
                searchSyncService.upsert(
                    "search_all",
                    "INTERVIEW",
                    (long) dto.getIno(),
                    dto.getItitle(),
                    dto.getIcontent()
                );
            } catch (Exception e) {
                e.printStackTrace();
            }
        });
    }

    @Transactional
    public void delete(int ino) {
        interviewDAO.delete(ino);

        TxAfterCommit.run(() -> {
            try {
                searchSyncService.delete("search_all", "INTERVIEW", (long) ino);
            } catch (Exception e) {
                e.printStackTrace();
            }
        });
    }
}
