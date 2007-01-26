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
    <style>
        td {
            font-size: 8pt;
        }
    </style>
</head>
<body>
    <c:choose>
        <c:when test="${not empty objectdata}">
            <c:forEach var="thema_object_data" items="${objectdata}">
                <strong>
                    ${thema_object_data[0]}
                </strong><br /><br />
                <table>
                    <c:forEach var="rij" items="${thema_object_data[1]}">
                        <tr>
                            <td>
                                ${rij[0]}
                            </td>
                            <td>
                                ${rij[1]}
                            </td>
                        </tr>
                    </c:forEach>
                </table>
            </c:forEach>
        </c:when>
        <c:otherwise>
            Er is geen objectdata gevonden!
        </c:otherwise>
    </c:choose>
</body>
</html>