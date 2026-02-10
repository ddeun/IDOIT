package com.idoit.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.idoit.dao.Job_postingDAO;
import com.idoit.dao.NoticeDAO;
import com.idoit.dto.Job_postingDTO;
import com.idoit.dto.NoticeDTO;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class MainController {

    private final Job_postingDAO jobPostingDAO;
    private final NoticeDAO noticeDAO;

    @GetMapping("/")
    public String home(Model model) {

        List<Job_postingDTO> featuredJobs = jobPostingDAO.selectFeatured(); // 3개
        List<Job_postingDTO> latestJobs   = jobPostingDAO.selectLatest10(); // 10개
        List<NoticeDTO> notices = noticeDAO.selectNoticeList(); // 기존 전체리스트면, JSP에서 3~5개만 잘라서 보여도 됨

        model.addAttribute("featuredJobs", featuredJobs);
        model.addAttribute("latestJobs", latestJobs);
        model.addAttribute("notices", notices);

        return "main";
    }
}

