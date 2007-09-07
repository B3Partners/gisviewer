<%@include file="/WEB-INF/jsp/taglibs.jsp" %>

<c:if test="${pageContext.request.remoteUser != null}">
    <div style="float: right">
        <span style="color: white; font-weight: bold; font-style: italic">
            <c:out value="${pageContext.request.remoteUser}"/>
        </span>
        <span style="color: white">|</span>
        <html:link page="/logout.do" style="color: white">Uitloggen</html:link>
    </div>
</c:if>    
