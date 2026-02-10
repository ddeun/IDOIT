<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시글 작성</title>

<!-- jQuery & Summernote -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<link href="https://cdn.jsdelivr.net/npm/summernote@0.8.20/dist/summernote-lite.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/summernote@0.8.20/dist/summernote-lite.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/summernote@0.8.20/lang/summernote-ko-KR.min.js"></script>

<script src="/js/board_common.js"></script>
<script src="/js/board_editor.js"></script>

<link rel="stylesheet" href="/css/board_write.css">
</head>

<body>
<%@ include file="/WEB-INF/views/header.jsp" %>
<div class="board-box">
  <div class="board-header">게시글 작성</div>

  <form action="/board/write" method="post" class="board-form">
    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}">

    <table>
      <tr>
        <th>카테고리</th>
        <td>
          <select name="btype" required onchange="handleBoardType()">
            <option value="FREE">자유게시판</option>
            <option value="STUDY">스터디 / 팀원 모집</option>
            <option value="REVIEW">취업 후기</option>
          </select>
        </td>
      </tr>

      <tr>
        <th>작성 방식</th>
        <td>
          <label><input type="checkbox" name="anonymous" value="Y"> 익명</label>
        </td>
      </tr>

      <tr>
        <th>제목</th>
        <td><input type="text" name="btitle" required></td>
      </tr>

      <tr>
        <th>내용</th>
        <td><textarea id="bcontent" name="bcontent" data-upload-type="board"></textarea></td>
      </tr>
    </table>

    <div class="form-footer">
      <button type="submit" class="btn-primary">등록</button>
      <button type="button" class="btn btn-outline" onclick="location.href='/board/list'">취소</button>
    </div>
  </form>
</div>
<%@ include file="/WEB-INF/views/footer.jsp" %>
</body>
</html>
