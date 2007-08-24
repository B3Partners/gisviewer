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
<link href="styles/etl.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="<html:rewrite page="/scripts/simple_treeview.js"/>"/>
<script type="text/javascript"></script>

<p>
    <h1>Selecteer uw Thema</h1>
</p>
<p>
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
    </table>
</p>