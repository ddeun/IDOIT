<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>${dto.ititle}</title>

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

  /* 상단 버튼 라인(리스트 톤으로) */
  .topbar{
    display:flex;
    justify-content:space-between;
    align-items:center;
    flex-wrap:wrap;
    gap:10px;
    margin-bottom:14px;
  }
  .leftbtns, .rightbtns{
    display:flex;
    gap:10px;
    align-items:center;
    flex-wrap:wrap;
  }

  .btn{
    display:inline-flex;
    align-items:center;
    justify-content:center;
    gap:8px;
    padding:10px 14px;
    border-radius:12px;
    border:1px solid var(--border-light);
    background:var(--bg-white);
    font-weight:900;
    text-decoration:none;
    color:var(--text-main);
    cursor:pointer;
  }
  .btn:hover{
    border-color:rgba(15,46,85,.25);
    box-shadow:0 8px 18px rgba(15,46,85,.06);
    transform: translateY(-1px);
    transition:.12s ease;
  }
  .btn.primary{
    background:var(--base-color);
    border-color:var(--base-color);
    color:#fff;
  }
  .btn.primary:hover{ background:var(--base-soft); }
  .btn.danger{
    background:var(--danger);
    border-color:var(--danger);
    color:#fff;
  }

  /* 카드(리스트 카드 톤으로) */
  .card{
    background:var(--bg-white);
    border:1px solid var(--border-light);
    border-radius:18px;
    overflow:hidden;
    box-shadow:0 8px 18px rgba(0,0,0,0.05);
  }

  .thumb{
    height:260px;
    background:var(--accent-weak);
    position:relative;
    display:flex;
    align-items:center;
    justify-content:center;
    border-bottom:1px solid var(--border-light);
  }
  .thumb img{
    width:100%;
    height:100%;
    object-fit:cover;
    display:block;
  }
  .fallback{
    position:absolute;
    font-weight:900;
    color:var(--base-color);
    letter-spacing:1px;
  }
  .thumb:not(.noimg) .fallback{ display:none; }
  .thumb.noimg .fallback{ display:block; }

  .head{
    padding:18px 18px 12px;
  }
  h2{
    margin:0;
    font-size:26px;
    font-weight:900;
    color:var(--base-color);
    line-height:1.25;
  }

  .meta{
    margin-top:10px;
    display:flex;
    gap:10px;
    flex-wrap:wrap;
    color:var(--text-sub);
    font-size:12px;
  }

  /* 태그(리스트와 동일) */
  .tags{
    margin-top:12px;
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

  .summary{
    margin-top:12px;
    color:var(--text-sub);
    font-size:13px;
    line-height:1.6;
  }

  /* 본문 */
  .content{
    padding:18px;
    border-top:1px solid var(--border-light);
    line-height:1.85;
    color:var(--text-main);
  }
  .content img{ max-width:100%; height:auto; }
  .content a{ color:var(--base-color); font-weight:800; }

  /* ===== 에디터 Summary 카드(같은 톤으로 재스킨) ===== */
  .sumwrap{
    padding:0 18px 12px;
  }
  .sumcard{
    margin-top:14px;
    padding:14px 16px;
    border:1px solid var(--border-light);
    background:var(--bg-white);
    border-radius:14px;
    box-shadow:0 10px 22px rgba(15,46,85,.06);
  }
  .sumhead{
    display:flex;
    align-items:center;
    justify-content:space-between;
    gap:10px;
    margin-bottom:10px;
  }
  .sumleft{ display:flex; align-items:center; gap:10px; }
  .badge{
    font-size:12px;
    padding:6px 10px;
    border-radius:999px;
    background:var(--base-color);
    color:#fff;
    font-weight:900;
  }
  .sumtitle{ font-size:14px; font-weight:900; color:var(--text-main); }
  .sumlist{
    margin:0;
    padding-left:18px;
    color:var(--text-sub);
    line-height:1.75;
  }
  .sumlist li{ margin:6px 0; }

  /* 본문 안 원본 Summary 숨김 */
  .hide-inline-summary{ display:none !important; }

</style>
</head>

<body>
<%@ include file="/WEB-INF/views/header.jsp" %>

<div class="wrap">

  <!-- 상단 버튼 -->
  <div class="topbar">
    <div class="leftbtns">
      <a class="btn" href="/interview/list">← 목록</a>
    </div>

    <sec:authorize access="hasRole('ADMIN')">
      <div class="rightbtns">
        <a class="btn primary" href="/admin/interview/updateForm?ino=${dto.ino}">수정</a>
        <form method="post" action="/admin/interview/delete" style="display:inline;">
          <input type="hidden" name="ino" value="${dto.ino}">
          <button type="submit" class="btn danger" onclick="return confirm('정말 삭제하시겠습니까?');">삭제</button>
        </form>
      </div>
    </sec:authorize>
  </div>

  <div class="card">

    <!-- 썸네일 -->
    <div class="thumb ${empty dto.iimagePath ? 'noimg' : ''}">
      <c:if test="${not empty dto.iimagePath}">
        <img src="${dto.iimagePath}" alt="thumb"
             onerror="this.style.display='none'; this.parentElement.classList.add('noimg');">
      </c:if>
      <div class="fallback">INTERVIEW</div>
    </div>

    <!-- 헤더 -->
    <div class="head">
      <h2>${dto.ititle}</h2>

      <div class="meta">
        <c:if test="${not empty dto.icategory}">
          <span>${dto.icategory}</span>
        </c:if>
        <span>조회 ${dto.iview}</span>
        <span>${dto.ireadmin}분</span>
      </div>

      <c:if test="${not empty dto.itags}">
        <div class="tags">
          <c:forTokens var="t" items="${dto.itags}" delims=",">
            <a class="tag" href="/interview/list?tag=${fn:trim(t)}">#${fn:trim(t)}</a>
          </c:forTokens>
        </div>
      </c:if>

      <c:if test="${not empty dto.isummary}">
        <div class="summary">${dto.isummary}</div>
      </c:if>
    </div>

    <!-- ✅ summary 카드가 생길 자리 (없으면 아예 안 뜸) -->
    <div class="sumwrap" id="summaryBox" style="display:none;">
      <div class="sumcard">
        <div class="sumhead">
          <div class="sumleft">
            <span class="badge">SUMMARY</span>
            <span class="sumtitle">에디터 요약</span>
          </div>
        </div>
        <ul class="sumlist" id="summaryList"></ul>
      </div>
    </div>

    <!-- 본문 -->
    <div class="content" id="contentBox">
      ${dto.icontent}
    </div>

  </div>
</div>

<%@ include file="/WEB-INF/views/footer.jsp" %>

<script>
(function () {
  const contentBox = document.getElementById("contentBox");
  const summaryBox = document.getElementById("summaryBox");
  const summaryList = document.getElementById("summaryList");
  if (!contentBox || !summaryBox || !summaryList) return;

  // ✅ "에디터 Summary"가 들어간 '작은 박스'만 찾기 (본문 통째로 잡는 것 방지)
  const MAX_TARGET_TEXT = 1500;
  let target = null;

  // 1) 먼저 li가 있는 박스 중에서 "에디터 Summary" 포함된 것 찾기 (가장 안정적)
  const candidates = contentBox.querySelectorAll("div, section, article");

  for (const el of candidates) {
    if (el === contentBox) continue;
    const text = (el.innerText || "").replace(/\s+/g, " ").trim();
    if (!text.includes("에디터 Summary")) continue;
    if (text.length > MAX_TARGET_TEXT) continue;

    const hasLi = el.querySelectorAll("li").length > 0;
    const hasBullet = /[•\-\·\*]/.test(el.innerText || "");
    if (hasLi || hasBullet) {
      target = el;
      break;
    }
  }

  // 2) 그래도 못 찾으면, "에디터 Summary"가 있는 가장 짧은 블록을 선택
  if (!target) {
    let best = null;
    let bestLen = 999999;

    for (const el of candidates) {
      if (el === contentBox) continue;
      const text = (el.innerText || "").replace(/\s+/g, " ").trim();
      if (!text.includes("에디터 Summary")) continue;
      if (text.length > MAX_TARGET_TEXT) continue;

      if (text.length < bestLen) {
        best = el;
        bestLen = text.length;
      }
    }
    target = best;
  }

  if (!target) return;

  // 3) bullet 추출
  let bullets = [];
  const lis = target.querySelectorAll("li");

  if (lis.length > 0) {
    lis.forEach(li => {
      const line = (li.innerText || "").trim();
      if (line) bullets.push(line);
    });
  } else {
    let raw = (target.innerText || "");
    raw = raw.replace("에디터 Summary", "").trim();

    raw.split(/\n+/)
      .map(s => s.trim())
      .filter(Boolean)
      .forEach(line => {
        line = line.replace(/^[•\-\·\－\–\—\*]+\s*/, "").trim();
        if (line) bullets.push(line);
      });
  }

  bullets = bullets.filter(Boolean);
  if (bullets.length === 0) return;

  // 4) 카드 렌더
  summaryList.innerHTML = "";
  bullets.forEach(b => {
    const li = document.createElement("li");
    li.textContent = b;
    summaryList.appendChild(li);
  });
  summaryBox.style.display = "block";

  // 5) ✅ summary 원본 블록만 숨김 (본문은 그대로)
  target.classList.add("hide-inline-summary");
})();
</script>

</body>
</html>
