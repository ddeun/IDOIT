<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>이력서 보기</title>
<style>
  :root{
    --base:#0F2E55;
    --bg:#F5F7FA;
    --card:#fff;
    --text:#111827;
    --muted:#6B7280;
    --line:#E5E7EB;
  }
  body{margin:0; font-family:'Segoe UI','Apple SD Gothic Neo',sans-serif; background:var(--bg); color:var(--text);}
  .wrap{max-width:900px; margin:26px auto; padding:0 18px 60px;}
  .top{display:flex; justify-content:space-between; align-items:flex-end; gap:12px; margin-bottom:14px;}
  h2{margin:0; font-size:22px; font-weight:900; color:var(--base);}
  .sub{color:var(--muted); font-size:13px; margin-top:6px;}
  .btn{display:inline-flex; align-items:center; justify-content:center; padding:8px 12px; border-radius:10px; font-weight:900; text-decoration:none; border:1px solid rgba(15,46,85,.35); color:var(--base); background:#fff;}
  .btn:hover{background:#E6EEF8;}
  .btn.btn-orange{
  background:#FF7A00 !important;
  color:#fff !important;
  border:1px solid #FF7A00 !important;}
  .btn.btn-orange:hover{
  background:#ff8f26;
  border-color:#ff8f26;}
  .card{background:var(--card); border:1px solid var(--line); border-radius:16px; padding:18px; box-shadow:0 10px 22px rgba(0,0,0,.06);}
  .row{display:flex; flex-wrap:wrap; gap:10px; margin:8px 0;}
  .chip{padding:6px 10px; border-radius:999px; border:1px solid var(--line); background:#fff; font-weight:900; font-size:12px; color:var(--base);}
  .label{width:110px; color:var(--muted); font-weight:900;}
  .val{flex:1;}
  .hr{height:1px; background:var(--line); margin:14px 0;}
  .empty{padding:18px; color:var(--muted); text-align:center;}
</style>
</head>

<body>
<%@ include file="/WEB-INF/views/header.jsp" %>

<div class="wrap">

  <div class="top">
    <div>
      <h2>이력서 보기</h2>
      
      <div class="sub">지원자 이력서(기업 소유 공고 지원건만 조회)</div>
    </div>
    <div style="display:flex; gap:10px;">
    	<c:if test="${not empty r && not empty r.rno}">
			  <a class="btn btn-orange" href="/resume/detail?rno=${r.rno}">이력서 상세 보기</a>
		  </c:if>
      <a class="btn" href="/company/postings">공고관리</a>
    </div>
  </div>

  <c:choose>
    <c:when test="${empty r}">
      <div class="card">
        <div class="empty">
          <c:out value="${msg}" default="이력서 정보가 없습니다."/>
        </div>
      </div>
    </c:when>

    <c:otherwise>
      <div class="card">

        <div class="row">
          <span class="chip">공고: <c:out value="${r.jtitle}"/></span>
          <span class="chip">지원번호: <c:out value="${r.ano}"/></span>
          <span class="chip">상태: <c:out value="${r.astatus}"/></span>
        </div>

        <div class="hr"></div>

        <div class="row">
          <div class="label">지원자</div>
          <div class="val">
            <c:out value="${r.applicantName}"/> (<c:out value="${r.applicantEmail}"/>)
          </div>
        </div>

        <div class="row">
          <div class="label">이력서 제목</div>
          <div class="val"><b><c:out value="${r.rtitle}"/></b></div>
        </div>

        <div class="row">
          <div class="label">희망직무</div>
          <div class="val">
            <c:choose>
              <c:when test="${not empty r.rjobrole}"><c:out value="${r.rjobrole}"/></c:when>
              <c:otherwise>-</c:otherwise>
            </c:choose>
          </div>
        </div>

        <div class="row">
          <div class="label">요약</div>
          <div class="val" style="white-space:pre-wrap;">
            <c:choose>
              <c:when test="${not empty r.rsummary}"><c:out value="${r.rsummary}"/></c:when>
              <c:otherwise>-</c:otherwise>
            </c:choose>
          </div>
        </div>

        <div class="hr"></div>

        <div class="row">
          <div class="label">작성일</div>
          <div class="val"><c:out value="${r.rcreate}"/></div>
        </div>

        <div class="row">
          <div class="label">수정일</div>
          <div class="val">
            <c:choose>
              <c:when test="${not empty r.rupdate}"><c:out value="${r.rupdate}"/></c:when>
              <c:otherwise>-</c:otherwise>
            </c:choose>
          </div>
        </div>

      </div>
    </c:otherwise>
  </c:choose>

</div>

<%@ include file="/WEB-INF/views/footer.jsp" %>
</body>
</html>

