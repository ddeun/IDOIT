<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>지원하기</title>
<style>
  :root{
    --base:#0F2E55;
    --base2:#163B6A;
    --bg:#F5F7FA;
    --card:#FFFFFF;
    --text:#111827;
    --muted:#6B7280;
    --border:#E5E7EB;
  }
  body{margin:0; font-family:'Segoe UI','Apple SD Gothic Neo',sans-serif; background:var(--bg); color:var(--text);}
  .wrap{max-width:820px; margin:26px auto; padding:0 18px 60px;}
  .card{background:var(--card); border:1px solid var(--border); border-radius:18px; overflow:hidden; box-shadow:0 10px 22px rgba(0,0,0,.06);}
  .head{padding:18px;}
  h2{margin:0; font-size:22px; font-weight:900; color:var(--base);}
  .sub{margin-top:8px; color:var(--muted); font-size:13px;}
  .section{padding:16px 18px; border-top:1px solid var(--border);}
  label{display:block; font-weight:900; margin-bottom:8px; color:var(--base);}
  select{width:100%; padding:12px 12px; border:1px solid var(--border); border-radius:12px; font-size:14px; background:#fff;}
  .row{display:flex; gap:10px; flex-wrap:wrap; align-items:center; justify-content:flex-end;}
  .btn{display:inline-flex; align-items:center; justify-content:center; padding:10px 14px; border-radius:10px; text-decoration:none; font-weight:900; border:0; cursor:pointer;}
  .btn.back{background:#fff; color:var(--base); border:1px solid rgba(15,46,85,.25);}
  .btn.back:hover{background:#E6EEF8;}
  .btn.primary{background:var(--base); color:#fff;}
  .btn.primary:hover{background:var(--base2);}
  .hint{margin-top:10px; color:var(--muted); font-size:13px;}
</style>
</head>
<body>
<%@ include file="/WEB-INF/views/header.jsp" %>

<div class="wrap">
  <div class="card">
    <div class="head">
      <h2>지원하기</h2>
      <div class="sub">
        <b>${item.jtitle}</b>
        <c:if test="${not empty item.cname}">
          · ${item.cname}
        </c:if>
      </div>
    </div>

    <form action="/application/apply" method="post">
      <input type="hidden" name="jno" value="${item.jno}" />

      <div class="section">
        <label>제출할 이력서 선택</label>

        <c:choose>
          <c:when test="${empty resumes}">
            <div class="hint">등록된 이력서가 없습니다. (이력서를 먼저 등록하면 선택할 수 있어요)</div>
            <!-- 이력서 없어도 지원 가능하게 하려면 select 없이 진행 -->
          </c:when>
          <c:otherwise>
            <select name="rno">
              <c:forEach var="r" items="${resumes}">
                <option value="${r.rno}">
                  ${r.rtitle}
                </option>
              </c:forEach>
            </select>
            <div class="hint">기본으로 선택된 이력서로 지원됩니다.</div>
          </c:otherwise>
        </c:choose>
      </div>

      <div class="section">
        <div class="row">
          <a class="btn back" href="/job_posting/detail/${item.jno}">뒤로가기</a>
          <button type="submit" class="btn primary" onclick="return confirm('해당 공고에 지원할까요?');">
            최종 제출
          </button>
        </div>
      </div>
    </form>
  </div>
</div>

<%@ include file="/WEB-INF/views/footer.jsp" %>
</body>
</html>
