<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>공지사항 관리</title>
    <!-- 공지사항 관리 전용 CSS -->
    <link rel="stylesheet" href="/css/admin_notice_list.css">
</head>

<body>
<%@ include file="/WEB-INF/views/header.jsp" %>

<h2>공지사항 관리</h2>

<!-- 상단 컨트롤 영역 -->
<div class="notice-admin-top">

    <!-- 왼쪽 : 관리자 홈 -->
    <div>
        <a href="/admin" class="btn-outline">관리자 홈</a>
    </div>

    <!-- 오른쪽 : 공지 작성 -->
    <div>
        <a href="/admin/notices/write" class="btn-outline">공지 작성</a>
    </div>
</div>

<!-- 테이블 영역 -->
<div class="notice-table-wrap">
    <table class="notice-table">
        <thead>
        <tr>
            <th style="width:60%;">제목</th>
            <th style="width:20%;">작성일</th>
            <th style="width:20%;">관리</th>
        </tr>
        </thead>

        <tbody>
        <c:forEach var="n" items="${list}">
            <tr>
                <!-- 제목 -->
                <td class="title">
                    <c:if test="${n.npin == 'Y'}">
                        <span class="pin">&#128204;</span>
                    </c:if>
                    <a href="/notice/detail?nno=${n.nno}">
                        ${n.ntitle}
                    </a>
                </td>

                <!-- 작성일 -->
                <td>
                    <fmt:formatDate value="${n.ndate}" pattern="yyyy-MM-dd"/>
                </td>

                <!-- 관리 -->
                <td class="manage">
                    <a href="/admin/notices/update?nno=${n.nno}" class="btn-primary">수정</a>

                    <form action="/admin/notices/delete"
                          method="post"
                          onsubmit="return confirm('정말 삭제하시겠습니까?');">
                        <input type="hidden" name="nno" value="${n.nno}">
                        <button type="submit">삭제</button>
                    </form>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</div>

<%@ include file="/WEB-INF/views/footer.jsp" %>
</body>
</html>
