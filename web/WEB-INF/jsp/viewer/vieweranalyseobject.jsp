<%@include file="/WEB-INF/jsp/taglibs.jsp" %>
<%@ page isELIgnored="false"%>

<c:if test="${not empty waarde}">
    <c:out value="${waarde}" escapeXml="false" />
</c:if>
