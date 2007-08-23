<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@ page language="java" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/xml" prefix="x" %>
<%@ page isELIgnored="false"%>

<link href="styles/main.css" rel="stylesheet" type="text/css">
<link href="styles/viewer.css" rel="stylesheet" type="text/css">
<p>
    <h1>Overzicht verschillende Thema's met bijhorende resultaten</h1>
</p>
<p>
    <table id="etl_overview_table" style="table-layout: fixed;">
        <tr class="etlTopRow">
            <td style="width: 300px;"><b>&nbsp;Thema naam</b></td>
            <td><b>&nbsp;Aantal NO</b></td>
            <td><b>&nbsp;Aantal OAO</b></td>
            <td><b>&nbsp;Aantal OGO</b></td>
            <td><b>&nbsp;Aantal GO</b></td>
            <td><b>&nbsp;Aantal VO</b></td>
            <td><b>&nbsp;Aantal OO</b></td>
            <td><b>&nbsp;Totaal</b></td>
            <td><b>&nbsp;% incorrect</b></td>
        </tr>

        <c:forEach var="nItem" items="${overview}" varStatus="counter">
            <c:choose>
                <c:when test="${counter.count % 2 == 1}">
                    <tr class="etlRow">
                </c:when>
                <c:otherwise>
                    <tr class="etlRow" style="background-color: #DDDDDD;">
                </c:otherwise>
            </c:choose>
            <c:forEach var="item" items="${nItem}" varStatus="i">
                <c:choose>
                    <c:when test="${i.count % 9 == 0}">
                        <td style="width: 300px;"><b>&nbsp;${item}</b></td>
                    </c:when>
                    <c:otherwise>
                        <td><b>&nbsp;${item}</b></td>                        
                    </c:otherwise>
                </c:choose>
            </c:forEach>
            </tr>
        </c:forEach>
    </table>
</p>
<ul>
    <li><b>NO</b>  - Nieuwe objecten</li>
    <li><b>OAO</b> - Onvolledig Administratieve Objecten</li>
    <li><b>OGO</b> - Onvolledig Geografische Objecten</li>
    <li><b>GO</b>  - Geupdate Objecten</li>
    <li><b>VO</b>  - Verwijderde Objecten</li>
    <li><b>OO</b>  - Ongewijzigde Objecten</li>
    <li>Totaal: alle objecten bij elkaar opgeteld</li>
    <li>% incorrect: ((OAO + OGO) / Totaal) * 100</li>
</ul>