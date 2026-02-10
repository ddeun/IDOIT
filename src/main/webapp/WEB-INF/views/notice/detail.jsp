<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공지글 상세보기</title>
<link rel="stylesheet" href="/css/notice_detail.css">
</head>
<body>
<%@ include file="/WEB-INF/views/header.jsp" %>
<div class="notice-wrap" style="width:800px; margin:40px auto;">

    <!-- 제목 -->
     <h2 class="notice-title">
        ${notice.ntitle}
    </h2>

    <!-- 작성일 -->
    <div style="color:#888; font-size:13px; margin-bottom:25px;">등록일 : 
        <fmt:formatDate value="${notice.ndate}" pattern="yyyy-MM-dd HH:mm"/>
    </div>

    <!-- 내용 -->
    <div class="notice-content"
         style="line-height:1.8; font-size:15px; min-height:200px;">
        ${notice.ncontent}
    </div>

    <!-- ======================
         이전글 / 다음글
         ====================== -->
    <hr style="margin:50px 0 20px;">

    <table class="notice-nav" style="width:100%; border-collapse:collapse;">
       <tr>
           <td class="notice-nav-label">이전글</td>
           <td>
               <c:choose>
                   <c:when test="${prev != null}">
                       <a href="/notice/detail?nno=${prev.nno}">
                           ${prev.ntitle}
                       </a>
                       <span style="color:#aaa; font-size:12px; margin-left:10px;">
                           <fmt:formatDate value="${prev.ndate}" pattern="yyyy-MM-dd"/>
                       </span>
                   </c:when>
                   <c:otherwise>없음</c:otherwise>
               </c:choose>
           </td>
       </tr>
   
       <tr>
           <td class="notice-nav-label">다음글</td>
           <td>
               <c:choose>
                   <c:when test="${next != null}">
                       <a href="/notice/detail?nno=${next.nno}">
                           ${next.ntitle}
                       </a>
                       <span style="color:#aaa; font-size:12px; margin-left:10px;">
                           <fmt:formatDate value="${next.ndate}" pattern="yyyy-MM-dd"/>
                       </span>
                   </c:when>
                   <c:otherwise>없음</c:otherwise>
               </c:choose>
           </td>
       </tr>
   </table>

    <!-- ======================
         하단 컨트롤 영역
         ====================== -->
    <hr style="margin:35px 0 20px;">

    <div class="notice-footer">

        <!-- 목록 -->
        <div>
            <sec:authorize access="hasRole('ADMIN')">
                <button type="button" class="btn-outline btn-list" onclick="location.href='/admin/notices'">
                  목록
               </button>
            </sec:authorize>

            <sec:authorize access="!hasRole('ADMIN')">
                <button type="button" class="btn-outline btn-list" onclick="location.href='/notice/list'">
                  목록
                 </button>
            </sec:authorize>
        </div>

        <!-- 오른쪽 : 관리자 버튼 -->
        <sec:authorize access="hasRole('ADMIN')">
    <div align="right">
        <form action="/admin/notices/update" method="get" style="display:inline;">
            <input type="hidden" name="nno" value="${notice.nno}">
            <button type="submit" class="btn btn-primary">수정</button>
        </form>
        <form action="/admin/notices/delete" method="post" style="display:inline;">
            <input type="hidden" name="nno" value="${notice.nno}">
            <button type="submit"
                    class="btn btn-outline"
                    onclick="return confirm('정말 삭제하시겠습니까?');">
                삭제
            </button>
        </form>
    </div>
</sec:authorize>

    </div>
</div>
<%@ include file="/WEB-INF/views/footer.jsp" %>
</body>
</html>