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
                document.forms[0].type.value    = document.getElementById('object_type').value;
                document.forms[0].optie.value   = document.getElementById('object_optie').value;
                document.forms[0].begin.value   = document.getElementById('begindate').value;
                document.forms[0].end.value     = document.getElementById('enddate').value;
                //document.forms[0].themaid.value = document.forms[0].themaid.value;
                document.forms[0].edit.value    = "submit";
                document.forms[0].submit();
            }
        </script>        
        <script>
            imgout = new Image(9,9);
            imgin  = new Image(9,9);
            imgout.src="<html:rewrite page='/images/u.gif' module='' />";
            imgin.src="<html:rewrite page='/images/d.gif' module='' />";

            //Switch expand collapse icons
            function filter(imagename, objectsrc) {
                if (document.images) {
                    document.images[imagename].src=eval(objectsrc+".src");
                }
            }

            //show OR hide funtion depends on if element is shown or hidden
            function shoh(id) {	
                if (document.getElementById) { // DOM3 = IE5, NS6
                    if (document.getElementById(id).style.display == "none"){
                        document.getElementById(id).style.display = 'block';
                        document.getElementById(id).style.width = '950px';
                        document.getElementById(id).style.height = '160px';
                        document.getElementById(id).style.border = '1px solid black';
                        filter(("img"+id),'imgin');			
                    } else {
                        filter(("img"+id),'imgout');
                        document.getElementById(id).style.display = 'none';			
                    }	
                } else { 
                    if (document.layers) {	
                        if (document.id.display == "none"){
                            document.id.display = 'block';
                            document.id.width = '950px';
                            document.id.height = '160px';
                            document.id.border = '1px solid black';
                            filter(("img"+id),'imgin');
                        } else {
                            filter(("img"+id),'imgout');	
                            document.id.display = 'none';
                        }
                    } else {
                        if (document.all.id.style.visibility == "none"){
                            document.all.id.style.display = 'block';
                            document.all.id.style.width = '950px';
                            document.all.id.style.height = '160px';
                            document.all.id.style.border = '1px solid black';
                        } else {
                            filter(("img"+id),'imgout');
                            document.all.id.style.display = 'none';
                        }
                    }
                }
            }
            
            
            function showHide(nr, el) {
                if(nr == 1 || nr == 2) {
                    document.getElementById('batchdate').style.backgroundColor = '#A1A1A1';
                    document.getElementById('batchdate').value = '';
                    
                    document.getElementById('batchdate').selectedIndex = 0;
                    document.getElementById('batchdate').selected = true;
                    
                    document.getElementById('begindate').style.backgroundColor = '';
                    document.getElementById('enddate').style.backgroundColor = '';
                } else if(nr == 3) {
                    document.getElementById('begindate').style.backgroundColor = '#A1A1A1';
                    document.getElementById('begindate').value = '';
                    document.getElementById('enddate').style.backgroundColor = '#A1A1A1';
                    document.getElementById('enddate').value = '';
                    document.getElementById('batchdate').style.backgroundColor = '';
                }
            }
        </script>
    </head>
    <body>
        <form id="myid" target="dataframe">
            <input type="hidden" name="type" />
            <input type="hidden" name="optie" />
            <input type="hidden" name="begin" />
            <input type="hidden" name="end" />
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
            <div id="rightdiv">                        
                <div id="infovak">
                    <strong>Van welke objecten wilt u de onvolledige data bekijken</strong>
                    <div class="optie">
                        <input type="radio" value="1" name="object_type" id="object_type"/> Nieuwe objecten<br />
                        <input type="radio" value="2" name="object_type" id="object_type"/> Onvolledige nieuwe objecten<br />
                        <input type="radio" value="3" name="object_type" id="object_type"/> Geupdate objecten<br />
                        <input type="radio" value="4" name="object_type" id="object_type"/> Verwijderde objecten<br />
                        <input type="radio" value="5" name="object_type" id="object_type"/> Onvolledig verwijderde objecten<br />
                        <input type="radio" value="6" name="object_type" id="object_type"/> Niet verwerkbare objecten<br/>
                        
                        <p><b>Welk type objecten wilt u tonen?</b></p>
                        <input type="radio" value="1" name="object_optie" id="object_optie"/> Alleen geografische objecten<br />
                        <input type="radio" value="2" name="object_optie" id="object_optie"/> Alleen administratieve objecten<br />
                        <input type="radio" value="3" name="object_optie" id="object_optie"/> Beide<br />
                        
                        <p><b>Van welke periode wilt u de gegevens bekijken:</b></p>
                        van: <input type="text" size="5" id="begindate" name="begindate" onfocus="showHide(1, this);"> tot: <input type="text" size="5" id="enddate" name="enddate" onfocus="showHide(2, this);">
                        
                        <p><b>of kies een batchverwerking:</b></p>
                        <p>
                        <select id="batchdate" name="batchdate" onclick="showHide(3, this);">
                            <option class="thema_object" value="-1">-- Selecteerd een Batchverwerking --</option>
                            <c:forEach var="nBatchverwerking" items="${batches}">
                                <option class="batch_object" value="${nBatchverwerking.id}">
                                    ${nBatchverwerking.name}                                    
                                </option>        
                            </c:forEach>                            
                        </select>
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