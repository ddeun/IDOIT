<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>${item.jtitle}</title>

<style>
@charset "UTF-8";

:root{
  --base-color:#0F2E55;
  --base-soft:#163B6A;
  --bg-white:#FFFFFF;
  --bg-light:#F5F7FA;
  --text-main:#111827;
  --text-sub:#6B7280;
  --border-light:#E5E7EB;

  --accent-weak:#E6EEF8;
  --muted-bg:#F3F4F6;

  --danger:#B42318;
  --danger-weak:#FEE4E2;

  --green:#16a34a;
  --green-soft:#15803d;
}

*{ box-sizing:border-box; }

body{
  margin:0;
  font-family:'Segoe UI','Apple SD Gothic Neo',sans-serif;
  background:var(--bg-light);
  color:var(--text-main);
}

/* ✅ 전체 이미지 안전장치 (부모 넘치지 않게) */
img{
  max-width:100%;
  height:auto;
}

/* ===== 전체 래퍼 ===== */
.wrap{
  max-width:1180px;
  margin:26px auto;
  padding:0 18px 60px;
}

/* ✅ GRID 2컬럼 */
.layout{
  display:grid;
  grid-template-columns: 1fr 320px;
  gap:18px;
}

.mainCol{ min-width:0; }

/* 오른쪽 컬럼 */
.sideCol{
  padding-top:140px;
}

/* ===== 공통 카드 ===== */
.card{
  background:#fff;
  border:1px solid var(--border-light);
  border-radius:18px;
  box-shadow:0 10px 22px rgba(0,0,0,0.06);
  overflow:hidden;
}

.head{padding:18px 18px 12px;}

.title{
  margin:0;
  font-size:22px;
  font-weight:900;
  color:var(--base-color);
}

.sub{
  margin-top:8px;
  display:flex;
  flex-wrap:wrap;
  gap:8px;
  font-size:13px;
  color:var(--text-sub);
}

.company{
  margin-top:10px;
  font-weight:900;
  font-size:15px;
}

/* ✅ 상단 로고 영역 */
.topLogo{
  display:flex;
  gap:14px;
  align-items:center;
  margin-top:12px;
}
.logo{
  width:86px;
  height:86px;
  border-radius:18px;
  overflow:hidden;
  background:var(--muted-bg);
  display:flex;
  align-items:center;
  justify-content:center;
  border:1px solid rgba(229,231,235,.9);
}
.logo img{
  width:100%;
  height:100%;
  object-fit:contain;
}
.logo .noimg{
  font-weight:900;
  color:#9ca3af;
  font-size:12px;
}

/* ===== 칩 ===== */
.chips{margin-top:12px; display:flex; flex-wrap:wrap; gap:8px;}
.chip{
  border:1px solid var(--border-light);
  border-radius:999px;
  padding:6px 10px;
  font-size:12px;
  background:var(--bg-white);
  color:var(--base-color);
  font-weight:800;
}

/* ===== 섹션 ===== */
.section{
  padding:16px 18px;
  border-top:1px solid var(--border-light);
}
.section h3{
  margin:0 0 12px;
  font-size:15px;
  font-weight:900;
  color:var(--base-color);
}

/* ===== 회사 이미지 ===== */
.grid{
  display:grid;
  grid-template-columns:repeat(3,1fr);
  gap:12px;
}
.imgbox{
  height:140px;
  border-radius:14px;
  overflow:hidden;
  background:var(--muted-bg);
  border:1px solid #e5e7eb;
}
.imgbox img{
  width:100%;
  height:100%;
  object-fit:cover;
  display:block;
}

/* ===== 스킬 ===== */
.skillGrid{display:grid; grid-template-columns:repeat(6,1fr); gap:10px;}
.skillBox{
  height:72px;
  border:1px solid var(--border-light);
  border-radius:14px;
  display:flex;
  align-items:center;
  justify-content:center;
  background:#fff;
  overflow:hidden;
}
.skillBox img{
  width:100%;
  height:100%;
  object-fit:contain;
  padding:10px;
  display:block;
}

/* ===== 텍스트 ===== */
.txt{
  white-space:pre-wrap;
  line-height:1.85;
  font-size:14px;
  color:#111827;
}

/* ✅ 텍스트 덩어리 박스 처리 */
.section .txt{
  padding:14px 14px;
  background:#fafafa;
  border:1px solid #e5e7eb;
  border-radius:14px;
}

/* ✅ contentText 안에 이미지가 섞여 들어오는 경우 폭발 방지 */
.section .txt img{
  max-width:100%;
  max-height:360px;
  display:block;
  margin:10px auto;
  border-radius:12px;
}

.muted{color:var(--text-sub); font-size:13px;}

/* ===== backRow ===== */
.backRow{
  padding:14px 18px;
  border-top:1px solid var(--border-light);
  display:flex;
  gap:10px;
  flex-wrap:wrap;
  align-items:center;
}

/* ===== 버튼 ===== */
.btn{
  display:inline-flex;
  align-items:center;
  justify-content:center;
  padding:10px 14px;
  border-radius:10px;
  font-weight:900;
  text-decoration:none;
}

.btn.back{
  border:1px solid rgba(15,46,85,.25);
  color:var(--base-color);
  background:#fff;
}
.btn.back:hover{background:var(--accent-weak);}

.btn.link{
  background:var(--base-color);
  color:#fff;
  border:0;
}

.btn.edit{
  border:1px solid rgba(15,46,85,.45);
  color:var(--base-color);
  background:#fff;
}

.btn.danger{
  background:var(--danger);
  color:#fff;
  border:0;
}

/* ===== 오른쪽 sticky 카드 ===== */
.applyCard{
  position:sticky;
  top:90px;
  z-index:20;
  background:#fff;
  border:1px solid var(--border-light);
  border-radius:18px;
  box-shadow:0 10px 22px rgba(0,0,0,0.06);
  overflow:hidden;
}

.applyHead{
  padding:12px 14px;
  font-weight:900;
  font-size:13px;
  background:#EEF5FF;
  border-bottom:1px solid var(--border-light);
}

.applyBody{padding:14px;}

.applyCompany{
  font-weight:900;
  font-size:18px;
  margin-bottom:12px;
}

.applyInfo{
  display:grid;
  grid-template-columns:56px 1fr;
  gap:8px 10px;
  font-size:13px;
  margin-bottom:14px;
}
.applyInfo .k{color:var(--text-sub); font-weight:800;}
.applyInfo .v{font-weight:800;}

.applyLinks{display:flex; gap:10px; flex-wrap:wrap; margin-top:4px;}
.miniLink{
  font-size:13px;
  font-weight:900;
  color:#0F2E55;
  text-decoration:none;
}
.miniLink:hover{
  text-decoration:underline;
  filter:brightness(0.95);
}

.applyBtn{
  width:100%;
  height:54px;
  border-radius:14px;
  border:0;
  font-weight:900;
  display:flex;
  align-items:center;
  justify-content:center;
  text-decoration:none;
}

.applyBtn.primary{
  background: var(--base-color);
  color:#fff;
}
.applyBtn.primary:hover{
  background: var(--base-soft);
}

.applyBtn.disabled{
  background:#e5e7eb;
  color:#374151;
}

/* ✅ 공고 내용만 줄/문단 간격 확 띄우기 */
.txt.content{
  line-height: 2.0;
  padding: 18px 18px;   /* 박스 안 여백도 좀 더 */
}

/* ✅ 빈 줄(문단) 체감 만들기: 줄바꿈을 더 여유롭게 */
.txt.content{
  white-space: pre-wrap;
}

</style>
</head>

<body>
<%@ include file="/WEB-INF/views/header.jsp" %>

<div class="wrap">
  <div class="layout">

    <!-- ✅ 왼쪽: 공고 카드 -->
    <div class="mainCol">
      <div class="card">
        <div class="head">
          <h2 class="title">${item.jtitle}</h2>

          <div class="topLogo">
            <div class="logo">
              <c:choose>
                <c:when test="${not empty companyThumb}">
                  <img src="${companyThumb}" alt="logo">
                </c:when>
                <c:otherwise>
                  <div class="noimg">NO IMAGE</div>
                </c:otherwise>
              </c:choose>
            </div>

            <div style="flex:1;">
              <c:if test="${not empty item.cname}">
                <div class="company">${item.cname}</div>
              </c:if>

              <div class="sub">
                <c:if test="${not empty item.jposition}"><span>${item.jposition}</span></c:if>
                <c:if test="${not empty item.jcareer}"><span>· ${item.jcareer}</span></c:if>
                <c:if test="${not empty item.jlocation}"><span>· ${item.jlocation}</span></c:if>
                <c:if test="${not empty item.jemployment}"><span>· ${item.jemployment}</span></c:if>
                <c:if test="${not empty item.jdeadline}"><span>· 마감: ${item.jdeadline}</span></c:if>
                <c:if test="${not empty item.jsal}"><span>· 연봉: ${item.jsal}</span></c:if>
              </div>

              <c:if test="${not empty categories}">
                <div class="chips">
                  <c:forEach var="t" items="${categories}">
                    <span class="chip">${t}</span>
                  </c:forEach>
                </div>
              </c:if>
            </div>
          </div>
        </div>

        <c:if test="${not empty companyImages}">
          <div class="section">
            <h3>회사 이미지</h3>
            <div class="grid">
              <c:forEach var="img" items="${companyImages}">
                <div class="imgbox"><img src="${img}" alt="company"></div>
              </c:forEach>
            </div>
          </div>
        </c:if>

        <c:if test="${not empty skillImages}">
          <div class="section">
            <h3>기술스택</h3>
            <div class="skillGrid">
              <c:forEach var="img" items="${skillImages}">
                <div class="skillBox"><img src="${img}" alt="skill"></div>
              </c:forEach>
            </div>
          </div>
        </c:if>

        <c:if test="${not empty companyIntroText}">
          <div class="section">
            <h3>기업/서비스 소개</h3>
            <div class="txt">${companyIntroText}</div>
          </div>
        </c:if>

        <div class="section">
          <h3>공고 내용</h3>
          <c:choose>
            <c:when test="${not empty contentText}">
              <!-- ✅ JSP만 수정: 공고 내용에 content 클래스 추가 -->
              <div class="txt content">${contentText}</div>
            </c:when>
            <c:otherwise>
              <div class="muted">등록된 공고 내용이 없습니다.</div>
            </c:otherwise>
          </c:choose>
        </div>

        <div class="backRow">
          <a class="btn back" href="/job_posting/list">목록으로</a>

          <c:if test="${canEdit}">
            <a class="btn edit" href="/job_posting/updateform/${item.jno}">수정</a>
            <form action="/job_posting/delete/${item.jno}" method="post" style="margin:0;">
              <button type="submit" class="btn danger"
                      onclick="return confirm('정말 삭제할까요?');">
                삭제
              </button>
            </form>
          </c:if>

         
        </div>

      </div>
    </div>

    <!-- ✅ 오른쪽: 스크롤 따라오는 지원 카드 -->
    <div class="sideCol">
      <div class="applyCard">
        <div class="applyHead">📍 근무지역 확인하고 바로 지원</div>

        <div class="applyBody">
          <div class="applyCompany">
            <c:out value="${item.cname}"/>
          </div>

          <div class="applyInfo">
            <div class="k">위치</div>
            <div class="v">
              <c:out value="${item.jlocation}"/>

              <div class="applyLinks">
                <a class="miniLink" href="https://map.naver.com/p/search/${item.jlocation}" target="_blank">위치 보기</a>
                <a class="miniLink" href="#" onclick="copyAddr(); return false;">주소복사</a>
              </div>
            </div>
          </div>

          <c:if test="${canApply}">
            <c:choose>
              <c:when test="${alreadyApplied}">
                <div class="applyBtn disabled">이미 지원한 공고입니다</div>
              </c:when>
              <c:otherwise>
                <a class="applyBtn primary" href="/application/applyform?jno=${item.jno}">
                  지원하기
                </a>
              </c:otherwise>
            </c:choose>
          </c:if>

          <c:if test="${not canApply}">
            <div class="muted" style="margin-top:8px; font-weight:800;">
              개인회원 로그인 시 지원할 수 있습니다.
            </div>
          </c:if>

        </div>
      </div>
    </div>

  </div>
</div>

<script>
  function copyAddr(){
    const addr = "${item.jlocation}";
    if(!addr) return;
    if(navigator.clipboard && window.isSecureContext){
      navigator.clipboard.writeText(addr).then(() => alert("주소를 복사했어요!"));
    }else{
      const ta = document.createElement("textarea");
      ta.value = addr;
      document.body.appendChild(ta);
      ta.select();
      document.execCommand("copy");
      document.body.removeChild(ta);
      alert("주소를 복사했어요!");
    }
  }
</script>

<%@ include file="/WEB-INF/views/footer.jsp" %>
</body>
</html>