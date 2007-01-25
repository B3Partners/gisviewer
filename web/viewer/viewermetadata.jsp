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
            <c:when test="${not empty meta_data}">
                <table>
                    <c:forEach var="rij" items="${meta_data}">
                        <tr>
                                <td>
                                    ${rij[0]}
                                </td>
                                <td>
                                    <%--
                                    <c:set var="aantalElementen" value="${fn:length(rij[1])}" />
                                    <c:if test="${aantalElementen > 1}">
                                        <ol>
                                    </c:if>
                                    <c:forEach var="opsomming" items="${rij[1]}">
                                        <c:if test="${aantalElementen > 1}">
                                            <li>
                                        </c:if>
                                        ${opsomming}
                                        <c:if test="${aantalElementen > 1}">
                                            </li>
                                        </c:if>
                                    </c:forEach>
                                    <c:if test="${aantalElementen > 1}">
                                        </ol>
                                    </c:if>
                                    --%>
                                    ${rij[1]}
                                </td>
                        </tr>
                    </c:forEach>
                </table>
            </c:when>
            <c:otherwise>
                Er is geen meta data gevonden!
            </c:otherwise>
        </c:choose>
    </body>
</html>