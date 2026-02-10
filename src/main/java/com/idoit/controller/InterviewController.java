package com.idoit.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import com.idoit.dao.InterviewDAO;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@Controller
@RequestMapping("/interview")
public class InterviewController {

    @Autowired
    private InterviewDAO interviewDAO;

    @GetMapping("/list")
    public String list(@RequestParam(name="keyword", required=false) String keyword,
                       @RequestParam(name="categoryKey", required=false) String categoryKey,
                       @RequestParam(name="tag", required=false) String tag,
                       Model model) {

        Map<String, Object> param = new HashMap<>();
        param.put("keyword", keyword);
        param.put("categoryKey", categoryKey);
        param.put("tag", tag);

        model.addAttribute("list", interviewDAO.list(param));
        model.addAttribute("keyword", keyword);
        model.addAttribute("categoryKey", categoryKey);
        model.addAttribute("tag", tag);

        return "interview/list";
    }

    @GetMapping("/detail")
    public String detail(@RequestParam(name="ino") int ino,
                         HttpServletRequest request,
                         HttpServletResponse response,
                         Model model) {

        String cookieName = "iview_" + ino;
        boolean alreadyViewed = false;

        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie c : cookies) {
                if (cookieName.equals(c.getName())) {
                    alreadyViewed = true;
                    break;
                }
            }
        }

        if (!alreadyViewed) {
            interviewDAO.increaseView(ino);

            Cookie viewCookie = new Cookie(cookieName, "1");
            viewCookie.setPath("/");
            viewCookie.setMaxAge(60 * 60 * 24); // 24시간
            response.addCookie(viewCookie);
        }

        model.addAttribute("dto", interviewDAO.detail(ino));
        return "interview/detail";
    }
}
