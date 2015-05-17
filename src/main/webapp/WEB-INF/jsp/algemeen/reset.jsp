<%@include file="/WEB-INF/jsp/taglibs.jsp" %>

<div class="content_block">
    <div class="content_title">Reset</div>

    <tiles:insert definition="actionMessages"/>

    <c:if test="${pageContext.request.remoteUser != null}">
        <div class="uitloggen">
            <p><tiles:insert name="loginblock"/></p>
        </div>
    </c:if>
</div>
