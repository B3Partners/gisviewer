<%@include file="/WEB-INF/jsp/taglibs.jsp" %>

<c:set var="requestURI" value="${fn:split(pageContext.request.requestURI, '/')}" />
<c:set var="requestJSP" value="${fn:substring(requestURI[fn:length(requestURI) - 1], 0, fn:indexOf(requestURI[fn:length(requestURI) - 1], '.'))}" />

<c:set var="links" value='<a class="*" href="etlthemalijst.do">&#155; ETL Afwijkingen</a>%<!--a class="*" href="etlscheduler.do">&#155; ETL Scheduler</a-->%<a class="*" href="index.do">&#155; Home</a>' />

<div class="topmenu">
    <c:set var="lnkArray" value="${fn:split(links, '%')}" />
    
    <c:set var="activelink" value="500" />
    
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