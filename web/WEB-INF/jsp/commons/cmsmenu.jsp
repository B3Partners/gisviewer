<%@include file="/WEB-INF/jsp/taglibs.jsp" %>
<%@ page isELIgnored="false"%>

<div id="topmenu">
    <%-- Set requestURI --%>
    <c:set var="requestURI" value="${requestScope['javax.servlet.forward.request_uri']}" />
    <%-- Split requestURI on / to create String[] with request parts (to strip of first part '/gisviewer') --%>
    <c:set var="requestArr" value="${fn:split(requestURI, '/')}" />
    <%-- Set requestURL to the substring of the requestURI from the first part to the end (now we have stripped of '/gisviewer') --%>
    <c:set var="requestURL" value="${fn:substring(requestURI, fn:indexOf(requestURI, requestArr[0]) + fn:length(requestArr[0]), fn:length(requestURI))}" />
    
    <c:forEach var="menuItem" varStatus="status" items="${cmsMenuItems}">
        <c:set var="stijlklasse" value="menulink" />
        <c:if test="${requestURL eq menuItem.url}">
            <c:set var="stijlklasse" value="activemenulink" />
        </c:if>

        <a href="<c:url value="${menuItem.url}"/>" class="${stijlklasse}">
            <c:if test="${empty menuItem.icon}">
                ${menuItem.titel}
            </c:if>
            <c:if test="${!empty menuItem.icon}">
                <img src="<c:url value='${menuItem.icon}' />" border="0" />
            </c:if>
        </a>
    </c:forEach>
</div>
