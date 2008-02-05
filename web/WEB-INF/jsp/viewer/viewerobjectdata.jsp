<%@include file="/WEB-INF/jsp/taglibs.jsp" %>
<%@ page isELIgnored="false"%>

<c:choose>
    <c:when test="${not empty object_data}">
        <c:forEach var="thema_object_data" items="${object_data}">
            <strong>
                ${thema_object_data[1]}
            </strong>
            <table>
                <c:forEach var="regel" items="${thema_object_data[2]}">
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
        Er zijn geen gebieden gevonden!
    </c:otherwise>
</c:choose>
