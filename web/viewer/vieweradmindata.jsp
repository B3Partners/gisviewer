<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@ page language="java" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/xml" prefix="x" %>
<%@ page isELIgnored="false"%>
<html>
    <head>
        <title>Viewer Data</title>
        <link href="styles/main.css" rel="stylesheet" type="text/css">
        <link href="styles/viewer.css" rel="stylesheet" type="text/css">
        <script type="text/javascript">
            function popUp(URL, naam) {
                eval("page" + naam + " = window.open(URL, '" + naam + "', 'toolbar=0,scrollbars=1,location=0,statusbar=1,menubar=0,resizable=1,width=800,height=400');");
            }
        </script>
    </head>
    <body>
        <c:choose>
            <c:when test="${not empty thema_items and not empty regels}">
                <div class="topRow">
                    <div style="width: 50px; float: left;">
                        Volgnr
                    </div>
                    <c:forEach var="ThemaItem" items="${thema_items}">
                        <c:choose>
                            <c:when test="${ThemaItem.kolombreedte != 0}">
                                <c:set var="breedte" value="${ThemaItem.kolombreedte}" />
                            </c:when>
                            <c:otherwise>
                                <c:set var="breedte" value="150" />
                            </c:otherwise>            
                        </c:choose>
                        <div style="width: ${breedte}; float: left;">
                            ${ThemaItem.label}
                        </div>
                    </c:forEach>
                </div>
                <c:forEach var="regel" items="${regels}" varStatus="counter">
                    <div class="row">
                        <div style="width: 50px; float: left;">
                            ${counter.count}
                        </div>
                        <c:forEach var="waarde" items="${regel}" varStatus="kolom">
                            <c:if test="${thema_items[kolom.count - 1] != null}">
                                <c:choose>
                                    <c:when test="${thema_items[kolom.count - 1].kolombreedte != 0}">
                                        <c:set var="breedte" value="${thema_items[kolom.count - 1].kolombreedte}" />
                                    </c:when>
                                    <c:otherwise>
                                        <c:set var="breedte" value="150" />
                                    </c:otherwise>            
                                </c:choose>
                                <c:choose>
                                    <c:when test="${thema_items[kolom.count - 1].dataType.id == 2}">
                                        <div style="width: ${breedte}; float: left;">
                                            <html:image src="./images/icons/information.png" onclick="popUp('${waarde}', 'aanvullende_info_scherm');" style="cursor: pointer; cursor: hand;" />
                                        </div>
                                    </c:when>
                                    <c:when test="${thema_items[kolom.count - 1].dataType.id == 3}">
                                        <div style="width: ${breedte}; float: left;">
                                            <html:image src="./images/icons/world_link.png" onclick="popUp('${waarde}', 'externe_link');" style="cursor: pointer; cursor: hand;" />
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <c:if test="${waarde eq '' or  waarde eq null}">
                                            <c:set var="waarde" value="&nbsp;" />
                                        </c:if>
                                        <div style="width: ${breedte}; float: left;">
                                            ${waarde}
                                        </div>
                                    </c:otherwise>            
                                </c:choose>
                            </c:if>
                        </c:forEach>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                Er is geen admin data gevonden!
            </c:otherwise>
        </c:choose>
    </body>
</html>