package com.idoit.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.idoit.dao.CompanyDAO;
import com.idoit.dao.Job_postingDAO;
import com.idoit.dao.MemberDAO;
import com.idoit.dto.CompanyDTO;
import com.idoit.dto.Job_postingDTO;
import com.idoit.dto.MemberDTO;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class Job_postingService {

	private final Job_postingDAO jobPostingDAO;
    private final CompanyDAO companyDAO;
    private final MemberDAO memberDAO;
    private final SearchSyncService searchSyncService;
    private final com.idoit.util.TxAfterCommit txAfterCommit;
    
    private void syncJobPostingToEsAfterCommit(Job_postingDTO dto) {
        txAfterCommit.run(() -> {
            try {
                long pk = (long) dto.getJno();

                // APPROVED만 ES에 올리고, 그 외는 ES에서 제거
                if ("APPROVED".equalsIgnoreCase(dto.getJstatus())) {
                    searchSyncService.upsert(
                        SearchSyncService.IDX_JOB,
                        SearchSyncService.T_JOB,
                        pk,
                        dto.getJtitle(),
                        dto.getJcontent()
                    );
                } else {
                    searchSyncService.delete(
                        SearchSyncService.IDX_JOB,
                        SearchSyncService.T_JOB,
                        pk
                    );
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        });
    }
    
 // ✅ (추가) 기업 로그인 mno 기준: 내 공고만 조회
    public Map<String, Object> listMyPostings(int mno, String q, int page, int size) {
        int offset = (page - 1) * size;

        Map<String, Object> param = new HashMap<>();
        param.put("mno", mno);
        param.put("q", q);
        param.put("offset", offset);
        param.put("size", size);

        int total = jobPostingDAO.countByCompanyOwner(param);
        List<Job_postingDTO> items = jobPostingDAO.listByCompanyOwner(param);

        Map<String, Object> res = new HashMap<>();
        res.put("page", page);
        res.put("size", size);
        res.put("total", total);
        res.put("items", items);
        return res;
    }
    
    public Map<String, Object> list(String q, String cat, int page, int size) {
        int offset = (page - 1) * size;

        Map<String, Object> param = new HashMap<>();
        param.put("q", q);
        param.put("cat", cat);
        param.put("offset", offset);
        param.put("size", size);

        int total = jobPostingDAO.count(param);
        List<Job_postingDTO> items = jobPostingDAO.list(param);

        Map<String, Object> res = new HashMap<>();
        res.put("page", page);
        res.put("size", size);
        res.put("total", total);
        res.put("items", items);
        return res;
    }

    public Job_postingDTO detail(int jno) {
        return jobPostingDAO.detail(jno);
    }

    public List<CompanyDTO> listCompaniesByMno(int mno) {
        return companyDAO.listByMno(mno);
    }

    public int getMnoByMemail(String memail) {
        MemberDTO member = memberDAO.findByMemail(memail);
        if (member == null) throw new IllegalStateException("회원 정보가 없습니다. memail=" + memail);
        return member.getMno();
    }

    public void assertOwnedCompany(int mno, int cno) {
        int cnt = companyDAO.countOwned(mno, cno);
        if (cnt == 0) throw new IllegalStateException("내 소유 회사가 아닙니다. cno=" + cno);
    }

    public CompanyDTO findOwnedCompany(int mno, int cno) {
        CompanyDTO c = companyDAO.findOwnedCompany(mno, cno);
        if (c == null) throw new IllegalStateException("회사 조회 실패(소유 아님). cno=" + cno);
        return c;
    }

    @Transactional
    public int createByCompanyOwner(int mno, int cno, Job_postingDTO dto) {
        assertOwnedCompany(mno, cno);

        dto.setCno(cno);

        if (dto.getJcategories() == null || dto.getJcategories().isBlank()) dto.setJcategories("[]");

        // ✅ 생성은 승인 전이니까 PENDING 추천
        dto.setJstatus("PENDING");

        jobPostingDAO.insert(dto);

        // ✅ 승인 전이므로 ES에는 노출하지 않게 delete 처리됨
        syncJobPostingToEsAfterCommit(dto);

        return dto.getJno();
    }


    public Job_postingDTO detailOwnedByMno(int mno, int jno) {
        List<CompanyDTO> myCompanies = companyDAO.listByMno(mno);
        for (CompanyDTO c : myCompanies) {
            Job_postingDTO found = jobPostingDAO.detailOwnedByCno(jno, c.getCno());
            if (found != null) return found;
        }
        throw new IllegalStateException("내 회사 공고가 아닙니다. jno=" + jno);
    }

    @Transactional
    public int updateByCompanyOwner(int mno, Job_postingDTO dto) {
        if (dto.getCno() == null) throw new IllegalArgumentException("cno가 필요합니다.");
        assertOwnedCompany(mno, dto.getCno());

        if (dto.getJcategories() == null || dto.getJcategories().isBlank()) dto.setJcategories("[]");
        dto.setJstatus("PENDING");

        int updated = jobPostingDAO.update(dto);
        if (updated == 0) throw new IllegalStateException("수정 실패(권한/데이터 확인).");

        // ✅ 수정하면 승인대기 → ES에서는 제거
        syncJobPostingToEsAfterCommit(dto);

        return updated;
    }


    @Transactional
    public int deleteByCompanyOwner(int mno, int jno) {
        Job_postingDTO owned = detailOwnedByMno(mno, jno);

        int deleted = jobPostingDAO.softDeleteOwnedByCno(jno, owned.getCno());
        if (deleted == 0) throw new IllegalStateException("삭제 실패(권한/데이터 확인).");

        // ✅ ES에서도 삭제
        txAfterCommit.run(() -> {
            try {
                searchSyncService.delete(
                    SearchSyncService.IDX_JOB,
                    SearchSyncService.T_JOB,
                    (long) jno
                );
            } catch (Exception e) {
                e.printStackTrace();
            }
        });

        return deleted;
    }

    

    public List<Job_postingDTO> findPending() {
        return jobPostingDAO.findPending();
    }

    @Transactional
    public void approve(long jno) {
        jobPostingDAO.approve(jno);

        // 승인 후 DB에서 최신 데이터 다시 읽어서 ES upsert
        Job_postingDTO dto = jobPostingDAO.detail((int) jno);
        if (dto == null) return;

        dto.setJstatus("APPROVED");
        syncJobPostingToEsAfterCommit(dto);
    }

    @Transactional
    public void reject(long jno) {
        jobPostingDAO.reject(jno);

        txAfterCommit.run(() -> {
            try {
                searchSyncService.delete(
                    SearchSyncService.IDX_JOB,
                    SearchSyncService.T_JOB,
                    jno
                );
            } catch (Exception e) {
                e.printStackTrace();
            }
        });
    }

}
