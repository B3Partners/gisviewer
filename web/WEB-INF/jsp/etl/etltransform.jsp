<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@ page language="java" %>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html" prefix="html" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/xml" prefix="x" %>
<%@ taglib uri="http://struts.apache.org/tags-tiles" prefix="tiles" %>

<%@ page isELIgnored="false"%>

<!-- <html>
    <head>
        <title>Analyse Data</title>
        <link href="etltransform.css" type=text/css rel=stylesheet> -->
<script type="text/javascript" src="<html:rewrite page="/scripts/swfobject.js"/>"></script>
<script language="JavaScript" type="text/javascript">
            function getObjects() {                                
                for (var i = 1; i < 8; i++) {
                    if(document.getElementById('radio' + i).checked) { 
                        document.forms[0].type.value = document.getElementById('radio' + i).value;
                    }
                }
                document.forms[0].edit.value    = "submit";
                document.forms[0].submit();
            }
</script>
<!-- </head>
    <body> -->
<form id="myid" target="dataframe">
    <input type="hidden" name="type" />
    <input type="hidden" name="themaid" value="${themaid}"/>
    <input type="hidden" name="edit" />
</form>

<div class="onderbalk">VIEWER<span><tiles:insert name="loginblock"/></span></div>
<div id="bovenkant">
    <div id="map">
        <div id="flashcontent">
            <font color="red"><strong>For some reason the Flamingo mapviewer can not be shown. Please contact the website administrator.</strong></font>
        </div>
        <script type="text/javascript">
                var so = new SWFObject("flamingo/flamingo.swf?config=/config.xml", "flamingo", "653", "493", "8", "#FFFFFF");
        </script>
        <!--[if lte IE 6]>
            <script type="text/javascript">
            var so = new SWFObject("flamingo/flamingo.swf?config=/config.xml", "flamingo", "652", "493", "8", "#FFFFFF");
            </script>
        <![endif]-->
        <script type="text/javascript">
                so.write("flashcontent");
        </script>
    </div>
    
    <div id="rightdiv">
        <div id="tabreplacement"></div>
        <div id="tab_container">
            <div id="infovak_etl" class="tabvak">
                <strong>Bepaal hieronder van welke status van het thema u de data wilt bekijken</strong>
                <div class="optie">
                    <input type="radio" value="1" name="radiogroup" id="radio1"/> Nieuwe objecten<br />
                    <input type="radio" value="2" name="radiogroup" id="radio2"/> Onvolledige administratie objecten<br />
                    <input type="radio" value="3" name="radiogroup" id="radio3"/> Onvolledige geografie objecten<br />
                    <input type="radio" value="4" name="radiogroup" id="radio4"/> Geupdate objecten<br />
                    <input type="radio" value="5" name="radiogroup" id="radio5"/> Verwijderde objecten<br />
                    <input type="radio" value="6" name="radiogroup" id="radio6"/> Niet verwerkbare objecten<br/>
                    <input type="radio" value="7" name="radiogroup" id="radio7"/> Ongewijzigde objecten<br />
                    <p>
                    </p>                        
                    <button onclick="getObjects();" style="margin-left:10px;">
                        Toon objecten
                    </button>&nbsp;
                </div>
            </div>
        </div>
    </div>
</div>
<div class="onderbalk">DETAILS<span id="actief_thema">Actieve thema: </span></div>
<div id="dataframediv">
    <iframe id="dataframe" name="dataframe" frameborder="0"></iframe>
</div>

<!-- </body>
</html> -->