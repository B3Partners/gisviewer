<%-- 
    Document   : a11y.jsp
    Created on : 23-okt-2012, 16:55:02
    Author     : Boy de Wit
--%>

<%@include file="/WEB-INF/jsp/taglibs.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="windows-1252"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html lang="NL">
    <head>
        <link href="styles/gisviewer_base.css" rel="stylesheet" type="text/css">
        <link href="styles/gisviewer_a11y.css" rel="stylesheet" type="text/css">

        <meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
        <title>Accessibility Viewer</title>
    </head>
    <body>
        <div id="wrapper">
            <div id="header"><div id="header_content"></div></div>
            <div id="content_normal">
                <div id="content">
                    <div class="contentstyle">
                        <h1>Accessibility Viewer</h1>
                        <p>Beschikbare zoekers</p>
                        <ul class="searchEntries">
                            <c:forEach var="zc" items="${zoekConfigs}">
                                <li>
                                    <p>
                                        <c:out value="${zc.omschrijving}" />
                                    </p>
                                    <p>
                                        <html:link page="/a11yViewer.do?search=t&amp;appCode=${appCode}&amp;searchConfigId=${zc.id}" styleClass="searchLink" module="">
                                            <c:out value="${zc.naam}" />
                                        </html:link>
                                    </p>
                                </li>
                            </c:forEach>
                        </ul>
                        <hr>
                        <div>
                            <html:link page="/viewer.do?appCode=${appCode}" styleClass="searchLink" module="">
                                Ga naar de kaartviewer
                            </html:link>
                            <div style="float: right;">
                                <address>Zonnebaan 12C</address>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>
