<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공고 등록 승인 관리</title>
<link rel="stylesheet" href="/css/admin.css">
<style>
  /* admin.css를 건드리지 않고 이 페이지에서만 최소 보강 */
  .admin-card {
    background: #fff;
    border-radius: 14px;
    padding: 18px;
    box-shadow: 0 8px 20px rgba(0,0,0,.06);
    margin-top: 14px;
  }
  .table {
    width: 100%;
    border-collapse: collapse;
    margin-top: 12px;
  }
  .table th, .table td {
    border-bottom: 1px solid #eee;
    padding: 12px 10px;
    text-align: center;
    vertical-align: middle;
  }
  .table th {
    background: #f9fafb;
    font-weight: 700;
  }
  .table td.title {
    text-align: left;
    font-weight: 600;
  }
  .badge {
    display: inline-block;
    padding: 4px 10px;
    border-radius: 999px;
    font-size: 12px;
    font-weight: 700;
  }
  .badge-pending { background: #fff7ed; color: #9a3412; }
  .actions form { display: inline-block; margin: 0 4px; }
  .btn-small {
    padding: 8px 10px;
    border-radius: 10px;
    border: 0;
    cursor: pointer;
    font-weight: 700;
  }
  .btn-approve { background: #10b981; color: #fff; }
  .btn-reject  { background: #ef4444; color: #fff; }
  .muted { color: #6b7280; font-size: 13px; }
</style>
</head>

<body>

  <%@ include file="/WEB-INF/views/header.jsp" %>

  <div class="admin-wrap">

    <!-- 상단 타이틀 영역: 대시보드 톤 그대로 -->
    <div class="admin-hero">
      <div>
        <h1>공고 등록 승인 관리</h1>
        <div class="muted" style="color:#d1fae5;">
          기업이 등록한 공고를 승인/반려합니다. (승인된 공고만 사용자에게 노출)
        </div>
      </div>

      <a class="btn btn-primary" href="/admin">관리자 홈</a>
    </div>

    <div class="admin-card">
      <div class="muted">
        현재권한: <sec:authentication property="authorities"/>
      </div>

      <!-- 데이터 없을 때 -->
      <c:if test="${empty list}">
        <p style="margin-top:14px;">승인 대기 중인 공고가 없습니다.</p>
      </c:if>

      <!-- 데이터 있을 때 -->
      <c:if test="${not empty list}">
        <table class="table">
          <thead>
            <tr>
              <th style="width:90px;">공고번호</th>
              <th>공고제목</th>
              <th style="width:180px;">기업명</th>
              <th style="width:130px;">등록일</th>
              <th style="width:110px;">상태</th>
              <th style="width:220px;">처리</th>
            </tr>
          </thead>
          <tbody>
            <c:forEach var="p" items="${list}">
              <tr>
                <td>${p.jno}</td>
                <td class="title">${p.jtitle}</td>
                <td>${p.cname}</td>
                <td><fmt:formatDate value="${p.jcreate}" pattern="yyyy-MM-dd"/></td>
                <td>
                  <span class="badge badge-pending">${p.jstatus}</span>
                </td>
                <td class="actions">
                  <!-- 승인 -->
                  <form action="${pageContext.request.contextPath}/admin/pending/approve" method="post">
                    <input type="hidden" name="jno" value="${p.jno}" />
                    <button type="submit" class="btn-small btn-approve">승인</button>
                  </form>

                  <!-- 반려 -->
                  <form action="${pageContext.request.contextPath}/admin/pending/reject" method="post">
                    <input type="hidden" name="jno" value="${p.jno}" />
                    <button type="submit" class="btn-small btn-reject"
                            onclick="return confirm('정말 반려 처리할까요?');">반려</button>
                  </form>
                </td>
              </tr>
            </c:forEach>
          </tbody>
        </table>
      </c:if>
    </div>

  </div>

  <%@ include file="/WEB-INF/views/footer.jsp" %>

</body>
</html>
