<%@include file="/WEB-INF/jsp/taglibs.jsp" %>
<%@ page isELIgnored="false"%>

<div id="topmenu">
    <c:forEach var="menuItem" varStatus="status" items="${cmsMenuItems}">
        <c:if test="${empty menuItem.icon}">            
            <a href="<c:url value="${menuItem.url}"/>" class="menulink">${menuItem.titel}</a>           
        </c:if>

        <c:if test="${!empty menuItem.icon}">
            <a href="<c:url value="${menuItem.url}"/>" class="menulink">         
                <img src="<c:url value='${menuItem.icon}' />" border="0" />
            </a>
        </c:if>
    </c:forEach>
</div>