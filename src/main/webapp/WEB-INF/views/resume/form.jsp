<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>
  <c:choose>
    <c:when test="${empty resume.rno}">이력서 작성</c:when>
    <c:otherwise>이력서 수정</c:otherwise>
  </c:choose>
</title>
<link rel="stylesheet" href="/css/resume_form.css">
</head>

<body>
<%@ include file="/WEB-INF/views/header.jsp" %>

<div class="form-wrap">
  <h1 class="page-title">
    <c:choose>
      <c:when test="${empty resume.rno}">이력서 작성</c:when>
      <c:otherwise>이력서 수정</c:otherwise>
    </c:choose>
  </h1>

  <form action="${resume.rno == 0 ? '/resume/form' : '/resume/update'}" method="post" enctype="multipart/form-data">
    <c:if test="${resume.rno > 0}">
      <input type="hidden" name="rno" value="${resume.rno}">
    </c:if>

    <!-- 기본 인적사항 -->
    <div class="card">
      <div class="card-head">기본 인적사항</div>
      <div class="card-body">
        <div class="profile-row">
          <div class="photo-box">
            <div id="imagePreview" class="photo-preview">
              <c:choose>
                <c:when test="${not empty resume.rimage}">
                  <img src="/upload/${resume.rimage}">
                </c:when>
                <c:otherwise>
                  <span style="color:#9CA3AF; font-size:12px;">사진 없음</span>
                </c:otherwise>
              </c:choose>
            </div>
            <input type="file" name="imageFile" id="imageInput" accept="image/*" class="file-input">
          </div>

          <table class="info-table">
            <tr>
              <td><strong>이름</strong></td>
              <td><c:out value="${member.mname}"/></td>
              <td><strong>이메일</strong></td>
              <td><c:out value="${member.memail}"/></td>
            </tr>
            <tr>
              <td><strong>전화번호</strong></td>
              <td><c:out value="${member.mtel}"/></td>
              <td><strong>생년월일</strong></td>
              <td>
                <fmt:parseDate value="${member.mbirth}" var="pBirth" pattern="yyyy-MM-dd" />
                <fmt:formatDate value="${pBirth}" pattern="yyyy-MM-dd"/>
              </td>
            </tr>
          </table>
        </div>
        <div class="hint">* 위 정보는 마이페이지에 등록된 정보입니다.</div>
      </div>
    </div>

    <!-- 기본 입력 -->
    <div class="card">
      <div class="card-head">기본 정보</div>
      <div class="card-body">
        <div class="field-grid">
          <div class="field">
            <div class="label">이력서 제목(필수)</div>
            <input class="input" type="text" name="rtitle" required value="<c:out value='${resume.rtitle}'/>">
          </div>
          <div class="field">
            <div class="label">희망 직무</div>
            <input class="input" type="text" name="rjobrole" value="<c:out value='${resume.rjobrole}'/>">
          </div>
        </div>
      </div>
    </div>

    <!-- 기술스택 -->
    <div class="card">
      <div class="card-head">기술스택(업무 툴/스킬)</div>
      <div class="card-body">
        <div class="skill-row">
          <div class="skill-search">
            <input class="input" type="text" id="skillSearch" placeholder="예) java, spring, oracle">
            <div id="skillList" class="skill-list"></div>
          </div>

          <div class="label">선택된 기술</div>
          <div id="selectedSkills" class="selected-box"></div>
        </div>
      </div>
    </div>

    <!-- 학력 -->
    <div class="card">
      <div class="card-head">학력 사항</div>
      <div class="card-body">
        <div id="educationList">
          <c:forEach var="e" items="${resume.eduList}" varStatus="status">
            <div class="item edu-item">
              <div class="item-top">
                <div class="item-title">학력 #${status.index + 1}</div>
                <button class="btn-danger" type="button" onclick="this.closest('.item').remove()">제거</button>
              </div>

              <div class="row-4">
                <input class="input" type="text" name="eduList[${status.index}].reschoolname" value="${e.reschoolname}" placeholder="학교명" required>
                <input class="input" type="text" name="eduList[${status.index}].remajor" value="${e.remajor}" placeholder="전공">
                <select class="input" name="eduList[${status.index}].redegree">
                  <option value="졸업" ${e.redegree == '졸업' ? 'selected' : ''}>졸업</option>
                  <option value="재학" ${e.redegree == '재학' ? 'selected' : ''}>재학</option>
                  <option value="휴학" ${e.redegree == '휴학' ? 'selected' : ''}>휴학</option>
                  <option value="졸업예정" ${e.redegree == '졸업예정' ? 'selected' : ''}>졸업예정</option>
                </select>
                <div></div>
              </div>

              <div class="row">
                <div class="field">
                  <div class="label">입학일</div>
                  <input class="input" type="month" name="eduList[${status.index}].restartdate" value="${e.restartdate}">
                </div>
                <div class="field">
                  <div class="label">졸업일</div>
                  <input class="input" type="month" name="eduList[${status.index}].reenddate" value="${e.reenddate}">
                </div>
              </div>
            </div>
          </c:forEach>
        </div>
        <button class="btn-ghost" type="button" onclick="addEducation()">+ 학력 추가</button>
      </div>
    </div>

    <!-- 경력 -->
    <div class="card">
      <div class="card-head">경력 사항</div>
      <div class="card-body">
        <div id="careerList">
          <c:forEach var="c" items="${resume.careerList}" varStatus="status">
            <div class="item career-item">
              <div class="item-top">
                <div class="item-title">경력 #${status.index + 1}</div>
                <button class="btn-danger" type="button" onclick="this.closest('.item').remove()">삭제</button>
              </div>

              <div class="row">
                <div class="field">
                  <div class="label">회사명</div>
                  <input class="input" type="text" name="careerList[${status.index}].rccompany" value="${c.rccompany}" required>
                </div>
                <div class="field">
                  <div class="label">직위</div>
                  <input class="input" type="text" name="careerList[${status.index}].rcposition" value="${c.rcposition}">
                </div>
              </div>

              <div class="row-3">
                <div class="field">
                  <div class="label">재직여부</div>
                  <select class="input" name="careerList[${status.index}].rccurrent">
                    <option value="N" ${c.rccurrent == 'N' ? 'selected' : ''}>퇴사</option>
                    <option value="Y" ${c.rccurrent == 'Y' ? 'selected' : ''}>재직중</option>
                  </select>
                </div>
                <div class="field">
                  <div class="label">입사일</div>
                  <input class="input" type="month" name="careerList[${status.index}].rcstartdate" value="${c.rcstartdate}">
                </div>
                <div class="field">
                  <div class="label">퇴사일</div>
                  <input class="input" type="month" name="careerList[${status.index}].rcenddate" value="${c.rcenddate}">
                </div>
              </div>

              <div class="field">
                <div class="label">담당업무</div>
                <textarea class="textarea" name="careerList[${status.index}].rcdescription" rows="3">${c.rcdescription}</textarea>
              </div>
            </div>
          </c:forEach>
        </div>
        <button class="btn-ghost" type="button" onclick="addCareer()">+ 경력 추가</button>
      </div>
    </div>

    <!-- 프로젝트 -->
    <div class="card">
      <div class="card-head">프로젝트 경험</div>
      <div class="card-body">
        <div id="projectList">
          <c:forEach var="p" items="${resume.projectList}" varStatus="status">
            <div class="item project-item">
              <div class="item-top">
                <div class="item-title">프로젝트 #${status.index + 1}</div>
                <button class="btn-danger" type="button" onclick="this.closest('.item').remove()">삭제</button>
              </div>

              <div class="row">
                <div class="field full">
                  <div class="label">프로젝트명</div>
                  <input class="input" type="text" name="projectList[${status.index}].rpname" value="${p.rpname}" required>
                </div>
              </div>

              <div class="row">
                <div class="field">
                  <div class="label">시작일</div>
                  <input class="input" type="month" name="projectList[${status.index}].rpstartdate" value="${p.rpstartdate}">
                </div>
                <div class="field">
                  <div class="label">종료일</div>
                  <input class="input" type="month" name="projectList[${status.index}].rpenddate" value="${p.rpenddate}">
                </div>
              </div>

              <div class="field">
                <div class="label">한줄 요약</div>
                <input class="input" type="text" name="projectList[${status.index}].rpsummary" value="${p.rpsummary}">
              </div>

              <div class="field">
                <div class="label">상세 내용</div>
                <textarea class="textarea" name="projectList[${status.index}].rpcontent" rows="4">${p.rpcontent}</textarea>
              </div>

              <div class="field">
                <div class="label">관련 링크</div>
                <input class="input" type="text" name="projectList[${status.index}].rplink" value="${p.rplink}">
              </div>
            </div>
          </c:forEach>
        </div>
        <button class="btn-ghost" type="button" onclick="addProject()">+ 프로젝트 추가</button>
      </div>
    </div>

    <!-- 기타 -->
    <div class="card">
      <div class="card-head">기타 사항 (자격증/수상/어학)</div>
      <div class="card-body">
        <div id="otherList">
          <c:forEach var="o" items="${resume.otherList}" varStatus="status">
            <div class="item other-item">
              <div class="item-top">
                <div class="item-title">기타 #${status.index + 1}</div>
                <button class="btn-danger" type="button" onclick="this.closest('.item').remove()">삭제</button>
              </div>

              <div class="row-4">
                <div class="field">
                  <div class="label">구분</div>
                  <select class="input" name="otherList[${status.index}].rotype">
                    <option value="자격증" ${o.rotype == '자격증' ? 'selected' : ''}>자격증</option>
                    <option value="어학" ${o.rotype == '어학' ? 'selected' : ''}>어학</option>
                    <option value="수상" ${o.rotype == '수상' ? 'selected' : ''}>수상</option>
                    <option value="기타" ${o.rotype == '기타' ? 'selected' : ''}>기타</option>
                  </select>
                </div>

                <div class="field">
                  <div class="label">명칭</div>
                  <input class="input" type="text" name="otherList[${status.index}].rotitle" value="${o.rotitle}" required>
                </div>

                <div class="field">
                  <div class="label">발행기관</div>
                  <input class="input" type="text" name="otherList[${status.index}].roorg" value="${o.roorg}">
                </div>

                <div class="field">
                  <div class="label">취득일</div>
                  <input class="input" type="date" name="otherList[${status.index}].rodate" value="${o.rodate}">
                </div>
              </div>
            </div>
          </c:forEach>
        </div>
        <button class="btn-ghost" type="button" onclick="addOther()">+ 기타 사항 추가</button>
      </div>
    </div>

    <!-- 교육/연수 -->
    <div class="card">
      <div class="card-head">교육 및 연수</div>
      <div class="card-body">
        <div id="trainingList">
          <c:forEach var="t" items="${resume.trainingList}" varStatus="status">
            <div class="item training-item">
              <div class="item-top">
                <div class="item-title">교육 #${status.index + 1}</div>
                <button class="btn-danger" type="button" onclick="this.closest('.item').remove()">삭제</button>
              </div>

              <div class="row">
                <div class="field full">
                  <div class="label">교육기관</div>
                  <input class="input" type="text" name="trainingList[${status.index}].rtorg" value="${t.rtorg}" required>
                </div>
              </div>

              <div class="row">
                <div class="field">
                  <div class="label">시작</div>
                  <input class="input" type="month" name="trainingList[${status.index}].rtstartdate" value="${t.rtstartdate}">
                </div>
                <div class="field">
                  <div class="label">종료</div>
                  <input class="input" type="month" name="trainingList[${status.index}].rtenddate" value="${t.rtenddate}">
                </div>
              </div>

              <div class="field">
                <div class="label">교육내용</div>
                <textarea class="textarea" name="trainingList[${status.index}].rtcontent" rows="3">${t.rtcontent}</textarea>
              </div>
            </div>
          </c:forEach>
        </div>
        <button class="btn-ghost" type="button" onclick="addTraining()">+ 교육 추가</button>
      </div>
    </div>

    <!-- 요약 -->
    <div class="card">
      <div class="card-head">요약(자기소개)</div>
      <div class="card-body">
        <textarea name="rsummary" class="resume-textarea"><c:out value="${resume.rsummary}"/></textarea>

        <div class="btn-row">
          <button class="btn-primary" type="submit">${empty resume.rno ? "저장" : "수정 저장"}</button>
          <a class="btn-outline" href="${empty resume.rno ? '/resume/list' : '/resume/detail?rno='.concat(resume.rno)}">취소</a>
        </div>
      </div>
    </div>

  </form>
</div>

<script>
  // ===== 기술스택 (원본 로직 유지) =====
  const EXISTING_SKILLS = [
    <c:forEach var="s" items="${skillNames}" varStatus="st">
      "<c:out value='${s}'/>"<c:if test="${!st.last}">,</c:if>
    </c:forEach>
  ];

  window.addEventListener("DOMContentLoaded", () => {
    if (EXISTING_SKILLS.length > 0) EXISTING_SKILLS.forEach(s => selectSkill(s));
  });

  const ALL_SKILLS = ["Java", "JavaScript", "TypeScript", "Python", "Spring", "Spring Boot", "Oracle", "MySQL", "React", "Vue.js", "Git", "Docker"];
  const skillListEl = document.getElementById("skillList");
  const selectedEl = document.getElementById("selectedSkills");
  const searchEl = document.getElementById("skillSearch");

  function renderAllSkills() {
    ALL_SKILLS.forEach(skill => {
      const div = document.createElement("div");
      div.className = "skill-item";
      div.textContent = skill;
      div.onclick = () => selectSkill(skill);
      skillListEl.appendChild(div);
    });
  }
  renderAllSkills();

  searchEl.addEventListener("input", function() {
    const keyword = this.value.toLowerCase().trim();
    skillListEl.style.display = keyword === "" ? "none" : "block";
    document.querySelectorAll(".skill-item").forEach(item => {
      item.style.display = item.textContent.toLowerCase().includes(keyword) ? "block" : "none";
    });
  });

  function selectSkill(skill) {
    if ([...selectedEl.querySelectorAll(".selected-skill")].some(x => x.dataset.skill === skill)) return;
    const tag = document.createElement("span");
    tag.className = "selected-skill";
    tag.dataset.skill = skill;
    tag.innerHTML = `<span>\${skill}</span><input type="hidden" name="rsname" value="\${skill}"><button type="button" onclick="this.parentElement.remove()">x</button>`;
    selectedEl.appendChild(tag);
    searchEl.value = "";
    skillListEl.style.display = "none";
  }

  // ===== 인덱스 카운트 (원본 유지) =====
  let eduCount = ${empty resume.eduList ? 0 : resume.eduList.size()};
  let careerCount = ${empty resume.careerList ? 0 : resume.careerList.size()};
  let projectCount = ${empty resume.projectList ? 0 : resume.projectList.size()};
  let otherCount = ${empty resume.otherList ? 0 : resume.otherList.size()};
  let trainingCount = ${empty resume.trainingList ? 0 : resume.trainingList.size()};

  function addEducation() {
    const container = document.getElementById('educationList');
    const div = document.createElement('div');
    div.className = "item edu-item";
    div.innerHTML = `
      <div class="item-top">
        <div class="item-title">학력 추가</div>
        <button class="btn-danger" type="button" onclick="this.closest('.item').remove()">제거</button>
      </div>
      <div class="row-4">
        <input class="input" type="text" name="eduList[\${eduCount}].reschoolname" placeholder="학교명" required>
        <input class="input" type="text" name="eduList[\${eduCount}].remajor" placeholder="전공">
        <select class="input" name="eduList[\${eduCount}].redegree">
          <option value="재학">재학</option>
          <option value="휴학">휴학</option>
          <option value="졸업예정">졸업예정</option>
          <option value="졸업">졸업</option>
        </select>
        <div></div>
      </div>
      <div class="row">
        <div class="field">
          <div class="label">입학일</div>
          <input class="input" type="month" name="eduList[\${eduCount}].restartdate">
        </div>
        <div class="field">
          <div class="label">졸업일</div>
          <input class="input" type="month" name="eduList[\${eduCount}].reenddate">
        </div>
      </div>`;
    container.appendChild(div);
    eduCount++;
  }

  function addCareer() {
    const container = document.getElementById('careerList');
    const div = document.createElement('div');
    div.className = "item career-item";
    div.innerHTML = `
      <div class="item-top">
        <div class="item-title">경력 추가</div>
        <button class="btn-danger" type="button" onclick="this.closest('.item').remove()">삭제</button>
      </div>

      <div class="row">
        <div class="field">
          <div class="label">회사명</div>
          <input class="input" type="text" name="careerList[\${careerCount}].rccompany" required>
        </div>
        <div class="field">
          <div class="label">직위</div>
          <input class="input" type="text" name="careerList[\${careerCount}].rcposition">
        </div>
      </div>

      <div class="row-3">
        <div class="field">
          <div class="label">재직여부</div>
          <select class="input" name="careerList[\${careerCount}].rccurrent">
            <option value="N">퇴사</option>
            <option value="Y">재직중</option>
          </select>
        </div>
        <div class="field">
          <div class="label">입사일</div>
          <input class="input" type="month" name="careerList[\${careerCount}].rcstartdate">
        </div>
        <div class="field">
          <div class="label">퇴사일</div>
          <input class="input" type="month" name="careerList[\${careerCount}].rcenddate">
        </div>
      </div>

      <div class="field">
        <div class="label">담당업무</div>
        <textarea class="textarea" name="careerList[\${careerCount}].rcdescription" rows="3"></textarea>
      </div>`;
    container.appendChild(div);
    careerCount++;
  }

  function addProject() {
    const container = document.getElementById('projectList');
    const div = document.createElement('div');
    div.className = "item project-item";
    div.innerHTML = `
      <div class="item-top">
        <div class="item-title">프로젝트 추가</div>
        <button class="btn-danger" type="button" onclick="this.closest('.item').remove()">삭제</button>
      </div>

      <div class="field">
        <div class="label">프로젝트명</div>
        <input class="input" type="text" name="projectList[\${projectCount}].rpname" required>
      </div>

      <div class="row">
        <div class="field">
          <div class="label">시작일</div>
          <input class="input" type="month" name="projectList[\${projectCount}].rpstartdate">
        </div>
        <div class="field">
          <div class="label">종료일</div>
          <input class="input" type="month" name="projectList[\${projectCount}].rpenddate">
        </div>
      </div>

      <div class="field">
        <div class="label">한줄 요약</div>
        <input class="input" type="text" name="projectList[\${projectCount}].rpsummary">
      </div>

      <div class="field">
        <div class="label">상세 내용</div>
        <textarea class="textarea" name="projectList[\${projectCount}].rpcontent" rows="4"></textarea>
      </div>

      <div class="field">
        <div class="label">관련 링크</div>
        <input class="input" type="text" name="projectList[\${projectCount}].rplink">
      </div>`;
    container.appendChild(div);
    projectCount++;
  }

  function addOther() {
    const container = document.getElementById('otherList');
    const div = document.createElement('div');
    div.className = "item other-item";
    div.innerHTML = `
      <div class="item-top">
        <div class="item-title">기타 추가</div>
        <button class="btn-danger" type="button" onclick="this.closest('.item').remove()">삭제</button>
      </div>

      <div class="row-4">
        <div class="field">
          <div class="label">구분</div>
          <select class="input" name="otherList[\${otherCount}].rotype">
            <option value="자격증">자격증</option>
            <option value="어학">어학</option>
            <option value="수상">수상</option>
            <option value="기타">기타</option>
          </select>
        </div>

        <div class="field">
          <div class="label">명칭</div>
          <input class="input" type="text" name="otherList[\${otherCount}].rotitle" required>
        </div>

        <div class="field">
          <div class="label">발행기관</div>
          <input class="input" type="text" name="otherList[\${otherCount}].roorg">
        </div>

        <div class="field">
          <div class="label">취득일</div>
          <input class="input" type="date" name="otherList[\${otherCount}].rodate">
        </div>
      </div>`;
    container.appendChild(div);
    otherCount++;
  }

  function addTraining() {
    const container = document.getElementById('trainingList');
    const div = document.createElement('div');
    div.className = "item training-item";
    div.innerHTML = `
      <div class="item-top">
        <div class="item-title">교육 추가</div>
        <button class="btn-danger" type="button" onclick="this.closest('.item').remove()">삭제</button>
      </div>

      <div class="field">
        <div class="label">교육기관</div>
        <input class="input" type="text" name="trainingList[\${trainingCount}].rtorg" required>
      </div>

      <div class="row">
        <div class="field">
          <div class="label">시작</div>
          <input class="input" type="month" name="trainingList[\${trainingCount}].rtstartdate">
        </div>
        <div class="field">
          <div class="label">종료</div>
          <input class="input" type="month" name="trainingList[\${trainingCount}].rtenddate">
        </div>
      </div>

      <div class="field">
        <div class="label">교육내용</div>
        <textarea class="textarea" name="trainingList[\${trainingCount}].rtcontent" rows="3"></textarea>
      </div>`;
    container.appendChild(div);
    trainingCount++;
  }

  // ===== 이미지 미리보기 (원본 유지) =====
  document.getElementById('imageInput').addEventListener('change', function(e) {
    const file = e.target.files[0];
    const preview = document.getElementById('imagePreview');

    if (file) {
      const reader = new FileReader();
      reader.onload = function(e) {
        preview.innerHTML = `<img src="${e.target.result}" style="width:100%; height:100%; object-fit:cover;">`;
      }
      reader.readAsDataURL(file);
    }
  });
</script>

<%@ include file="/WEB-INF/views/footer.jsp" %>
</body>
</html>


