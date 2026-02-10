<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>개발자 인터뷰</title>

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

  .wrap{
    max-width:1100px;
    margin:28px auto;
    padding:0 18px 60px;
  }

  h2{
    margin:0 0 6px;
    font-size:26px;
    font-weight:900;
    color:var(--base-color);
  }
  .sub{
    color:var(--text-sub);
    font-size:13px;
    margin-bottom:14px;
  }

  .top{
    display:flex;
    justify-content:space-between;
    align-items:center;
    flex-wrap:wrap;
    gap:10px;
  }

  .writebtn{
    padding:10px 14px;
    border-radius:12px;
    background:var(--base-color);
    color:#fff;
    font-weight:900;
    text-decoration:none;
  }
  .writebtn:hover{ background:var(--base-soft); }

  /* 검색 */
  .search{
    display:flex;
    gap:8px;
    margin:14px 0 16px;
  }
  .search input{
    flex:1;
    padding:12px 14px;
    border:1px solid var(--border-light);
    border-radius:999px;
    outline:none;
    background:var(--bg-white);
  }
  .search input:focus{
    border-color:rgba(15,46,85,.45);
    box-shadow:0 0 0 3px rgba(15,46,85,.12);
  }
  .search button{
    padding:12px 18px;
    border:0;
    border-radius:999px;
    background:var(--base-color);
    color:#fff;
    font-weight:900;
    cursor:pointer;
  }
  .search button:hover{ background:var(--base-soft); }

  /* 카테고리 */
  .chips{
    display:flex;
    gap:8px;
    flex-wrap:wrap;
    margin-bottom:18px;
  }
  .chip{
    padding:9px 12px;
    border-radius:999px;
    border:1px solid var(--border-light);
    background:var(--bg-white);
    font-size:13px;
    font-weight:900;
    text-decoration:none;
    color:var(--text-sub);
  }
  .chip:hover{
    border-color:rgba(15,46,85,.35);
    background:var(--accent-weak);
    color:var(--base-color);
  }
  .chip.on{
    background:var(--base-color);
    border-color:var(--base-color);
    color:#fff;
  }

  /* 카드 그리드 */
  .interview-grid{
    display:grid !important;
    grid-template-columns:repeat(3, 1fr) !important;
    gap:16px !important;
  }
  @media(max-width:980px){
    .interview-grid{ grid-template-columns:repeat(2,1fr) !important; }
  }
  @media(max-width:640px){
    .interview-grid{ grid-template-columns:1fr !important; }
  }

  .interview-card{
    background:var(--bg-white);
    border:1px solid var(--border-light);
    border-radius:18px;
    overflow:hidden;
    box-shadow:0 8px 18px rgba(0,0,0,0.05);
    transition:transform .08s ease, box-shadow .12s ease, border-color .12s ease;
  }
  .interview-card:hover{
    transform: translateY(-2px);
    border-color:rgba(15,46,85,.22);
    box-shadow:0 14px 26px rgba(15,46,85,.10);
  }

  .interview-link{
    display:block;
    text-decoration:none;
    color:inherit;
  }

  .interview-thumb{
    height:150px !important;
    background:var(--accent-weak);
    position:relative;
    display:flex;
    align-items:center;
    justify-content:center;
    overflow:hidden;
  }
  .interview-thumb img{
    width:100%;
    height:100%;
    object-fit:cover;
    object-position:center;
    display:block;
  }

  .fallback{
    position:absolute;
    font-weight:900;
    color:var(--base-color);
    letter-spacing:1px;
  }
  .interview-thumb:not(.noimg) .fallback{ display:none; }
  .interview-thumb.noimg .fallback{ display:block; }

  .interview-body{
    padding:14px 14px 12px;
  }
  .title{
    font-size:16px;
    font-weight:900;
    line-height:1.35;
    height:44px;
    overflow:hidden;
    color:var(--text-main);
  }
  .sum{
    margin-top:8px;
    color:var(--text-sub);
    font-size:13px;
    line-height:1.4;
    height:36px;
    overflow:hidden;
  }
  .meta{
    display:flex;
    gap:10px;
    flex-wrap:wrap;
    margin-top:10px;
    color:var(--text-sub);
    font-size:12px;
  }

  .tagline{
    padding:0 14px 14px;
    display:flex;
    gap:6px;
    flex-wrap:wrap;
  }
  .tag{
    font-size:12px;
    padding:6px 10px;
    border-radius:999px;
    background:var(--muted-bg);
    color:var(--base-color);
    font-weight:900;
    text-decoration:none;
    border:1px solid transparent;
    transition:transform .08s ease, background .12s ease, border-color .12s ease;
  }
  .tag:hover{
    transform: translateY(-1px);
    background:var(--accent-weak);
    border-color:rgba(15,46,85,.20);
  }

  .empty{
    margin-top:14px;
    padding:18px;
    border:1px dashed rgba(15,46,85,.25);
    border-radius:14px;
    background:var(--bg-white);
    color:var(--text-sub);
  }
</style>

</head>

<body>
<%@ include file="/WEB-INF/views/header.jsp" %>
<div class="wrap">

  <div class="top">
    <div>
      <h2>현업 개발자들의 커리어·기술·성장 이야기</h2>
      <div class="sub">실제 개발자 인터뷰를 만나보세요</div>
    </div>

    <sec:authorize access="hasRole('ADMIN')">
      <a class="writebtn" href="/admin/interview/write">인터뷰 등록</a>
    </sec:authorize>
  </div>

  <!-- 검색 -->
  <form class="search" method="get" action="/interview/list">
    <input type="text" name="keyword" value="${keyword}" placeholder="검색어를 입력해주세요 (제목/요약/본문)">
    <button type="submit">검색</button>
    <input type="hidden" name="categoryKey" value="${categoryKey}">
    <input type="hidden" name="tag" value="${tag}">
  </form>

  <!-- ✅ 카테고리 (점핏 동일) -->
  <div class="chips">

    <!-- 전체 -->
    <c:url var="uAll" value="/interview/list">
      <c:param name="keyword" value="${keyword}" />
      <c:param name="tag" value="${tag}" />
    </c:url>
    <a class="chip ${empty categoryKey ? 'on' : ''}" href="${uAll}">전체</a>

    <!-- 서버/백엔드 개발자 -->
    <c:url var="uBackend" value="/interview/list">
      <c:param name="categoryKey" value="backend" />
      <c:param name="keyword" value="${keyword}" />
      <c:param name="tag" value="${tag}" />
    </c:url>
    <a class="chip ${categoryKey=='backend'?'on':''}" href="${uBackend}">서버/백엔드 개발자</a>

    <!-- 프론트엔드 개발자 -->
    <c:url var="uFrontend" value="/interview/list">
      <c:param name="categoryKey" value="frontend" />
      <c:param name="keyword" value="${keyword}" />
      <c:param name="tag" value="${tag}" />
    </c:url>
    <a class="chip ${categoryKey=='frontend'?'on':''}" href="${uFrontend}">프론트엔드 개발자</a>

    <!-- 웹 풀스택 개발자 -->
    <c:url var="uFullstack" value="/interview/list">
      <c:param name="categoryKey" value="fullstack" />
      <c:param name="keyword" value="${keyword}" />
      <c:param name="tag" value="${tag}" />
    </c:url>
    <a class="chip ${categoryKey=='fullstack'?'on':''}" href="${uFullstack}">웹 풀스택 개발자</a>

    <!-- 안드로이드 개발자 -->
    <c:url var="uAndroid" value="/interview/list">
      <c:param name="categoryKey" value="android" />
      <c:param name="keyword" value="${keyword}" />
      <c:param name="tag" value="${tag}" />
    </c:url>
    <a class="chip ${categoryKey=='android'?'on':''}" href="${uAndroid}">안드로이드 개발자</a>

    <!-- iOS 개발자 -->
    <c:url var="uIos" value="/interview/list">
      <c:param name="categoryKey" value="ios" />
      <c:param name="keyword" value="${keyword}" />
      <c:param name="tag" value="${tag}" />
    </c:url>
    <a class="chip ${categoryKey=='ios'?'on':''}" href="${uIos}">iOS 개발자</a>

    <!-- 크로스플랫폼 앱개발자 -->
    <c:url var="uCross" value="/interview/list">
      <c:param name="categoryKey" value="cross" />
      <c:param name="keyword" value="${keyword}" />
      <c:param name="tag" value="${tag}" />
    </c:url>
    <a class="chip ${categoryKey=='cross'?'on':''}" href="${uCross}">크로스플랫폼 앱개발자</a>

    <!-- 게임 클라이언트 개발자 -->
    <c:url var="uGame" value="/interview/list">
      <c:param name="categoryKey" value="game" />
      <c:param name="keyword" value="${keyword}" />
      <c:param name="tag" value="${tag}" />
    </c:url>
    <a class="chip ${categoryKey=='game'?'on':''}" href="${uGame}">게임 클라이언트 개발자</a>

    <!-- DBA -->
    <c:url var="uDba" value="/interview/list">
      <c:param name="categoryKey" value="dba" />
      <c:param name="keyword" value="${keyword}" />
      <c:param name="tag" value="${tag}" />
    </c:url>
    <a class="chip ${categoryKey=='dba'?'on':''}" href="${uDba}">DBA</a>

    <!-- 빅데이터 엔지니어 -->
    <c:url var="uBigdata" value="/interview/list">
      <c:param name="categoryKey" value="bigdata" />
      <c:param name="keyword" value="${keyword}" />
      <c:param name="tag" value="${tag}" />
    </c:url>
    <a class="chip ${categoryKey=='bigdata'?'on':''}" href="${uBigdata}">빅데이터 엔지니어</a>

    <!-- 인공지능/머신러닝 -->
    <c:url var="uAiml" value="/interview/list">
      <c:param name="categoryKey" value="aiml" />
      <c:param name="keyword" value="${keyword}" />
      <c:param name="tag" value="${tag}" />
    </c:url>
    <a class="chip ${categoryKey=='aiml'?'on':''}" href="${uAiml}">인공지능/머신러닝</a>

    <!-- devops/시스템 엔지니어 -->
    <c:url var="uDevops" value="/interview/list">
      <c:param name="categoryKey" value="devops" />
      <c:param name="keyword" value="${keyword}" />
      <c:param name="tag" value="${tag}" />
    </c:url>
    <a class="chip ${categoryKey=='devops'?'on':''}" href="${uDevops}">devops/시스템 엔지니어</a>

    <!-- 정보보안 담당자 -->
    <c:url var="uSecurity" value="/interview/list">
      <c:param name="categoryKey" value="security" />
      <c:param name="keyword" value="${keyword}" />
      <c:param name="tag" value="${tag}" />
    </c:url>
    <a class="chip ${categoryKey=='security'?'on':''}" href="${uSecurity}">정보보안 담당자</a>

    <!-- QA 엔지니어 -->
    <c:url var="uQa" value="/interview/list">
      <c:param name="categoryKey" value="qa" />
      <c:param name="keyword" value="${keyword}" />
      <c:param name="tag" value="${tag}" />
    </c:url>
    <a class="chip ${categoryKey=='qa'?'on':''}" href="${uQa}">QA 엔지니어</a>

    <!-- 개발 PM -->
    <c:url var="uPm" value="/interview/list">
      <c:param name="categoryKey" value="pm" />
      <c:param name="keyword" value="${keyword}" />
      <c:param name="tag" value="${tag}" />
    </c:url>
    <a class="chip ${categoryKey=='pm'?'on':''}" href="${uPm}">개발 PM</a>

    <!-- HW/임베디드 -->
    <c:url var="uEmbedded" value="/interview/list">
      <c:param name="categoryKey" value="embedded" />
      <c:param name="keyword" value="${keyword}" />
      <c:param name="tag" value="${tag}" />
    </c:url>
    <a class="chip ${categoryKey=='embedded'?'on':''}" href="${uEmbedded}">HW/임베디드</a>

    <!-- SW/솔루션 -->
    <c:url var="uSolution" value="/interview/list">
      <c:param name="categoryKey" value="solution" />
      <c:param name="keyword" value="${keyword}" />
      <c:param name="tag" value="${tag}" />
    </c:url>
    <a class="chip ${categoryKey=='solution'?'on':''}" href="${uSolution}">SW/솔루션</a>

    <!-- VR/AR/3D -->
    <c:url var="uVrar3d" value="/interview/list">
      <c:param name="categoryKey" value="vrar3d" />
      <c:param name="keyword" value="${keyword}" />
      <c:param name="tag" value="${tag}" />
    </c:url>
    <a class="chip ${categoryKey=='vrar3d'?'on':''}" href="${uVrar3d}">VR/AR/3D</a>

    <!-- 기술지원 -->
    <c:url var="uSupport" value="/interview/list">
      <c:param name="categoryKey" value="support" />
      <c:param name="keyword" value="${keyword}" />
      <c:param name="tag" value="${tag}" />
    </c:url>
    <a class="chip ${categoryKey=='support'?'on':''}" href="${uSupport}">기술지원</a>

  </div>

  <c:if test="${empty list}">
    <div class="empty">해당 조건의 인터뷰가 없어요 😅</div>
  </c:if>

  <!-- 카드 목록 -->
  <div class="interview-grid">
    <c:forEach var="it" items="${list}">
      <div class="interview-card">

        <a class="interview-link" href="/interview/detail?ino=${it.ino}">
          <c:set var="thumbSrc" value="${not empty it.iimagePath ? it.iimagePath : it.iimage_path}" />

          <div class="interview-thumb ${empty thumbSrc ? 'noimg' : ''}">
            <c:if test="${not empty thumbSrc}">
              <img src="${thumbSrc}" alt="thumb"
                   onerror="this.style.display='none'; this.parentElement.classList.add('noimg');">
            </c:if>
            <div class="fallback">INTERVIEW</div>
          </div>

          <div class="interview-body">
            <div class="title">${it.ititle}</div>
            <div class="sum">${it.isummary}</div>

            <div class="meta">
              <c:if test="${not empty it.icategory}">
                <span>${it.icategory}</span>
              </c:if>
              <span>조회 ${it.iview}</span>
              <span>${it.ireadmin}분</span>
            </div>
          </div>
        </a>

        <c:if test="${not empty it.itags}">
          <div class="tagline">
            <c:forTokens var="t" items="${it.itags}" delims=",">
              <c:url var="uTag" value="/interview/list">
                <c:param name="tag" value="${fn:trim(t)}" />
                <c:param name="keyword" value="${keyword}" />
                <c:param name="categoryKey" value="${categoryKey}" />
              </c:url>
              <a class="tag" href="${uTag}">#${fn:trim(t)}</a>
            </c:forTokens>
          </div>
        </c:if>

      </div>
    </c:forEach>
  </div>

</div>
<%@ include file="/WEB-INF/views/footer.jsp" %>
</body>
</html>
