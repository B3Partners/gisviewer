<%--
B3P Gisviewer is an extension to Flamingo MapComponents making      
it a complete webbased GIS viewer and configuration tool that    
works in cooperation with B3P Kaartenbalie.  
                    
Copyright 2006, 2007, 2008 B3Partners BV

This file is part of B3P Gisviewer.

B3P Gisviewer is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

B3P Gisviewer is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with B3P Gisviewer.  If not, see <http://www.gnu.org/licenses/>.
--%>
<%@include file="/WEB-INF/jsp/taglibs.jsp" %>
<%@ page isELIgnored="false"%>
<script type="text/javascript" src='dwr/interface/JMapData.js'></script>
<script type="text/javascript" src='dwr/engine.js'></script>
<script type="text/javascript" src="<html:rewrite page="/scripts/admindataFunctions.js"/>"></script>
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
    var mapRequest;
    if (window.opener){
        if (window.opener.lastGetMapRequest){
            mapRequest=window.opener.lastGetMapRequest;
        }else if(window.opener.opener && window.opener.opener.lastGetMapRequest){
            mapRequest=window.opener.opener.lastGetMapRequest;
        }else if(window.opener.parent && window.opener.parent.lastGetMapRequest){
            mapRequest=window.opener.parent.lastGetMapRequest;
        }

    }else{
        mapRequest=lastGetMapRequest;
    }
    mapRequest=removeParam(mapRequest,"bbox");
    mapRequest=removeParam(mapRequest,"width");
    mapRequest=removeParam(mapRequest,"height");
    if (mapRequest.lastIndexOf("?")!=mapRequest.length-1 && mapRequest.lastIndexOf("&")!=mapRequest.length-1){
        if (mapRequest.indexOf("?")>0){
            mapRequest+="&";
        }else{
            mapRequest+="?";
        }
    }
    //max map image height
    var maxMapImageWidth=300;
    //max map image width
    var maxMapImageHeight=300;
    //De ruimte om het object heen dat ook moet worden getoond in het kaartje.
    var mapSpaceAround=10;
    function removeParam(url,param){
        var newUrl;
        var paramBeginIndex=url.toLowerCase().indexOf(param+"=", 0);
        if (paramBeginIndex == -1)
            return url;
        var paramEndIndex=url.toLowerCase().indexOf('?',paramBeginIndex);
        if (paramEndIndex==-1){
            paramEndIndex=url.length-1;
        }        
        newUrl=url.substring(0,paramBeginIndex);
        newUrl+=url.substring(paramEndIndex);
        return newUrl;
    }
</script>

<c:choose>
    <c:when test="${not empty thema_items and not empty regels}">
        <table id="aanvullende_info_master_table">
            <c:forEach var="regel" items="${regels}" varStatus="regelCounter">
                    <tr style="page-break-after: always;">
                        <td valign="top">
                            <table class="aanvullende_info_table">
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
                                                <c:when test="${regel.values[counter.count - 1] eq ''}">
                                                    -
                                                </c:when>
                                                <c:when test="${ThemaItem.dataType.id == 3}">
                                                    <html:image src="./images/icons/world_link.png" onclick="popUp('${regel.values[counter.count - 1]}', 'externe_link');" style="cursor: pointer; cursor: hand;" />
                                                </c:when>
                                                <c:when test="${ThemaItem.dataType.id == 4}">
                                                    <c:set var="valar" value="${fn:split(regel.values[counter.count - 1], '###')}" />
                                                    <c:set var="funct" value="${valar[0]}" />
                                                    <c:if test="${fn:length(valar) > 1}">
                                                        <c:set var="funct" value="${valar[1]}" />
                                                    </c:if>
                                                    <c:choose>
                                                        <c:when test="${fn:startsWith(funct,'setAttributeValue')}}">
                                                            <c:choose>
                                                                <c:when test="${fn:length(valar) > 1}">
                                                                    <c:out value="${valar[0]}"/>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    -
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </c:when>
                                                        <c:when test="${fn:startsWith(funct,'setAttributeText')}">
                                                            <c:choose>
                                                                <c:when test="${fn:length(valar) > 1}">
                                                                    <a class="datalink" id="href${counter.count}${kolom.count-1}" href="#" onclick="return ${valar[1]}">${valar[0]}</a>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <a class="datalink" id="href${counter.count}${kolom.count-1}" href="#" onclick="return ${valar[0]}"><em>leeg</em></a>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </c:when>
                                                        <c:when test="${fn:length(valar) > 1}">
                                                            <a class="datalink" id="href${counter.count}${kolom.count-1}" href="#" onclick="${valar[1]}">${valar[0]}</a>
                                                        </c:when>
                                                    </c:choose>
                                                </c:when>
                                                <c:otherwise>
                                                    ${regel.values[counter.count - 1]}
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </table>
                        </td>
                       <td valign="top">
                            <!-- Wordt een plaatje getoond van het object -->
                            <c:if test="${envelops[0]!=null and not empty envelops[0]}">
                                <div class="aanvullendeInfoKaartContainer">
                                    <script>
                                        var minx,maxx,miny,maxy,ax,ay;
                                        minx=<c:out value="${envelops[regelCounter.count-1][0]}"/>;
                                        miny=<c:out value="${envelops[regelCounter.count-1][1]}"/>;
                                        maxx=<c:out value="${envelops[regelCounter.count-1][2]}"/>;
                                        maxy=<c:out value="${envelops[regelCounter.count-1][3]}"/>;

                                        minx=Number(minx)-mapSpaceAround;
                                        miny=Number(miny)-mapSpaceAround;
                                        maxx=Number(maxx)+mapSpaceAround;
                                        maxy=Number(maxy)+mapSpaceAround;
                                        var ax=maxx-minx;
                                        var ay=maxy-miny;

                                        var xfactor=ax/maxMapImageWidth;
                                        var yfactor=ay/maxMapImageHeight;
                                        var width;
                                        var height;
                                        if (xfactor > yfactor){
                                            width=ax/xfactor;
                                            height=ay/xfactor;
                                        }else{
                                            width=ax/yfactor;
                                            height=ay/yfactor;
                                        }
                                        var newMapRequest=""+mapRequest;
                                        newMapRequest+="bbox="+minx+","+miny+","+maxx+","+maxy+"&";
                                        newMapRequest+="height="+height+"&";
                                        newMapRequest+="width="+width+"&";
                                        var imagetag="<img src='"+newMapRequest+"'";
                                        if (xfactor > yfactor){
                                            imagetag+=" width='"+width;
                                        }else{
                                            imagetag+=" height='"+height;
                                        }
                                        imagetag+="' alt='"+newMapRequest+"'/>";
                                        document.write(imagetag);
                                    </script>
                                </div>
                            </c:if>
                       </td>
                   </tr>
            </c:forEach>
        </table>
        <!-- Wordt gebruikt om eventuele opmerkingen te bewerken -->
        <div id="opmerkingenedit" style="display: none; position: absolute; text-align: right;">
            <textarea id="opmText" cols="60" rows="3"></textarea><br />
            <input type="button" value="Ok" id="opmOkButton" />
            <input type="button" value="Cancel" id="opmCancelButton" />
        </div>
    </c:when>
    <c:otherwise>
        Er is geen admin data gevonden!
    </c:otherwise>
</c:choose>

