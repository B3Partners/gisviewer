<%@include file="/WEB-INF/jsp/taglibs.jsp" %>

<c:if test="${pageContext.request.remoteUser != null}">
    Ingelogd als: <c:out value="${pageContext.request.remoteUser}"/> | <html:link page="/logout.do" module="">Uitloggen</html:link>
</c:if>    
