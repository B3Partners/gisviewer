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
        <title>Analyse Data</title>
        <LINK href="support.css" type=text/css rel=stylesheet>
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
    </head>
    <body>
        <form id="myid" target="dataframe">
            <input type="hidden" name="type" />
            <input type="hidden" name="themaid" value="${themaid}"/>
            <input type="hidden" name="edit" />
        </form>
        
        <div style="width: 1000px; margin-top: 20px;">
            <div id="kop" style="clear: both; width: 800px; margin-bottom: 20px;">
                <strong style="color: Red; font-size: 16px;">ETL - Onvolledige objecten van thema ${themaName}</strong><br />
            </div>
            
            <div id="map">
                <div id="flashcontent">
                    <font color="red"><strong>For some reason the Flamingo mapviewer can not be shown. Please contact the website administrator.</strong></font>
                </div>
                <script type="text/javascript">
                    var so = new SWFObject("flamingo/flamingo.swf?config=/config.xml", "flamingo", "659", "493", "8", "#FFFFFF");
                </script>
                <!--[if lte IE 6]>
                <script type="text/javascript">
                var so = new SWFObject("flamingo/flamingo.swf?config=/config.xml", "flamingo", "651", "488", "8", "#FFFFFF");
                </script>
                <![endif]-->
                <script type="text/javascript">
                    so.write("flashcontent");
                </script>
            </div>
            <div id="rightdiv_etl">                        
                <div id="infovak_etl">
                    <strong>Van welke objecten wilt u de onvolledige data bekijken</strong>
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
            <iframe id="dataframe" name="dataframe" frameborder="0"></iframe>
        </div>
    </body>
</html>