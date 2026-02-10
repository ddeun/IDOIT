package com.idoit.controller;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import com.idoit.dto.SearchResultRow;
import com.idoit.service.MainSearchService;

@Controller
@RequestMapping("/search_log")
public class MainSearchController {

    private final MainSearchService mainSearchService;

    public MainSearchController(MainSearchService mainSearchService) {
        this.mainSearchService = mainSearchService;
    }

    @GetMapping("/main")
    public String main(@RequestParam(value="keyword", required=false) String keyword,
                       @RequestParam(value="type", required=false) String type,
                       Model model) throws Exception {

        Map<String, List<SearchResultRow>> grouped = mainSearchService.searchGrouped(keyword, 20);

        model.addAttribute("keyword", keyword == null ? "" : keyword.trim());
        model.addAttribute("type", type == null ? "" : type.trim().toUpperCase());

        model.addAttribute("jobList", grouped.get("JOB"));
        model.addAttribute("boardList", grouped.get("BOARD"));
        model.addAttribute("interviewList", grouped.get("INTERVIEW"));
        model.addAttribute("noticeList", grouped.get("NOTICE"));
        model.addAttribute("faqList", grouped.get("FAQ"));

        return "search_log/main";
    }

}

