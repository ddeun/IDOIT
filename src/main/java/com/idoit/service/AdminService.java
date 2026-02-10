package com.idoit.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.idoit.dao.AdminDAO;
import com.idoit.dto.MemberDTO;

@Service
public class AdminService {
    private final AdminDAO adminDAO;

    public AdminService(AdminDAO adminDAO) {
        this.adminDAO = adminDAO;
    }

    public List<MemberDTO> findPersonalMembers() {
        return adminDAO.findPersonalMembers();
    }
    
    public void changeRole(String memail, String role) {
        adminDAO.updateRole(memail, role);
    }
    public void changeMemberStatus(Long mno, String mstatus) {
        adminDAO.updateMemberStatus(mno, mstatus);
    }
    public void withdrawMember(Long mno) {
        adminDAO.withdrawMember(mno);
    }

}
