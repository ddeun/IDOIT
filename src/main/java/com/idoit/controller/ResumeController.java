package com.idoit.controller;

import java.io.File;
import java.util.UUID;

import org.springframework.security.core.Authentication;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.idoit.dao.MemberDAO;
import com.idoit.dto.MemberDTO;
import com.idoit.dto.ResumeDTO;
import com.idoit.service.ResumeService;

@Controller
@RequestMapping("/resume")
public class ResumeController {

    private final ResumeService resumeService;
    private final MemberDAO memberDAO;

    private int getLoginMno(Authentication authentication) {
        Object principal = authentication.getPrincipal();

        // 카카오 로그인
        if (principal instanceof OAuth2User oAuth2User) {
        	Object idObj = oAuth2User.getAttribute("id");
            String providerId = String.valueOf(idObj);
            MemberDTO member = memberDAO.findByProvider("kakao", providerId);
            return member.getMno();
        }

        // 일반 로그인
        String email = authentication.getName();
        MemberDTO member = memberDAO.findByMemail(email);
        return member.getMno();
    }
    
    public ResumeController(ResumeService resumeService, MemberDAO memberDAO) {
        this.resumeService = resumeService;
        this.memberDAO = memberDAO;
    }

    private MemberDTO getLoginMember(Authentication authentication) {
        Object principal = authentication.getPrincipal();

        if (principal instanceof OAuth2User oAuth2User) {
            Object idObj = oAuth2User.getAttribute("id");
            String providerId = String.valueOf(idObj);
            return memberDAO.findByProvider("kakao", providerId);
        }

        String email = authentication.getName();
        return memberDAO.findByMemail(email);
    }
    
    // 내 이력서 목록
    @GetMapping("/list")
    public String list(Authentication authentication, Model model) {
        MemberDTO me = getLoginMember(authentication);
        int mno = me.getMno();

        model.addAttribute("resumes", resumeService.findByMno(mno));
        return "resume/list";
    }
    
    @GetMapping("/form/{rno}")
    public String editForm(@PathVariable("rno") int rno, Authentication auth, Model model){

        int mno = getLoginMno(auth);

        ResumeDTO resume = resumeService.findOneByOwner(rno, mno);
        if (resume == null) {
            return "redirect:/resume/list";
        }
        model.addAttribute("member", getLoginMember(auth));
        
        resume.setEduList(resumeService.findEducationByRno(rno));
        resume.setCareerList(resumeService.findCareerByRno(rno));
        resume.setProjectList(resumeService.findProjectByRno(rno));
        resume.setOtherList(resumeService.findOtherByRno(rno));
        resume.setTrainingList(resumeService.findTrainingByRno(rno));

        model.addAttribute("resume", resume);
        model.addAttribute("skillNames", resumeService.findSkillNames(rno));

        return "resume/form";
    }
    
    //작성
    @GetMapping("/form")
    public String resumeForm(Authentication authentication, Model model) {
        // 1. 로그인한 사용자의 정보를 DB에서 가져옴 (mname, memail, mtel, mbirth 등 포함)
        MemberDTO member = resumeService.getMemberInfo(authentication.getName()); 
        model.addAttribute("member", member); // 여기서 'member'라는 이름으로 보내야 합니다.

        model.addAttribute("resume", new ResumeDTO());
        return "resume/form";
    }
    
    @PostMapping("/form")
    public String write(ResumeDTO dto, 
                        @RequestParam(value="imageFile", required=false) MultipartFile imageFile, 
                        Authentication auth) {
        try {
            // 1. 사진 저장 처리
        	if (imageFile != null && !imageFile.isEmpty()) {
        	    String uploadDir = "C:/upload/resume/"; 
        	    File dir = new File(uploadDir);
        	    if (!dir.exists()) dir.mkdirs();

        	    String saveFileName = UUID.randomUUID().toString() + "_" + imageFile.getOriginalFilename();
        	    // File.separator를 사용하여 경로를 더 안전하게 결합
        	    File saveFile = new File(uploadDir, saveFileName); 
        	    imageFile.transferTo(saveFile);
        	    
        	    dto.setRimage("resume/" + saveFileName);
        	    System.out.println("✅ 파일이 저장된 절대 경로: " + saveFile.getAbsolutePath());
        	}

            // 2. 로그인 정보 세팅
            int mno = getLoginMno(auth);
            dto.setMno(mno);

            // 3. 서비스 호출 (DB 인서트)
            resumeService.insertResume(dto, dto.getRsname(), dto.getEduList(), 
                                       dto.getCareerList(), dto.getProjectList(), 
                                       dto.getOtherList(), dto.getTrainingList());
            System.out.println("DB 인서트 성공!");

        } catch (Exception e) {
            // 어디서 에러가 났는지 콘솔에 출력 (이걸 확인해야 합니다!)
            System.out.println("에러 발생 원인: " + e.getMessage());
            e.printStackTrace(); 
            return "redirect:/resume/form?error"; 
        }

        return "redirect:/resume/list";
    }
 // 상세보기
    @GetMapping("/detail")
    public String detail(@RequestParam("rno") int rno,
                         Authentication authentication,
                         Model model) {

        boolean isCompany = authentication.getAuthorities().stream()
                .anyMatch(a -> a.getAuthority().equals("ROLE_COMPANY"));

        ResumeDTO resume;
        MemberDTO ownerMember; // 이력서 작성자(지원자)

        if (isCompany) {
            // ✅ 기업은 공개용 조회 (owner 체크 X)
            resume = resumeService.findPublicForCompany(rno);
            if (resume == null) return "redirect:/company/postings";

            ownerMember = memberDAO.findByMno(resume.getMno());
        } else {
            // ✅ 개인은 본인 이력서만
            MemberDTO loginMember = getLoginMember(authentication);
            int mno = loginMember.getMno();

            resume = resumeService.findOneByOwner(rno, mno);
            if (resume == null) return "redirect:/resume/list";

            ownerMember = loginMember;
        }

        model.addAttribute("member", ownerMember);
        model.addAttribute("resume", resume);
        model.addAttribute("skills", resumeService.findSkillNames(rno));
        model.addAttribute("educations", resumeService.findEducationByRno(rno));
        model.addAttribute("careers", resumeService.findCareerByRno(rno));
        model.addAttribute("projects", resumeService.findProjectByRno(rno));
        model.addAttribute("others", resumeService.findOtherByRno(rno));
        model.addAttribute("trainings", resumeService.findTrainingByRno(rno));

        return "resume/detail";
    }

    // 수정
    @PostMapping("/update")
    public String update(ResumeDTO dto,
                         @RequestParam(value="imageFile", required=false) MultipartFile imageFile,
                         Authentication authentication) {

        int mno = getLoginMember(authentication).getMno();
        dto.setMno(mno);

        try {
            // ✅ 새 사진 올린 경우만 저장 + DB 업데이트용 rimage 세팅
            if (imageFile != null && !imageFile.isEmpty()) {
                String uploadDir = "C:/upload/resume/";
                File dir = new File(uploadDir);
                if (!dir.exists()) dir.mkdirs();

                String saveFileName = UUID.randomUUID().toString() + "_" + imageFile.getOriginalFilename();
                File saveFile = new File(uploadDir, saveFileName);
                imageFile.transferTo(saveFile);

                dto.setRimage("resume/" + saveFileName);
                System.out.println("✅ 수정 이미지 저장: " + saveFile.getAbsolutePath());
            }
            // ✅ 사진 안 올리면 dto.rimage는 null/"" → 너가 만든 mapper if가 기존 이미지 유지해줌

            resumeService.updateResume(dto, dto.getRsname(), dto.getEduList(),
                                       dto.getCareerList(), dto.getProjectList(),
                                       dto.getOtherList(), dto.getTrainingList());

        } catch (Exception e) {
            e.printStackTrace();
            return "redirect:/resume/form/" + dto.getRno() + "?error";
        }

        return "redirect:/resume/detail?rno=" + dto.getRno();
    }


    @PostMapping("/delete")
    public String delete(@RequestParam("rno") int rno, Authentication authentication) {
        MemberDTO me = getLoginMember(authentication);

        resumeService.deleteResume(rno, me.getMno());
        return "redirect:/resume/list";
    }
}
