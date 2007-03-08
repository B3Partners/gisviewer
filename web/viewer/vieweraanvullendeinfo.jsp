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
                <table id="aanvullende_info_table">
                    <tr>
                        <th colspan="2" class="aanvullende_info_td" style="text-align: center; padding-bottom: 10px;">
                            Aanvullende informatie
                        </th>
                    </tr>
                    <c:forEach var="ThemaItem" items="${thema_items}" varStatus="counter">
                        <c:choose>
                            <c:when test="${counter.count % 2 == 0}">
                                <tr onmouseover="this.style.backgroundColor = '#CCCCCC;'" onmouseout="this.style.backgroundColor = '#FFFFFF;'">
                            </c:when>
                            <c:otherwise>
                                <tr style="background-color: #DDDDDD;" onmouseover="this.style.backgroundColor = '#CCCCCC;'" onmouseout="this.style.backgroundColor = '#DDDDDD;'">
                            </c:otherwise>
                        </c:choose>
                        
                            <th class="aanvullende_info_th">${ThemaItem.label}</th>
                            <td class="aanvullende_info_td">
                                <c:choose>
                                    <c:when test="${regels[0][counter.count - 1] eq ''}">
                                        -
                                    </c:when>
                                    <c:otherwise>
                                        ${regels[0][counter.count - 1]}
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                </table>
            </c:when>
            <c:otherwise>
                Er is geen admin data gevonden!
            </c:otherwise>
        </c:choose>
    </body>
</html>