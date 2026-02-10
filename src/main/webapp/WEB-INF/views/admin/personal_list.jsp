<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>일반회원 관리</title>
<link rel="stylesheet" href="/css/main.css">

<style>
  .wrap{max-width:1120px; margin:26px auto; padding:0 16px 60px;}
  .topbar{display:flex; align-items:flex-end; justify-content:space-between; gap:12px; margin-bottom:14px;}
  .title{font-size:22px; font-weight:900; margin:0;}
  .sub{color:#6b7280; font-size:13px; margin-top:6px;}

  .card{border:1px solid #e5e7eb; border-radius:16px; background:#fff; overflow:hidden;}
  .table{width:100%; border-collapse:collapse;}
  .table th, .table td{padding:12px 12px; border-bottom:1px solid #f1f5f9; font-size:14px; text-align:left; vertical-align:middle;}
  .table th{background:#f8fafc; color:#334155; font-weight:800;}
  .muted{color:#64748b; font-size:13px;}
  .badge{display:inline-block; padding:6px 10px; border-radius:999px; font-weight:800; font-size:12px;}
  .active{background:#E7F8EE; color:#027A48;}
  .blocked{background:#FEE4E2; color:#B42318;}
  .btn{border:1px solid #e5e7eb; background:#fff; padding:8px 10px; border-radius:10px; cursor:pointer; font-weight:800; font-size:12px;}
  .btn-danger{border-color:#fecaca; color:#b42318; background:#fff;}
  .btn-ok{border-color:#bbf7d0; color:#027a48; background:#fff;}
  .actions{display:flex; gap:8px; flex-wrap:wrap;}
  .empty{padding:24px; text-align:center; color:#6b7280;}
</style>
</head>

<body>
<%@ include file="/WEB-INF/views/header.jsp" %>

<div class="wrap">
  <div class="topbar">
    <div>
      <h1 class="title">일반회원 관리</h1>
      <div class="sub">회원 목록 조회 및 상태 관리</div>
    </div>

    <div class="actions">
      <a class="btn" href="/admin">대시보드</a>
      <a class="btn" href="/">홈으로</a>
    </div>
  </div>

  <div class="card">
    <c:choose>
      <c:when test="${empty members}">
        <div class="empty">등록된 일반회원이 없습니다.</div>
      </c:when>
      <c:otherwise>
        <table class="table">
          <thead>
            <tr>
              <th style="width:90px;">번호</th>
              <th>이메일</th>
              <th>이름</th>
              <th style="width:140px;">상태</th>
              <th style="width:180px;">가입일</th>
              <th style="width:220px;">관리</th>
            </tr>
          </thead>

          <tbody>
          <c:forEach var="m" items="${members}">
            <tr>
              <td class="muted">${m.mno}</td>
              <td>${m.memail}</td>
              <td>${m.mname}</td>

              <td>
                <c:choose>
                  <c:when test="${m.mstatus == 'ACTIVE'}">
                    <span class="badge active">ACTIVE</span>
                  </c:when>
                  <c:otherwise>
                    <span class="badge blocked">${m.mstatus}</span>
                  </c:otherwise>
                </c:choose>
              </td>

              <td class="muted">
                <c:if test="${not empty m.mcreate}">
                  <fmt:formatDate value="${m.mcreate}" pattern="yyyy-MM-dd" />
                </c:if>
              </td>

              <td>
                <div class="actions">
                  <!-- ✅ 상태 변경: (예시) /admin/member/status 로 POST -->
                  <form method="post" action="/admin/member/status" style="margin:0;">
                    <input type="hidden" name="mno" value="${m.mno}">
                    <input type="hidden" name="mstatus" value="ACTIVE">
                    <button class="btn btn-ok" type="submit">활성화</button>
                  </form>

                  <form method="post" action="/admin/member/status" style="margin:0;">
                    <input type="hidden" name="mno" value="${m.mno}">
                    <input type="hidden" name="mstatus" value="BLOCKED">
                    <button class="btn btn-danger" type="submit"
                      onclick="return confirm('정말 정지 처리할까요?');">정지</button>
                  </form>
                  
                  <form method="post" action="/admin/member/withdraw" style="margin:0;">
					  <input type="hidden" name="mno" value="${m.mno}">
					  <button class="btn btn-danger" type="submit"
					    onclick="return confirm('정말 탈퇴(삭제) 처리할까요?');">탈퇴</button>
				  </form>
                </div>
              </td>
            </tr>
          </c:forEach>
          </tbody>
        </table>
      </c:otherwise>
    </c:choose>
  </div>
</div>

<%@ include file="/WEB-INF/views/footer.jsp" %>
</body>
</html>
