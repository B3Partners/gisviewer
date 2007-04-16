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
        <title>Analyse Data</title>
        <link href="styles/main.css" rel="stylesheet" type="text/css">
        <link href="styles/viewer.css" rel="stylesheet" type="text/css">
        <style>
            td, select {
            font-size: 8pt;
            }
            
            select {
            margin-top: 5px;
            margin-bottom: 5px;
            margin-left: 5px;
            }
            
            .zoek_knop {
            margin-top: 5px;
            margin-left: 5px;
            }
            
            .thema_label {
            margin-left: 1px;
            font-weight: bold;
            font-style: italic;
            }
            
            .thema_object {
            margin-left: 5px;
            }
            
            .optie {
            float: left;
            clear: both;
            }
            
            #object_opties, #waarde_opties {
            margin-left: 20px;
            clear: both;
            float: left;
            }
        </style>
        <script type="text/javascript">
        function showDiv(id) {
            document.getElementById(id).style.display = 'block';
            if(id == 'object_opties') document.getElementById('waarde_opties').style.display = 'none';
            if(id == 'waarde_opties') document.getElementById('object_opties').style.display = 'none';
        }
        
        function submitdata() {
            if(document.getElementById('objectoptie').checked) {
                // Geef object -- Laad nieuwe pagina in frame
                document.forms[0].analyseobject.value = "t";
                document.forms[0].analysewaarde.value = "";
                document.forms[0].target = 'dataframe';
                document.forms[0].submit();
            }
            if(document.getElementById('waardeoptie').checked) {
                // Geef waarde
                document.forms[0].analysewaarde.value = "t";
                document.forms[0].analyseobject.value = "";
                document.forms[0].target = '';
                document.forms[0].submit();
            }
        }
        </script>
    </head>
    <body>
        <c:choose>
            <c:when test="${not empty analyse_data}">
                <form id="doanalysedataForm" method="post" action="viewerdata.do">
                    <strong> Extra criteria voor actieve thema</strong> 
                        <c:choose>
                            <c:when test="${not empty thema_items}">
                                <table>
                                    <c:forEach var="ThemaItem" items="${thema_items}">
                                        <c:if test="${not empty ThemaItem.label and ThemaItem.basisregel and ThemaItem.dataType.id==1}">
                                            <tr>
                                                <td>
                                                    ${ThemaItem.label}
                                                </td>
                                                <td>
                                                    <input type="text" size="15" name="ThemaItem_${ThemaItem.thema.id}_${ThemaItem.id}"/>
                                                </td>
                                            </tr>
                                        </c:if>
                                    </c:forEach>
                                </table>
                            </c:when>
                        </c:choose>
                    <strong> Analysegebied</strong><br/>
                    <select name="geselecteerd_object" id="geselecteerd_object">
                        <option value="-1">-- Selecteerd een gebied --</option>
                        <c:forEach var="thema_analyse_data" items="${analyse_data}">
                            <optgroup label="${thema_analyse_data[0]}">
                                <c:forEach var="regel" items="${thema_analyse_data[2]}">
                                    <option class="thema_object" value="ThemaObject_${thema_analyse_data[1]}_${regel[0]}">
                                        <c:forEach var="item" items="${regel}" end="1">
                                            ${item}
                                        </c:forEach>
                                    </option>        
                                </c:forEach>
                            </optgroup>
                        </c:forEach>
                    </select>
                    
                    
                    <div class="optie"><input type="radio" value="1" name="zoekopties" id="objectoptie" onclick="showDiv('object_opties')" /> Geef object</div>
                    <div id="object_opties" style="display: none;">
                        <input type="radio" value="1" name="zoekopties_object" /> Zonder overlap, niet in gebied<br />
                        <input type="radio" value="2" name="zoekopties_object" /> Geheel in gebied<br />
                        <input type="radio" value="3" name="zoekopties_object" /> Met overlap, geheel of gedeeltelijk in gebied
                    </div>
                    <div class="optie"><input type="radio" value="2" name="zoekopties" id="waardeoptie" onclick="showDiv('waarde_opties')" /> Geef waarde</div>
                    <div id="waarde_opties" style="display: none;">
                        <input type="radio" value="1" name="zoekopties_waarde" /> Maximale waarde<br />
                        <input type="radio" value="2" name="zoekopties_waarde" /> Minimale waarde<br />
                        <input type="radio" value="3" name="zoekopties_waarde" /> Gemiddelde waarde<br />
                        <input type="radio" value="4" name="zoekopties_waarde" /> Totale waarde<br />
                    </div>
                    <input type="hidden" name="analyseobject" />
                    <input type="hidden" name="analysewaarde" />
                    <input type="hidden" name="themaid" value="${themaid}" />
                    <input type="hidden" name="lagen" value="${lagen}" />
                    <input type="hidden" name="xcoord" value="${xcoord}" />
                    <input type="hidden" name="ycoord" value="${ycoord}" />
                    <div class="optie"><input type="button" value="Bereken" class="zoek_knop" id="analysedata" name="analysedata" onclick="submitdata();" /></div>
                    <div class="optie" style="height: 10px;">&nbsp;</div>
                </form>
            </c:when>
            <c:otherwise>
                Geen data ter analyse gevonden
            </c:otherwise>
        </c:choose>
        <c:if test="${not empty waarde}">
            <div class="optie" style="margin-left: 10px;"><div class="waardeResult"><c:out value="${waarde}" escapeXml="false" /></div></div>
        </c:if>
        
        <c:if test="${not empty object}">
            <div class="optie" style="margin-left: 10px;"><strong>Object</strong><br /><c:out value="${object}" escapeXml="false" /></div>
        </c:if>
    </body>
</html>