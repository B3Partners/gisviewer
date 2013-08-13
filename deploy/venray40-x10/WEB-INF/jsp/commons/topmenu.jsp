<%@include file="/WEB-INF/jsp/taglibs.jsp" %>
<%@ page isELIgnored="false"%>

<div id="topmenu">
    
    <div id="topmenu_header"><h2>Geo Dataportaal</h2></div>
    
    <c:set var="requestURI" value="${fn:split(requestScope['javax.servlet.forward.request_uri'], '/')}" />
    <c:set var="requestJSP" value="${requestURI[fn:length(requestURI) - 1]}" />
    
    <c:set var="appCode" value="${param['appCode']}"/>
    
    <c:set var="stijlklasse" value="menulink" />
    <c:if test="${requestJSP eq 'index.do' or requestJSP eq 'indexlist.do' or requestJSP eq ''}">
        <c:set var="stijlklasse" value="activemenulink" />
    </c:if>
    <html:link page="/indexlist.do?appCode=${appCode}" styleClass="${stijlklasse}" module=""><fmt:message key="commons.topmenu.home"/></html:link>
    
    <c:set var="stijlklasse" value="menulink" />
    <c:if test="${requestJSP eq 'viewer.do'}">
        <c:set var="stijlklasse" value="activemenulink" />
    </c:if>
    <c:if test="${pageContext.request.remoteUser != null}">
        <html:link page="/viewer.do?appCode=${appCode}" styleClass="${stijlklasse}" module=""><fmt:message key="commons.topmenu.viewer"/></html:link>
    </c:if>
    
    <c:set var="stijlklasse" value="menulink" />
    <c:if test="${requestJSP eq 'help.do'}">
        <c:set var="stijlklasse" value="activemenulink" />
    </c:if>
    <html:link page="/help.do?id=${kaartid}" target="_blank" styleClass="${stijlklasse}" module="">
        <fmt:message key="commons.topmenu.help"/>
    </html:link>
    
    <a href="mailto:geo@venray.nl" class="menulink">
        <fmt:message key="commons.topmenu.contact"/>
    </a>  
</div>
<div id="venraylogo"></div>
<div id="venrayhead">
    <h1>Welkom op het Geo Dataportaal van de gemeente Venray</h1>
</div>