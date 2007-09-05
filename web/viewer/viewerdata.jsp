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
        <style>
            body {
                background-image: url(/nbr_prototype/images/infovak_bg.jpg);
                background-repeat: no-repeat;
                background-position: 100% 100%;
                background-attachment: fixed;
            }
        </style>
    </head>
    <body>
        <html:messages id="error" message="true">
            <div class="messages" style="border: 1px solid blue; width: 250px; padding: 5px; margin: 2px; font-size: 9pt; font-weight: bold;"><img src="<html:rewrite page='/images/icons/error.gif' module='' />" width="15" height="15"/>&nbsp;<c:out value="${error}" escapeXml="false"/>&#160;&#160;</div>
        </html:messages>
    </body>
</html:html>
