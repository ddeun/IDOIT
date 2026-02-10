<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>통합검색 | IDOIT</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="stylesheet"
      href="${pageContext.request.contextPath}/css/main.css">

<!-- ✅ 더보기 색상만 제어 -->
<style>
  .more-link{
    font-weight:800;
    color:#6b7280;        /* 무난한 회색 */
    text-decoration:none;
  }
  .more-link:hover{
    color:var(--navy);
    text-decoration:underline;
  }

  /* ✅ 혹시 HTML로 남아있는 img 태그는 아예 숨김(깨진 아이콘 방지) */
  .quick-card-desc img { display:none !important; }
</style>
</head>

<body>

  <%@ include file="/WEB-INF/views/header.jsp" %>

  <div class="container">

    <!-- 페이지 타이틀 -->
    <div style="margin: 18px 0 10px;">
      <div style="font-weight: 900; font-size: 22px; color: var(--navy);">통합검색</div>
      <div class="muted" style="margin-top:6px;">게시판 · 채용공고 · 인터뷰 · 공지 · FAQ를 한 번에 검색합니다.</div>
    </div>

    <!-- 검색바 -->
    <form method="get" action="/search_log/main"
          style="display:flex; gap:10px; align-items:center; margin: 10px 0 18px;">
      <input type="text" name="keyword" value="${keyword}"
             placeholder="검색어를 입력해주세요" autocomplete="off"
             style="flex:1; padding:12px 14px; border:1px solid #d1d5db; border-radius:12px;">
      <button type="submit" class="btn btn-primary" style="height:44px;">검색</button>
    </form>

    <c:if test="${empty keyword}">
      <div class="quick-grid">
        <a class="quick-card" href="/job_posting/list">
          <div class="quick-card-title">채용 공고</div>
          <div class="quick-card-desc">직무/키워드로 빠르게 검색</div>
        </a>

        <a class="quick-card" href="/board/list">
          <div class="quick-card-title">게시판</div>
          <div class="quick-card-desc">정보 공유/질문/후기</div>
        </a>

        <a class="quick-card" href="/interview/list">
          <div class="quick-card-title">인터뷰</div>
          <div class="quick-card-desc">질문/답변 모음</div>
        </a>
      </div>
    </c:if>

    <c:if test="${not empty keyword}">

      <!-- 결과 0개일 때 -->
      <c:if test="${empty jobList and empty boardList and empty interviewList and empty noticeList and empty faqList}">
        <div class="muted" style="padding:14px 0;">검색 결과가 없습니다.</div>
      </c:if>

      <!-- 채용공고 -->
      <div style="margin-top:14px;">
        <div style="display:flex; align-items:center; justify-content:space-between; margin: 10px 0;">
          <div style="font-weight:900; color:var(--navy); font-size:18px;">채용공고</div>
          <a class="more-link" href="/job_posting/list">더보기 →</a>
        </div>

        <c:if test="${empty jobList}">
          <div class="muted" style="padding:10px 0;">검색 결과가 없습니다.</div>
        </c:if>

        <c:forEach var="r" items="${jobList}" varStatus="st">
          <c:if test="${st.index lt 3}">
            <a href="/job_posting/detail/${r.pk}" style="display:block; text-decoration:none; color:inherit;">
              <div class="quick-card" style="margin-bottom:10px;">
                <div class="quick-card-title">
                  <c:out value="${r.hlTitle}" escapeXml="false"/>
                </div>
                <div class="quick-card-desc" style="margin-top:6px;">
                  <c:out value="${r.hlContent.replaceAll('(?i)<img[^>]*>', '').replaceAll('(?i)<img.*', '')}" escapeXml="false"/>
                </div>
              </div>
            </a>
          </c:if>
        </c:forEach>
      </div>

      <!-- 게시판 -->
      <div style="margin-top:14px;">
        <div style="display:flex; align-items:center; justify-content:space-between; margin: 10px 0;">
          <div style="font-weight:900; color:var(--navy); font-size:18px;">게시판</div>
          <a class="more-link" href="/board/list">더보기 →</a>
        </div>

        <c:if test="${empty boardList}">
          <div class="muted" style="padding:10px 0;">검색 결과가 없습니다.</div>
        </c:if>

        <c:forEach var="r" items="${boardList}" varStatus="st">
          <c:if test="${st.index lt 3}">
            <a href="/board/detail?bno=${r.pk}" style="display:block; text-decoration:none; color:inherit;">
              <div class="quick-card" style="margin-bottom:10px;">
                <div class="quick-card-title">
                  <c:out value="${r.hlTitle}" escapeXml="false"/>
                </div>
                <div class="quick-card-desc" style="margin-top:6px;">
                 
                </div>
              </div>
            </a>
          </c:if>
        </c:forEach>
      </div>

      <!-- 인터뷰 -->
      <div style="margin-top:14px;">
        <div style="display:flex; align-items:center; justify-content:space-between; margin: 10px 0;">
          <div style="font-weight:900; color:var(--navy); font-size:18px;">인터뷰</div>
          <a class="more-link" href="/interview/list">더보기 →</a>
        </div>

        <c:if test="${empty interviewList}">
          <div class="muted" style="padding:10px 0;">검색 결과가 없습니다.</div>
        </c:if>

        <c:forEach var="r" items="${interviewList}" varStatus="st">
          <c:if test="${st.index lt 3}">
            <a href="/interview/detail?ino=${r.pk}" style="display:block; text-decoration:none; color:inherit;">
              <div class="quick-card" style="margin-bottom:10px;">
                <div class="quick-card-title">
                  <c:out value="${r.hlTitle}" escapeXml="false"/>
                </div>
                <div class="quick-card-desc" style="margin-top:6px;">
                  
                </div>
              </div>
            </a>
          </c:if>
        </c:forEach>
      </div>

      <!-- 공지 -->
      <div style="margin-top:14px;">
        <div style="display:flex; align-items:center; justify-content:space-between; margin: 10px 0;">
          <div style="font-weight:900; color:var(--navy); font-size:18px;">공지</div>
          <a class="more-link" href="/notice/list">더보기 →</a>
        </div>

        <c:if test="${empty noticeList}">
          <div class="muted" style="padding:10px 0;">검색 결과가 없습니다.</div>
        </c:if>

        <c:forEach var="r" items="${noticeList}" varStatus="st">
          <c:if test="${st.index lt 3}">
            <a href="/notice/detail?no=${r.pk}" style="display:block; text-decoration:none; color:inherit;">
              <div class="quick-card" style="margin-bottom:10px;">
                <div class="quick-card-title">
                  <c:out value="${r.hlTitle}" escapeXml="false"/>
                </div>
                <div class="quick-card-desc" style="margin-top:6px;">
                  
                </div>
              </div>
            </a>
          </c:if>
        </c:forEach>
      </div>

      <!-- FAQ -->
      <div style="margin-top:14px;">
        <div style="display:flex; align-items:center; justify-content:space-between; margin: 10px 0;">
          <div style="font-weight:900; color:var(--navy); font-size:18px;">FAQ</div>
          <a class="more-link" href="/faq/list">더보기 →</a>
        </div>

        <c:if test="${empty faqList}">
          <div class="muted" style="padding:10px 0;">검색 결과가 없습니다.</div>
        </c:if>

        <c:forEach var="r" items="${faqList}" varStatus="st">
          <c:if test="${st.index lt 3}">
            <a href="/faq" style="display:block; text-decoration:none; color:inherit;">
              <div class="quick-card" style="margin-bottom:10px;">
                <div class="quick-card-title">
                  <c:out value="${r.hlTitle}" escapeXml="false"/>
                </div>
                <div class="quick-card-desc" style="margin-top:6px;">
                  
                </div>
              </div>
            </a>
          </c:if>
        </c:forEach>
      </div>

    </c:if>
  </div>

  <%@ include file="/WEB-INF/views/footer.jsp" %>

</body>
</html>
