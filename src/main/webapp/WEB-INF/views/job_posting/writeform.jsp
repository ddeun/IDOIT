<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공고 등록</title>
<style>
  body{font-family:'Segoe UI','Apple SD Gothic Neo',sans-serif; max-width:900px; margin:30px auto; padding:0 20px;}
  h2{margin-bottom:18px;}
  .row{margin:14px 0;}
  label{display:block; font-weight:800; margin-bottom:6px;}
  input, textarea, select{
    width:100%; padding:10px; border:1px solid #ddd; border-radius:10px; box-sizing:border-box;
  }
  textarea{min-height:160px; resize:vertical;}
  .hint{font-size:12px; color:#666; margin-top:6px; line-height:1.4;}
  .grid2{display:grid; grid-template-columns:1fr 1fr; gap:12px;}
  .btns{display:flex; gap:10px; margin-top:18px; flex-wrap:wrap;}
  button{padding:10px 16px; border:0; border-radius:10px; font-weight:800; cursor:pointer;}
  .save{background:#111; color:#fff;}
  .back{background:#f3f4f6;}

  .chips{display:flex; flex-wrap:wrap; gap:8px; margin-top:6px;}
  .chip{border:1px solid #ddd; border-radius:999px; padding:6px 10px; font-size:13px; display:flex; gap:6px; align-items:center;}
  .chip input{width:auto; margin:0;}

  /* 기술스택 아이콘 선택 UI */
  .skillGrid{display:grid; grid-template-columns:repeat(6, 1fr); gap:10px; margin-top:8px;}
  .skillItem{
    border:1px solid #e5e7eb; border-radius:14px; background:#fff;
    height:72px; display:flex; align-items:center; justify-content:center;
    overflow:hidden; cursor:pointer;
  }
  .skillItem img{width:100%; height:100%; object-fit:contain; padding:10px; box-sizing:border-box;}
  .skillItem input{display:none;}
  .skillItem.on{outline:3px solid #111;}

  /* 섹션 타이틀 느낌 */
  .sectionTitle{margin-top:18px; font-size:15px; font-weight:900;}
</style>
</head>
<body>

<h2>채용공고 등록</h2>

<form action="/job_posting/write" method="post">

  <!-- ✅ 회사 선택: 한 계정에 여러 회사 대응 -->
  <div class="row">
    <label>회사 선택</label>
    <select name="cno" required>
      <option value="">회사 선택</option>
      <c:forEach var="c" items="${companies}">
        <option value="${c.cno}">${c.cname} (cno=${c.cno})</option>
      </c:forEach>
    </select>
    <div class="hint">공고를 등록할 회사를 선택하세요.</div>
  </div>

  <div class="row">
    <label>공고 제목</label>
    <input name="jtitle" required>
  </div>

  <div class="row">
    <label>포지션</label>
    <input name="jposition" required>
  </div>

  <div class="row grid2">
    <div>
      <label>경력</label>
      <input name="jcareer" required>
    </div>
    <div>
      <label>근무지역</label>
      <input name="jlocation" required>
    </div>
  </div>

  <div class="row grid2">
    <div>
      <label>고용형태</label>
      <select name="jemployment" required>
        <option value="">선택(없으면 비움)</option>
        <option value="정규직">정규직</option>
        <option value="계약직">계약직</option>
        <option value="인턴">인턴</option>
        <option value="프리랜서">프리랜서</option>
      </select>
    </div>
    <div>
      <label>마감일</label>
      <input type="date" name="jdeadline">
      <div class="hint">비우면 마감일 없음</div>
    </div>
  </div>

  <div class="row">
    <label>연봉(선택)</label>
    <input name="jsal" placeholder="예: 회사내규 / 4000~6000 / 면접 후 결정">
  </div>

  <div class="row">
    <label>원문 링크(선택)</label>
    <input name="jlink" placeholder="https://...">
  </div>

  <!-- ✅ 카테고리 -->
  <div class="row">
    <label>카테고리(복수 선택)</label>
    <div class="chips">
      <c:set var="catList" value="서버/백엔드 개발자,프론트엔드 개발자,웹 풀스택 개발자,안드로이드 개발자,iOS 개발자,크로스플랫폼 앱개발자,게임 클라이언트 개발자,게임 서버 개발자,DBA,빅데이터 엔지니어,인공지능/머신러닝,devops/시스템 엔지니어,정보보안 담당자,QA 엔지니어,개발 PM,HW/임베디드,SW/솔루션,웹퍼블리셔,VR/AR/3D,블록체인,기술지원"/>
      <c:forTokens var="cname" items="${catList}" delims=",">
        <label class="chip">
          <input type="checkbox" name="categories" value="${cname}">
          <span>${cname}</span>
        </label>
      </c:forTokens>
    </div>
    <div class="hint">선택한 값은 DB에 JSON 배열 문자열로 저장됩니다.</div>
  </div>

  <!-- ✅ 기술스택 -->
  <div class="row">
    <label>기술스택(복수 선택)</label>

    <c:set var="skillIcons"
      value="/images/skills/apachetomcat.png,
             /images/skills/aws.png,
             /images/skills/c++.png,
             /images/skills/css3.png,
             /images/skills/docker.png,
             /images/skills/elasticsearch.png,
             /images/skills/gcp.png,
             /images/skills/git.png,
             /images/skills/github.png,
             /images/skills/html5.png,
             /images/skills/java.png,
             /images/skills/javascript.png,
             /images/skills/json.png,
             /images/skills/linux.png,
             /images/skills/mssql.png,
             /images/skills/mysql.png,
             /images/skills/nginx.png,
             /images/skills/node.js.png,
             /images/skills/oracle.png,
             /images/skills/postgresql.png,
             /images/skills/python.png,
             /images/skills/react.png,
             /images/skills/spring.png,
             /images/skills/typescript.png,
             /images/skills/windows.png"/>

    <div class="skillGrid">
      <c:forTokens var="s" items="${skillIcons}" delims=",">
        <label class="skillItem">
          <input type="checkbox" name="skills" value="${s}">
          <img src="${s}" alt="skill">
        </label>
      </c:forTokens>
    </div>

    <div class="hint">
      체크한 기술스택은 DB에 <b>JSON 배열 문자열</b>로 저장됩니다.
    </div>
  </div>

  <!-- ✅ jcontent를 "두 칸"으로 분리: intro + content -->
  <div class="row">
    <div class="sectionTitle">기업/서비스 소개</div>
    <textarea name="introText" placeholder="회사/서비스 소개를 입력하세요."></textarea>
    <div class="hint">저장 시 jcontent에 <b>[기업/서비스 소개]</b> 섹션으로 합쳐 저장됩니다.</div>
  </div>

  <div class="row">
    <div class="sectionTitle">공고 내용</div>
    <textarea name="contentText" placeholder="공고 상세 내용을 입력하세요."></textarea>
    <div class="hint">저장 시 jcontent에 합쳐 저장됩니다.</div>
  </div>

  <div class="btns">
    <button type="submit" class="save">저장</button>
    <button type="button" class="back" onclick="location.href='/job_posting/list'">취소</button>
  </div>

</form>

<script>
  // 선택된 스킬 카드 강조
  document.querySelectorAll('.skillItem input[type="checkbox"]').forEach(cb => {
    const box = cb.closest('.skillItem');
    const sync = () => box.classList.toggle('on', cb.checked);
    cb.addEventListener('change', sync);
    sync();
  });
</script>

</body>
</html>
