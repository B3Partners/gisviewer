<%@include file="/WEB-INF/jsp/taglibs.jsp" %>
<%@ page isELIgnored="false"%>

<div id="topmenu">

    <c:set var="requestURI" value="${fn:split(requestScope['javax.servlet.forward.request_uri'], '/')}" />
    <c:set var="requestJSP" value="${requestURI[fn:length(requestURI) - 1]}" />

    <c:forEach var="menuItem" varStatus="status" items="${cmsMenuItems}">
        <c:set var="stijlklasse" value="menulink" />
        <c:if test="${requestJSP eq menuItem.url}">
            <c:set var="stijlklasse" value="activemenulink" />
        </c:if>
        <c:if test="${empty menuItem.icon}">            
            <a href="<c:url value="${menuItem.url}"/>" class="${stijlklasse}">${menuItem.titel}</a>           
        </c:if>

        <c:if test="${!empty menuItem.icon}">
            <a href="<c:url value="${menuItem.url}"/>" class="${stijlklasse}">         
                <img src="<c:url value='${menuItem.icon}' />" border="0" />
            </a>
        </c:if>
    </c:forEach>
</div>