<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회사 정보</title>
<style>
  :root{
    --base:#0F2E55;
    --baseSoft:#163B6A;
    --bg:#F5F7FA;
    --card:#fff;
    --text:#111827;
    --muted:#6B7280;
    --line:#E5E7EB;
    --accent:#E6EEF8;
  }

  body{
    margin:0;
    font-family:'Segoe UI','Apple SD Gothic Neo',sans-serif;
    background:var(--bg);
    color:var(--text);
  }

  .wrap{
    max-width:1100px;
    margin:26px auto;
    padding:0 18px 60px;
  }

  .head{
    display:flex;
    align-items:flex-end;
    justify-content:space-between;
    gap:12px;
    margin-bottom:14px;
  }
  h2{
    margin:0;
    font-size:22px;
    font-weight:900;
    color:var(--base);
  }
  .sub{
    margin-top:6px;
    color:var(--muted);
    font-size:13px;
  }

  .topbar{
    display:flex;
    gap:10px;
    flex-wrap:wrap;
  }

  .btn{
    display:inline-flex;
    align-items:center;
    justify-content:center;
    padding:9px 12px;
    border-radius:10px;
    font-weight:900;
    text-decoration:none;
    border:1px solid rgba(15,46,85,.35);
    color:var(--base);
    background:#fff;
    cursor:pointer;
    white-space:nowrap;
    font-size:13px;
  }
  .btn:hover{background:var(--accent);}
  .btn.primary{
    background:var(--base);
    border-color:transparent;
    color:#fff;
  }
  .btn.primary:hover{background:var(--baseSoft);}

  .grid{
    display:grid;
    grid-template-columns:repeat(2, minmax(0, 1fr));
    gap:14px;
  }

  .card{
    background:var(--card);
    border:1px solid var(--line);
    border-radius:16px;
    padding:16px;
    box-shadow:0 10px 22px rgba(0,0,0,.06);
  }

  .row{
    display:flex;
    justify-content:space-between;
    gap:12px;
    align-items:flex-start;
  }

  .name{
    font-size:18px;
    font-weight:900;
    color:var(--text);
    margin:0 0 6px;
  }

  .meta{
    color:var(--muted);
    font-size:13px;
    line-height:1.6;
  }

  .chip{
    display:inline-flex;
    align-items:center;
    gap:6px;
    padding:6px 10px;
    border-radius:999px;
    border:1px solid var(--line);
    background:#fff;
    color:var(--base);
    font-weight:900;
    font-size:12px;
    width:max-content;
  }

  .thumb{
    width:68px;
    height:68px;
    border-radius:14px;
    border:1px solid var(--line);
    background:#fff;
    overflow:hidden;
    display:flex;
    align-items:center;
    justify-content:center;
    flex:0 0 auto;
  }
  .thumb img{
    width:100%;
    height:100%;
    object-fit:cover;
    display:block;
  }
  .thumb .ph{
    color:var(--muted);
    font-weight:900;
    font-size:12px;
  }

  .actions{
    margin-top:12px;
    display:flex;
    gap:10px;
    flex-wrap:wrap;
  }

  .empty{
    background:var(--card);
    border:1px solid var(--line);
    border-radius:16px;
    padding:22px;
    text-align:center;
    color:var(--muted);
    box-shadow:0 10px 22px rgba(0,0,0,.06);
  }

  .link{
    color:var(--base);
    font-weight:800;
    text-decoration:none;
    word-break:break-all;
  }
  .link:hover{text-decoration:underline;}

  @media (max-width: 860px){
    .grid{grid-template-columns:1fr;}
  }
</style>
</head>

<body>
<%@ include file="/WEB-INF/views/header.jsp" %>

<div class="wrap">

  <div class="head">
    <div>
      <h2>회사 정보</h2>
      <div class="sub">현재 로그인한 기업 계정에 등록된 회사 목록입니다.</div>
    </div>
    <div class="topbar">
      <a class="btn" href="/company/dashboard">기업 홈</a>
      <a class="btn" href="/company/postings">공고 관리</a>
      <a class="btn primary" href="/company/join">회사 추가 등록</a>
    </div>
  </div>

  <c:choose>
    <c:when test="${empty items}">
      <div class="empty">
        등록된 회사가 없습니다.<br/>
        상단의 <b>회사 추가 등록</b>으로 회사를 등록하세요.
      </div>
    </c:when>

    <c:otherwise>
      <div class="grid">
        <c:forEach var="c" items="${items}">
          <div class="card">
            <div class="row">
              <div>
                <div class="name">${c.cname}</div>
                <div class="meta">
                  <div><span class="chip">회사번호: ${c.cno}</span></div>

                  <div style="margin-top:8px;">
                    <c:choose>
                      <c:when test="${not empty c.cbizno}">
                        사업자번호: ${c.cbizno}
                      </c:when>
                      <c:otherwise>
                        사업자번호: -
                      </c:otherwise>
                    </c:choose>
                  </div>

                  <div style="margin-top:6px;">
                    <c:choose>
                      <c:when test="${not empty c.caddr}">
                        주소: ${c.caddr} ${c.caddrdetail}
                      </c:when>
                      <c:otherwise>
                        주소: -
                      </c:otherwise>
                    </c:choose>
                  </div>

                  <div style="margin-top:6px;">
                    <c:choose>
                      <c:when test="${not empty c.cpage}">
                        홈페이지:
                        <a class="link" href="${c.cpage}" target="_blank" rel="noopener noreferrer">
                          ${c.cpage}
                        </a>
                      </c:when>
                      <c:otherwise>
                        홈페이지: -
                      </c:otherwise>
                    </c:choose>
                  </div>
                </div>
              </div>

              <!-- ✅ 회사 이미지: JSON 배열/단일문자열 둘다 대응 + 안전처리 -->
              <div class="thumb">
                <c:set var="raw" value="${c.cimage}" />
                <c:choose>
                  <c:when test="${not empty raw}">
                    <!-- 1) [ ] 제거 -->
                    <c:set var="t" value="${fn:replace(fn:replace(raw,'[',''),']','')}" />
                    <!-- 2) 따옴표 제거(일반 따옴표/HTML 엔티티) -->
                    <c:set var="t" value="${fn:replace(fn:replace(t,'&quot;',''),'\"','')}" />
                    <!-- 3) 첫번째 요소만 -->
                    <c:set var="first" value="${fn:trim(fn:split(t, ',')[0])}" />

                    <c:choose>
                      <c:when test="${not empty first}">
                        <img src="${first}" alt="company image">
                      </c:when>
                      <c:otherwise>
                        <img src="/images/no-company.png" alt="no image">
                      </c:otherwise>
                    </c:choose>
                  </c:when>

                  <c:otherwise>
                    <img src="/images/no-company.png" alt="no image">
                  </c:otherwise>
                </c:choose>
              </div>
            </div>

            <div class="actions">
              <a class="btn" href="/company/updateform?cno=${c.cno}">수정</a>
            </div>
          </div>
        </c:forEach>
      </div>
    </c:otherwise>
  </c:choose>

</div>

<%@ include file="/WEB-INF/views/footer.jsp" %>
</body>
</html>
