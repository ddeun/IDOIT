package com.idoit.controller;

import java.io.File;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.idoit.dao.BoardDAO;
import com.idoit.dao.Board_commentDAO;
import com.idoit.dao.MemberDAO;
import com.idoit.dto.BoardDTO;
import com.idoit.dto.MemberDTO;
import com.idoit.service.BoardService;
import com.idoit.util.FileDeleteUtil;

@Controller
@RequestMapping("/board")
public class BoardController {

   @Autowired
   private BoardDAO boardDAO;
   
   @Autowired
   private BoardService boardService;

    @Autowired
    private MemberDAO memberDAO;

    @Autowired
    private Board_commentDAO boardCommentDAO;

    private final String uploadPath =
            "C:\\Springboot\\IDOIT\\src\\main\\resources\\static\\images\\";

    /* =================
      로그인 사용자 (카카오 + 일반 공통)
      ================== */
   private MemberDTO getLoginUser() {
      Authentication auth = SecurityContextHolder.getContext().getAuthentication();
      if (auth == null || !auth.isAuthenticated()) return null;

      Object principal = auth.getPrincipal();

      // 카카오 로그인
      if (principal instanceof OAuth2User oAuth2User) {
         Object idObj = oAuth2User.getAttribute("id");
         String providerId = String.valueOf(idObj);
         return memberDAO.findByProvider("kakao", providerId);
      }

      // 일반 로그인
      String email = auth.getName();
      if ("anonymousUser".equals(email)) return null;

      return memberDAO.findByMemail(email);
   }

    /* ==================
       관리자 여부
       ================== */
    private boolean isAdmin() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth == null || !auth.isAuthenticated()) return false;

        return auth.getAuthorities().stream()
                .anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN"));
    }

    /* ==================
    게시글 목록 (카테고리 + 검색)
    ================== */
    @GetMapping("/list")
    public String list(
            @RequestParam(value = "btype", required = false) String btype,
            @RequestParam(value = "searchType", required = false) String searchType,
            @RequestParam(value = "keyword", required = false) String keyword,
            Model model
    ) {
   
        boolean hasSearch = keyword != null && !keyword.isBlank();
   
        if (hasSearch) {
            model.addAttribute(
                "boardList",
                boardDAO.searchBoardList(btype, searchType, keyword)
            );
        } else {
            model.addAttribute(
                "boardList",
                (btype == null || btype.isBlank())
                    ? boardDAO.selectBoardList()
                    : boardDAO.selectBoardListByType(btype)
            );
        }
   
        model.addAttribute("selectedType", btype);
        model.addAttribute("searchType", searchType);
        model.addAttribute("keyword", keyword);
   
        return "board/list";
    }

    /* ==================
       게시글 상세
       ================== */
    @GetMapping("/detail")
    public String detail(@RequestParam("bno") int bno, Model model) {

        boardDAO.updateViewCount(bno);

        BoardDTO board = boardDAO.selectBoard(bno);

        // 관리자 + 익명글이면 실제 작성자 정보 세팅
        if (isAdmin() && "익명".equals(board.getBwriter())) {
            MemberDTO writer = memberDAO.selectMemberByMno(board.getMno());
            board.setRealWriterName(writer.getMname());
            board.setRealWriterEmail(writer.getMemail());
        }

        model.addAttribute("board", board);
        model.addAttribute("commentList", boardCommentDAO.selectCommentList(bno));
        model.addAttribute("loginUser", getLoginUser());
        model.addAttribute("isAdmin", isAdmin());

        return "board/detail";
    }

    /* ==================
       글 작성 폼
       ================== */
    @GetMapping("/write")
    public String writeForm() {
        return "board/write";
    }

    /* ==================
       글 작성
       ================== */
    @PostMapping("/write")
    public String write(
            BoardDTO dto,
            @RequestParam(value = "uploadfile", required = false) MultipartFile file,
            @RequestParam(value = "anonymous", required = false) String anonymous
    ) throws Exception {

        MemberDTO loginUser = getLoginUser();
        if (loginUser == null) return "redirect:/member/login";

        dto.setMno(loginUser.getMno());
        dto.setBwriter("Y".equals(anonymous) ? "익명" : loginUser.getMname());

        if (file != null && !file.isEmpty()) {
            File dir = new File(uploadPath);
            if (!dir.exists()) dir.mkdirs();

            String fileName = file.getOriginalFilename();
            file.transferTo(new File(dir, fileName));
            dto.setBimage(fileName);
        }

        boardService.write(dto);
        return "redirect:/board/list";
    }

    /* ==================
       게시글 삭제
       ================== */
    @PostMapping("/delete")
    public String delete(@RequestParam("bno") int bno) {

        MemberDTO loginUser = getLoginUser();
        if (loginUser == null) {
            return "redirect:/member/login";
        }

        BoardDTO board = boardDAO.selectBoard(bno);
        if (board == null) {
            return "redirect:/board/list";
        }

        // 작성자 또는 관리자만 삭제 가능
        if (loginUser.getMno() != board.getMno() && !isAdmin()) {
            return "redirect:/board/detail?bno=" + bno;
        }

        // 이미지 삭제
        String content = board.getBcontent();
        if (content != null && !content.isBlank()) {
            FileDeleteUtil.deleteImagesFromContent(content);
        }

        // 댓글 → 게시글 삭제
        boardService.delete(bno);

        return "redirect:/board/list";
    }

    /* ==================
       게시글 수정 폼
       ================== */
    @GetMapping("/update")
    public String updateForm(@RequestParam("bno") int bno, Model model) {
        model.addAttribute("board", boardDAO.selectBoard(bno));
        return "board/update";
    }

    /* ==================
       게시글 수정
       ================== */
    @PostMapping("/update")
    public String update(
            BoardDTO dto,
            @RequestParam(value = "uploadfile", required = false) MultipartFile file
    ) throws Exception {

        BoardDTO origin = boardDAO.selectBoard(dto.getBno());

        dto.setBwriter(origin.getBwriter());
        dto.setMno(origin.getMno());

        if (file != null && !file.isEmpty()) {
            File dir = new File(uploadPath);
            if (!dir.exists()) dir.mkdirs();

            String fileName = file.getOriginalFilename();
            file.transferTo(new File(dir, fileName));
            dto.setBimage(fileName);
        } else {
            dto.setBimage(origin.getBimage());
        }

        boardService.update(dto);
        return "redirect:/board/detail?bno=" + dto.getBno();
    }
}
