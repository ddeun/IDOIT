<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>내 지원내역</title>
<style>
  :root{
    --base:#0F2E55;
    --bg:#F5F7FA;
    --card:#fff;
    --text:#111827;
    --muted:#6B7280;
    --line:#E5E7EB;
    --ok:#16a34a;
    --bad:#dc2626;
    --wait:#B54708;
  }
  body{margin:0; font-family:'Segoe UI','Apple SD Gothic Neo',sans-serif; background:var(--bg); color:var(--text);}
  .wrap{max-width:1100px; margin:26px auto; padding:0 18px 60px;}
  .head{display:flex; align-items:flex-end; justify-content:space-between; gap:12px; margin-bottom:14px;}
  h2{margin:0; font-size:22px; font-weight:900; color:var(--base);}
  .sub{color:var(--muted); font-size:13px; margin-top:6px;}

  .card{background:var(--card); border:1px solid var(--line); border-radius:16px; overflow:hidden; box-shadow:0 10px 22px rgba(0,0,0,.06);}
  table{width:100%; border-collapse:collapse;}
  th,td{padding:12px 12px; border-top:1px solid var(--line); text-align:center; font-size:14px;}
  th{background:#F3F4F6; font-weight:900; border-top:0;}
  td.left{text-align:left;}

  .badge{display:inline-block; padding:6px 10px; border-radius:999px; font-weight:900; font-size:12px; border:1px solid var(--line); background:#fff; color:var(--base);}
  .badge.ok{background:#DCFCE7; border-color:#bbf7d0; color:#166534;}
  .badge.bad{background:#FEE2E2; border-color:#fecaca; color:#991b1b;}
  .badge.wait{background:#FFFAEB; border-color:#FEDF89; color:#92400e;}
  .badge.done{background:#E6EEF8; border-color:#cfe0f6; color:var(--base);}

  .btn{display:inline-flex; align-items:center; justify-content:center; padding:8px 12px; border-radius:10px; font-weight:900; text-decoration:none; border:1px solid rgba(15,46,85,.35); color:var(--base); background:#fff; font-size:13px;}
  .btn:hover{background:#E6EEF8;}

  .empty{padding:22px; text-align:center; color:var(--muted);}
</style>
</head>

<body>
<%@ include file="/WEB-INF/views/header.jsp" %>

<div class="wrap">

  <div class="head">
    <div>
      <h2>내 지원내역</h2>
      <div class="sub">기업에서 합격/불합격 처리한 결과를 여기서 확인합니다.</div>
    </div>
    <div style="display:flex; gap:10px;">
      <a class="btn" href="/mypage">마이페이지</a>
      <a class="btn" href="/job_posting/list">공고 보러가기</a>
    </div>
  </div>

  <div class="card">
    <c:choose>
      <c:when test="${empty list}">
        <div class="empty">아직 지원한 내역이 없습니다.</div>
      </c:when>

      <c:otherwise>
        <table>
          <thead>
            <tr>
              <th>지원번호</th>
              <th>회사</th>
              <th class="left">공고</th>
              <th>지원일</th>
              <th>상태</th>
            </tr>
          </thead>
          <tbody>
            <c:forEach var="a" items="${list}">
              <tr>
                <td>${a.ano}</td>
                <td>${a.cname}</td>
                <td class="left">${a.jtitle}</td>
                <td>${a.adate}</td>
                <td>
                  <c:choose>
                    <c:when test="${a.astatus eq '합격'}"><span class="badge ok">합격</span></c:when>
                    <c:when test="${a.astatus eq '불합격'}"><span class="badge bad">불합격</span></c:when>
                    <c:when test="${a.astatus eq '지원완료'}"><span class="badge wait">지원완료</span></c:when>
                    <c:otherwise><span class="badge done">${a.astatus}</span></c:otherwise>
                  </c:choose>
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
