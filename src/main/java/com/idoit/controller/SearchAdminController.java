package com.idoit.controller;

import java.util.Map;
import org.springframework.web.bind.annotation.*;

import com.idoit.service.SearchReindexService;

@RestController
@RequestMapping("/admin/search")
public class SearchAdminController {

    private final SearchReindexService reindexService;

    public SearchAdminController(SearchReindexService reindexService) {
        this.reindexService = reindexService;
    }
    @GetMapping("/reindex")
    public Map<String, Integer> reindexGet() throws Exception {
        return reindexService.reindexAll();
    }
    
    @PostMapping("/reindex")
    public Map<String, Integer> reindex() throws Exception {
        return reindexService.reindexAll();
    }
}
