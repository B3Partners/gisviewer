<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@ page language="java" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/xml" prefix="x" %>
<%@ page isELIgnored="false"%>

<script type="text/javascript" src="<html:rewrite page="/scripts/simple_treeview.js"/>"/>
<script type="text/javascript"></script>

<div id="treevak">
    <div id="layermaindiv"></div>
</div>

<script type="text/javascript">
    function createLabel(container, item) {
        var div = document.createElement("div");
        var vink= document.createElement("input");
        div.className = item.type == "root" ? "root" : "child";
        container.appendChild(div);
        
        if (!item.children) {
            var lnk = document.createElement('a');
            lnk.innerHTML = item.title ? item.title : item.id;
            lnk.href = '<html:rewrite page="/etltransform.do?showOptions=submit&themaid=' + item.id + '"/>';
            container.appendChild(lnk);
        } else {
            container.appendChild(document.createTextNode(item.title ? item.title : item.id));
        }
    }
    
    treeview_create( {
        "id": "layermaindiv",
        "root": ${tree},
        "rootChildrenAsRoots": true,
        "itemLabelCreatorFunction": createLabel,
        "toggleImages": {
            "collapsed": "<html:rewrite page="/images/treeview/plus.gif"/>",
            "expanded": "<html:rewrite page="/images/treeview/minus.gif"/>",
            "leaf": "<html:rewrite page="/images/treeview/leaft.gif"/>"
        },
        "saveExpandedState": true,
        "saveScrollState": true,
        "expandAll": true
    });
</script>