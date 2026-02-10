package com.idoit.service;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.idoit.dao.NoticeDAO;
import com.idoit.dto.NoticeDTO;
import com.idoit.util.TxAfterCommit;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class NoticeService {

    private final NoticeDAO noticeDAO;
    private final SearchSyncService searchSyncService;

    @Transactional
    public int create(NoticeDTO dto) {
        noticeDAO.insertNotice(dto); // selectKey로 nno 채워져 있어야 함
        int pk = dto.getNno();

        TxAfterCommit.run(() -> {
            try {
                searchSyncService.upsert(
                    "search_all",
                    "NOTICE",
                    (long) pk,
                    dto.getNtitle(),
                    dto.getNcontent()
                );
            } catch (Exception e) {
                e.printStackTrace();
            }
        });

        return pk;
    }

    @Transactional
    public void update(NoticeDTO dto) {
        noticeDAO.updateNotice(dto);

        TxAfterCommit.run(() -> {
            try {
                searchSyncService.upsert(
                    "search_all",
                    "NOTICE",
                    (long) dto.getNno(),
                    dto.getNtitle(),
                    dto.getNcontent()
                );
            } catch (Exception e) {
                e.printStackTrace();
            }
        });
    }

    @Transactional
    public void delete(int nno) {
        noticeDAO.deleteNotice(nno);

        TxAfterCommit.run(() -> {
            try {
                searchSyncService.delete("search_all", "NOTICE", (long) nno);
            } catch (Exception e) {
                e.printStackTrace();
            }
        });
    }
}
