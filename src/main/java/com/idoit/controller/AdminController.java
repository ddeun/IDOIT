package com.idoit.controller;

import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.idoit.dao.NoticeDAO;
import com.idoit.dto.NoticeDTO;
import com.idoit.service.AdminService;
import com.idoit.service.Job_postingService;
import com.idoit.util.FileDeleteUtil;

@Controller
@RequestMapping("/admin")
@PreAuthorize("hasRole('ADMIN')")
public class AdminController {
	private final AdminService adminService;
	private final NoticeDAO noticeDAO;
	private final Job_postingService jobPostingService;

    public AdminController(AdminService adminService,
    						NoticeDAO noticeDAO,
    						Job_postingService jobPostingService) {
        this.adminService = adminService;
        this.noticeDAO = noticeDAO;
        this.jobPostingService = jobPostingService;
    }
    @GetMapping("")
    public String dashboard() {
        return "admin/dashboard";
    }

    @GetMapping("/personals")
    public String personals(Model model) {
        model.addAttribute("members", adminService.findPersonalMembers());
        return "admin/personal_list";
    }
    @PostMapping("/member/status")
    public String changeStatus(@RequestParam("mno") Long mno,
                               @RequestParam("mstatus") String mstatus) {
        adminService.changeMemberStatus(mno, mstatus);
        return "redirect:/admin/personals";
    }
    
    @PostMapping("/member/withdraw")
    public String withdraw(@RequestParam("mno") Long mno) {
        adminService.withdrawMember(mno);
        return "redirect:/admin/personals";
    }

    @GetMapping("/interviews")
    public String interviews() {
        return "admin/interview_list";
    }


    /* =========================
    공지사항 관리 (관리자)
    ========================= */
	 @GetMapping("/notices")
	 public String notices(Model model) {
	     model.addAttribute("list", noticeDAO.selectNoticeList());
	     return "admin/notice/manage";
	 }
	
	 /* 공지 작성 폼 */
	 @GetMapping("/notices/write")
	 public String writeForm() {
	     return "admin/notice/write";
	 }
	
	 /* 공지 작성 처리 */
	 @PostMapping("/notices/write")
	 public String write(NoticeDTO dto) {
	     noticeDAO.insertNotice(dto);
	     return "redirect:/admin/notices";
	 }
	
	 /* 공지 수정 폼 */
	 @GetMapping("/notices/update")
	 public String updateForm(@RequestParam("nno") int nno, Model model) {
	     model.addAttribute("notice", noticeDAO.selectNotice(nno));
	     return "admin/notice/update";
	 }
	
	 /* 공지 수정 처리 */
	 @PostMapping("/notices/update")
	 public String update(NoticeDTO dto) {
	     noticeDAO.updateNotice(dto);
	     return "redirect:/admin/notices";
	 }
	 
	 /* =========================
	   공지 삭제 처리 (관리자)
	   ========================= */
	@PostMapping("/notices/delete")
	public String delete(@RequestParam("nno") int nno) {

	    // 1. 삭제 전 내용 가져오기 (이미지 삭제용)
	    String content = noticeDAO.selectNotice(nno).getNcontent();

	    // 2. 이미지 파일 삭제
	    FileDeleteUtil.deleteImagesFromContent(content);

	    // 3. DB 삭제
	    noticeDAO.deleteNotice(nno);

	    // 4. 관리자 공지 목록으로 복귀
	    return "redirect:/admin/notices";
	}

    @GetMapping("/applications")
    public String applications() {
        return "admin/application_list";
    }
    
    @PostMapping("/members/role")
    public String changeRole(@RequestParam String memail,
                             @RequestParam String role) {
        adminService.changeRole(memail, role);
        return "redirect:/admin/members";
    }
    
    @GetMapping("/pending")
    public String pendingList(Model model) {
        model.addAttribute("list", jobPostingService.findPending());
        return "admin/pending";
    }
    
    @PostMapping("/pending/approve")
    public String approve(@RequestParam("jno") long jno) {
        jobPostingService.approve(jno);
        return "redirect:/admin/pending";
    }

    @PostMapping("/pending/reject")
    public String reject(@RequestParam("jno") long jno) {
        jobPostingService.reject(jno);
        return "redirect:/admin/pending";
    }
}
