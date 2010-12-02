<%@include file="/WEB-INF/jsp/taglibs.jsp" %>
<%@ page isELIgnored="false" %>

<script type="text/javascript" src='dwr/interface/JCollectAdmindata.js'></script>
<script type="text/javascript" src='dwr/engine.js'></script>
<script type="text/javascript" src="<html:rewrite page='/scripts/table.js'/>"></script>
<script type="text/javascript" src="<html:rewrite page='/scripts/flamingo/FlamingoController.js'/>"></script>
<script type="text/javascript" src="<html:rewrite page='/scripts/admindataFunctions.js'/>"></script>
<script type="text/javascript">
    var doClose=true;

    var usePopup = true;
    var autoPopupRedirect = false;
    var maxExtraInfo=100;
    var styleObjects = new Array();
    var timeout = 3000;
    var loop = 0;

    function editFeature(ggbId, attrName, attrVal) {
        getParent().drawFeature(ggbId, attrName, attrVal);
    };
    function popUp(link, title, width, heigth) {
        getParent().popUp(link, title, width, heigth);
    }

    getParent().hideLoading();

    if(!(opener && opener.usePopup) && !(parent && parent.useDivPopup) && !autoPopupRedirect) {
        if(parent) {
            if(parent.panelBelowCollapsed) {
                parent.panelResize('below');
            }
        }
    }

</script>


<tiles:insert definition="specialMessages"/>
<%-- nog een keer loading melden en pas wissen als er data binnenkomt via ofwel
reguliere admindata of GetFeatureInfo --%>
<div id="content_style">
    <table class="kolomtabel">
        <tr>
            <td valign="top">
                <div class="inleiding">
                    <table>
                        <tr>
                            <td style="width:20px;"><img style="border: 0px;" src="/gisviewer/images/waiting.gif" alt="Bezig met laden..." /></td>
                            <td>
                                <h2>Bezig met laden ...</h2>
                                <p>Bezig met zoeken naar administratieve gegevens.</p>
                            </td>
                        </tr>
                    </table>
                </div>
            </td>
        </tr>
    </table>
</div>

<div id="adminDataContainer"></div>
<%-- div id="childLoadingadminDataContainer" class="childLoading"><img src="images/icons/loading.gif" alt="Loading" title="Loading" /></div --%>
<div id="getFeatureInfo"></div>

<script type="text/javascript">
    <c:choose>
        <c:when test="${not empty beans and not empty wkt}">
            <%-- er komt reguliere admindata binnen. de wachtmelding wordt in de
            handleGetGegevensBron op onzichtbaar gezet. --%>
                $j(document).ready(function() {
            <c:forEach items="${beans}" var="bean">
                    // optellen aantal gegevensbronnen
                    loop++;
                    // haal gegevens op van gegevensbron
                    JCollectAdmindata.fillGegevensBronBean(${bean.id}, ${bean.themaId}, '${wkt}', '${bean.cql}', 'adminDataContainer', handleGetGegevensBron);
            </c:forEach>
                });
        </c:when>
        <c:otherwise>
            <%-- er komt geen reguliere admindata binnen, we schrijven vertraagd
            dat er geen data beschikbaar is. Als via getFeatureInfo data binnenkomt
            dan wordt deze melding op onzichtbaar gezet. --%>
                window.setTimeout("writeNoResults();", timeout);
        </c:otherwise>
    </c:choose>
</script>



<script type="text/javascript">
    //writes the obj data from flamingo to a table
    function writeFeatureInfoData(obj){
        doClose=false;
        var tableData="";
        for (layer in obj){
            tableData+="<table class=\"aanvullende_info_table\" >";
            for (feature in obj[layer]){
                tableData+="    <tr class=\"topRow\">";
                tableData+="        <th colspan=\"2\" class=\"aanvullende_info_td\">&nbsp;";
                tableData+=layer;
                tableData+="        </th>";
                tableData+="    </tr>";
                var tellerAtt=0;
                for (attribute in obj[layer][feature]){
                    if (tellerAtt%2==0){
                        tableData+="    <tr>"
                    }else{
                        tableData+="    <tr class=\"aanvullende_info_alternateTr\">"
                    }
                    tellerAtt++;
                    tableData+="        <td>"+attribute+"</td>"
                    tableData+="        <td>"+obj[layer][feature][attribute]+"</td>"
                    tableData+="    </tr>";
                }
                tableData+="    <tr><td> </td><td> </td></tr>";
            }
            tableData+="</table>";
        }
        if (document.getElementById("content_style")!=undefined && tableData.length>0){
            document.getElementById("content_style").style.display="none";
        }
        document.getElementById('getFeatureInfo').innerHTML=tableData;
    }

    function writeNoResults() {
        var tableData="";
        tableData+="<table class=\"kolomtabel\">";
        tableData+="<tr>";
        tableData+="<td valign=\"top\">";
        tableData+="<div id=\"inleiding\" class=\"inleiding\">";
        tableData+="<h2><fmt:message key="admindata.geeninfo.header"/></h2>";
        tableData+="<p><fmt:message key="admindata.geeninfo.tekst"/></p>";
        tableData+="</div>";
        tableData+="</td>";
        tableData+="</tr>";
        tableData+="</table>";
        if (document.getElementById("content_style")!=undefined){
            document.getElementById('content_style').innerHTML=tableData;
        }
    }
</script>

<script type="text/javascript">
    var plusicon = '<html:rewrite href="./images/icons/plus_icon.gif" />';
    var minusicon = '<html:rewrite href="./images/icons/minus_icon.gif" />';
    var infoicon = '<html:rewrite href="./images/icons/information.png" />';
    var urlicon = '<html:rewrite href="./images/icons/world_link.png" />';
    var flagicon = '<html:rewrite href="./images/icons/flag_blue.png" />';
    var wandicon = '<html:rewrite href="./images/icons/wand.png" />';
    var loadingicon = '<html:rewrite href="./images/icons/loading.gif" />';

    var csvexporticon = '<html:rewrite href="./images/icons/page_white_csv.png" />';
    var infoexporticon = '<html:rewrite href="./images/icons/page_white_info.png" />';

    var idcounter = 1;

    function handleGetGegevensBron(gegevensbron) {
        // aftellen verwerkte gegevensbron
        loop--;
        if(!gegevensbron) {
            if (loop==0) {
                 // geen enkele gegevensbron was gevuld!
                 window.setTimeout("writeNoResults();", timeout);
            }
            return;
        }
        //minstens 1 gegevensbron was gevuld, nooit writeNoResults schrijven
        loop = 0;

        var htmlId = gegevensbron.parentHtmlId;

        // Create container
        var bronContainer = $j('<div></div>').attr({
            "id": "bronContainer" + htmlId + gegevensbron.id,
            "class": "bronContainer"
        });
        
        // Create caption
        var bronCaption = $j('<div></div>').attr({
            "id": "bronCaption" + htmlId + gegevensbron.id,
            "class": "bronCaption"
        })
        .append('<img src="'+minusicon+'" alt="Dichtklappen" title="Dichtklappen" /> ' + gegevensbron.title)
        .click(function() {
            toggleBron("bronContent" + htmlId + gegevensbron.id)
        });
        
        //CSV export knop
        //TODO: post van maken en toggle uit zetten
        var csv_export_url = "services/Data2CSV?themaId=" + gegevensbron.id + "&objectIds=" + gegevensbron.csvPks;
        var icon = $j('<img src="'+csvexporticon+'"/>').attr({
            "alt": csv_export_url,
            "title": csv_export_url
        })
        .click(function() {
            popUp(csv_export_url, 'csv_export', 600, 500);
        });
        bronCaption.append(" ");
        bronCaption.append(icon);

        //Info export knop
        //TODO: post van maken en toggle uit zetten
        var info_export_url = "viewerdata.do?aanvullendeinfo=t&themaid=" + gegevensbron.id + "&primaryKeys=" + gegevensbron.csvPks+ "&addKaart=j"
        var icon = $j('<img src="'+infoexporticon+'" alt="Info Export" alt="Info Export"/>').attr({
            "alt": info_export_url,
            "title": info_export_url
        })
        .click(function() {
            popUp(info_export_url, 'info_export', 600, 500);
        });
        bronCaption.append(" ");
        bronCaption.append(icon);
        
        // Create content table
        var bronContent = $j('<div></div>').attr({
            "id": "bronContent" + htmlId + gegevensbron.id,
            "class": "bronContent bronContentOpen"
        });
        var bronTable = $j('<table></table>');
        var bronTableHead = $j('<thead></thead>');
        var bronTableBody = $j('<tbody></tbody>');

        // Create table heading
        var trHead = $j('<tr></tr>');
        var volgnr = $j('<th></th>').css({
            "width": "50px"
        })
        .html('Volgnr');
        trHead.append(volgnr);
        $j.each(gegevensbron.labels, function(index, label) {
            var kolomBreedte = (label.kolomBreedte == 0) ? 150 : label.kolomBreedte;
            var th = $j('<th></th>')
            .css({
                "width": kolomBreedte + "px"
            })
            .html(label.label);
            trHead.append(th);
        });
        bronTableHead.append(trHead);

        // Create table content
        if(!gegevensbron.records) {
            //gegevensbron.labels
            var tr = $j('<tr></tr>');
            var message = $j('<td></td>').attr({
                "colspan": "3"
            })
            .html("leeg");
            tr.append(message);
            bronTableBody.append(tr);
            // TODO als 1 record en opgegeven aantal kolommen, dan meteen popup openen
        } else {
            $j.each(gegevensbron.records, function(index, record) {
                var tr = $j('<tr></tr>');
                var volgnr = $j('<td></td>').css({
                    "width": "50px"
                });
 
                var icon = $j('<img src="'+wandicon+'" alt="Selecteer object in kaart" title="Selecteer object in kaart" />')
                .click(function() {
                    editFeature(gegevensbron.id,gegevensbron.adminPk,record.id);
                });
                volgnr.append(icon);
                volgnr.append(" ");
                volgnr.append(index+1);

                tr.append(volgnr);
                $j.each(record.values, function(index2, waarde) {
                    var kolomBreedte = (waarde.kolomBreedte == 0) ? 150 : waarde.kolomBreedte;
                    var td = $j('<td></td>')
                    .css({
                        "width": kolomBreedte + "px"
                    });
                    
                    if(waarde.type == 'TYPE_DATA') {
                        if (!waarde.value) {
                            td.html("-");
                        } else {
                            td.html(waarde.value);
                        }
                    }
                    if(waarde.type == 'TYPE_URL') {
                        if (!waarde.value) {
                            td.html("-");
                        } else {
                            var icon = $j('<img src="'+infoicon+'" alt="Aanvullende informatie" title="Aanvullende informatie" />')
                            .click(function() {
                                popUp(waarde.value, 'aanvullende_info_scherm', 500, 600);
                            });
                            td.html(icon);
                        }
                    }
                    if(waarde.type == 'TYPE_FUNCTION') {
                        if (!waarde.value) {
                            td.html("-");
                        } else if(waarde.value.search('###') != -1) {
                            var funcarray = waarde.value.split('###');
                            var icon = $j('<img src="'+flagicon+'" alt="'+funcarray[0]+'" title="'+funcarray[0]+'" />')
                            .click(function() {
                                eval(funcarray[1]);
                            });
                            td.html(icon);
                        } else {
                            var icon = $j('<img src="'+flagicon+'" alt="Voer functie uit" title="Voer functie uit" />')
                            .click(function() {
                                eval(waarde.value);
                            });
                            td.html(icon);
                        }
                    }
                    if (waarde.type == 'TYPE_QUERY') {
                        $j.each(waarde.valueList, function(index3, listWaarde) {
                            if (!listWaarde) {
                                td.append("-");
                            } else {
                                var linkspan = $j('<span></span>');
                                // TODO: icon kiezen afh van extentie listWaarde
                                var icon = $j('<img src="'+urlicon+'" alt="Externe informatie"/>')
                                .attr({
                                    "title": listWaarde
                                })
                                .click(function() {
                                    popUp(listWaarde, 'externe_link', 600, 500);
                                });
                                linkspan.html(icon);
                                td.append(linkspan);
                                td.append(" ");
                            }
                        });
                    }
                    tr.append(td);
                });
                bronTableBody.append(tr);
                // Check if there are childs
                if(record.childs != null && record.childs.length > 0) {
                    $j.each(record.childs, function(index2, child) {
                        var childDivId = 'bronChild' + gegevensbron.id + '_' + fixId(record.id) + '_' + fixId(child.id);
                        var tr = $j('<tr></tr>');
                        var toggleIcon = $j('<img src="'+plusicon+'" alt="Openklappen" title="Openklappen" />')
                        .click(function(){
                            var childLoaded = loadChild(childDivId, child.id, '${wkt}', child.cql);
                            if(!childLoaded) toggleBron(childDivId);
                        });
                        var collapse = $j('<td></td>').css({
                            "width": "50px"
                        });
                        tr.append(collapse);
                        var childTd = $j('<td></td>').attr({
                            "colspan": record.values.length
                        });
                        var childCaption = $j('<div></div>').attr({
                            "id": "childCaption" + childDivId,
                            "class": "childCaption"
                        });
                        childCaption
                        .append(toggleIcon)
                        .append(' ' + child.title);
                        if (child.aantalRecords>1) {
                            childCaption.append(' (' + child.aantalRecords + ')');
                        }
                        var childDiv = $j('<div></div>').attr({
                            "id": childDivId,
                            "class": "bronChild bronChildEmpty"
                        });
                        var loadingIcon = $j('<img src="'+loadingicon+'" alt="Loading" title="Loading" />')
                        var childLoading = $j('<div></div>').attr({
                            "id": "childLoading" + childDivId,
                            "class": "childLoading"
                        })
                        .append(loadingIcon)
                        .hide();
                        childTd
                        .append(childCaption)
                        .append(childLoading)
                        .append(childDiv);
                        tr.append(childTd);
                        bronTableBody.append(tr);

                        toggleIcon.click();
 
                    });
                }
            });
        }

        // wachtmelding weghalen
        if (document.getElementById("content_style")!=undefined){
            document.getElementById("content_style").style.display="none";
        }

        // Append all to DOM tree
        bronContent.append(bronTable.append(bronTableHead).append(bronTableBody));
        bronContainer
        .append(bronCaption)
        .append(bronContent);
        $j('#' + htmlId).append(bronContainer);

        // child loading weghalen indien aanwezig
        $j('#'+htmlId).siblings('.childLoading').hide();

        // alle childs pre-loaden
        $j.each(gegevensbron.records, function(index, record) {
            if(record.childs != null && record.childs.length > 0) {
                $j.each(record.childs, function(index2, child) {
                    var childDivId = 'bronChild' + gegevensbron.id + '_' + fixId(record.id) + '_' + fixId(child.id);
                    var childLoaded = loadChild(childDivId, child.id, '${wkt}', child.cql);
                    if(!childLoaded) toggleBron(childDivId);
                });
            }
        });

    }

    function loadChild(bronContentId, beanId, wkt, beanCql) {
        var $bronContentDiv = $j('#'+bronContentId);

        if($bronContentDiv.hasClass("bronChildEmpty"))
        {
            JCollectAdmindata.fillGegevensBronBean(beanId, 0, wkt, beanCql, bronContentId, handleGetGegevensBron);
            $bronContentDiv.removeClass("bronChildEmpty").addClass("bronContentOpen");
            $j("#childCaption"+bronContentId).hide();
            $j('#childLoading'+bronContentId).show();
            window.setTimeout(function() {
                $j('#childLoading'+bronContentId).hide();
            }, timeout);

            return true;
        }

        return false;
    }

    function toggleBron(bronContentId) {
        var $bronContentDiv = $j('#'+bronContentId);

        if($bronContentDiv) {
            // Toggle function
            var $parent = $bronContentDiv.parent().parent();
            if($bronContentDiv.hasClass("bronContentOpen")) {
                $bronContentDiv.removeClass("bronContentOpen").addClass("bronContentClosed");
                $bronContentDiv.hide();

                // If parent has bronChild -> is a child
                if($parent.hasClass("bronChild")) {
                    $parent.siblings('.childCaption').show();
                    $parent.removeClass("bronContentOpen").addClass("bronContentClosed");
                    $bronContentDiv.siblings('.bronCaption').hide();
                }
                if($bronContentDiv.hasClass("bronChild")) {
                    $bronContentDiv.siblings('.childCaption').show();
                    $bronContentDiv.find('.bronContainer').find('div').hide();
                    $bronContentDiv.find('.bronContainer').find('.bronContent').removeClass("bronContentOpen").addClass("bronContentClosed");
                }
            } else {
                $bronContentDiv.removeClass("bronContentClosed").addClass("bronContentOpen");
                $bronContentDiv.show();

                // If parent has bronChild -> is a child
                if($parent.hasClass("bronChild")) {
                    $parent.siblings('.childCaption').hide();
                    $parent.removeClass("bronContentClosed").addClass("bronContentOpen");
                    $bronContentDiv.siblings('.bronCaption').show();
                }
                if($bronContentDiv.hasClass("bronChild")) {
                    $bronContentDiv.siblings('.childCaption').hide();
                    $bronContentDiv.find('.bronContainer').find('div').show();
                    $bronContentDiv.find('.bronContainer').find('.bronContent').removeClass("bronContentClosed").addClass("bronContentOpen");
                }
            }
        }
    }

    function fixId(myid) {
        var newId = "";
        if (typeof myid === 'string') {
            newId = myid.replace(/(:|\.)/g,'_');
        }
        return newId;
    }

</script>