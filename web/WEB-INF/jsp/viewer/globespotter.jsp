<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@page isELIgnored="false"%>

<%@include file="/WEB-INF/jsp/taglibs.jsp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html:html>
    <head>
        <%@include file="/WEB-INF/jsp/metatags.jsp" %>
        <title>B3P GIS Viewer</title>
    </head>

    <body>
        <script language="JavaScript" type="text/javascript">       
        </script>
        
        <object id="GlobeSpotter" name="TID">
            <embed src="https://www.globespotter.nl/api/test/viewer_bapi.swf"
                   width="600" height="400"
                   type="application/x-shockwave-flash"
                   allowScriptAccess="always"
                   FlashVars="&imageid=${imageId}&APIKey=
                   &MapSRSName=EPSG:28992&TID=${tid}">
            </embed>
        </object>
</body>
</html:html>