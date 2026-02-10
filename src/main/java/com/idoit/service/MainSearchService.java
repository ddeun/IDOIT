package com.idoit.service;

import java.util.*;
import java.util.stream.Collectors;

import org.elasticsearch.action.search.SearchRequest;
import org.elasticsearch.action.search.SearchResponse;
import org.elasticsearch.client.*;
import org.elasticsearch.index.query.QueryBuilders;
import org.elasticsearch.search.SearchHit;
import org.elasticsearch.search.builder.SearchSourceBuilder;
import org.elasticsearch.search.fetch.subphase.highlight.HighlightBuilder;
import org.springframework.stereotype.Service;

import com.idoit.dto.SearchResultRow;

@Service
public class MainSearchService {

    private final RestHighLevelClient client;

    // 네가 만든 alias 이름 (필요하면 바꿔)
    private static final String ALIAS = "search_all";

    public MainSearchService(RestHighLevelClient client) {
        this.client = client;
    }

    public Map<String, List<SearchResultRow>> searchGrouped(String keyword, int sizePerType) throws Exception {
        String q = (keyword == null) ? "" : keyword.trim();
        if (q.isEmpty()) {
            return emptyGroups();
        }

        SearchRequest req = new SearchRequest(ALIAS);

        SearchSourceBuilder source = new SearchSourceBuilder();
        source.size(200); // 전체 결과 상한 (너무 크면 100~300 사이로)

        // 1~2글자도 잡히게 ngram 필드도 같이 검색
        source.query(
        	    QueryBuilders.multiMatchQuery(q)
        	        .field("title", 4.0f)
        	        .field("content", 1.0f)
        	        .field("title.ngram", 2.0f)
        	        .field("content.ngram", 1.0f)
        	);

        // 하이라이트
        HighlightBuilder hb = new HighlightBuilder()
                .preTags("<em>")
                .postTags("</em>");
        hb.field(new HighlightBuilder.Field("title"));
        hb.field(new HighlightBuilder.Field("content"));
        source.highlighter(hb);

        req.source(source);

        SearchResponse resp = client.search(req, RequestOptions.DEFAULT);

        List<SearchResultRow> rows = new ArrayList<>();
        for (SearchHit hit : resp.getHits().getHits()) {
            Map<String, Object> m = hit.getSourceAsMap();

            SearchResultRow r = new SearchResultRow();
            r.setType(nvl((String) m.get("type")));
            r.setPk(parseLong(m.get("pk")));
            r.setTitle(nvl((String) m.get("title")));
            r.setContent(nvl((String) m.get("content")));

            // highlight 있으면 우선 사용
            String hlTitle = r.getTitle();
            if (hit.getHighlightFields().get("title") != null
                    && hit.getHighlightFields().get("title").fragments().length > 0) {
                hlTitle = hit.getHighlightFields().get("title").fragments()[0].string();
            }
            r.setHlTitle(hlTitle);

            String hlContent = snippet(r.getContent(), 120);
            if (hit.getHighlightFields().get("content") != null
                    && hit.getHighlightFields().get("content").fragments().length > 0) {
                hlContent = hit.getHighlightFields().get("content").fragments()[0].string();
            }
            r.setHlContent(hlContent);

            rows.add(r);
        }

        // type별 그룹화
        Map<String, List<SearchResultRow>> grouped = rows.stream()
                .collect(Collectors.groupingBy(
                        r -> nvl(r.getType()),
                        LinkedHashMap::new,
                        Collectors.toList()
                ));

        // 항상 5개 키가 존재하게 보정 + type당 N개 제한
        Map<String, List<SearchResultRow>> out = emptyGroups();
        for (String key : out.keySet()) {
            List<SearchResultRow> list = grouped.getOrDefault(key, List.of());
            if (list.size() > sizePerType) list = list.subList(0, sizePerType);
            out.put(key, list);
        }

        return out;
    }

    private Map<String, List<SearchResultRow>> emptyGroups() {
        Map<String, List<SearchResultRow>> m = new LinkedHashMap<>();
        m.put("JOB", new ArrayList<>());
        m.put("BOARD", new ArrayList<>());
        m.put("INTERVIEW", new ArrayList<>());
        m.put("NOTICE", new ArrayList<>());
        m.put("FAQ", new ArrayList<>());
        return m;
    }

    private String nvl(String s) { return s == null ? "" : s; }

    private long parseLong(Object o) {
        if (o == null) return 0L;
        try { return Long.parseLong(o.toString()); }
        catch (Exception e) { return 0L; }
    }

    private String snippet(String s, int max) {
        if (s == null) return "";
        String t = s.replaceAll("\\s+", " ").trim();
        if (t.length() <= max) return t;
        return t.substring(0, max) + "...";
    }
}
