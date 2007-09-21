<%@include file="/WEB-INF/jsp/taglibs.jsp" %>
<%@ page isELIgnored="false"%>

<html:html>
    <head>
        <title>Viewer Data</title>
        <link href="styles/viewer.css" rel="stylesheet" type="text/css">
        <link rel="stylesheet" type="text/css" href="styles/viewer_b3p.css">
    </head>
    <body class="tabvak_body">
        <html:messages id="error" message="true">
            <div class="messages"><img src="<html:rewrite page='/images/icons/error.gif' module='' />" width="15" height="15"/>&nbsp;<c:out value="${error}" escapeXml="false"/>&#160;&#160;</div>
        </html:messages>
    </body>
</html:html>
