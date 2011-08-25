<%@include file="/WEB-INF/jsp/taglibs.jsp" %>
<%@include file="/WEB-INF/jsp/metatags.jsp" %>

<script type="text/javascript" src="<html:rewrite page='/scripts/kaartselectie.js'/>"></script>
<script type="text/javascript" src="<html:rewrite page="/scripts/simple_treeview.js"/>"></script>

<p><b>Vaste kaartlagen</b></p>

<p>
Maak een selectie van de kaartlagen die u beschikbaar wilt hebben binnen de viewer.
Deze kaartlagen zijn van te voren klaargezet door de beheerder. Ook kunt u aangeven
welke kaartlagen al aan moeten staan bij het opstarten van de viewer.
</p>

<div class="messages">
    <html:messages id="message" message="true" >
        <div id="error_tab">
            <c:out value="${message}" escapeXml="false"/>
        </div>
    </html:messages>
    <html:messages id="message" name="acknowledgeMessages">
        <div id="acknowledge_tab">
            <c:out value="${message}"/>
        </div>
    </html:messages>
</div>

<html:form styleId="kaartselectieForm" action="/kaartselectie">
    <div>
        <div class="kaartselectie" id="mainTreeDiv"></div>
    </div>

    <script type="text/javascript">
        treeview_create({
            "id": "mainTreeDiv",
            "root": ${tree},
            "rootChildrenAsRoots": true,
            "itemLabelCreatorFunction": createLeaf,
            "toggleImages": {
                "collapsed": "<html:rewrite page="/images/treeview/plus.gif"/>",
                "expanded": "<html:rewrite page="/images/treeview/minus.gif"/>",
                "leaf": "<html:rewrite page="/images/treeview/leaft.gif"/>"
            },
            "saveExpandedState": true,
            "streeaveScrollState": true,
            "expandAll": true,
            "childrenPadding": '15px'
        });
    </script>

    <p><b>Zelf toegevoegde kaartlagen</b></p>

    <p>
    U kunt ook zelf kaartlagen toevoegen aan de viewer door een wms service toe te
    voegen en daarna de kaartlagen die u beschikbaar wilt hebben aan te vinken.
    De nieuwe lagen worden in de kaartboom onder de ingevulde groepnaam getoond.
    </p>

    <c:forEach var="serviceTree" items="${servicesTrees}" varStatus="status">
        <div id="layerTreeDiv_${status.count}" class="kaartselectie"></div>

        <script type="text/javascript">            
        treeview_create({
            "id": 'layerTreeDiv_${status.count}',
            "root": ${serviceTree},
            "rootChildrenAsRoots": false,
            "itemLabelCreatorFunction": createServiceLeaf,
            "toggleImages": {
                "collapsed": "<html:rewrite page="/images/treeview/plus.gif"/>",
                "expanded": "<html:rewrite page="/images/treeview/minus.gif"/>",
                "leaf": "<html:rewrite page="/images/treeview/leaft.gif"/>"
            },
            "saveExpandedState": true,
            "streeaveScrollState": true,
            "expandAll": true,
            "childrenPadding": '15px'
        });
        </script>
    </c:forEach>

    <p>
        <html:submit property="save">Alles opslaan</html:submit>
        <html:submit property="deleteWMSServices">Services wissen</html:submit>
    </p>

    <p><b>Nieuwe WMS Service toevoegen</b></p>

    <table>
        <tr>
            <td>Groep</td>
            <td><html:text property="groupName" size="20" /></td>
        </tr>
        <tr>
            <td>Url</td>
            <td><html:text property="serviceUrl" size="40" /></td>
        </tr>
        <tr>
            <td>Sld url</td>
            <td><html:text property="sldUrl" size="40" /></td>
        </tr>
    </table>

    <p>
        <html:submit property="saveWMSService">Service toevoegen</html:submit>
    </p>
    
</html:form>
    
<script type="text/javascript">
    function treeZebra() {
        $j(".kaartselectie").each(function() {
            var counter = 0;
            $j(".treeview_row", this).each(function() {
                // check if visible
                if($j(this).parent().parent().parent().parent().is(":visible")) {
                    $j(this).removeClass("treeview_odd_row");
                    if(counter%2==0) {
                        $j(this).addClass("treeview_odd_row");
                    }
                    counter++;
                }
            });
        });
    }
    treeZebra();
    
    function debugLog(msg) {
        if (console !== undefined && (console.debug !== undefined || console.log !== undefined)) { 
            console.log(msg);
        }
    }
</script>