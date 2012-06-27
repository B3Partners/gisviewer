<%@include file="/WEB-INF/jsp/taglibs.jsp" %>
<%@ page isELIgnored="false"%>

<img src="<html:rewrite page="/images/kwr_logo.gif"/>" alt="KWR logo" />
<div id="topmenu">
    <c:set var="requestURI" value="${fn:split(requestScope['javax.servlet.forward.request_uri'], '/')}" />
    <c:set var="requestJSP" value="${requestURI[fn:length(requestURI) - 1]}" />

    <c:set var="appCode" value="${param['appCode']}"/>

    <c:set var="stijlklasse" value="menulink imagemenulink" />
    <c:if test="${requestJSP eq 'help.do'}">
        <c:set var="stijlklasse" value="activemenulink imagemenulink" />
    </c:if>
    <html:link page="/help.do?id=${kaartid}" target="_blank" styleClass="${stijlklasse}" module="">
        <img src="<html:rewrite page="/images/helpicon.png"/>" alt="Help" title="Help" border="0" />
    </html:link>

    <c:set var="stijlklasse" value="menulink" />
    <c:if test="${requestJSP eq 'viewer.do'}">
        <c:set var="stijlklasse" value="activemenulink" />
    </c:if>

    <c:if test="${pageContext.request.remoteUser != null}">
        <html:link page="/viewer.do?appCode=${appCode}" styleClass="${stijlklasse}" module=""><fmt:message key="commons.topmenu.viewer"/></html:link>
    </c:if>

    <c:set var="stijlklasse" value="menulink" />
    <c:if test="${requestJSP eq 'index.do' or requestJSP eq 'indexlist.do' or requestJSP eq ''}">
        <c:set var="stijlklasse" value="activemenulink" />
    </c:if>
    <html:link page="/indexlist.do?appCode=${appCode}" styleClass="${stijlklasse}" module=""><fmt:message key="commons.topmenu.home"/></html:link>
</div>