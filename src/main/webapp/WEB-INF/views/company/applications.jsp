<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<h2>📌 ${posting.jtitle} 지원자 목록</h2>

<c:forEach var="a" items="${apps}">
  <div style="border:1px solid #ddd; padding:14px; margin-bottom:10px;">
    <div><b>지원자:</b> ${a.mname}</div>
    <div><b>상태:</b> ${a.astatus}</div>

    <form method="post" action="/company/applications/status">
      <input type="hidden" name="ano" value="${a.ano}">
      <input type="hidden" name="jno" value="${posting.jno}">
      <select name="astatus">
        <option ${a.astatus=='지원완료'?'selected':''}>지원완료</option>
        <option ${a.astatus=='합격'?'selected':''}>합격</option>
        <option ${a.astatus=='불합격'?'selected':''}>불합격</option>
      </select>
      <button type="submit">변경</button>
    </form>
  </div>
</c:forEach>
