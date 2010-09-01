<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@page isELIgnored="false"%>
<%@include file="/WEB-INF/jsp/taglibs.jsp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html:html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta http-equiv="Expires" content="-1">
        <meta http-equiv="Cache-Control" content="max-age=0, no-store">

        <title>B3P GIS Viewer</title>
        <link href="styles/gisviewer_base.css" rel="stylesheet" type="text/css">
        <link href="styles/gisviewer_b3p.css" rel="stylesheet" type="text/css">
        <script type="text/javascript">
            function getParent(){
                if (window.opener){
                    return window.opener;
                }else if (window.parent){
                    return window.parent;
                }else{
                    alert("No parent found");
                    return null;
                }
            }
        </script>
    </head>
    <body>
        
    <h2>Meerdere kaartlagen actief</h2>

    <p>Kies de kaartlaag met het object die u wilt selecteren.</p>

    <script type="text/javascript">
        for (var i=0; i < getParent().enabledLayerItems.length; i++) {
            var item = getParent().enabledLayerItems[i];

            var link = "<a class='highlightlink' href='javascript:getParent().handlePopupValue("+item.id+");'>" + item.title +"</A>";
            document.write("<p>"+link +"</p>");
        }
    </script>
       
    </body>
</html:html>