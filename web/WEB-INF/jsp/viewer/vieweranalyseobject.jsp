<%@include file="/WEB-INF/jsp/taglibs.jsp" %>
<%@ page isELIgnored="false"%>

<c:if test="${not empty object}">
    <c:out value="${object}" escapeXml="false" />
</c:if>
