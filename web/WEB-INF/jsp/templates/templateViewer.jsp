<%--
B3P Gisviewer is an extension to Flamingo MapComponents making
it a complete webbased GIS viewer and configuration tool that
works in cooperation with B3P Kaartenbalie.

Copyright 2006, 2007, 2008 B3Partners BV

This file is part of B3P Gisviewer.

B3P Gisviewer is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

B3P Gisviewer is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with B3P Gisviewer.  If not, see <http://www.gnu.org/licenses/>.
--%>
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
        <meta http-equiv=”X-UA-Compatible” content=”IE=edge” />

        <title><tiles:insert name='title'/> - B3P GIS Viewer</title>
        <link href="styles/gisviewer_base.css" rel="stylesheet" type="text/css">
        <link href="styles/gisviewer_viewer.css" rel="stylesheet" type="text/css">
        <link href="styles/niftyCorners.css" rel="stylesheet" type="text/css">
        <link href="styles/gisviewer_b3p.css" rel="stylesheet" type="text/css">
        <link rel="stylesheet" type="text/css" href="styles/ui-lightness/jquery-ui-1.7.2.custom.css"/>
        <script type="text/javascript" src="scripts/jquery-1.3.2.min.js"></script>
        <script type="text/javascript" src="scripts/jquery-ui-1.7.2.custom.min.js"></script>
        <script type="text/javascript" src="scripts/commonfunctions.js"></script>

        <!--[if lte IE 6]>
            <link href="styles/gisviewer_ie6.css" rel="stylesheet" type="text/css" />
        <![endif]-->
        <!--[if lte IE 7]>
            <link href="styles/gisviewer_ie7.css" rel="stylesheet" type="text/css" />
            <script type="text/javascript" src="scripts/cssfixes_ie.js"></script>
        <![endif]-->
        <script type="text/javascript">
            attachOnload(checkLocation);
        </script>
        <!--[if IE]>
        <script type="text/javascript">
            var iframes = ['objectframeViewer','analyseframeViewer','beschrijvingVakViewer'];
            fixTransparentBackgroundIframe = function() {
                for(i in iframes) {
                    var iframe = document.getElementById(iframes[i]);
                    if(iframe) {
                        iframe.allowTransparency = 'allowtransparency';
                    }
                }
            }
            attachOnload(fixTransparentBackgroundIframe);
        </script>
        <![endif]-->
    </head>
    <body>
        <div id="header"><div id="header_content"><tiles:insert attribute="menu" /></div></div>
        <div id="content_viewer"><tiles:insert attribute="content" /></div>
        <tiles:insert definition="googleAnalytics"/>
    </body>
</html:html>