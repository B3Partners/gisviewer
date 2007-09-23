<%@include file="/WEB-INF/jsp/taglibs.jsp" %>
<%@ page isELIgnored="false"%>

<html:messages id="error" message="true">
    <div class="messages"><img src="<html:rewrite page='/images/icons/error.gif' module='' />" width="15" height="15"/>&nbsp;<c:out value="${error}" escapeXml="false"/>&#160;&#160;</div>
</html:messages>
