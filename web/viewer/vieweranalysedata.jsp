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
    </script>
</head>
<body>
    <c:choose>
        <c:when test="${not empty analyse_data}">
            <form>
                <label for="geselecteerd_object">Selecteer object waarover analyse moet worden uitgevoerd</label><br />
                <select name="geselecteerd_object" id="geselecteerd_object" onchange="if(this.value!='-1') document.getElementById('submitknop').disabled = false; else document.getElementById('submitknop').disabled = true;">
                    <option value="-1">-- Selecteerd een object --</option>
                    <c:forEach var="thema_analyse_data" items="${analyse_data}">
                        <option value="-1" disabled="disabled" class="thema_label">
                            ${thema_analyse_data[0]}
                        </option>
                        <c:forEach var="rij" items="${thema_analyse_data[1]}">
                            <option class="thema_object" value="${rij[0]}">
                                ${rij[1]} ${rij[2]}
                            </option>        
                        </c:forEach>
                    </c:forEach>
                </select>
                <div class="optie" style="border: 1px solid Gray; margin-left: 10px; margin-bottom: 10px; margin-top: 10px; padding-top: 3px; padding-left: 3px; padding-right: 40px;">
                    <strong> Optionele selectie </strong><br />
                    <c:choose>
                        <c:when test="${not empty thema_items}">
                            <table>
                                <c:forEach var="thema" items="${thema_items}">
                                    <tr>
                                        <td>
                                            ${thema[1]}
                                        </td>
                                        <td>
                                            <select name="selectie_${thema[0]}">
                                                <option value="-1"> --- </option>
                                                <c:forEach var="regels" items="${thema[2]}">
                                                    <option value="${regels}">${regels}</option>
                                                </c:forEach>
                                            </select>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </table>
                        </c:when>
                    </c:choose>
                </div>
                <div class="optie"><input type="radio" value="1" name="zoekopties" onclick="showDiv('object_opties')" /> Geef object</div>
                    <div id="object_opties" style="display: none;">
                        <input type="radio" value="1" name="zoekopties_object" /> Zonder overlap, niet in gebied<br />
                        <input type="radio" value="2" name="zoekopties_object" /> Geheel in gebied<br />
                        <input type="radio" value="3" name="zoekopties_object" /> Met overlap, geheel of gedeeltelijk in gebied
                    </div>
                <div class="optie"><input type="radio" value="2" name="zoekopties" onclick="showDiv('waarde_opties')" /> Geef waarde</div>
                    <div id="waarde_opties" style="display: none;">
                        <input type="radio" value="1" name="zoekopties_waarde" /> Maximale waarde<br />
                        <input type="radio" value="2" name="zoekopties_waarde" /> Minimale waarde<br />
                        <input type="radio" value="3" name="zoekopties_waarde" /> Gemiddelde waarde<br />
                        <input type="radio" value="4" name="zoekopties_waarde" /> Totale waarde<br />
                    </div>
                <div class="optie"><input type="submit" value="Zoek" class="zoek_knop" id="submitknop" disabled="disabled" /></div>
            </form>
        </c:when>
        <c:otherwise>
            Geen data ter anaylse gevonden
        </c:otherwise>
    </c:choose>
</body>
</html>