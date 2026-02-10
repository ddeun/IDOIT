package com.idoit.controller;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import com.idoit.dao.FaqDAO;
import com.idoit.dto.FaqDTO;

@Controller
@RequestMapping("/admin/faq")
@PreAuthorize("hasRole('ADMIN')")
public class AdminFaqController {

    private final FaqDAO faqDAO;

    public AdminFaqController(FaqDAO faqDAO) {
        this.faqDAO = faqDAO;
    }

    /* =========================
       FAQ 관리 목록
       ========================= */
    @GetMapping("")
    public String manage(Model model) {
        model.addAttribute("list", faqDAO.selectAll());
        return "admin/faq/manage";
    }

    /* =========================
       FAQ 작성
       ========================= */
    @GetMapping("/write")
    public String writeForm() {
        return "admin/faq/write";
    }

    @PostMapping("/write")
    public String write(FaqDTO dto) {
        faqDAO.insertFaq(dto);
        return "redirect:/admin/faq";
    }

    /* =========================
       FAQ 수정
       ========================= */
    @GetMapping("/update")
    public String updateForm(@RequestParam("fno") int fno, Model model) {
        model.addAttribute("faq", faqDAO.selectById(fno));
        return "admin/faq/update";
    }

    @PostMapping("/update")
    public String update(FaqDTO dto) {
        faqDAO.updateFaq(dto);
        return "redirect:/admin/faq";
    }

    /* =========================
       FAQ 삭제
       ========================= */
    @PostMapping("/delete")
    public String delete(@RequestParam("fno") int fno) {
        faqDAO.deleteFaq(fno);
        return "redirect:/admin/faq";
    }
}
