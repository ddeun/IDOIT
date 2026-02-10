<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>지원내역 관리</title>
<style>
  :root{
    --base:#0F2E55;
    --baseSoft:#163B6A;
    --bg:#F5F7FA;
    --card:#fff;
    --text:#111827;
    --muted:#6B7280;
    --line:#E5E7EB;
    --ok:#16a34a;
    --bad:#dc2626;
  }
  body{margin:0; font-family:'Segoe UI','Apple SD Gothic Neo',sans-serif; background:var(--bg); color:var(--text);}
  .wrap{max-width:1100px; margin:26px auto; padding:0 18px 60px;}
  .head{display:flex; align-items:flex-end; justify-content:space-between; gap:12px; margin-bottom:14px;}
  h2{margin:0; font-size:22px; font-weight:900; color:var(--base);}
  .sub{color:var(--muted); font-size:13px;}
  .sub b{color:var(--base);}

  .flash{
    margin:0 0 12px;
    padding:12px 14px;
    border-radius:14px;
    background:#E6EEF8;
    border:1px solid rgba(15,46,85,.18);
    color:var(--base);
    font-weight:900;
    font-size:13px;
  }

  .card{background:var(--card); border:1px solid var(--line); border-radius:16px; overflow:hidden; box-shadow:0 10px 22px rgba(0,0,0,.06);}
  table{width:100%; border-collapse:collapse;}
  th,td{padding:12px 12px; border-top:1px solid var(--line); text-align:center; font-size:14px;}
  th{background:#F3F4F6; font-weight:900; border-top:0;}
  td.left{text-align:left;}
  .badge{display:inline-block; padding:6px 10px; border-radius:999px; font-weight:900; font-size:12px; border:1px solid var(--line); background:#fff; color:var(--base);}
  .badge.done{background:#E6EEF8; border-color:#cfe0f6;}
  .badge.ok{background:#DCFCE7; border-color:#bbf7d0; color:#166534;}
  .badge.bad{background:#FEE2E2; border-color:#fecaca; color:#991b1b;}

  .btn{display:inline-flex; align-items:center; justify-content:center; padding:8px 12px; border-radius:10px; font-weight:900; text-decoration:none; border:1px solid transparent; cursor:pointer; font-size:13px;}
  .btn.outline{background:#fff; border-color:rgba(15,46,85,.35); color:var(--base);}
  .btn.outline:hover{background:#E6EEF8;}
  .btn.ok{background:var(--ok); color:#fff;}
  .btn.bad{background:var(--bad); color:#fff;}
  .btn.ok:hover,.btn.bad:hover{filter:brightness(.95);}

  .rowbtns{display:flex; gap:8px; justify-content:center; flex-wrap:wrap;}
  .empty{padding:22px; text-align:center; color:var(--muted);}

  .topbar{display:flex; gap:10px; margin-top:10px;}
</style>
</head>
<body>
<%@ include file="/WEB-INF/views/header.jsp" %>

<div class="wrap">

  <div class="head">
    <div>
      <h2>지원내역 관리</h2>

      <div class="sub">
        <c:choose>
          <c:when test="${not empty posting}">
            공고: <b>${posting.jtitle}</b> 의 지원자 목록입니다.
          </c:when>
          <c:otherwise>
            선택한 공고의 지원자 목록입니다.
          </c:otherwise>
        </c:choose>
      </div>
    </div>

    <div class="topbar">
      <a class="btn outline" href="/company/dashboard">기업 홈</a>
      <a class="btn outline" href="/company/postings">공고 관리</a>
    </div>
  </div>

  <c:if test="${not empty msg}">
    <div class="flash">${msg}</div>
  </c:if>

  <div class="card">
    <c:choose>
      <c:when test="${empty list}">
        <div class="empty">현재 지원 내역이 없습니다.</div>
      </c:when>
      <c:otherwise>
        <table>
          <thead>
            <tr>
              <th>지원번호</th>
              <th>회사</th>
              <th>공고</th>
              <th>지원자</th>
              <th>지원일</th>
              <th>상태</th>
              <th>관리</th>
            </tr>
          </thead>
          <tbody>
            <c:forEach var="a" items="${list}">
              <tr>
                <td>${a.ano}</td>
                <td>${a.cname}</td>
                <td class="left">${a.jtitle}</td>
                <td>${a.mname}</td>
                <td>${a.adate}</td>
                <td>
                  <c:choose>
                    <c:when test="${a.astatus eq '합격'}"><span class="badge ok">합격</span></c:when>
                    <c:when test="${a.astatus eq '불합격'}"><span class="badge bad">불합격</span></c:when>
                    <c:otherwise><span class="badge done">${a.astatus}</span></c:otherwise>
                  </c:choose>
                </td>

                <td>
                  <div class="rowbtns">

                    <!-- ✅ 이력서 버튼/없음 표시 (ano로 이동) -->
                    <c:choose>
                      <c:when test="${a.rno ne null && a.rno gt 0}">
                        <a class="btn outline" href="/company/resume/${a.ano}" target="_blank">이력서</a>
                      </c:when>
                      <c:otherwise>
                        <span class="badge done">이력서 없음</span>
                      </c:otherwise>
                    </c:choose>

                    <form action="/application/company/status" method="post" style="margin:0;">
                      <input type="hidden" name="ano" value="${a.ano}">
                      <input type="hidden" name="status" value="합격">
                      <input type="hidden" name="jno" value="${jno}">
                      <button class="btn ok" type="submit">합격</button>
                    </form>

                    <form action="/application/company/status" method="post" style="margin:0;">
                      <input type="hidden" name="ano" value="${a.ano}">
                      <input type="hidden" name="status" value="불합격">
                      <input type="hidden" name="jno" value="${jno}">
                      <button class="btn bad" type="submit">불합격</button>
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
