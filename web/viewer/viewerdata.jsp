<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@ page language="java" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/xml" prefix="x" %>
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
