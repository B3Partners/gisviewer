<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@ page language="java" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/xml" prefix="x" %>
<%@ page isELIgnored="false"%>
<html>
    <head>
        <title>Viewer Data</title>
        <link href="styles/main.css" rel="stylesheet" type="text/css">
        <link href="styles/viewer.css" rel="stylesheet" type="text/css">
    </head>
    <body>
        <c:choose>
            <c:when test="${not empty thema_items}">
                <div class="topRow">
                    <c:forEach var="ThemaItem" items="${thema_items}">
                        <c:choose>
                            <c:when test="${ThemaItem.kolombreedte != 0}">
                                <c:set var="breedte" value="${ThemaItem.kolombreedte}" />
                            </c:when>
                            <c:otherwise>
                                <c:set var="breedte" value="150" />
                            </c:otherwise>            
                        </c:choose>
                        <div style="width: ${breedte}; float: left;">
                            ${ThemaItem.label}
                        </div>
                    </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                Er is geen admin data gevonden!
            </c:otherwise>
        </c:choose>
    </body>
</html>