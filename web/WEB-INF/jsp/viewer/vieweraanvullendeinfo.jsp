<%@include file="/WEB-INF/jsp/taglibs.jsp" %>
<%@ page isELIgnored="false"%>
<script type="text/javascript" src='dwr/interface/JMapData.js'></script>
<script type="text/javascript" src='dwr/engine.js'></script>
<script type="text/javascript">
    function popUp(URL, naam) {
        var screenwidth = 1024;
        var screenheight = 768;
        var popupleft =(screen.width) ? (screen.width - screenwidth) / 2:100;
        var popuptop = (screen.height) ? (screen.height - screenheight) / 2:100;
        properties = "toolbar = 0, " + 
                     "scrollbars = 1, " + 
                     "location = 0, " + 
                     "statusbar = 1, " + 
                     "menubar = 0, " + 
                     "resizable = 1, " + 
                     "width = " + screenwidth + ", " + 
                     "height = " + screenheight + ", " + 
                     "top = " + popuptop + ", " + 
                     "left = " + popupleft;
        eval("page" + naam + " = window.open(URL, '" + naam + "', properties);");
    }
    function setAttributeValue(element, themaid, keyName, keyValue, attributeName, attributeValue, eenheid){
        // Leeg -> Ja
        // Nee -> Ja
        // Ja -> Nee        
        var oldValue = element.innerHTML; // Nu wordt er gegeken naar wat de waarde is die in de link staat, deze wordt gebruikt, niet attributeValue
        var newValue = 'Nee';
        if(oldValue == 'Leeg' || oldValue == 'Nee' || oldValue == 'Nieuw')
            newValue = 'Ja';
        JMapData.setAttributeValue(element.id, themaid, keyName, keyValue, attributeName, attributeValue, newValue, handleSetAttribute);
    }
    function handleSetAttribute(str){
        document.getElementById(str[0]).innerHTML=str[1];
    }
    function berekenOppervlakte(element, themaid, kolomnaam,value,eenheid){        
        JMapData.getArea(element.id,themaid,kolomnaam,value,eenheid,handleGetArea);
    }
    function handleGetArea(str){
        document.getElementById(str[0]).innerHTML=str[1];
    }
</script>

<c:choose>
    <c:when test="${not empty thema_items and not empty regels}">
        <table id="aanvullende_info_table">
            <tr class="topRow">
                <th colspan="2" class="aanvullende_info_td">
                    Aanvullende informatie
                </th>
            </tr>
            <c:forEach var="ThemaItem" items="${thema_items}" varStatus="counter">
                <c:choose>
                    <c:when test="${counter.count % 2 == 0}">
                        <c:set var="altTr" value=""/>
                    </c:when>
                    <c:otherwise>
                        <c:set var="altTr" value="aanvullende_info_alternateTr"/>
                    </c:otherwise>
                </c:choose>
                <tr class="${altTr}">
                    <th class="aanvullende_info_th">${ThemaItem.label}</th>
                    <td class="aanvullende_info_td">
                        <c:choose>
                            <c:when test="${ThemaItem.dataType.id == 2}">
                                -
                            </c:when>
                            <c:when test="${ThemaItem.dataType.id == 3}">
                                <html:image src="./images/icons/world_link.png" onclick="popUp('${regels[0][counter.count - 1]}', 'externe_link');" style="cursor: pointer; cursor: hand;" />
                            </c:when>
                            <c:when test="${regels[0][counter.count - 1] eq ''}">
                                -
                            </c:when>
                            <c:when test="${ThemaItem.dataType.id == 4}">
                                <c:choose>
                                    <c:when test="${fn:startsWith(fn:split(regels[0][counter.count - 1], '###')[1],'setAttributeValue')}">
                                        <c:out value="${fn:split(regels[0][counter.count - 1], '###')[0]}"/> 
                                    </c:when>
                                    <c:otherwise>
                                        <a class="datalink" id="href${counter.count-1}" href="#" onclick="${fn:split(regels[0][counter.count - 1], '###')[1]}">${fn:split(regels[0][counter.count - 1], '###')[0]}</a>                                
                                    </c:otherwise>
                                </c:choose>
                            </c:when>
                            <c:otherwise>
                                ${regels[0][counter.count - 1]}
                            </c:otherwise>
                        </c:choose>
                    </td>
                </tr>
            </c:forEach>
        </table>
    </c:when>
    <c:otherwise>
        Er is geen admin data gevonden!
    </c:otherwise>
</c:choose>
