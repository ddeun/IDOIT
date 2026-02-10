<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공고 관리</title>

<style>
  :root{
    --base-color:#0F2E55;
    --base-soft:#163B6A;
    --bg-white:#FFFFFF;
    --bg-light:#F5F7FA;
    --text-main:#111827;
    --text-sub:#6B7280;
    --border-light:#E5E7EB;

    --accent-weak:#E6EEF8;
    --muted-bg:#F3F4F6;

    --ok:#027A48;
    --ok-weak:#ECFDF3;

    --warn:#B54708;
    --warn-weak:#FFFAEB;

    --danger:#B42318;
    --danger-weak:#FEE4E2;
  }

  body{
    font-family:'Segoe UI','Apple SD Gothic Neo',sans-serif;
    background:var(--bg-light);
    margin:0;
    color:var(--text-main);
  }

  .wrap{max-width:1100px; margin:26px auto; padding:0 18px 60px;}

  .topbar{
    display:flex;
    align-items:flex-end;
    justify-content:space-between;
    gap:12px;
    margin-bottom:14px;
  }
  h2{
    margin:0;
    font-size:24px;
    font-weight:900;
    color:var(--base-color);
  }
  .sub{
    margin-top:6px;
    color:var(--text-sub);
    font-size:13px;
  }

  .btn{
    display:inline-flex;
    align-items:center;
    justify-content:center;
    padding:10px 14px;
    border-radius:10px;
    text-decoration:none;
    font-weight:900;
    border:1px solid transparent;
    cursor:pointer;
    white-space:nowrap;
  }
  .btn.primary{background:var(--base-color); color:#fff;}
  .btn.primary:hover{background:var(--base-soft);}
  .btn.ghost{
    background:var(--bg-white);
    color:var(--base-color);
    border-color:rgba(15,46,85,.25);
  }
  .btn.ghost:hover{background:var(--accent-weak); border-color:rgba(15,46,85,.35);}
  .btn.outline{
    background:var(--bg-white);
    color:var(--base-color);
    border-color:rgba(15,46,85,.45);
  }
  .btn.outline:hover{background:var(--accent-weak); border-color:rgba(15,46,85,.55);}
  .btn.danger{
    background:var(--danger);
    color:#fff;
    border:0;
  }
  .btn.danger:hover{filter:brightness(.95);}

  .card{
    border:1px solid var(--border-light);
    border-radius:18px;
    overflow:hidden;
    box-shadow:0 10px 22px rgba(0,0,0,0.06);
    background:var(--bg-white);
  }

  .table{
    width:100%;
    border-collapse:collapse;
  }
  .table th, .table td{
    border-top:1px solid var(--border-light);
    padding:12px 12px;
    text-align:left;
    vertical-align:middle;
    font-size:14px;
  }
  .table thead th{
    border-top:0;
    background:#FBFCFE;
    color:var(--text-sub);
    font-size:12px;
    letter-spacing:.3px;
    text-transform:uppercase;
    font-weight:900;
  }

  .titleCell{
    display:flex;
    flex-direction:column;
    gap:6px;
    min-width:260px;
  }
  .jt{
    font-weight:900;
    color:var(--text-main);
    text-decoration:none;
  }
  .jt:hover{color:var(--base-color); text-decoration:underline;}
  .meta{
    display:flex;
    flex-wrap:wrap;
    gap:8px;
    color:var(--text-sub);
    font-size:12px;
  }

  .badge{
    display:inline-flex;
    align-items:center;
    gap:6px;
    padding:6px 10px;
    border-radius:999px;
    font-size:12px;
    font-weight:900;
    border:1px solid transparent;
    width:max-content;
  }
  .badge.ok{background:var(--ok-weak); color:var(--ok); border-color:#ABEFC6;}
  .badge.warn{background:var(--warn-weak); color:var(--warn); border-color:#FEDF89;}
  .badge.danger{background:var(--danger-weak); color:var(--danger); border-color:#FECDCA;}
  .badge.gray{background:var(--muted-bg); color:var(--text-sub); border-color:var(--border-light);}

  .actions{
    display:flex;
    gap:8px;
    justify-content:flex-end;
    flex-wrap:wrap;
  }

  .empty{
    padding:26px 18px;
    color:var(--text-sub);
    text-align:center;
  }

  .flash{
    margin:0 0 12px;
    padding:12px 14px;
    border-radius:14px;
    background:var(--accent-weak);
    border:1px solid rgba(15,46,85,.18);
    color:var(--base-color);
    font-weight:900;
    font-size:13px;
  }

  @media (max-width: 820px){
    .hide-sm{display:none;}
    .titleCell{min-width:auto;}
    .actions{justify-content:flex-start;}
  }
</style>
</head>

<body>
<%@ include file="/WEB-INF/views/header.jsp" %>

<div class="wrap">

  <div class="topbar">
    <div>
      <h2>공고 관리</h2>
      <div class="sub">현재 로그인한 기업 계정 기준으로 등록된 공고만 표시됩니다.</div>
    </div>

    <div style="display:flex; gap:10px; flex-wrap:wrap;">
      <a class="btn ghost" href="/company">기업 홈</a>
      <a class="btn primary" href="/job_posting/writeform">공고 등록</a>
    </div>
  </div>

  <c:if test="${not empty msg}">
    <div class="flash">${msg}</div>
  </c:if>

  <div class="card">

    <c:choose>
      <c:when test="${empty items}">
        <div class="empty">
          등록된 공고가 없습니다.<br/>
          상단의 <b>공고 등록</b> 버튼으로 새 공고를 작성해보세요.
        </div>
      </c:when>

      <c:otherwise>
        <table class="table">
          <thead>
            <tr>
              <th>공고</th>
              <th class="hide-sm">회사</th>
              <th class="hide-sm">마감</th>
              <th class="hide-sm">지원</th>
              <th>상태</th>
              <th style="text-align:right;">관리</th>
            </tr>
          </thead>
          <tbody>
            <c:forEach var="it" items="${items}">
              <tr>
                <td>
                  <div class="titleCell">
                    <a class="jt" href="/job_posting/detail/${it.jno}">
                      ${it.jtitle}
                    </a>
                    <div class="meta">
                      <c:if test="${not empty it.jposition}">
                        <span>${it.jposition}</span>
                      </c:if>
                      <c:if test="${not empty it.jemployment}">
                        <span>· ${it.jemployment}</span>
                      </c:if>
                      <c:if test="${not empty it.jlocation}">
                        <span>· ${it.jlocation}</span>
                      </c:if>
                    </div>
                  </div>
                </td>

                <td class="hide-sm">
                  <c:choose>
                    <c:when test="${not empty it.cname}">
                      ${it.cname}
                    </c:when>
                    <c:otherwise>
                      <span style="color:var(--text-sub);">-</span>
                    </c:otherwise>
                  </c:choose>
                </td>

                <td class="hide-sm">
                  <c:choose>
                    <c:when test="${not empty it.jdeadline}">
                      ${it.jdeadline}
                    </c:when>
                    <c:otherwise>
                      <span style="color:var(--text-sub);">상시</span>
                    </c:otherwise>
                  </c:choose>
                </td>

                <!-- ✅ 공고별 지원내역 보기 -->
                <td class="hide-sm">
                  <a class="btn outline" href="/company/applications?jno=${it.jno}">
                    지원내역
                    <c:if test="${it.applyCnt ne null}">
                      (${it.applyCnt})
                    </c:if>
                  </a>
                </td>

                <td>
                  <c:choose>
                    <c:when test="${it.jstatus == 'APPROVED'}">
                      <span class="badge ok">승인</span>
                    </c:when>
                    <c:when test="${it.jstatus == 'PENDING'}">
                      <span class="badge warn">대기</span>
                    </c:when>
                    <c:when test="${it.jstatus == 'REJECTED'}">
                      <span class="badge danger">반려</span>
                    </c:when>
                    <c:otherwise>
                      <span class="badge gray">${it.jstatus}</span>
                    </c:otherwise>
                  </c:choose>
                </td>

                <td>
                  <div class="actions">
                    <a class="btn outline" href="/job_posting/updateform/${it.jno}">수정</a>

                    <form action="/job_posting/delete/${it.jno}" method="post" style="margin:0;">
                      <button class="btn danger" type="submit"
                              onclick="return confirm('정말 삭제할까요?');">
                        삭제
                      </button>
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
