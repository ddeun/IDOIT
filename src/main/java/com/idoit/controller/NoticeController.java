package com.idoit.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.idoit.dao.NoticeDAO;

@Controller
@RequestMapping("/notice")
public class NoticeController {

    private final NoticeDAO noticeDAO;

    public NoticeController(NoticeDAO noticeDAO) {
        this.noticeDAO = noticeDAO;
    }

    /* =========================
       공지 목록 (사용자)
       ========================= */
    @GetMapping("/list")
    public String list(Model model) {
        model.addAttribute("list", noticeDAO.selectNoticeList());
        return "notice/list";
    }

    /* =========================
       공지 상세 (사용자/관리자 공용, 읽기 전용)
       ========================= */
    @GetMapping("/detail")
    public String detail(@RequestParam("nno") int nno, Model model) {
        model.addAttribute("notice", noticeDAO.selectNotice(nno));
        
        model.addAttribute("prev", noticeDAO.selectPrevNotice(nno));
        model.addAttribute("next", noticeDAO.selectNextNotice(nno));
        
        return "notice/detail";
    }
}
