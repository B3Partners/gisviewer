<%@include file="/WEB-INF/jsp/taglibs.jsp" %>
<%@ page isELIgnored="false"%>
<html>
    <head>
        <title>Viewer Data</title>
        <link href="styles/main.css" rel="stylesheet" type="text/css">
        <link href="styles/viewer.css" rel="stylesheet" type="text/css">
        <link rel="stylesheet" type="text/css" href="styles/viewer_b3p.css">
    </head>
    <body class="tabvak_body">
        <c:choose>
            <c:when test="${not empty object_data}">
                <c:forEach var="thema_object_data" items="${object_data}">
                    <strong>
                        ${thema_object_data[0]}
                    </strong>
                    <table>
                        <c:forEach var="regel" items="${thema_object_data[1]}">
                            <tr>
                                <c:forEach var="item" items="${regel}" end="1">
                                    <td>
                                        ${item}
                                    </td>
                                </c:forEach>
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