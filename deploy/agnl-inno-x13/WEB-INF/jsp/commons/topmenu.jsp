<%@include file="/WEB-INF/jsp/taglibs.jsp" %>
<%@ page isELIgnored="false"%>

<img width="940" height="90" alt="AgentschapNL Innovatie" src="<html:rewrite page='/images/agentschapnl_logo.gif' module=''/>" class="logo_boven" />

<div class="duurzaamheidbalk_home">
    <img alt="Duurzaamheid" src="<html:rewrite page='/images/duurzaamheid_header.png' module=''/>" />
</div>

<div id="topmenu">
    <c:set var="requestURI" value="${fn:split(requestScope['javax.servlet.forward.request_uri'], '/')}" />
    <c:set var="requestJSP" value="${requestURI[fn:length(requestURI) - 1]}" />
	<c:set var="appCode" value="${param['appCode']}"/>

    <c:set var="stijlklasse" value="menulink" />
    <c:if test="${requestJSP eq 'index.do' or requestJSP eq 'indexlist.do' or requestJSP eq ''}">
        <c:set var="stijlklasse" value="activemenulink" />
    </c:if>
    <html:link page="/indexlist.do?id=${kaartid}" styleClass="${stijlklasse}" module=""><fmt:message key="commons.topmenu.home"/></html:link>
    
    <c:set var="stijlklasse" value="menulink" />
    <c:if test="${requestJSP eq 'viewer.do'}">
        <c:set var="stijlklasse" value="activemenulink" />
    </c:if>

    <c:set var="stijlklasse" value="menulink" />
    <html:link page="/viewer.do?appCode=${appCode}" target="_new" styleClass="${stijlklasse}" module="">
        &#155; Viewer
    </html:link>
    
    <div id="menulinks_onder"></div>
    <div id="menulinks_whitespaceonder"></div>
</div>