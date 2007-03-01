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
            <c:when test="${not empty thema_items and not empty regels}">
                <div class="topRow">
                    <c:forEach var="ThemaItem" items="${thema_items}">
                        <c:set var="themaid" value="${ThemaItem.thema}" />
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
                
                <div class="row">
                    <c:forEach var="Regel" items="${regels}" varStatus="counter">
                        <c:forEach var="waarde" items="${Regel[1]}" varStatus="kolom">
                            <c:if test="${thema_items[kolom.count - 1] != null}">
                                <c:choose>
                                    <c:when test="${thema_items[kolom.count - 1].kolombreedte != 0}">
                                        <c:set var="breedte" value="${thema_items[kolom.count - 1].kolombreedte}" />
                                    </c:when>
                                    <c:otherwise>
                                        <c:set var="breedte" value="150" />
                                    </c:otherwise>            
                                </c:choose>
                                <div style="width: ${breedte}; float: left;">
                                    ${waarde}
                                </div>
                            </c:if>
                        </c:forEach>
                    </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                ${thema_items}
                Er is geen admin data gevonden!
            </c:otherwise>
        </c:choose>
    </body>
</html>