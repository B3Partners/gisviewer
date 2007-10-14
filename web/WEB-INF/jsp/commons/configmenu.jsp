<%@include file="/WEB-INF/jsp/taglibs.jsp" %>

<c:set var="requestURI" value="${fn:split(requestScope['javax.servlet.forward.request_uri'], '/')}" />
<c:set var="requestJSP" value="${requestURI[fn:length(requestURI) - 1]}" />

<c:set var="links" value='<a class="*" href="configThemaData.do">&#155; Thema Data</a>%<a class="*" href="configCluster.do">&#155; Cluster</a>%<a class="*" href="configThema.do">&#155; Thema</a>%<a class="*" href="index.do">&#155; Home</a>' />

<div class="topmenu">
    <c:set var="lnkArray" value="${fn:split(links, '%')}" />
    
    <c:if test="${requestJSP eq 'index.do'}">
        <c:set var="activelink" value="4" />
    </c:if>
    <c:if test="${requestJSP eq 'configThema.do'}">
        <c:set var="activelink" value="3" />
    </c:if>
    <c:if test="${requestJSP eq 'configCluster.do'}">
        <c:set var="activelink" value="2" />
    </c:if>
    <c:if test="${requestJSP eq 'configThemaData.do'}">
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