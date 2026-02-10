<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>이력서 상세</title>
<link rel="stylesheet" href="/css/resume_detail.css">
</head>
<body>
<%@ include file="/WEB-INF/views/header.jsp" %>

<div class="detail-wrap">
  <h1 class="page-title">이력서 상세</h1>

  <!-- 기본 인적사항 카드 -->
  <div class="card">
    <div class="card-head">기본 인적사항</div>
    <div class="card-body">
      <div class="profile-row">
        <div class="photo-preview">
          <c:choose>
            <c:when test="${not empty resume.rimage}">
              <img src="/upload/${resume.rimage}">
            </c:when>
            <c:otherwise>
              <span style="color:#9CA3AF; font-size:12px;">사진 없음</span>
            </c:otherwise>
          </c:choose>
        </div>

        <table class="info-table">
          <tr>
            <td width="90"><strong>이름</strong></td>
            <td width="220"><c:out value="${member.mname}"/></td>
            <td width="90"><strong>이메일</strong></td>
            <td><c:out value="${member.memail}"/></td>
          </tr>
          <tr>
            <td><strong>전화번호</strong></td>
            <td><c:out value="${member.mtel}"/></td>
            <td><strong>생년월일</strong></td>
            <td>
              <c:choose>
                <c:when test="${not empty member.mbirth}">
                  <fmt:parseDate value="${member.mbirth}" var="pBirth" pattern="yyyy-MM-dd" />
                  <fmt:formatDate value="${pBirth}" pattern="yyyy-MM-dd"/>
                </c:when>
                <c:otherwise>-</c:otherwise>
              </c:choose>
            </td>
          </tr>
        </table>
      </div>
    </div>
  </div>

  <!-- 상세 테이블 -->
  <div class="card">
    <div class="card-head">이력서 정보</div>
    <div class="card-body">

      <table class="detail-table">
        <tr>
          <th>번호</th>
          <td><c:out value="${resume.rno}"/></td>
        </tr>
        <tr>
          <th>제목</th>
          <td><c:out value="${resume.rtitle}"/></td>
        </tr>
        <tr>
          <th>희망 직무</th>
          <td><c:out value="${resume.rjobrole}"/></td>
        </tr>

        <tr>
          <th>기술 스택</th>
          <td>
            <c:choose>
              <c:when test="${not empty skills}">
                <c:forEach var="s" items="${skills}">
                  <span class="badge"><c:out value="${s}"/></span>
                </c:forEach>
              </c:when>
              <c:otherwise>
                <span style="color:#9CA3AF;">등록된 기술스택이 없습니다.</span>
              </c:otherwise>
            </c:choose>
          </td>
        </tr>

        <tr>
          <th>등록일</th>
          <td>
            <c:choose>
              <c:when test="${not empty resume.rcreate}">
                <fmt:parseDate value="${resume.rcreate}" var="parsedRcreate" pattern="yyyy-MM-dd" />
                <fmt:formatDate value="${parsedRcreate}" pattern="yyyy-MM-dd"/>
              </c:when>
              <c:otherwise>-</c:otherwise>
            </c:choose>
          </td>
        </tr>

        <tr>
          <th>수정일</th>
          <td>
            <c:choose>
              <c:when test="${not empty resume.rupdate}">
                <fmt:parseDate value="${resume.rupdate}" var="parsedRupdate" pattern="yyyy-MM-dd" />
                <fmt:formatDate value="${parsedRupdate}" pattern="yyyy-MM-dd"/>
              </c:when>
              <c:otherwise>-</c:otherwise>
            </c:choose>
          </td>
        </tr>

        <tr>
          <th>학력 사항</th>
          <td>
            <c:choose>
              <c:when test="${not empty educations}">
                <table class="sub-table">
                  <thead>
                    <tr>
                      <th>학교</th>
                      <th>전공</th>
                      <th>상태</th>
                      <th>기간</th>
                    </tr>
                  </thead>
                  <tbody>
                    <c:forEach var="edu" items="${educations}">
                      <tr>
                        <td><c:out value="${edu.reschoolname}"/></td>
                        <td><c:out value="${edu.remajor}"/></td>
                        <td><c:out value="${edu.redegree}"/></td>
                        <td>
                          <c:choose>
                            <c:when test="${not empty edu.restartdate}">
                              <fmt:parseDate value="${edu.restartdate}" var="pEduStart" pattern="yyyy-MM" />
                              <fmt:formatDate value="${pEduStart}" pattern="yyyy-MM"/>
                            </c:when>
                            <c:otherwise>-</c:otherwise>
                          </c:choose>
                          ~
                          <c:choose>
                            <c:when test="${not empty edu.reenddate}">
                              <fmt:parseDate value="${edu.reenddate}" var="pEduEnd" pattern="yyyy-MM" />
                              <fmt:formatDate value="${pEduEnd}" pattern="yyyy-MM"/>
                            </c:when>
                            <c:otherwise>-</c:otherwise>
                          </c:choose>
                        </td>
                      </tr>
                    </c:forEach>
                  </tbody>
                </table>
              </c:when>
              <c:otherwise>등록된 학력이 없습니다.</c:otherwise>
            </c:choose>
          </td>
        </tr>

        <tr>
          <th>경력 사항</th>
          <td>
            <c:choose>
              <c:when test="${not empty careers}">
                <table class="sub-table">
                  <thead>
                    <tr>
                      <th>회사</th>
                      <th>직위</th>
                      <th>기간</th>
                      <th>업무</th>
                    </tr>
                  </thead>
                  <tbody>
                    <c:forEach var="car" items="${careers}">
                      <tr>
                        <td><c:out value="${car.rccompany}"/></td>
                        <td><c:out value="${car.rcposition}"/></td>
                        <td>
                          <c:choose>
                            <c:when test="${not empty car.rcstartdate}">
                              <fmt:parseDate value="${car.rcstartdate}" var="pCarStart" pattern="yyyy-MM" />
                              <fmt:formatDate value="${pCarStart}" pattern="yyyy-MM"/>
                            </c:when>
                            <c:otherwise>-</c:otherwise>
                          </c:choose>
                          ~
                          <c:choose>
                            <c:when test="${car.rccurrent == 'Y'}">재직중</c:when>
                            <c:otherwise>
                              <c:choose>
                                <c:when test="${not empty car.rcenddate}">
                                  <fmt:parseDate value="${car.rcenddate}" var="pCarEnd" pattern="yyyy-MM" />
                                  <fmt:formatDate value="${pCarEnd}" pattern="yyyy-MM"/>
                                </c:when>
                                <c:otherwise>-</c:otherwise>
                              </c:choose>
                            </c:otherwise>
                          </c:choose>
                        </td>
                        <td><c:out value="${car.rcdescription}"/></td>
                      </tr>
                    </c:forEach>
                  </tbody>
                </table>
              </c:when>
              <c:otherwise>등록된 경력이 없습니다.</c:otherwise>
            </c:choose>
          </td>
        </tr>

        <tr>
          <th>프로젝트 경험</th>
          <td>
            <c:choose>
              <c:when test="${not empty projects}">
                <c:forEach var="proj" items="${projects}">
                  <div class="proj">
                    <div>
                      <span class="proj-title"><c:out value="${proj.rpname}"/></span>
                      <span class="proj-date">
                        (
                        <c:choose>
                          <c:when test="${not empty proj.rpstartdate}">
                            <fmt:parseDate value="${proj.rpstartdate}" var="pProjStart" pattern="yyyy-MM" />
                            <fmt:formatDate value="${pProjStart}" pattern="yyyy-MM"/>
                          </c:when>
                          <c:otherwise>-</c:otherwise>
                        </c:choose>
                        ~
                        <c:choose>
                          <c:when test="${not empty proj.rpenddate}">
                            <fmt:parseDate value="${proj.rpenddate}" var="pProjEnd" pattern="yyyy-MM" />
                            <fmt:formatDate value="${pProjEnd}" pattern="yyyy-MM"/>
                          </c:when>
                          <c:otherwise>-</c:otherwise>
                        </c:choose>
                        )
                      </span>
                    </div>

                    <div class="proj-summary"><c:out value="${proj.rpsummary}"/></div>
                    <div class="proj-content"><c:out value="${proj.rpcontent}"/></div>

                    <c:if test="${not empty proj.rplink}">
                      <div class="proj-link" style="margin-top:8px;">
                        <a href="${proj.rplink}" target="_blank">프로젝트 링크 바로가기</a>
                      </div>
                    </c:if>
                  </div>
                </c:forEach>
              </c:when>
              <c:otherwise>등록된 프로젝트가 없습니다.</c:otherwise>
            </c:choose>
          </td>
        </tr>

        <tr>
          <th>기타 사항</th>
          <td>
            <c:choose>
              <c:when test="${not empty others}">
                <table class="sub-table">
                  <thead>
                    <tr>
                      <th>구분</th>
                      <th>명칭</th>
                      <th>발행기관</th>
                      <th>날짜</th>
                    </tr>
                  </thead>
                  <tbody>
                    <c:forEach var="oth" items="${others}">
                      <tr>
                        <td><c:out value="${oth.rotype}"/></td>
                        <td><c:out value="${oth.rotitle}"/></td>
                        <td><c:out value="${oth.roorg}"/></td>
                        <td>
                          <c:choose>
                            <c:when test="${not empty oth.rodate}">
                              <fmt:parseDate value="${oth.rodate}" var="pOthDate" pattern="yyyy-MM-dd" />
                              <fmt:formatDate value="${pOthDate}" pattern="yyyy-MM-dd"/>
                            </c:when>
                            <c:otherwise>-</c:otherwise>
                          </c:choose>
                        </td>
                      </tr>
                    </c:forEach>
                  </tbody>
                </table>
              </c:when>
              <c:otherwise>등록된 기타 사항이 없습니다.</c:otherwise>
            </c:choose>
          </td>
        </tr>

        <tr>
          <th>교육 및 연수</th>
          <td>
            <c:choose>
              <c:when test="${not empty trainings}">
                <c:forEach var="tr" items="${trainings}">
                  <div class="proj">
                    <div>
                      <span class="proj-title"><c:out value="${tr.rtorg}"/></span>
                      <span class="proj-date">
                        (
                        <c:choose>
                          <c:when test="${not empty tr.rtstartdate}">
                            <fmt:parseDate value="${tr.rtstartdate}" var="pTrStart" pattern="yyyy-MM" />
                            <fmt:formatDate value="${pTrStart}" pattern="yyyy-MM"/>
                          </c:when>
                          <c:otherwise>-</c:otherwise>
                        </c:choose>
                        ~
                        <c:choose>
                          <c:when test="${not empty tr.rtenddate}">
                            <fmt:parseDate value="${tr.rtenddate}" var="pTrEnd" pattern="yyyy-MM" />
                            <fmt:formatDate value="${pTrEnd}" pattern="yyyy-MM"/>
                          </c:when>
                          <c:otherwise>-</c:otherwise>
                        </c:choose>
                        )
                      </span>
                    </div>
                    <div class="proj-content" style="margin-top:8px;"><c:out value="${tr.rtcontent}"/></div>
                  </div>
                </c:forEach>
              </c:when>
              <c:otherwise>등록된 교육/연수가 없습니다.</c:otherwise>
            </c:choose>
          </td>
        </tr>

        <tr>
          <th>요약(자기소개)</th>
          <td>
            <div class="proj-content"><c:out value="${resume.rsummary}"/></div>
          </td>
        </tr>
      </table>

      <div class="actions">
        <a class="btn-outline" href="/resume/form/${resume.rno}">수정</a>

        <form action="/resume/delete" method="post" style="display:inline;">
          <input type="hidden" name="rno" value="${resume.rno}">
          <button class="btn-danger" type="submit" onclick="return confirm('정말 삭제할까요?')">삭제</button>
        </form>

        <a class="btn-primary" href="/resume/list">목록</a>
      </div>

    </div>
  </div>
</div>

<%@ include file="/WEB-INF/views/footer.jsp" %>
</body>
</html>

