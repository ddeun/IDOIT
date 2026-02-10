<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>IDOIT</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<link rel="stylesheet" href="/css/main.css">

</head>

<body>

  <%@ include file="/WEB-INF/views/header.jsp" %>

  <div class="container">

    <!-- HERO -->
    <div class="hero">

      <div class="hero-left">
        <div class="hero-title">IDOIT 취업 플랫폼</div>
        <div class="hero-sub">Do IT. Build Your Career.</div>

        <div class="hero-actions">
          <a class="btn btn-primary" href="/job_posting/list">공고 보러가기</a>
          <a class="btn" href="/resume/form">이력서 작성</a>
        </div>

      </div>

      <div class="hero-right" id="jobSlider">

        <!-- ✅ featuredJobs(최신 3개) -->
        <c:forEach var="j" items="${featuredJobs}" varStatus="st">

		  <c:set var="rawImg" value="${not empty j.thumb ? j.thumb : j.cimage}" />
		  <c:set var="imgSrc" value="${rawImg}" />
		  <c:if test="${not empty rawImg && fn:startsWith(rawImg, '[')}">
		    <c:set var="tmp" value="${fn:substringAfter(rawImg, '[\"')}" />
		    <c:set var="imgSrc" value="${fn:substringBefore(tmp, '\"')}" />
		  </c:if>
		
		  <a class="job-slide ${st.first ? 'active' : ''}" href="/job_posting/detail/${j.jno}">
			  <div class="slide-card slide-onlyimg">
			    <c:choose>
			      <c:when test="${not empty imgSrc}">
			        <img class="slide-onlyimg-img" src="${imgSrc}" alt="공고 이미지">
			      </c:when>
			      <c:otherwise>
			        <div class="noimg">NO IMAGE</div>
			      </c:otherwise>
			    </c:choose>
			
			    <div class="slide-onlyimg-title">
			      <c:out value="${j.jtitle}"/>
			    </div>
			  </div>
		  </a>

		
		</c:forEach>


        <!-- dots: 3개 고정 (featuredJobs가 3개라는 가정) -->
        <div class="dots">
          <span class="dot on"></span>
          <span class="dot"></span>
          <span class="dot"></span>
        </div>
      </div>

    </div>

    <!-- QUICK : ✅ 지원내역 / 공지사항만 -->
    <div class="quick-grid">
      <a class="quick-card" href="/application/my">
        <div class="quick-card-title">지원내역</div>
        <div class="quick-card-desc">지원 상태를 한눈에 확인</div>
      </a>

      <a class="quick-card" href="/notice/list">
        <div class="quick-card-title">공지사항</div>
        <div class="quick-card-desc">서비스 안내 및 업데이트</div>
      </a>
    </div>


    <!-- ✅ 메인 하단: 채용 공고 10개 -->
    <div class="main-section-title">최신 채용 공고</div>

    <div class="job-grid">
      <c:forEach var="job" items="${latestJobs}">
		  <a href="/job_posting/detail/${job.jno}"
		     style="display:block; text-decoration:none; color:inherit; margin-bottom:12px;">
		
		    <div class="quick-card" style="display:flex; gap:16px; align-items:center;">
		
		      <c:set var="rawImg" value="${not empty job.thumb ? job.thumb : job.cimage}" />
				<c:set var="imgSrc" value="${rawImg}" />
				
				<c:if test="${not empty rawImg && fn:startsWith(rawImg, '[')}">
				  <c:set var="tmp" value="${fn:substringAfter(rawImg, '[\"')}" />
				  <c:set var="imgSrc" value="${fn:substringBefore(tmp, '\"')}" />
				</c:if>
				
				<div class="main-job-thumb">
				  <c:choose>
				    <c:when test="${not empty imgSrc}">
				      <img src="${imgSrc}" alt="회사 이미지">
				    </c:when>
				    <c:otherwise>
				      <span class="noimg">이미지 없음</span>
				    </c:otherwise>
				  </c:choose>
				</div>


		      <div style="flex:1;">
		        <div style="font-weight:900; color:var(--navy);">
		          ${job.jtitle}
		        </div>
		
		        <div class="muted" style="margin-top:6px;">
		          ${job.cname}
		        </div>
		
		        <div class="muted" style="margin-top:4px; font-size:13px;">
		          ${job.jlocation} · ${job.jcareer}
		        </div>
		      </div>
		
		    </div>
		  </a>
		</c:forEach>

    </div>

    <div class="more-row">
      <a class="more-link" href="/job_posting/list">채용공고 더보기 →</a>
    </div>

  </div>

  <%@ include file="/WEB-INF/views/footer.jsp" %>

  <!-- 슬라이드 JS (그대로) -->
  <script>
    (function(){
      const root = document.getElementById('jobSlider');
      if(!root) return;
      const slides = Array.from(root.querySelectorAll('.job-slide'));
      const dots   = Array.from(root.querySelectorAll('.dot'));
      if(slides.length === 0) return;

      let idx = 0;
      function show(i){
        slides.forEach((s, k) => s.classList.toggle('active', k === i));
        dots.forEach((d, k) => d.classList.toggle('on', k === i));
      }
      setInterval(() => {
        idx = (idx + 1) % slides.length;
        show(idx);
      }, 3200);
      show(0);
    })();
  </script>

</body>
</html>

