package com.idoit.service;

import java.util.HashMap;
import java.util.Map;

import org.elasticsearch.action.delete.DeleteRequest;
import org.elasticsearch.action.index.IndexRequest;
import org.elasticsearch.client.RequestOptions;
import org.elasticsearch.client.RestHighLevelClient;
import org.springframework.stereotype.Service;

@Service
public class SearchSyncService {

    private final RestHighLevelClient client;

    public SearchSyncService(RestHighLevelClient client) {
        this.client = client;
    }

    // 인덱스명 상수
    public static final String IDX_JOB = "job_posting";
    public static final String IDX_BOARD = "board";
    public static final String IDX_INTERVIEW = "interview";
    public static final String IDX_NOTICE = "notice";
    public static final String IDX_FAQ = "faq";

    // type 상수
    public static final String T_JOB = "JOB";
    public static final String T_BOARD = "BOARD";
    public static final String T_INTERVIEW = "INTERVIEW";
    public static final String T_NOTICE = "NOTICE";
    public static final String T_FAQ = "FAQ";

    /** 등록/수정: 같은 ID로 index 하면 "덮어쓰기"라 update까지 커버됨 */
    public void upsert(String indexName, String type, Long pk, String title, String content) throws Exception {
        if (pk == null) throw new IllegalArgumentException("pk is null");

        Map<String, Object> doc = new HashMap<>();
        doc.put("pk", pk);
        doc.put("type", type);
        doc.put("title", title == null ? "" : title);
        doc.put("content", content == null ? "" : content);

        IndexRequest req = new IndexRequest(indexName)
                .id(docId(type, pk))
                .source(doc);

        client.index(req, RequestOptions.DEFAULT);
    }

    /** 삭제 */
    public void delete(String indexName, String type, Long pk) throws Exception {
        if (pk == null) throw new IllegalArgumentException("pk is null");

        DeleteRequest req = new DeleteRequest(indexName, docId(type, pk));
        client.delete(req, RequestOptions.DEFAULT);
    }

    private String docId(String type, Long pk) {
        return type + "-" + pk;
    }
}
