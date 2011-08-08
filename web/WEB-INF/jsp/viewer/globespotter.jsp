<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@page isELIgnored="false"%>
<%@include file="/WEB-INF/jsp/taglibs.jsp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html:html>
    <head>
        <%@include file="/WEB-INF/jsp/metatags.jsp" %>

        <title>B3P GIS Viewer</title>        

        <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
        <script type="text/javascript" src="<html:rewrite page='/scripts/swfObjectGlobeSpotter.js'/>"></script>

        <style type="text/css">
            body {
                color: #000000;
                font-family: Arial, sans-serif;
                font-size: 8pt;
            }
            h2 {
                color: #196299;
            }
            a {
                color: #1962A0;
                text-decoration: underline;
                font-weight: bold;
            }
            a:hover {
                text-decoration: none;
            }
        </style>
    </head>
    <body>
        <h2>Globespotter SDK</h2>

        <!-- Multi window example
        <script type="text/javascript">
            var flashvars = {};
            flashvars.imageid = "5B0DGOPG";
            flashvars.APIKey = "K3MRqDUdej4JGvohGfM5e78xaTUxmbYBqL0tSHsNWnwdWPoxizYBmjIBGHAhS3U1";
            flashvars.MapSRSName = "EPSG:28992";

            var params = {};
            params.allowfullscreen = "true";
            params.allowscriptaccess = "always";

            var attributes = {};
            attributes.id = "globespotterswf";
            attributes.name = "viewer_mapi";
            
            swfobject.embedSWF("https://www.globespotter.nl/v2/api/mapi/viewer_mapi.swf", "globespotter", "640", "360", "10.0.22", false, flashvars, params, attributes);
        </script>
        -->

        <!-- Simple html example -->
        <object>
            <embed src="https://www.globespotter.nl/v2/api/bapi/viewer_bapi.swf"
                    width="400" height="400"
                    type="application/x-shockwave-flash"
                    allowScriptAccess="always"
                    flashvars="&hfov=110&APIKey=K3MRqDUdej4JGvohGfM5e78xaTUxmbYBqL0tSHsNWnwdWPoxizYBmjIBGHAhS3U1&MapSRSName=EPSG:28992&imageid=5B0DGOPG">
            </embed>
        </object>
    </body>
</html:html>