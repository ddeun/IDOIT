package com.idoit.controller;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.idoit.dao.FaqDAO;
import com.idoit.dto.FaqDTO;

@Controller
public class FaqController {

    private final FaqDAO faqDAO;

    public FaqController(FaqDAO faqDAO) {
        this.faqDAO = faqDAO;
    }
    
    /* =========================
    	FAQ 메인
	    ========================= */
	 @GetMapping("/faq")
	 public String faqMain() {
	     return "faq/main";
 }


    /* =========================
       FAQ 목록 + 검색
       ========================= */
    @GetMapping("/faq/list")
    public String faqlist(
            @RequestParam(value = "keyword", required = false) String keyword,
            Model model) {

        List<FaqDTO> list;

        if (keyword != null && !keyword.isBlank()) {
            list = faqDAO.searchFaq(null, keyword);
        } else {
            list = faqDAO.selectAll();
        }

        // 카테고리별 그룹핑 (목록용)
        Map<String, List<FaqDTO>> faqMap =
                list.stream()
                    .collect(Collectors.groupingBy(FaqDTO::getFcategory));

        model.addAttribute("faqMap", faqMap);
        model.addAttribute("keyword", keyword);

        return "faq/list";
    }

    /* =========================
       FAQ 상세
       ========================= */
    @GetMapping("/faq/detail")
    public String detail(@RequestParam("fno") int fno, Model model) {
        model.addAttribute("faq", faqDAO.selectById(fno));
        return "faq/detail";
    }
}
