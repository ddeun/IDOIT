package com.idoit.service;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.idoit.dao.BoardDAO;
import com.idoit.dao.Board_commentDAO;
import com.idoit.dto.BoardDTO;
import com.idoit.util.FileDeleteUtil;
import com.idoit.util.TxAfterCommit;

@Service
public class BoardService {

    private final BoardDAO boardDAO;
    private final Board_commentDAO boardCommentDAO;
    private final SearchSyncService searchSyncService;
    private final TxAfterCommit txAfterCommit;

    public BoardService(BoardDAO boardDAO,
                        Board_commentDAO boardCommentDAO,
                        SearchSyncService searchSyncService,
                        TxAfterCommit txAfterCommit) {
        this.boardDAO = boardDAO;
        this.boardCommentDAO = boardCommentDAO;
        this.searchSyncService = searchSyncService;
        this.txAfterCommit = txAfterCommit;
    }

    /** 글 작성: DB insert 성공 후 ES upsert */
    @Transactional
    public void write(BoardDTO dto) {
        boardDAO.insertBoard(dto); // selectKey로 dto.bno 세팅됨

        final long pk = (long) dto.getBno(); // ✅ int -> long 캐스팅
        final String title = dto.getBtitle();
        final String content = dto.getBcontent();

        txAfterCommit.run(() -> {
            try {
                searchSyncService.upsert(
                        SearchSyncService.IDX_BOARD,
                        SearchSyncService.T_BOARD,
                        pk,
                        title,
                        content
                );
            } catch (Exception e) {
                e.printStackTrace();
            }
        });
    }

    /** 글 수정: DB update 성공 후 ES upsert(덮어쓰기) */
    @Transactional
    public void update(BoardDTO dto) {
        boardDAO.updateBoard(dto);

        final long pk = (long) dto.getBno();
        final String title = dto.getBtitle();
        final String content = dto.getBcontent();

        txAfterCommit.run(() -> {
            try {
                searchSyncService.upsert(
                        SearchSyncService.IDX_BOARD,
                        SearchSyncService.T_BOARD,
                        pk,
                        title,
                        content
                );
            } catch (Exception e) {
                e.printStackTrace();
            }
        });
    }

    /** 글 삭제: 댓글/이미지 정리 + DB delete 성공 후 ES delete */
    @Transactional
    public void delete(int bno) {
        BoardDTO board = boardDAO.selectBoard(bno);
        if (board == null) return;

        // 이미지 삭제(기존 컨트롤러 로직 유지)
        String content = board.getBcontent();
        if (content != null && !content.isBlank()) {
            FileDeleteUtil.deleteImagesFromContent(content);
        }

        // 댓글 → 게시글 삭제
        boardCommentDAO.deleteCommentByBoard(bno);
        boardDAO.deleteBoard(bno);

        final long pk = (long) bno;

        txAfterCommit.run(() -> {
            try {
                searchSyncService.delete(
                        SearchSyncService.IDX_BOARD,
                        SearchSyncService.T_BOARD,
                        pk
                );
            } catch (Exception e) {
                e.printStackTrace();
            }
        });
    }
}
