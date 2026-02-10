<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시글 상세</title>
<link rel="stylesheet" href="/css/board_detail.css">

<script>
function showEdit(bcno) {
  document.getElementById("view-" + bcno).style.display = "none";
  document.getElementById("edit-" + bcno).style.display = "block";
}
function hideEdit(bcno) {
  document.getElementById("edit-" + bcno).style.display = "none";
  document.getElementById("view-" + bcno).style.display = "block";
}
</script>
</head>

<body>
<%@ include file="/WEB-INF/views/header.jsp" %>

<h2 class="hero-title">게시글 상세</h2>

<table border="1" width="900" align="center">
  <tr>
    <th width="120">구분</th>
    <td>
      <c:choose>
        <c:when test="${board.btype eq 'FREE'}">자유</c:when>
        <c:when test="${board.btype eq 'STUDY'}">스터디</c:when>
        <c:when test="${board.btype eq 'REVIEW'}">취업후기</c:when>
        <c:otherwise>${board.btype}</c:otherwise>
      </c:choose>
    </td>
  </tr>

  <tr>
    <th>제목</th>
    <td>${board.btitle}</td>
  </tr>

  <tr>
    <th>작성자</th>
    <td>
      ${board.bwriter}
      <c:if test="${isAdmin and board.bwriter eq '익명'}">
        <span class="admin-info">
          (${board.realWriterName} / ${board.realWriterEmail})
        </span>
      </c:if>
    </td>
  </tr>

  <tr>
    <th>작성일</th>
    <td><fmt:formatDate value="${board.bcreate}" pattern="yyyy-MM-dd HH:mm"/></td>
  </tr>

  <tr>
    <th>조회수</th>
    <td>${board.bview}</td>
  </tr>

  <tr>
    <th>내용</th>
    <td>
      <c:out value="${board.bcontent}" escapeXml="false"/>
    </td>
  </tr>
</table>

<h3 class="comment-title">댓글</h3>

<div class="comment-wrap">

<c:if test="${empty commentList}">
  <p style="text-align:center; color:#6B7280; font-size:13px;">
    아직 댓글이 없습니다.
  </p>
</c:if>

<c:forEach var="c" items="${commentList}">

  <div id="view-${c.bcno}" class="comment-item">

    <div class="comment-header">
      <span class="comment-writer">
        <c:choose>
          <c:when test="${loginUser ne null and c.mno eq loginUser.mno}">
            나
          </c:when>
          <c:when test="${c.bcsecret eq 'Y' and (isAdmin or (loginUser ne null and loginUser.mno eq board.mno))}">
            ${c.realWriterName}
          </c:when>
          <c:when test="${c.bcsecret eq 'Y'}">
            익명
          </c:when>
          <c:otherwise>
            ${c.realWriterName}
          </c:otherwise>
        </c:choose>

        <c:if test="${isAdmin and c.bcsecret eq 'Y'}">
          <span class="admin-info">
            (${c.realWriterName} / ${c.realWriterEmail})
          </span>
        </c:if>
      </span>

      <span class="comment-date">
        <fmt:formatDate value="${c.bccreate}" pattern="yyyy-MM-dd HH:mm"/>
      </span>
    </div>

    <div class="comment-body">
      <c:choose>
        <c:when test="${c.bcsecret eq 'Y'
                        and not isAdmin
                        and (loginUser eq null
                             or (loginUser.mno ne c.mno and loginUser.mno ne board.mno))}">
          🔒 비밀 댓글입니다.
        </c:when>
        <c:otherwise>
          ${c.bccontent}
        </c:otherwise>
      </c:choose>
    </div>

    <div class="comment-actions">
      <c:if test="${loginUser ne null and c.mno eq loginUser.mno}">
        <button type="button" onclick="showEdit(${c.bcno})">수정</button>
      </c:if>

      <c:if test="${loginUser ne null and (c.mno eq loginUser.mno or isAdmin)}">
        <form action="/board_comment/delete" method="post">
          <input type="hidden" name="bcno" value="${c.bcno}">
          <input type="hidden" name="bno" value="${board.bno}">
          <button type="submit"
                  onclick="return confirm('댓글을 삭제하시겠습니까?');">
            삭제
          </button>
        </form>
      </c:if>
    </div>
  </div>

  <div id="edit-${c.bcno}" style="display:none;">
    <form action="/board_comment/update" method="post">
      <input type="hidden" name="bcno" value="${c.bcno}">
      <input type="hidden" name="bno" value="${board.bno}">
      <textarea name="bccontent" rows="4" required>${c.bccontent}</textarea>
      <div class="comment-actions">
        <button type="submit">저장</button>
        <button type="button" onclick="hideEdit(${c.bcno})">취소</button>
      </div>
    </form>
  </div>

</c:forEach>
</div>

<c:if test="${loginUser ne null}">
  <form action="/board_comment/write" method="post">
    <input type="hidden" name="bno" value="${board.bno}">
    <textarea name="bccontent" required></textarea>
    <label>
      <input type="checkbox" name="bcsecret" value="Y"> 비밀댓글
    </label>
    <button type="submit">댓글 등록</button>
  </form>
</c:if>

<c:if test="${loginUser eq null}">
  <p align="center">댓글 작성은 로그인 후 가능합니다.</p>
</c:if>

<div class="board-footer">
  <div class="footer-center">
    <button type="button"
            class="btn btn-outline"
            onclick="location.href='/board/list'">
      목록
    </button>
  </div>

  <div class="footer-right">
    <c:if test="${loginUser ne null and (loginUser.mno eq board.mno or isAdmin)}">
      <button type="button"
              class="btn btn-primary"
              onclick="location.href='/board/update?bno=${board.bno}'">
        수정
      </button>

      <form action="/board/delete" method="post" style="display:inline;">
        <input type="hidden" name="bno" value="${board.bno}">
        <button type="submit"
                class="btn btn-outline"
                onclick="return confirm('게시글을 삭제하시겠습니까?');">
          삭제
        </button>
      </form>
    </c:if>
  </div>
</div>

<%@ include file="/WEB-INF/views/footer.jsp" %>
</body>
</html>
