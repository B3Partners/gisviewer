<%@include file="/WEB-INF/jsp/taglibs.jsp" %>

<c:set var="requestURI" value="${fn:split(pageContext.request.requestURI, '/')}" />
<c:set var="requestJSP" value="${fn:substring(requestURI[fn:length(requestURI) - 1], 0, fn:indexOf(requestURI[fn:length(requestURI) - 1], '.'))}" />

<c:set var="links" value='<a class="*" href="help.do"> &#155; Beschrijving</a>%<a class="*" href="etl.do">&#155; ETL Themabeheer</a>%<a class="*" href="viewer.do">&#155; Viewer</a>%<a class="*" href="index.do">&#155; Home</a>' />

<div class="topmenu">
    <c:set var="lnkArray" value="${fn:split(links, '%')}" />
    
    <c:if test="${requestJSP eq 'index'}">
        <c:set var="activelink" value="4" />
    </c:if>
    <c:if test="${requestJSP eq 'viewerBase'}">
        <c:set var="activelink" value="3" />
    </c:if>
    <c:if test="${requestJSP eq 'etlTransformBase'}">
        <c:set var="activelink" value="2" />
    </c:if>
    <c:if test="${requestJSP eq 'help'}">
        <c:set var="activelink" value="1" />
    </c:if>
    
    <c:forEach items="${lnkArray}" var="link" varStatus="counter">
        <c:choose>
            <c:when test="${counter.count == activelink}">
                <c:out value="${fn:replace(link, '*', 'activemenulink')}" escapeXml="false" />    
            </c:when>
            <c:otherwise>
                <c:out value="${fn:replace(link, '*', 'menulink')}" escapeXml="false" />
            </c:otherwise>
        </c:choose>
    </c:forEach>
</div>
<div class="menu_boven_logo"></div>