<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 페이지</title>
<link rel="stylesheet" href="/css/admin.css">
</head>

<body>

  <%@ include file="/WEB-INF/views/header.jsp" %>

  <div class="admin-wrap">

    <div class="admin-hero">
      <div>
        <h1>관리자 페이지</h1>
        <div class="muted" style="color:#d1fae5;">
          회원/기업/공지/공고내역을 관리합니다.
        </div>
      </div>

      <a class="btn btn-primary" href="/">홈으로</a>
    </div>

    <div class="admin-grid">

      <a class="admin-tile" href="/admin/personals">
        <div class="admin-tile-title">일반회원 관리</div>
        <div class="admin-tile-desc">회원 목록 조회 / 상태 관리</div>
      </a>

      <a class="admin-tile" href="/admin/notices">
        <div class="admin-tile-title">공지사항 관리</div>
        <div class="admin-tile-desc">공지 등록/수정/삭제</div>
      </a>
      
      <a class="admin-tile" href="/admin/faq">
         <div class="admin-tile-title">FAQ 관리</div>
         <div class="admin-tile-desc">FAQ 등록/수정/삭제</div>
      </a>

      <a class="admin-tile" href="/admin/pending">
        <div class="admin-tile-title">공고등록 관리</div>
        <div class="admin-tile-desc">공고등록현황 확인</div>
      </a>
      
      <a class="admin-tile" href="/interview/list">
		  <div class="admin-tile-title">인터뷰 관리</div>
		  <div class="admin-tile-desc">인터뷰 등록/수정/삭제</div>
	  </a>
	  
	  <a class="admin-tile" href="http://192.168.10.102:5601/app/dashboards#/view/2ea6eb50-055b-11f1-af05-2bcbe3332711?_g=(filters:!(),refreshInterval:(pause:!t,value:0),time:(from:now-15m,to:now))&_a=(description:'',filters:!(),fullScreenMode:!f,options:(hidePanelTitles:!f,useMargins:!t),query:(language:kuery,query:''),timeRestore:!f,title:'IDO!!T',viewMode:view)">
		  
		  <div class="admin-tile-title">통계 관리</div>
		  <div class="admin-tile-desc">대시보드 및 시각화</div>
	  </a>
    </div>

  </div>

  <%@ include file="/WEB-INF/views/footer.jsp" %>

</body>
</html>
