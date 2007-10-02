<%@include file="/WEB-INF/jsp/taglibs.jsp" %>
<%@ page isELIgnored="false"%>

<div class="onderbalk">ETL THEMASELECTIE<span><tiles:insert name="loginblock"/></span></div>
<table id="etl_overview_table" style="table-layout: fixed;">
    <tr class="etlTopRow">
        <td style="width: 300px;"><b>&nbsp;Thema naam</b></td>
    </tr>
    <c:forEach var="nItem" items="${themalist}" varStatus="counter">
        <c:choose>
            <c:when test="${counter.count % 2 == 1}">
                <tr class="etlRowList">
                    <td style="width: 300px;">
                        <a href="<html:rewrite page="/etltransform.do?showOptions=submit&themaid=${nItem.id}"/>">
                            <b>&nbsp;${nItem.naam}</b>
                        </a>
                    </td>
                </tr>
            </c:when>
            <c:otherwise>
                <tr class="etlRowList" style="background-color: #DDDDDD;">
                    <td style="width: 300px;">
                        <a href="<html:rewrite page="/etltransform.do?showOptions=submit&themaid=${nItem.id}"/>">
                            <b>&nbsp;${nItem.naam}</b>
                        </a>
                    </td>
                </tr>
            </c:otherwise>
        </c:choose>
    </c:forEach>
    <tr class="etlRowList">
        <td style="width: 300px;">
                <b>&nbsp;</b>
        </td>
    </tr>
</table>
