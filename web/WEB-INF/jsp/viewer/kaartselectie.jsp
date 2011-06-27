<%@include file="/WEB-INF/jsp/taglibs.jsp" %>
<%@ page isELIgnored="false"%>

<c:set var="form" value="${kaartselectieForm}"/>

<script type="text/javascript" src='dwr/interface/JMapData.js'></script>
<script type="text/javascript" src='dwr/interface/JCollectAdmindata.js'></script>
<script type="text/javascript" src='dwr/engine.js'></script>

<script type="text/javascript" src="<html:rewrite page='/scripts/kaartselectie.js'/>"></script>
<script type="text/javascript" src="<html:rewrite page="/scripts/simple_treeview.js"/>"></script>

<tiles:insert definition="specialMessages"/>

<h2>Kaartselectie</h2>

<p>Vaste kaartlagen</p>

<html:form styleId="kaartselectieForm" action="/kaartselectie">
    <input type="hidden" name="save" value="t" />

    <div id="layermaindiv"></div>

    <html:submit property="save">Opslaan</html:submit>
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
        "expandAll": false
    }); 
</script>