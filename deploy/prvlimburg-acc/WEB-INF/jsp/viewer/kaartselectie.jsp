<%@include file="/WEB-INF/jsp/taglibs.jsp" %>

<script type="text/javascript" src="<html:rewrite page='/scripts/kaartselectie.js'/>"></script>
<script type="text/javascript" src="<html:rewrite page="/scripts/simple_treeview.js"/>"></script>
<div class="kaartselectieBody">

<h1>Kaartselectie</h1>

<script type="text/javascript">
    function checkForm() {
        var id = document.forms["kaartselectieForm"]["selectedUserWMSId"].value;
        
        if (id && id != "") {
            return true;
        } else {
            return false;
        }
    }
</script>
    
<!-- Indien niet goed opgeslagen dan wel messages tonen -->
<c:if test="${empty appCodeSaved}">
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
</c:if>


<c:if test="${!empty appCodeSaved}">
    <div id="appUrl">
    <c:set var="appUrl" value="/viewer.do?appCode=${appCodeSaved}"/>

    Uw persoonlijke instellingen zijn opgeslagen. U kunt de nieuwe viewer bekijken
    via de volgende <html:link page="${appUrl}" target="_top">persoonlijke url</html:link>.
    </div>
</c:if>

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
        <h4>Laag tonen</h4>
        <h4 class="col2">Laag aan bij opstarten</h4>
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
            "saveExpandedState": false,
            "saveScrollState": false,
            "expandAll": false,
            "childrenPadding": '20px',
            "zebraEffect": true
        });
    </script>

    <c:if test="${!empty servicesTrees}">
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
            <h4>Laag tonen</h4>
            <h4 class="col2">Laag aan bij opstarten</h4>
            <h4 class="col3">Style</h4>
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
                "saveExpandedState": false,
                "saveScrollState": false,
                "expandAll": false,
                "childrenPadding": '20px',
                "zebraEffect": true
            });
            </script>
        </c:forEach>

        <p>
            <html:submit property="deleteWMSServices" styleClass="submitbutton deletebutton">Services wissen</html:submit>
        </p>
    </c:if>

    <p>
        <html:hidden property="currentAppReadOnly" />
        <html:hidden property="useUserWmsDropdown" />

        <div id="alleenLezenHelp" class="alleenLezen">
            <strong>Niet meer wijzigen</strong><BR/>
            Als u aangeeft deze kaart niet meer te kunnen wijzigen kunnen andere uw
            kaart wel bekijken maar geen wijzigingen opslaan in de boom instellingen. 
            Als iemand uw kaart toch aanpast dan ontvangen zij hiervoor een eigen url.
        </div>
    </p>
    
    <div id="submitPopup" class="kaartlaagselectieSubmitPopup">
        
        <c:if test="${currentAppReadOnly == '0'}">
        <p>
            <input type="radio" name="newkaartoption" value="new" onclick="$j('#name_email').show();" /> opslaan als nieuwe kaart<br />
            <input type="radio" name="newkaartoption" value="existing" onclick="$j('#name_email').hide();" checked /> bestaande kaart ${kaartNaam} wijzigen
        </p>
        </c:if>
        
        <div id="name_email" style="display: none;">
            <table>
                <tr>
                    <td>Kaartnaam</td>
                    <td><html:text property="kaartNaam" size="30" /></td>
                </tr>
                <tr>
                    <td>E-mail</td>
                    <td>
                        <!-- TODO: Deze email suffix ergens uit een config halen -->
                        <c:if test="${empty gebruikerEmail}">
                            <html:text property="gebruikerEmail" size="30" value="@prvlimburg.nl" />
                        </c:if>
                        
                        <c:if test="${not empty gebruikerEmail}">
                            <html:text property="gebruikerEmail" size="30" />
                        </c:if>                        
                    </td>
                </tr>                    
            </table>
        </div>
                
        <c:if test="${currentAppReadOnly == '1'}">
            <script type="text/javascript">
                $j('#name_email').show();
            </script>            
        </c:if>
            
        <p>
            Ik wil dat deze kaart niet meer kan worden gewijzigd: <html:checkbox property="makeAppReadOnly" />
            &nbsp;<img src="<html:rewrite page="/images/icons/help.png"/>" class="helpbuttonAlleenLezen" alt="help" />
        </p>
        
        <p>
            <input type="button" class="submitbutton deletebutton" id="closeSelection" value="Sluiten" />
            <html:submit property="save" styleClass="leftButton submitbutton">Kaart opslaan</html:submit>
        </p>
    </div>
        
    <input type="button" class="rightButton submitbutton" id="saveSelection" value="Selectie opslaan" />
           
    <div style="clear: both;"></div>
        
    <div class="kaartselectieKoppen">
        <h3>Nieuwe WMS Service toevoegen</h3>
    </div>
    
    <c:if test="${useUserWmsDropdown == '1'}">
        <p>
            U kunt ook nog extra kaartlagen toevoegen door een WMS te selecteren
            uit deze lijst.
        </p>
        <html:select property="selectedUserWMSId">
            <html:option value="">-Kies een service-</html:option>
            <c:forEach items="${userWmsList}" var="item">
                <html:option value="${item.id}">${item.name}</html:option>
            </c:forEach>
        </html:select>
            
        <html:submit property="saveWMSService" styleClass="leftButton submitbutton" onclick="return checkForm();">Service toevoegen</html:submit>      
    </c:if>
        
    <c:if test="${useUserWmsDropdown == '0'}">
        <div id="kaartselectieAddService">
        <label for="groupName">Groep</label>
        <html:text property="groupName" size="20" />
        <label for="serviceUrl">Url</label>
        <html:text property="serviceUrl" size="40" />
        
        <label for="sldUrl">Sld url</label>
        <html:text property="sldUrl" size="40" />

        <html:submit property="saveWMSService" styleClass="rightButton submitbutton">Service toevoegen</html:submit>
    </div>
    </c:if>
    
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

        $j('.helpbuttonAlleenLezen').hover(function() {
            $j(this).parent().parent().parent().parent().find('.alleenLezen').show();
        }, function() {
            $j(this).parent().parent().parent().parent().find('.alleenLezen').hide();
        });
        $j('.alleenLezen').hover(function() {
            $j(this).show();
        }, function() {
            $j(this).hide();
        });
        
        $j('#saveSelection').click(function() {
            $j('#submitPopup').show();
            /* if (ieVersion <= 8 && ieVersion != -1) {
                $j('#submitPopup').parent().css("z-index", "5000");
            } */
            $j('#saveSelection').hide();            
        });
        
        $j('#closeSelection').click(function() {
            $j('#submitPopup').hide();
            $j('#saveSelection').show();            
        });

        treeZebra();
    });
</script>