package com.idoit.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.idoit.dao.Board_commentDAO;
import com.idoit.dao.MemberDAO;
import com.idoit.dto.Board_commentDTO;
import com.idoit.dto.MemberDTO;

@Controller
@RequestMapping("/board_comment")
public class Board_commentController {

    @Autowired
    private Board_commentDAO boardCommentDAO;

    @Autowired
    private MemberDAO memberDAO;

    /* =================
      로그인 사용자 (카카오 + 일반 공통)
      ================== */
   private MemberDTO getLoginUser() {
      Authentication auth = SecurityContextHolder.getContext().getAuthentication();
      if (auth == null || !auth.isAuthenticated()) return null;

      Object principal = auth.getPrincipal();

      if (principal instanceof OAuth2User oAuth2User) {
         Object idObj = oAuth2User.getAttribute("id");
         String providerId = String.valueOf(idObj);
         return memberDAO.findByProvider("kakao", providerId);
      }

      String email = auth.getName();
      if ("anonymousUser".equals(email)) return null;

      return memberDAO.findByMemail(email);
   }

    /* 댓글 작성 */
    @PostMapping("/write")
    public String write(
            @RequestParam("bno") int bno,
            @RequestParam("bccontent") String bccontent,
            @RequestParam(value = "bcsecret", required = false) String bcsecret
    ) {
        MemberDTO loginUser = getLoginUser();
        if (loginUser == null) {
            return "redirect:/member/login";
        }

        Board_commentDTO dto = new Board_commentDTO();
        dto.setBno(bno);
        dto.setBccontent(bccontent);
        dto.setMno(loginUser.getMno());
        dto.setBcsecret(bcsecret != null ? "Y" : "N");

        boardCommentDAO.insertComment(dto);

        return "redirect:/board/detail?bno=" + bno;
    }


    /* 댓글 삭제 */
    @PostMapping("/delete")
    public String delete(
            @RequestParam("bcno") int bcno,
            @RequestParam("bno") int bno
    ) {
        boardCommentDAO.deleteComment(bcno);
        return "redirect:/board/detail?bno=" + bno;
    }

    /* 댓글 수정 */
    @PostMapping("/update")
    public String update(
            @RequestParam("bcno") int bcno,
            @RequestParam("bno") int bno,
            @RequestParam("bccontent") String bccontent
    ) {
        Board_commentDTO dto = new Board_commentDTO();
        dto.setBcno(bcno);
        dto.setBccontent(bccontent);

        boardCommentDAO.updateComment(dto);

        return "redirect:/board/detail?bno=" + bno;
    }
}