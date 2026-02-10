package com.idoit.controller;

import java.util.Map;

import org.springframework.web.bind.annotation.*;

import com.idoit.dto.Job_postingDTO;
import com.idoit.service.Job_postingService;

import lombok.RequiredArgsConstructor;

@RestController
@RequiredArgsConstructor
@RequestMapping("/api/job_posting")
public class Job_postingController {

    private final Job_postingService service;

    @GetMapping
    public Map<String, Object> list(
        @RequestParam(value="q", required=false) String q,
        @RequestParam(value="cat", required=false) String cat,
        @RequestParam(value="page", defaultValue="1") int page,
        @RequestParam(value="size", defaultValue="20") int size
    ) {
        if (q != null) q = q.trim();
        if (cat != null) cat = cat.trim();

        return service.list(q, cat, page, size);
    }

    @GetMapping("/{jno}")
    public Job_postingDTO detail(@PathVariable("jno") int jno) {
        return service.detail(jno);
    }
}
