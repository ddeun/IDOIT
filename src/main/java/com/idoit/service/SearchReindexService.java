package com.idoit.service;

import java.util.*;
import org.elasticsearch.action.bulk.*;
import org.elasticsearch.action.index.IndexRequest;
import org.elasticsearch.client.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.idoit.dao.SearchIndexDAO;
import com.idoit.dto.IndexRow;

@Service
public class SearchReindexService {

    private final RestHighLevelClient client;
    private final SearchIndexDAO searchIndexDAO;

    public SearchReindexService(RestHighLevelClient client, SearchIndexDAO searchIndexDAO) {
        this.client = client;
        this.searchIndexDAO = searchIndexDAO;
    }

    private static final String IDX_JOB = "job_posting";
    private static final String IDX_INTERVIEW = "interview";
    private static final String IDX_BOARD = "board";
    private static final String IDX_NOTICE = "notice";
    private static final String IDX_FAQ = "faq";

    @Transactional(readOnly = true)
    public Map<String, Integer> reindexAll() throws Exception {
        Map<String, Integer> result = new LinkedHashMap<>();

        result.put(IDX_JOB, bulkIndex(IDX_JOB, "JOB", searchIndexDAO.selectJobPostingForIndex()));
        result.put(IDX_INTERVIEW, bulkIndex(IDX_INTERVIEW, "INTERVIEW", searchIndexDAO.selectInterviewForIndex()));
        result.put(IDX_BOARD, bulkIndex(IDX_BOARD, "BOARD", searchIndexDAO.selectBoardForIndex()));
        result.put(IDX_NOTICE, bulkIndex(IDX_NOTICE, "NOTICE", searchIndexDAO.selectNoticeForIndex()));
        result.put(IDX_FAQ, bulkIndex(IDX_FAQ, "FAQ", searchIndexDAO.selectFaqForIndex()));

        return result;
    }

    private int bulkIndex(String indexName, String type, List<IndexRow> rows) throws Exception {
        if (rows == null || rows.isEmpty()) return 0;

        BulkRequest bulk = new BulkRequest();

        for (IndexRow r : rows) {
            if (r.getPk() == null) continue;

            Map<String, Object> doc = new HashMap<>();
            doc.put("pk", r.getPk());
            doc.put("type", type);
            doc.put("title", nvl(r.getTitle()));
            doc.put("content", nvl(r.getContent()));

            // 문서 ID는 type-pk 추천 (충돌 방지)
            String docId = type + "-" + r.getPk();

            bulk.add(new IndexRequest(indexName).id(docId).source(doc));
        }

        if (bulk.numberOfActions() == 0) return 0;

        BulkResponse resp = client.bulk(bulk, RequestOptions.DEFAULT);

        if (resp.hasFailures()) {
            System.out.println("Bulk 실패(" + indexName + "): " + resp.buildFailureMessage());
        }

        return bulk.numberOfActions();
    }

    private String nvl(String s) {
        return s == null ? "" : s;
    }
}
