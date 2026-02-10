package com.idoit.controller;

import java.io.File;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import com.idoit.dao.InterviewDAO;
import com.idoit.dao.MemberDAO;
import com.idoit.dto.InterviewDTO;
import com.idoit.dto.MemberDTO;

@Controller
@RequestMapping("/admin/interview")
public class AdminInterviewController {

    @Autowired private InterviewDAO interviewDAO;
    @Autowired private MemberDAO memberDAO;

    // 개발 단계용: static 아래 저장
    private final String uploadDir = "src/main/resources/static/uploads/interview/";

    @GetMapping("/write")
    public String writeForm() {
        return "interview/write";
    }

    @PostMapping("/write")
    public String write(@ModelAttribute InterviewDTO dto,
                        @RequestParam(name="thumb", required=false) MultipartFile thumb,
                        Authentication auth) {

        String memail = auth.getName();
        MemberDTO member = memberDAO.findByMemail(memail);
        if (member == null) return "redirect:/member/login";

        dto.setMno(member.getMno());

        String savedPath = saveThumbIfExists(thumb);
        if (savedPath != null) dto.setIimagePath(savedPath);

        int len = (dto.getIcontent() == null) ? 0 : dto.getIcontent().replaceAll("<[^>]*>", "").length();
        dto.setIreadmin(Math.max((int)Math.ceil(len / 700.0), 1));

        interviewDAO.insert(dto);
        return "redirect:/interview/list";
    }

    @GetMapping("/updateForm")
    public String updateForm(@RequestParam(name="ino") int ino, Model model) {
        model.addAttribute("dto", interviewDAO.detail(ino));
        return "interview/updateForm";
    }

    @PostMapping("/update")
    public String update(@ModelAttribute InterviewDTO dto,
                         @RequestParam(name="thumb", required=false) MultipartFile thumb) {

        String savedPath = saveThumbIfExists(thumb);
        if (savedPath != null) {
            dto.setIimagePath(savedPath);
        } else {
            // 새 파일이 없으면 기존 썸네일 유지
            InterviewDTO origin = interviewDAO.detail(dto.getIno());
            dto.setIimagePath(origin.getIimagePath());
        }

        int len = (dto.getIcontent() == null) ? 0 : dto.getIcontent().replaceAll("<[^>]*>", "").length();
        dto.setIreadmin(Math.max((int)Math.ceil(len / 700.0), 1));

        interviewDAO.update(dto);
        return "redirect:/interview/detail?ino=" + dto.getIno();
    }

    @PostMapping("/delete")
    public String delete(@RequestParam(name="ino") int ino) {
        interviewDAO.delete(ino);
        return "redirect:/interview/list";
    }

    private String saveThumbIfExists(MultipartFile file) {
        try {
            if (file == null || file.isEmpty()) return null;

            String original = file.getOriginalFilename();
            String ext = (original != null && original.contains("."))
                    ? original.substring(original.lastIndexOf(".")).toLowerCase()
                    : "";

            if (!(ext.equals(".jpg") || ext.equals(".jpeg") || ext.equals(".png") || ext.equals(".webp"))) {
                return null;
            }

            File dir = new File(uploadDir);
            if (!dir.exists()) dir.mkdirs();

            String filename = UUID.randomUUID().toString().replace("-", "") + ext;
            File dest = new File(dir, filename);
            file.transferTo(dest);

            return "/uploads/interview/" + filename;

        } catch (Exception e) {
            return null;
        }
    }
}
