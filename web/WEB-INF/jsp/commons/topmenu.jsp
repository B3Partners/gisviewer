<%@include file="/WEB-INF/jsp/taglibs.jsp" %>
<%@ page isELIgnored="false"%>

<div id="topmenu">
    <c:set var="requestURI" value="${fn:split(requestScope['javax.servlet.forward.request_uri'], '/')}" />
    <c:set var="requestJSP" value="${requestURI[fn:length(requestURI) - 1]}" />
    
    <c:set var="appCode" value="${param['appCode']}"/>
    
    <a href="mailto:<fmt:message key="commons.topmenu.email"/>" class="menulink">
        <img src="<html:rewrite page="/images/email.png"/>" alt="<fmt:message key="commons.topmenu.emailmessage"/>" title="Stuur een e-mail naar de beheerder" />
    </a>

    <c:set var="stijlklasse" value="menulink" />
    <c:if test="${requestJSP eq 'help.do'}">
        <c:set var="stijlklasse" value="activemenulink" />
    </c:if>
    <html:link page="/help.do?id=${kaartid}" styleClass="${stijlklasse}" module="">
        <img src="<html:rewrite page="/images/help.png"/>" alt="Help" title="Help" />
    </html:link>

    <%-- niet direct naar viewer    
    <c:set var="stijlklasse" value="menulink" />
    <c:if test="${requestJSP eq 'viewer.do'}">
        <c:set var="stijlklasse" value="activemenulink" />
    </c:if>
    <c:if test="${pageContext.request.remoteUser != null}">
        <html:link page="/viewer.do?appCode=${appCode}" styleClass="${stijlklasse}" module=""><fmt:message key="commons.topmenu.viewer"/></html:link>
    </c:if>
    --%>
    
    <c:set var="stijlklasse" value="menulink" />
    <c:if test="${requestJSP eq 'index.do' or requestJSP eq 'indexlist.do' or requestJSP eq ''}">
        <c:set var="stijlklasse" value="activemenulink" />
    </c:if>
    <html:link page="/indexlist.do?appCode=${appCode}" styleClass="${stijlklasse}" module=""><fmt:message key="commons.topmenu.home"/></html:link>
</div>