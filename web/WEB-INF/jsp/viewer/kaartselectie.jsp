<%@include file="/WEB-INF/jsp/taglibs.jsp" %>

<script type="text/javascript" src="<html:rewrite page='/scripts/kaartselectie.js'/>"></script>
<script type="text/javascript" src="<html:rewrite page="/scripts/simple_treeview.js"/>"></script>
<div class="kaartselectieBody">

    <h1>Kaartselectie</h1>
    
<div class="messages">
    <html:messages id="message" message="true" >
        <div id="error">
            <c:out value="${message}" escapeXml="false"/>
        </div>
    </html:messages>
    <html:messages id="message" name="acknowledgeMessages">
        <div id="acknowledge">
            <c:out value="${message}"/>
        </div>
    </html:messages>
</div>

<html:form styleId="kaartselectieForm" action="/kaartselectie">
    <div class="kaartselectieKoppen">
        <h3>
            Vaste kaartlagen
            <img src="<html:rewrite page="/images/icons/help.png"/>" class="helpbutton" />
        </h3>
        <div id="vasteKaartlagenHelp" class="help">
            <strong>Vaste kaartlagen</strong><br />
            Maak een selectie van de kaartlagen die u beschikbaar wilt hebben binnen de viewer.
            Deze kaartlagen zijn van te voren klaargezet door de beheerder. Ook kunt u aangeven
            welke kaartlagen al aan moeten staan bij het opstarten van de viewer.
        </div>
        <h4>Laag aanzetten</h4>
        <h4 class="col2">Laag aanzetten bij opstarten</h4>
    </div>
    <div style="clear: both;"></div>
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
            "saveScrollState": true,
            "expandAll": true,
            "childrenPadding": '20px',
            "zebraEffect": true
        });
    </script>
   
    <div class="kaartselectieKoppen">
        <h3>
            Eigen kaartlagen
            <img src="<html:rewrite page="/images/icons/help.png"/>" class="helpbutton" />
        </h3>
        <div id="eigenKaartlagenHelp" class="help">
            <strong>Zelf toegevoegde kaartlagen</strong><br />
            U kunt ook zelf kaartlagen toevoegen aan de viewer door een wms service toe te
            voegen en daarna de kaartlagen die u beschikbaar wilt hebben aan te vinken.
            De nieuwe lagen worden in de kaartboom onder de ingevulde groepnaam getoond.
        </div>
        <h4>Laag aanzetten</h4>
        <h4 class="col2">Laag aanzetten bij opstarten</h4>
        <h4 class="col3">Style / SLD</h4>
    </div>
    <div style="clear: both;"></div>

    <c:forEach var="serviceTree" items="${servicesTrees}" varStatus="status">
        <div id="layerTreeDiv${status.count}" class="kaartselectie"></div>

        <script type="text/javascript">            
        treeview_create({
            "id": 'layerTreeDiv${status.count}',
            "root": ${serviceTree},
            "rootChildrenAsRoots": false,
            "itemLabelCreatorFunction": createServiceLeaf,
            "toggleImages": {
                "collapsed": "<html:rewrite page="/images/treeview/plus.gif"/>",
                "expanded": "<html:rewrite page="/images/treeview/minus.gif"/>",
                "leaf": "<html:rewrite page="/images/treeview/leaft.gif"/>"
            },
            "saveExpandedState": true,
            "saveScrollState": true,
            "expandAll": true,
            "childrenPadding": '20px',
            "zebraEffect": true
        });
        </script>
    </c:forEach>

    <p>
        <html:submit property="deleteWMSServices" styleClass="submitbutton deletebutton">Services wissen</html:submit>
        <html:submit property="save" styleClass="rightButton submitbutton">Alles opslaan</html:submit>
    </p>

    <a href="#" id="kaartselectieAddServiceLink">Nieuwe WMS Service toevoegen</a>
    <div style="clear: both;"></div>
    <div id="kaartselectieAddService">
        <h4>Nieuwe WMS Service toevoegen</h4>
        <label for="groupName">Groep</label>
        <html:text property="groupName" size="20" /></td>
        <label for="serviceUrl">Url</label>
        <html:text property="serviceUrl" size="40" /></td>
        <label for="sldUrl">Sld url</label>
        <html:text property="sldUrl" size="40" /></td>
        <html:submit property="saveWMSService" styleClass="rightButton submitbutton">Service toevoegen</html:submit>
    </div>
    
</html:form>
    </div>
    
<script type="text/javascript">
    function treeZebra() {
        var treecounter = 0;
        var zebracounter = 0;
        $j(".kaartselectie").each(function() {
            if(treecounter <= 1) zebracounter = 0;
            $j(".treeview_row", this).each(function() {
                // check if visible
                if($j(this).parent().parent().parent().parent().is(":visible")) {
                    $j(this).removeClass("treeview_odd_row");
                    if(zebracounter%2==0) {
                        $j(this).addClass("treeview_odd_row");
                    }
                    zebracounter++;
                }
            });
            treecounter++;
        });
    }
    
    $j(function() {
        $j("#kaartselectieAddServiceLink").click(function() {
            $j("#kaartselectieAddService").show();
            $j(this).hide();
            return false;
        });
        $j('.kaartselectieBody').click(function() {
            closeSldContainers();
        });
        $j('.helpbutton').hover(function() {
            $j(this).parent().parent().find('.help').show();
        }, function() {
            $j(this).parent().parent().find('.help').hide();
        });
        $j('.help').hover(function() {
            $j(this).show();
        }, function() {
            $j(this).hide();
        });
        treeZebra();
    });
</script>