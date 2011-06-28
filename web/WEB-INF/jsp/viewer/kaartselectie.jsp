<%@include file="/WEB-INF/jsp/taglibs.jsp" %>
<%@include file="/WEB-INF/jsp/metatags.jsp" %>

<script type="text/javascript" src="<html:rewrite page='/scripts/kaartselectie.js'/>"></script>
<script type="text/javascript" src="<html:rewrite page="/scripts/simple_treeview.js"/>"></script>

<tiles:insert definition="specialMessages"/>

<p>Vaste kaartlagen</p>

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
    <div id="layermaindiv"></div>

    <html:submit property="save">Opslaan</html:submit>

    <hr>

    <p>Nieuwe WMS Service</p>

    Groep: <html:text property="groupName" size="20"></html:text><BR>
    Url: <html:text property="serviceUrl" size="40"></html:text><BR>
    Sld url: <html:text property="sldUrl" size="40"></html:text><BR>

    <html:submit property="saveWMSService">Service opslaan</html:submit>
</html:form>

<script type="text/javascript">
    function catchEmpty(defval){
        return defval
    }

    var themaTree = catchEmpty(${tree});
    if(typeof themaTree === 'undefined' || !themaTree) {
        themaTree = null;
    }

    treeview_create({
        "id": "layermaindiv",
        "root": themaTree,
        "rootChildrenAsRoots": true,
        "itemLabelCreatorFunction": createLeaf,
        "toggleImages": {
            "collapsed": "<html:rewrite page="/images/treeview/plus.gif"/>",
            "expanded": "<html:rewrite page="/images/treeview/minus.gif"/>",
            "leaf": "<html:rewrite page="/images/treeview/leaft.gif"/>"
        },
        "saveExpandedState": true,
        "streeaveScrollState": true,
        "expandAll": true
    });
</script>