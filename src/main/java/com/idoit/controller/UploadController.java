package com.idoit.controller;

import java.io.File;
import java.time.LocalDate;
import java.util.UUID;

import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

@Controller
public class UploadController {

    private final String boardUploadRoot  = "C:/upload/board/";
    private final String noticeUploadRoot = "C:/upload/notice/";

    /* =========================
       Board 이미지 업로드
       ========================= */
    @PostMapping({
        "/upload/board-image"       // 신규 권장 URL
    })
    @ResponseBody
    public ResponseEntity<?> uploadBoardImage(
            @RequestParam("file") MultipartFile file
    ) throws Exception {

        String imageUrl = saveFile(file, boardUploadRoot, "board");
        return ResponseEntity.ok().body(
            java.util.Map.of("url", imageUrl)
        );
    }

    /* =========================
       Notice 이미지 업로드
       ========================= */
    @PostMapping("/upload/notice-image")
    @ResponseBody
    public ResponseEntity<?> uploadNoticeImage(
            @RequestParam("file") MultipartFile file
    ) throws Exception {

        String imageUrl = saveFile(file, noticeUploadRoot, "notice");
        return ResponseEntity.ok().body(
            java.util.Map.of("url", imageUrl)
        );
    }

    /* =========================
       공통 파일 저장 로직
       ========================= */
    private String saveFile(
            MultipartFile file,
            String uploadRoot,
            String type
    ) throws Exception {

        // yyyy/MM 폴더
        LocalDate now = LocalDate.now();
        String folder = now.getYear() + "/" +
                        String.format("%02d", now.getMonthValue());

        File dir = new File(uploadRoot + folder);
        if (!dir.exists()) dir.mkdirs();

        // 파일명 중복 방지
        String fileName = UUID.randomUUID() + "_" + file.getOriginalFilename();

        File saveFile = new File(dir, fileName);
        file.transferTo(saveFile);

        // 웹 접근 경로
        return "/upload/" + type + "/" + folder + "/" + fileName;
    }
}
