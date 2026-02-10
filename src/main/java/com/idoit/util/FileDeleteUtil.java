package com.idoit.util;

import java.io.File;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class FileDeleteUtil {

    // <img src="..."> 에서 src 추출
    private static final Pattern IMG_SRC_PATTERN =
            Pattern.compile("<img[^>]+src=[\"']([^\"']+)[\"']");

    /**
     * HTML 안의 이미지 파일 삭제
     */
    public static void deleteImagesFromContent(String content) {
        if (content == null || content.isBlank()) return;

        Matcher matcher = IMG_SRC_PATTERN.matcher(content);

        while (matcher.find()) {
            String imageUrl = matcher.group(1);

            // /upload/board/... or /upload/notice/... 만 처리
            if (!imageUrl.startsWith("/upload/")) continue;

            // 실제 파일 경로 변환
            String realPath = "C:" + imageUrl.replace("/", File.separator);

            File file = new File(realPath);
            if (file.exists()) {
                file.delete();
            }
        }
    }
}