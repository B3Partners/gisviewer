<%@include file="/WEB-INF/jsp/taglibs.jsp" %>

<c:set var="requestURI" value="${fn:split(requestScope['javax.servlet.forward.request_uri'], '/')}" />
<c:set var="requestJSP" value="${requestURI[fn:length(requestURI) - 1]}" />

<c:set var="links" value='<a class="*" href="configThema.do">&#155; Configuratie</a>%<a class="*" href="etl.do">&#155; ETL Themabeheer</a>%<a class="*" href="viewer.do">&#155; Viewer</a>%<a class="*" href="index.do">&#155; Home</a>' />

<div class="topmenu topmenu_basis">
    <c:set var="lnkArray" value="${fn:split(links, '%')}" />
    
    <c:if test="${requestJSP eq 'index.do'}">
        <c:set var="activelink" value="4" />
    </c:if>
    <c:if test="${requestJSP eq 'viewer.do'}">
        <c:set var="activelink" value="3" />
    </c:if>
    <c:if test="${requestJSP eq 'etl.do'}">
        <c:set var="activelink" value="2" />
    </c:if>
    <c:if test="${requestJSP eq 'configThema.do'}">
        <c:set var="activelink" value="1" />
    </c:if>
    
    <c:forEach items="${lnkArray}" var="link" varStatus="counter">
        <c:choose>
            <c:when test="${counter.count == activelink}">
                <c:set var="link" value="${fn:replace(link, '*', 'activemenulink')}" />    
            </c:when>
            <c:otherwise>
                <c:set var="link" value="${fn:replace(link, '*', 'menulink')}" />
            </c:otherwise>
        </c:choose>
        <c:choose>
            <c:when test="${counter.count == 1}">
                <c:if test="${pageContext.request.remoteUser != null}">
                    <c:if test="${f:isUserInRole(pageContext.request, 'beheerder')}">
                        <c:out value="${link}" escapeXml="false" />
                    </c:if>
                </c:if>
            </c:when>
            <c:when test="${counter.count == 2}">
                <c:if test="${pageContext.request.remoteUser != null}">
                    <c:if test="${f:isUserInRole(pageContext.request, 'beheerder')}">
                        <c:out value="${link}" escapeXml="false" />
                    </c:if>
                </c:if>
            </c:when>
            <c:otherwise>
                <c:out value="${link}" escapeXml="false" />
            </c:otherwise>
        </c:choose>
    </c:forEach>
</div>
<div class="menu_boven_logo"></div>