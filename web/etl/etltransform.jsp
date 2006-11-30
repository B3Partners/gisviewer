<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@ page language="java" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/xml" prefix="x" %>
<%@ page isELIgnored="false"%>

<div style="width: 600px; margin-top: 20px;">
    <div class="hoofdvak">
        <strong>Kaart met algemene achtergrond</strong>
        <div id="kaartvak">
            
        </div>
    </div>
    <div class="hoofdvak">
        <strong>Preview administratieve data</strong>
        <div id="adminvak">
            
        </div>
    </div>
    
    <div class="hoofdvak">
        <strong>Geo-afwijking</strong>
        <div id="geoafwijking">
            <form name="geoafwijking">
                <c:if test="${not empty geoafwijking}">
                    <select size="2" name="geoa" id="geoa" onchange="selecteerGekoppelde(this)">
                        <c:forEach var="geoa" items="${geoafwijking}">
                            <option id="<c:out value="${geoa.id}" />" class="<c:out value="${geoa.afwijking}"  />" value="<c:out value="${geoa.id}" />" ><c:out value="${geoa.naam}" /></option>
                        </c:forEach>
                    </select>
                </c:if>
            </form>
        </div>
    </div>
    <div class="hoofdvak" style="width: 100px; text-align: center;">
        <div style="height: 130px;">&nbsp;</div>
        <div style="clear: left;">        
            <button onclick="koppel()">Koppelen</button><br /><br />
            <button onclick="ontkoppel()">Ontkoppelen</button>
        </div>
    </div>
    <div class="hoofdvak">
        <strong>Administratieve-afwijking</strong>
        <div id="adminafwijking">
            <form name="adminafwijking">
                <c:if test="${not empty adminafwijking}">
                    <select size="2" name="admina" id="admina" onchange="selecteerGekoppelde(this)">
                        <c:forEach var="admina" items="${adminafwijking}" varStatus="status">
                            <option id="<c:out value="${admina.id}" />" value="<c:out value="${admina.id}" />" class="<c:out value="${admina.afwijking}" />"><c:out value="${admina.naam}" /></option>
                        </c:forEach>
                    </select>
                </c:if>
            </form>
        </div>
    </div>
    
    <div style="clear: both;" class="hoofdvak">
        <strong>Leganda</strong><br />
        <nobr>
            <span class="oud">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>&nbsp; Oud &nbsp;
            <span class="nieuw">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>&nbsp; Nieuw &nbsp;
            <span class="ontkoppeld">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>&nbsp; Ontkoppeld &nbsp;
            <span class="parkeren">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>&nbsp; Parkeren &nbsp;
            <span class="definitief_ontkoppeld">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>&nbsp; Definitief ontkoppeld &nbsp;
            <span style="background-color: #33CCFF;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>&nbsp; Gekoppeld &nbsp;
        </nobr>
    </div>
</div>