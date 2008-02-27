<%@include file="/WEB-INF/jsp/taglibs.jsp" %>
<%@ page isELIgnored="false"%>

<script>
    function printpage() {
        window.print(); 
    }
</script>

<c:if test="${pageContext.request.remoteUser != null}">
    <c:if test="${f:isUserInRole(pageContext.request, 'beheerder')}">
        <c:set var="beheerder" value="true"/>
    </c:if>
</c:if>

<div class="topmenu" id="topmenu">
    <div class="topmenu_menu">
        <c:set var="requestURI" value="${fn:split(requestScope['javax.servlet.forward.request_uri'], '/')}" />
        <c:set var="requestJSP" value="${requestURI[fn:length(requestURI) - 1]}" />
        
        <c:set var="stijlklasse" value="menulink" />
        <c:if test="${requestJSP eq 'help.do'}">
            <c:set var="stijlklasse" value="activemenulink" />
        </c:if>
        <html:link page="/help.do" styleClass="${stijlklasse}" module="">&#155; Help</html:link>
        
        <c:choose>
            <c:when test="${beheerder == true}">
                <c:set var="stijlklasse" value="menulink" />
                <c:if test="${requestJSP eq 'configThema.do'}">
                    <c:set var="stijlklasse" value="activemenulink" />
                </c:if>
                <html:link page="/configThema.do" styleClass="${stijlklasse}" module="">&#155; Configuratie</html:link>
            </c:when>
            <c:otherwise>
                <c:set var="stijlklasse" value="menulink" />
                <c:if test="${requestJSP eq 'contact.do'}">
                    <c:set var="stijlklasse" value="activemenulink" />
                </c:if>
                <html:link page="/index.do" styleClass="${stijlklasse}" module="">&#155; Contact</html:link>
            </c:otherwise>
        </c:choose>
        
        <c:set var="stijlklasse" value="menulink" />
        <c:if test="${requestJSP eq 'uitleg.do'}">
            <c:set var="stijlklasse" value="activemenulink" />
        </c:if>
        <html:link page="/index.do" styleClass="${stijlklasse}" module="">&#155; Uitleg</html:link>
        
        <html:link href="javascript: printpage();" styleClass="menulink" module="">&#155; Print kaart</html:link>
        
        <c:set var="stijlklasse" value="menulink" />
        <c:if test="${requestJSP eq 'viewer.do'}">
            <c:set var="stijlklasse" value="activemenulink" />
        </c:if>
        <html:link page="/viewer.do" styleClass="${stijlklasse}" module="">&#155; Viewer</html:link>
        
        <c:set var="stijlklasse" value="menulink" />
        <c:if test="${requestJSP eq 'index.do'}">
            <c:set var="stijlklasse" value="activemenulink" />
        </c:if>
        <html:link page="/index.do" styleClass="${stijlklasse}" module="">&#155; Home</html:link>
    </div>
</div>
<div class="menu_boven_logo"></div>