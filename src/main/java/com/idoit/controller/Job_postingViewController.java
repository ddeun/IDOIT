package com.idoit.controller;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.springframework.security.core.Authentication;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.idoit.dto.CompanyDTO;
import com.idoit.dto.Job_postingDTO;
import com.idoit.service.ApplicationService;
import com.idoit.service.Job_postingService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
@RequestMapping("/job_posting")
public class Job_postingViewController {

    private final ApplicationService applicationService;
    private final Job_postingService service;
    private final ObjectMapper om = new ObjectMapper();

    // =========================
    // LIST
    // =========================
    @GetMapping("/list")
    public String list(
            @RequestParam(value = "q", required = false) String q,
            @RequestParam(value = "cat", required = false) String cat,
            @RequestParam(value = "page", defaultValue = "1") int page,
            @RequestParam(value = "size", defaultValue = "20") int size,
            Model model
    ) {
        if (q != null) q = q.trim();
        if (cat != null) cat = cat.trim();

        Map<String, Object> res = service.list(q, cat, page, size);

        @SuppressWarnings("unchecked")
        List<Job_postingDTO> items = (List<Job_postingDTO>) res.getOrDefault("items", List.of());

        for (Job_postingDTO it : items) {
            // ✅ 화면 표시용 근무지역 정제 (지도보기/주소복사/미정 제거)
            it.setJlocation(cleanLocationView(it.getJlocation()));

            List<String> cats = normalizeTextList(parseJsonArray(it.getJcategories()));
            it.setCategories(cats);

            List<String> companyImages = normalizeAll(parseJsonArray(it.getCimage()));
            String thumb = companyImages.isEmpty() ? null : companyImages.get(companyImages.size() - 1);
            it.setThumb(thumb);
        }

        Map<String, Object> allRes = service.list(q, null, 1, 2000);
        @SuppressWarnings("unchecked")
        List<Job_postingDTO> allItems = (List<Job_postingDTO>) allRes.getOrDefault("items", List.of());
        for (Job_postingDTO it : allItems) {
            it.setCategories(normalizeTextList(parseJsonArray(it.getJcategories())));
        }
        model.addAttribute("categoryList", buildCategoryList(allItems));

        model.addAttribute("q", q);
        model.addAttribute("cat", cat);
        model.addAttribute("page", res.get("page"));
        model.addAttribute("size", res.get("size"));
        model.addAttribute("total", res.get("total"));
        model.addAttribute("items", items);

        return "job_posting/list";
    }

    // =========================
    // DETAIL
    // =========================
    @GetMapping("/detail/{jno}")
    public String detail(@PathVariable("jno") int jno, Authentication auth, Model model) {
        Job_postingDTO item = service.detail(jno);

        // ✅ 화면 표시용 근무지역 정제 (지도보기/주소복사/미정 제거)
        item.setJlocation(cleanLocationView(item.getJlocation()));

        model.addAttribute("item", item);

        List<String> companyImages = normalizeAll(parseJsonArray(item.getCimage()));
        List<String> skillImages = normalizeAll(parseJsonArray(item.getJskills()));

        String companyThumb = null;
        if (!companyImages.isEmpty()) companyThumb = companyImages.get(companyImages.size() - 1);

        // ✅ 공고 내용 분리 + 공고내용(rest) 정제(지도보기/주소복사 제거)
        Map<String, String> sections = splitCompanyIntro(item.getJcontent());
        String intro = sections.getOrDefault("intro", "");
        String rest  = sections.getOrDefault("rest", item.getJcontent() == null ? "" : item.getJcontent());
        rest = cleanContentView(rest);

        model.addAttribute("companyIntroText", intro);
        model.addAttribute("contentText", rest);

        model.addAttribute("companyImages", companyImages);
        model.addAttribute("companyThumb", companyThumb);
        model.addAttribute("skillImages", skillImages);

        List<String> cats = normalizeTextList(parseJsonArray(item.getJcategories()));
        model.addAttribute("categories", cats);

        // ✅ 기업 + 내 소유 공고일 때만 수정/삭제 노출
        boolean canEdit = false;
        if (auth != null && hasRole(auth, "ROLE_COMPANY")) {
            try {
                int mno = getLoginMno(auth);
                service.assertOwnedCompany(mno, item.getCno());
                canEdit = true;
            } catch (Exception ignore) {
                canEdit = false;
            }
        }
        model.addAttribute("canEdit", canEdit);

        // ✅ 지원하기: USER만 + 중복 지원 체크
        boolean canApply = false;
        boolean alreadyApplied = false;

        if (auth != null && hasRole(auth, "ROLE_USER")) {
            try {
                int mno = getLoginMno(auth);
                canApply = true;
                alreadyApplied = applicationService.exists(mno, jno);
            } catch (Exception ignore) {
                canApply = false;
                alreadyApplied = false;
            }
        }

        model.addAttribute("canApply", canApply);
        model.addAttribute("alreadyApplied", alreadyApplied);

        return "job_posting/detail";
    }

    // =========================
    // WRITEFORM (기업만 접근: Security에서 막음)
    // =========================
    @GetMapping("/writeform")
    public String writeform(Authentication auth, Model model) {
        int mno = getLoginMno(auth);

        List<CompanyDTO> companies = service.listCompaniesByMno(mno);
        model.addAttribute("companies", companies);

        model.addAttribute("dto", new Job_postingDTO());
        return "job_posting/writeform";
    }

    // =========================
    // WRITE (기업만 접근: Security에서 막음)
    // =========================
    @PostMapping("/write")
    public String write(
            @ModelAttribute Job_postingDTO dto,
            @RequestParam(value = "cno") int cno,
            @RequestParam(value = "categories", required = false) List<String> categories,
            @RequestParam(value = "skills", required = false) List<String> skills,
            @RequestParam(value = "introText", required = false) String introText,
            @RequestParam(value = "contentText", required = false) String contentText,
            Authentication auth
    ) throws Exception {

        if (categories == null) categories = List.of();
        dto.setJcategories(om.writeValueAsString(categories));

        if (skills == null) skills = List.of();
        dto.setJskills(om.writeValueAsString(skills));

        dto.setJcontent(mergeContent(introText, contentText));

        int mno = getLoginMno(auth);
        service.createByCompanyOwner(mno, cno, dto);

        return "redirect:/job_posting/list";
    }

    // =========================
    // UPDATEFORM (기업 + 소유만)
    // =========================
    @GetMapping("/updateform/{jno}")
    public String updateform(@PathVariable("jno") int jno, Authentication auth, Model model) {
        int mno = getLoginMno(auth);

        Job_postingDTO dto = service.detailOwnedByMno(mno, jno);

        CompanyDTO company = service.findOwnedCompany(mno, dto.getCno());
        model.addAttribute("company", company);

        model.addAttribute("selectedCategories", parseJsonArray(dto.getJcategories()));
        model.addAttribute("selectedSkills", normalizeAll(parseJsonArray(dto.getJskills())));

        Map<String, String> sections = splitCompanyIntro(dto.getJcontent());
        model.addAttribute("companyIntroText", sections.getOrDefault("intro", ""));
        model.addAttribute("contentText", sections.getOrDefault("rest", ""));

        model.addAttribute("dto", dto);
        return "job_posting/updateform";
    }

    // =========================
    // UPDATE (기업 + 소유만)
    // =========================
    @PostMapping("/update")
    public String update(
            @ModelAttribute Job_postingDTO dto,
            @RequestParam(value = "categories", required = false) List<String> categories,
            @RequestParam(value = "skills", required = false) List<String> skills,
            @RequestParam(value = "introText", required = false) String introText,
            @RequestParam(value = "contentText", required = false) String contentText,
            Authentication auth
    ) throws Exception {

        if (categories == null) categories = List.of();
        dto.setJcategories(om.writeValueAsString(categories));

        if (skills == null) skills = List.of();
        dto.setJskills(om.writeValueAsString(skills));

        dto.setJcontent(mergeContent(introText, contentText));

        int mno = getLoginMno(auth);
        service.updateByCompanyOwner(mno, dto);

        return "redirect:/job_posting/detail/" + dto.getJno();
    }

    // =========================
    // DELETE (기업 + 소유만)
    // =========================
    @PostMapping("/delete/{jno}")
    public String delete(@PathVariable("jno") int jno, Authentication auth) {
        int mno = getLoginMno(auth);
        service.deleteByCompanyOwner(mno, jno);
        return "redirect:/job_posting/list";
    }

    // =========================
    // helpers
    // =========================
    private boolean hasRole(Authentication auth, String role) {
        return auth.getAuthorities().stream().anyMatch(a -> a.getAuthority().equals(role));
    }

    private List<String> parseJsonArray(String json) {
        if (json == null) return List.of();
        String s = json.trim();
        if (s.isEmpty()) return List.of();
        try {
            return om.readValue(s, new TypeReference<List<String>>() {});
        } catch (Exception e) {
            return List.of();
        }
    }

    private List<String> normalizeTextList(List<String> list) {
        if (list == null || list.isEmpty()) return List.of();
        List<String> out = new ArrayList<>();
        for (String v : list) {
            if (v == null) continue;
            String t = v.trim();
            if (t.isEmpty()) continue;
            out.add(t);
        }
        return out;
    }

    private List<String> buildCategoryList(List<Job_postingDTO> items) {
        if (items == null || items.isEmpty()) return List.of();
        Set<String> set = new LinkedHashSet<>();
        for (Job_postingDTO it : items) {
            List<String> cats = it.getCategories();
            if (cats == null) continue;
            for (String c : cats) {
                if (c == null) continue;
                String t = c.trim();
                if (!t.isEmpty()) set.add(t);
            }
        }
        List<String> list = new ArrayList<>(set);
        list.sort(Comparator.naturalOrder());
        return list;
    }

    private String normalize(String p) {
        if (p == null) return null;
        String s = p.trim();
        if (s.isEmpty()) return null;
        if (!s.startsWith("/")) s = "/" + s;
        return s;
    }

    private List<String> normalizeAll(List<String> list) {
        if (list == null || list.isEmpty()) return List.of();
        List<String> out = new ArrayList<>();
        for (String p : list) {
            String n = normalize(p);
            if (n != null) out.add(n);
        }
        return out;
    }

    private String mergeContent(String introText, String contentText) {
        String intro = (introText == null) ? "" : introText.trim();
        String cont = (contentText == null) ? "" : contentText.trim();

        StringBuilder sb = new StringBuilder();
        if (!intro.isBlank()) {
            sb.append("[기업/서비스 소개]\n").append(intro).append("\n\n");
        }
        if (!cont.isBlank()) {
            sb.append("[공고 내용]\n").append(cont);
        }
        return sb.toString().trim();
    }

    private Map<String, String> splitCompanyIntro(String jcontent) {
        String text = (jcontent == null) ? "" : jcontent;

        Pattern p = Pattern.compile("\\[기업/서비스 소개\\]\\s*(.*?)\\s*(?=\\n\\[[^\\]]+\\]|\\z)", Pattern.DOTALL);
        Matcher m = p.matcher(text);

        String intro = "";
        String rest = text;

        if (m.find()) {
            intro = m.group(1).trim();
            rest = (text.substring(0, m.start()) + "\n" + text.substring(m.end())).trim();
        }

        rest = rest.replaceFirst("^\\[공고 내용\\]\\s*", "").trim();

        Map<String, String> out = new HashMap<>();
        out.put("intro", intro);
        out.put("rest", rest);
        return out;
    }

    // ✅ 화면 표시용 주소 정제 (지도보기 / 주소복사 / 미정 제거)
    private String cleanLocationView(String s) {
        if (s == null) return null;

        String t = s.trim();
        if (t.isEmpty()) return t;

        // 1) "지도보기" 이후 전부 제거 (줄바꿈 포함)
        t = t.replaceAll("(?s)\\s*지도보기.*$", "").trim();

        // 2) "주소복사"만 남는 변형 제거
        t = t.replaceAll("(?s)\\s*주소복사.*$", "").trim();

        // 3) '미정' 제거 (앞뒤 구분자 포함해서)
        t = t.replaceAll("(\\s*[·•|]\\s*)?미정$", "").trim();

        // 4) 가운데점/여러 공백 정리
        t = t.replace("\u00B7", " ");
        t = t.replaceAll("\\s+", " ").trim();

        return t;
    }

    // ✅ 공고 내용(contentText)에서 "지도보기/주소복사" 잔여 문구 제거
    private String cleanContentView(String s) {
        if (s == null) return null;

        String t = s;

        // 단독 줄로 들어간 케이스
        t = t.replaceAll("(?m)^\\s*지도보기\\s*[·•\\-–—]?\\s*$", "");
        t = t.replaceAll("(?m)^\\s*주소복사\\s*[·•\\-–—]?\\s*$", "");

        // 같은 줄에 붙은 케이스
        t = t.replaceAll("\\s*지도보기\\s*[·•\\-–—]?\\s*주소복사\\s*", " ");
        t = t.replaceAll("\\s*지도보기\\s*", " ");
        t = t.replaceAll("\\s*주소복사\\s*", " ");

        // 빈 줄/연속 줄 정리
        t = t.replaceAll("(?m)^[ \\t]*\\r?\\n", "");
        t = t.replaceAll("\\n{3,}", "\n\n").trim();

        return t;
    }

    /**
     * ✅ 폼로그인/소셜로그인 모두 mno를 안정적으로 얻는 메서드
     * - 폼로그인: auth.getName() = memail
     * - 카카오 소셜: auth.getName() = nickname 이므로 attrs의 id로 memail을 재구성
     */
    private int getLoginMno(Authentication auth) {
        if (auth == null) throw new IllegalStateException("로그인 정보가 없습니다.");

        String name = auth.getName();
        if (name != null && name.contains("@")) {
            return service.getMnoByMemail(name);
        }

        Object principal = auth.getPrincipal();
        if (principal instanceof OAuth2User oAuth2User) {
            Object idObj = oAuth2User.getAttribute("id"); // kakao id
            if (idObj != null) {
                String providerId = String.valueOf(idObj);
                String memail = "kakao_" + providerId + "@idoit.social";
                return service.getMnoByMemail(memail);
            }
        }

        throw new IllegalStateException("로그인 사용자 식별 실패");
    }
}
