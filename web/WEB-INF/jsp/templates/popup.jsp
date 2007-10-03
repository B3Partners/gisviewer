<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>

<%@include file="/WEB-INF/jsp/taglibs.jsp" %>
<%@ page isELIgnored="false"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html:html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <META HTTP-EQUIV="Expires" CONTENT="-1">
        <META HTTP-EQUIV="Cache-Control" CONTENT="max-age=0, no-store">

        <title>Viewer Popup</title>
        <link href="styles/main.css" rel="stylesheet" type="text/css">
        <link href="styles/viewer.css" rel="stylesheet" type="text/css">
        <link href="styles/viewer_b3p.css" rel="stylesheet" type="text/css" >
        <script type="text/javascript">  
            function checkLocation() {
                if (top.location != self.location)
                    top.location = self.location;
            };
        </script>
    </head>
    <body onload="checkLocation()" class="admindatabody">
        <tiles:insert attribute="content" />
    </body>
</html:html>