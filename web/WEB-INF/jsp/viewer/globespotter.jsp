<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@page isELIgnored="false"%>

<%@include file="/WEB-INF/jsp/taglibs.jsp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html:html>
    <head>
        <%@include file="/WEB-INF/jsp/metatags.jsp" %>

        <title>B3P GIS Viewer</title>

        <script type="text/javascript" src="<html:rewrite page='/scripts/AC_OETags.js'/>"></script>
    </head>

    <body>
        <script language="JavaScript" type="text/javascript">
            /* Only runs when on a webserver */
            AC_FL_RunContent(
                "src",
                "https://www.globespotter.nl/v2/api/bapi/viewer_bapi.swf",
                "width", "320",
                "height", "240",
                "align", "left",
                "id", "viewer_bapi",
                "quality", "high",
                "bgcolor", "#ffffff",
                "name", "viewer_bapi",
                "allowScriptAccess","always",
                "type", "application/x-shockwave-flash",
                "pluginspage", "http://www.adobe.com/go/getflashplayer",
                "allowFullScreen", "true",
                "FlashVars",
                "APIKey=K3MRqDUdej4JGvohGfM5e78xaTUxmbYBqL0tSHsNWnwdWPoxizYBmjIBGHAhS3U1&MapSRSName=EPSG:28992&imageid=5B0DGOPG"
            );

            /* Callback als component klaar is */
            function hst_componentReady()
            {
                try
                {
                    (viewer_bapi).setUserNamePassword("B3_Develop","***REMOVED***");
                } catch (error) {
                    alert(error);
                }
            }
        </script>

    </body>
</html:html>