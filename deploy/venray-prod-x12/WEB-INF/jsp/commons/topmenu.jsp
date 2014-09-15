<%@include file="/WEB-INF/jsp/taglibs.jsp" %>
<%@ page isELIgnored="false"%>

<div id="topmenu">
    <div id="topmenu_header"><h2>Geo Dataportaal</h2></div>
    <c:set var="requestURI" value="${fn:split(requestScope['javax.servlet.forward.request_uri'], '/')}" />
    <c:set var="requestJSP" value="${requestURI[fn:length(requestURI) - 1]}" />
    <c:set var="appCode" value="${param['appCode']}"/>

    <c:set var="stijlklasse" value="menulink" />
    <c:if test="${requestJSP eq 'index.do' or requestJSP eq 'indexlist.do' or requestJSP eq 'gisviewer' or requestJSP eq ''}">
        <c:set var="stijlklasse" value="activemenulink" />
    </c:if>
    <html:link page="/cms/1/home.htm" styleClass="${stijlklasse}" module=""><fmt:message key="commons.topmenu.home"/></html:link>
</div>
<div id="venraylogo"></div>
<div id="venrayhead">
    <h1>Welkom op het Geo Dataportaal van de gemeente Venray</h1>
</div>