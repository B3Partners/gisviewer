<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>

<%@include file="/WEB-INF/jsp/taglibs.jsp" %>
<%@ page isELIgnored="false"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html:html>
    <head>
        <title>Viewer Tab</title>
        <link href="styles/main.css" rel="stylesheet" type="text/css">
        <link href="styles/viewer.css" rel="stylesheet" type="text/css">
        <link href="styles/viewer_b3p.css" rel="stylesheet" type="text/css" >
        <script type="text/javascript">  
            function checkLocation() {
                if (top.location == self.location)
                    top.location = '<html:rewrite page="/index.do"/>';
            };
        </script>
    </head>
    <body onload="checkLocation()" class="tabvak_body">
        <tiles:insert attribute="content" />
    </body>
</html:html>