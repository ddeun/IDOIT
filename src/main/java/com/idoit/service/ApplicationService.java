package com.idoit.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.idoit.dao.ApplicationDAO;
import com.idoit.dto.ApplicationDTO;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class ApplicationService {

    private final ApplicationDAO applicationDAO;

    public boolean exists(int mno, int jno) {
        return applicationDAO.exists(mno, jno) > 0;
    }

    @Transactional
    public boolean apply(int mno, int jno) {
        if (applicationDAO.exists(mno, jno) > 0) return false;
        applicationDAO.insert(mno, jno);
        return true;
    }

    @Transactional
    public boolean applyWithResume(int mno, int jno, int rno) {
        if (applicationDAO.exists(mno, jno) > 0) return false;
        applicationDAO.insertWithResume(mno, jno, rno);
        return true;
    }

    // ✅ 유저: 내 지원내역 (합격/불합격 통보 화면 데이터)
    public List<ApplicationDTO> findByMno(int mno) {
        return applicationDAO.findByMno(mno);
    }

    // ✅ 기업용: 특정 공고 지원자 목록(내 회사만)
    public List<ApplicationDTO> findApplicantsByJnoOwned(int jno, int companyMno) {
        return applicationDAO.findByJnoOwned(jno, companyMno);
    }

    @Transactional
    public void updateStatus(int ano, String status) {
        applicationDAO.updateStatus(ano, status);
    }
}
