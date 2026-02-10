<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>채용공고</title>

<style>
  @charset "UTF-8";

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

    --danger:#B42318;
    --danger-weak:#FEE4E2;
  }

  body{
    font-family:'Segoe UI','Apple SD Gothic Neo',sans-serif;
    background:var(--bg-light);
    margin:0;
    color:var(--text-main);
  }

  .wrap{max-width:1100px; margin:28px auto; padding:0 18px 50px;}
  h2{margin:0 0 14px; font-size:24px; font-weight:900; color:var(--base-color);}

  .topbar{display:flex; gap:10px; align-items:center; margin:12px 0 10px;}
  .search{display:flex; gap:8px; align-items:center; flex:1;}

  .search input{
    flex:1;
    padding:10px 12px;
    border:1px solid var(--border-light);
    border-radius:10px;
    background:var(--bg-white);
    outline:none;
  }
  .search input:focus{
    border-color:rgba(15,46,85,.45);
    box-shadow:0 0 0 3px rgba(15,46,85,.12);
  }

  .search button{
    padding:10px 14px;
    border:1px solid rgba(15,46,85,.25);
    border-radius:10px;
    background:var(--bg-white);
    cursor:pointer;
    font-weight:900;
    color:var(--base-color);
  }
  .search button:hover{
    background:var(--accent-weak);
    border-color:rgba(15,46,85,.35);
  }

  .writeBtn{
    padding:10px 14px;
    border:0;
    border-radius:10px;
    background:var(--base-color);
    color:#fff;
    font-weight:900;
    cursor:pointer;
  }
  .writeBtn:hover{ background:var(--base-soft); }

  /* ===== category chips ===== */
  .catwrap{
    background:var(--bg-white);
    border:1px solid var(--border-light);
    border-radius:16px;
    padding:14px 14px 12px;
    margin:8px 0 14px;
  }
  .catbar{
    display:flex;
    flex-wrap:wrap;
    gap:10px 10px;
    align-items:center;
    overflow:visible;
  }
  .chip{
    display:inline-flex;
    align-items:center;
    justify-content:center;
    padding:9px 14px;
    border:1px solid var(--border-light);
    border-radius:999px;
    background:var(--bg-white);
    color:var(--text-sub);
    font-size:13px;
    font-weight:900;
    text-decoration:none;
    white-space:nowrap;
    line-height:1;
    box-shadow:0 1px 0 rgba(0,0,0,0.02);
  }
  .chip:hover{
    border-color:rgba(15,46,85,.35);
    background:var(--accent-weak);
    color:var(--base-color);
  }
  .chip.active{
    background:var(--base-color);
    border-color:var(--base-color);
    color:#fff;
  }

  .list{margin-top:12px;}
  .row{
    position:relative;
    display:grid;
    grid-template-columns:120px 1fr;
    gap:18px;
    padding:22px 0;
    border-bottom:1px solid var(--border-light);
    align-items:start;
  }

  .thumb{
    width:120px; height:120px;
    border-radius:16px;
    background:var(--muted-bg);
    overflow:hidden;
    display:flex; align-items:center; justify-content:center;
    border:1px solid rgba(229,231,235,.9);
  }
  .thumb img{width:100%; height:100%; object-fit:cover;}
  .noimg{font-size:12px; color:#9ca3af; font-weight:900;}

  /* ===== 배지 ===== */
  .badge{
    position:absolute;
    top:30px; left:7px;
    padding:5px 9px;
    border-radius:7px;
    font-size:12px;
    font-weight:900;
    line-height:1;
    background:var(--accent-weak);
    color:var(--base-color);
    border:1px solid rgba(15,46,85,.18);
  }
  .badge.always{
    background:var(--accent-weak);
    color:var(--base-color);
    border-color:rgba(15,46,85,.18);
  }
  .badge.today{
    background:var(--danger-weak);
    color:var(--danger);
    border-color:rgba(180,35,24,.18);
  }
  .badge.closed{
    background:var(--muted-bg);
    color:var(--text-sub);
    border-color:var(--border-light);
  }

  .title{margin:0; font-size:20px; font-weight:900; line-height:1.25;}
  .title a{
    text-decoration:none;
    color:var(--base-color);
  }
  .title a:hover{
    color:var(--base-soft);
    text-decoration:underline;
    text-underline-offset:3px;
  }

  .company{margin-top:6px; font-weight:900; font-size:15px; color:var(--text-main);}
  .meta{margin-top:8px; color:var(--text-sub); font-size:13px; display:flex; flex-wrap:wrap; gap:8px;}

  .tags{margin-top:12px; display:flex; flex-wrap:wrap; gap:8px;}
  .tag{
    border:1px solid var(--border-light);
    background:var(--bg-white);
    color:var(--base-color);
    border-radius:999px;
    padding:7px 11px;
    font-size:12px;
    font-weight:800;
  }

  /* ===== pagination ===== */
  .paging{
    display:flex;
    justify-content:center;
    align-items:center;
    gap:8px;
    margin:26px 0 0;
  }
  .paging a, .paging span{
    min-width:38px;
    height:38px;
    padding:0 12px;
    display:inline-flex;
    align-items:center;
    justify-content:center;
    border:1px solid var(--border-light);
    border-radius:12px;
    font-weight:900;
    font-size:13px;
    color:var(--base-color);
    text-decoration:none;
    background:var(--bg-white);
  }
  .paging a:hover{
    border-color:rgba(15,46,85,.35);
    background:var(--accent-weak);
  }
  .paging .active{
    background:var(--base-color);
    color:#fff;
    border-color:var(--base-color);
  }
  .paging .disabled{
    color:#9ca3af;
    background:#f9fafb;
    border-color:#eef2f7;
    cursor:not-allowed;
  }

  @media (max-width:640px){
    .row{grid-template-columns:104px 1fr; gap:14px;}
    .thumb{width:104px; height:104px;}
    .title{font-size:18px;}
  }
</style>

</head>

<body>
<%@ include file="/WEB-INF/views/header.jsp" %>
<div class="wrap">
  <h2>개발 직무 탐색</h2>

  <div class="topbar">
    <form class="search" action="/job_posting/list" method="get">
      <input type="hidden" name="cat" value="${cat}">
      <input name="q" value="${q}" placeholder="검색어(회사/제목/포지션)">
      <button type="submit">검색</button>
    </form>

    <!-- ✅ 기업만 공고등록 버튼 보이기 (Spring Security 태그 방식) -->
    <sec:authorize access="hasRole('COMPANY')">
      <button class="writeBtn" onclick="location.href='/job_posting/writeform'">공고등록</button>
    </sec:authorize>
  </div>

  <div class="catwrap">
    <div class="catbar">
      <c:url var="allUrl" value="/job_posting/list">
        <c:param name="page" value="1"/>
        <c:param name="size" value="${size}"/>
        <c:if test="${not empty q}">
          <c:param name="q" value="${q}"/>
        </c:if>
      </c:url>
      <a class="chip ${empty cat ? 'active' : ''}" href="${allUrl}">전체</a>

      <c:forEach var="cname" items="${categoryList}">
        <c:url var="catUrl" value="/job_posting/list">
          <c:param name="page" value="1"/>
          <c:param name="size" value="${size}"/>
          <c:if test="${not empty q}">
            <c:param name="q" value="${q}"/>
          </c:if>
          <c:param name="cat" value="${cname}"/>
        </c:url>

        <a class="chip ${cat eq cname ? 'active' : ''}" href="${catUrl}">
          ${cname}
        </a>
      </c:forEach>
    </div>
  </div>

  <div class="list">
    <c:forEach var="it" items="${items}">

      <!-- D-day 계산 -->
      <c:set var="d" value="999999"/>
      <c:if test="${not empty it.jdeadline}">
        <fmt:formatDate value="<%= new java.util.Date() %>" pattern="yyyyMMdd" var="todayYmd"/>
        <fmt:formatDate value="${it.jdeadline}" pattern="yyyyMMdd" var="deadYmd"/>
        <fmt:parseDate value="${todayYmd}" pattern="yyyyMMdd" var="todayDate"/>
        <fmt:parseDate value="${deadYmd}" pattern="yyyyMMdd" var="deadDate"/>
        <c:set var="d" value="${(deadDate.time - todayDate.time) div 86400000}" />
      </c:if>

      <div class="row">

        <!-- 배지 -->
        <c:choose>
          <c:when test="${empty it.jdeadline}">
            <div class="badge always">상시</div>
          </c:when>
          <c:when test="${d lt 0}">
            <div class="badge closed">마감</div>
          </c:when>
          <c:when test="${d eq 0}">
            <div class="badge today">D-DAY</div>
          </c:when>
          <c:otherwise>
            <div class="badge">
              D-<fmt:formatNumber value="${d}" maxFractionDigits="0"/>
            </div>
          </c:otherwise>
        </c:choose>

        <!-- 썸네일 -->
        <div class="thumb">
          <c:set var="imgSrc" value="${not empty it.thumb ? it.thumb : it.cimage}" />
          <c:choose>
            <c:when test="${not empty imgSrc}">
              <img src="<c:url value='${imgSrc}'/>" alt="company">
            </c:when>
            <c:otherwise>
              <div class="noimg">NO IMAGE</div>
            </c:otherwise>
          </c:choose>
        </div>

        <div>
          <p class="title">
            <a href="/job_posting/detail/${it.jno}">${it.jtitle}</a>
          </p>

          <c:if test="${not empty it.cname}">
            <div class="company">${it.cname}</div>
          </c:if>

          <div class="meta">
            <c:if test="${not empty it.jposition}">${it.jposition}</c:if>
            <c:if test="${not empty it.jcareer}">· ${it.jcareer}</c:if>
            <c:if test="${not empty it.jlocation}">· ${it.jlocation}</c:if>

            <!-- ✅ 미정이면 숨김 -->
            <c:if test="${not empty it.jemployment and it.jemployment ne '미정'}">· ${it.jemployment}</c:if>
          </div>

          <c:if test="${not empty it.categories}">
            <div class="tags">
              <c:forEach var="t" items="${it.categories}">
                <span class="tag">${t}</span>
              </c:forEach>
            </div>
          </c:if>
        </div>

      </div>
    </c:forEach>

    <c:if test="${empty items}">
      <div style="padding:30px 0; color:#6b7280;">표시할 공고가 없습니다.</div>
    </c:if>

    <!-- Pagination (기존 그대로) -->
    <c:set var="blockSize" value="10"/>
    <c:set var="lastPage" value="${(total + size - 1) / size}"/>
    <c:if test="${lastPage lt 1}">
      <c:set var="lastPage" value="1"/>
    </c:if>

    <c:set var="startPage" value="${((page - 1) / blockSize) * blockSize + 1}"/>
    <c:set var="endPage" value="${startPage + blockSize - 1}"/>
    <c:if test="${endPage gt lastPage}">
      <c:set var="endPage" value="${lastPage}"/>
    </c:if>

    <c:if test="${total gt 0 && lastPage gt 1}">
      <div class="paging">

        <c:url var="firstUrl" value="/job_posting/list">
          <c:param name="page" value="1"/>
          <c:param name="size" value="${size}"/>
          <c:if test="${not empty q}"><c:param name="q" value="${q}"/></c:if>
          <c:if test="${not empty cat}"><c:param name="cat" value="${cat}"/></c:if>
        </c:url>

        <c:url var="prevUrl" value="/job_posting/list">
          <c:param name="page" value="${page - 1}"/>
          <c:param name="size" value="${size}"/>
          <c:if test="${not empty q}"><c:param name="q" value="${q}"/></c:if>
          <c:if test="${not empty cat}"><c:param name="cat" value="${cat}"/></c:if>
        </c:url>

        <c:url var="nextUrl" value="/job_posting/list">
          <c:param name="page" value="${page + 1}"/>
          <c:param name="size" value="${size}"/>
          <c:if test="${not empty q}"><c:param name="q" value="${q}"/></c:if>
          <c:if test="${not empty cat}"><c:param name="cat" value="${cat}"/></c:if>
        </c:url>

        <c:url var="lastUrl" value="/job_posting/list">
          <c:param name="page" value="${lastPage}"/>
          <c:param name="size" value="${size}"/>
          <c:if test="${not empty q}"><c:param name="q" value="${q}"/></c:if>
          <c:if test="${not empty cat}"><c:param name="cat" value="${cat}"/></c:if>
        </c:url>

        <c:choose>
          <c:when test="${page gt 1}">
            <a href="${firstUrl}">처음</a>
          </c:when>
          <c:otherwise>
            <span class="disabled">처음</span>
          </c:otherwise>
        </c:choose>

        <c:choose>
          <c:when test="${page gt 1}">
            <a href="${prevUrl}">이전</a>
          </c:when>
          <c:otherwise>
            <span class="disabled">이전</span>
          </c:otherwise>
        </c:choose>

        <c:forEach var="p" begin="${startPage}" end="${endPage}">
          <c:url var="pageUrl" value="/job_posting/list">
            <c:param name="page" value="${p}"/>
            <c:param name="size" value="${size}"/>
            <c:if test="${not empty q}"><c:param name="q" value="${q}"/></c:if>
            <c:if test="${not empty cat}"><c:param name="cat" value="${cat}"/></c:if>
          </c:url>

          <c:choose>
            <c:when test="${p eq page}">
              <span class="active">${p}</span>
            </c:when>
            <c:otherwise>
              <a href="${pageUrl}">${p}</a>
            </c:otherwise>
          </c:choose>
        </c:forEach>

        <c:choose>
          <c:when test="${page lt lastPage}">
            <a href="${nextUrl}">다음</a>
          </c:when>
          <c:otherwise>
            <span class="disabled">다음</span>
          </c:otherwise>
        </c:choose>

        <c:choose>
          <c:when test="${page lt lastPage}">
            <a href="${lastUrl}">끝</a>
          </c:when>
          <c:otherwise>
            <span class="disabled">끝</span>
          </c:otherwise>
        </c:choose>

      </div>
    </c:if>

  </div>
</div>
<%@ include file="/WEB-INF/views/footer.jsp" %>
</body>
</html>
