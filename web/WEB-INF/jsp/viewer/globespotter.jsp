<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@page isELIgnored="false"%>

<%@include file="/WEB-INF/jsp/taglibs.jsp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html:html>
    <head>
        <%@include file="/WEB-INF/jsp/metatags.jsp" %>
        <!--
        <script type="text/javascript" src="<html:rewrite page="/scripts/AC_OETags.js"/>"></script>
        -->

        <title>B3P GIS Viewer</title>
    </head>

    <body>
        <div style="margin-top: 5px; margin-left: 10px; margin-bottom: 5px; width: 800px; border: 1px solid #000; background-color: #eee;">
            <div style="padding: 5px; font-size: 1.2em;">
                <img src="<html:rewrite page="/images/icons/information.png"/>" />
                
                U kunt rondkijken door de linkermuisknop ingedrukt te houden boven de foto 
                en de muis te bewegen. Met het scroll wheel op de muis kunt u in- en uitzoomen.
            </div>
        </div>

        <script type="text/javascript">
            function hst_componentReady() {            
                //var viewer = document.getElementById('Globespotter');
                //(viewer_bapi).setApplicationParameter("abcd", 5);
            }
        
            function hst_apiReady(apiState) {            
                if(apiState == true) {
                    //var viewer = document.getElementById('Globespotter');
                    //alert((viewer_bapi).getMajorVersion());
                }
            }
        </script>
    
        <div style="margin-left: 10px;">            
            <object id="Globespotter" name="TID">
                <param name="allowScriptAccess" value="always" />
                <param name="allowFullScreen" value="true" />

                <!-- Test API: https://www.globespotter.nl/api/test/viewer_bapi.swf -->
                <!-- 2.1 API: https://www.globespotter.nl/v2/api/bapi/viewer_bapi.swf -->
                <!-- 2.6 API: https://globespotter.cyclomedia.com/v26/api/viewer_api.swf -->

                <embed src="https://www.globespotter.nl/v2/api/bapi/viewer_bapi.swf"
                       quality="high" bgcolor="#888888"
                       width="800" height="400"
                       type="application/x-shockwave-flash"
                       allowScriptAccess="always"
                       allowfullscreen="true"
                       FlashVars="&APIKey=${apiKey}&imageid=${imageId}&MapSRSName=EPSG:28992&TID=${tid}">
                </embed>
            </object>
        </div>

</body>
</html:html>