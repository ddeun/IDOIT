package com.idoit.service;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.idoit.dao.FaqDAO;
import com.idoit.dto.FaqDTO;
import com.idoit.util.TxAfterCommit;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class FaqService {

    private final FaqDAO faqDAO;
    private final SearchSyncService searchSyncService;

    @Transactional
    public int create(FaqDTO dto) {
        faqDAO.insertFaq(dto); // selectKey로 fno 채워짐
        int pk = dto.getFno();

        TxAfterCommit.run(() -> {
            try {
                searchSyncService.upsert(
                    "search_all",
                    "FAQ",
                    (long) pk,
                    dto.getFquestion(),
                    dto.getFanswer()
                );
            } catch (Exception e) {
                e.printStackTrace();
            }
        });

        return pk;
    }

    @Transactional
    public void update(FaqDTO dto) {
        faqDAO.updateFaq(dto);

        TxAfterCommit.run(() -> {
            try {
                searchSyncService.upsert(
                    "search_all",
                    "FAQ",
                    (long) dto.getFno(),
                    dto.getFquestion(),
                    dto.getFanswer()
                );
            } catch (Exception e) {
                e.printStackTrace();
            }
        });
    }

    @Transactional
    public void delete(int fno) {
        faqDAO.deleteFaq(fno);

        TxAfterCommit.run(() -> {
            try {
                searchSyncService.delete("search_all", "FAQ", (long) fno);
            } catch (Exception e) {
                e.printStackTrace();
            }
        });
    }
}

