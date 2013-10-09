<%@include file="/WEB-INF/jsp/taglibs.jsp" %>
<%@page contentType="text/css" pageEncoding="UTF-8" %>
<c:forEach var="tb" varStatus="status" items="${tekstBlokken}">
    .tekstblok${tb.id} {
        <c:if test="${!empty tb.kleur}">
            background-color: ${tb.kleur} !important;
        </c:if>
        <c:if test="${!empty tb.hoogte && tb.hoogte != 0}">
            height: ${tb.hoogte}px !important;
        </c:if>
    }
</c:forEach>