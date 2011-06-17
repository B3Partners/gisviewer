<%@include file="/WEB-INF/jsp/taglibs.jsp" %>
<%@ page isELIgnored="false"%>

<script type="text/javascript" src='dwr/interface/JMapData.js'></script>
<script type="text/javascript" src='dwr/interface/JCollectAdmindata.js'></script>
<script type="text/javascript" src='dwr/engine.js'></script>
<script type="text/javascript" src="<html:rewrite page='/scripts/kaartselectie.js'/>"></script>

<tiles:insert definition="specialMessages"/>

<h2>Kaartselectie</h2>

<p>User kaartgroepen</p>

<table>
    <tr>
        <td>ID</td>
        <td>Code</td>
        <td>Cluster ID</td>
        <td>Default On</td>
    </tr>

    <c:forEach var="groep" items="${user_kaartgroepen}">
        <tr>
            <td><c:out value="${groep.id}" /></td>
            <td><c:out value="${groep.code}" /></td>
            <td><c:out value="${groep.clusterid}" /></td>
            <td><c:out value="${groep.default_on}" /></td>
        </tr>
    </c:forEach>
</table>