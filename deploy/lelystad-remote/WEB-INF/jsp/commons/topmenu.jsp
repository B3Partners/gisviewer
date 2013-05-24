<%@include file="/WEB-INF/jsp/taglibs.jsp" %>
<%@ page isELIgnored="false"%>

<div id="topmenu">
    <c:set var="requestURI" value="${fn:split(requestScope['javax.servlet.forward.request_uri'], '/')}" />
    <c:set var="requestJSP" value="${requestURI[fn:length(requestURI) - 1]}" />
    
    <c:set var="appCode" value="${param['appCode']}"/>
    
    <c:set var="stijlklasse" value="menulink" />
    <c:if test="${requestJSP eq 'index.do' or requestJSP eq 'indexlist.do' or requestJSP eq '' or requestJSP eq 'gisviewer' }">
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
    
    <a href="mailto:JM.Koeckhoven@Lelystad.nl" class="menulink">
        <fmt:message key="commons.topmenu.contact"/>
    </a>

</div>

<!--[if lte IE 8]>
<script type="text/javascript">
    // Give menu nice colors
    (function() {
        var counter = 1;
        $j('#topmenu').find('a').each(function() {
            $j(this).addClass('menuitem' + counter++);
            if(counter === 6) counter = 1;
        });
    })();
</script>
<![endif]-->