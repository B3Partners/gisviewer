<%@include file="/WEB-INF/jsp/taglibs.jsp" %>
<%@ page isELIgnored="false"%>


<script type="text/javascript" src="<html:rewrite page="/scripts/swfobject.js"/>"></script>
<script language="JavaScript" type="text/javascript">
    function getObjects() {                                
        var radiobuttons=document.getElementsByName('radiogroup');
        for (var i = 0; i < radiobuttons.length; i++) {
            if(radiobuttons[i].checked) { 
                document.forms[0].type.value = radiobuttons[i].value;
            }
        }
        refreshLayer();
        document.forms[0].edit.value    = "submit";
        document.forms[0].submit();
        
    }
    
    function isInCheckboxArray(id) {
        if(checkboxArray == null) return false;
        for(i = 0; i < checkboxArray.length; i++) {
            if(checkboxArray[i] == id) {
                return true;
            }
        }
        return false;
    }

    function refreshLayer(){
        var layersToAdd = '${layerToAdd}';
        layerUrl='${kburl}';
        //layerUrl="${kburl}"+"&filter=status_etl%3D'UO'%20or%20status_etl%3D'OO'%20or%20status_etl%3D'NO'";
        var status;
        var radiobuttons=document.getElementsByName('radiogroup');
        for (var i = 0; i < radiobuttons.length; i++) {
            if(radiobuttons[i].checked) {
                status=radiobuttons[i].value;                
            }
        }
        //alert(status);
        if(layerUrl.indexOf('?')> 0)
            layerUrl+='&';
        else
            layerUrl+='?';
        layerUrl+="filter=status_etl%3D'"+status+"'";
        //var newLayer= "<fmc:LayerOGWMS xmlns:fmc=\"fmc\" id=\"OG2\" timeout=\"30\" retryonerror=\"10\" format=\"image/png\" transparent=\"true\" url=\""+layerUrl+"\" layers=\"+allActiveLayers+"\" query_layers=\""+layersToAdd+"\" srs=\"EPSG:28992\"/>";
        var newLayer= "<fmc:LayerOGWMS xmlns:fmc=\"fmc\" id=\"OG2\" timeout=\"30\" retryonerror=\"10\" format=\"image/png\" transparent=\"true\" url=\""+layerUrl+"\" layers=\""+layersToAdd+"\" query_layers=\""+layersToAdd+"\" srs=\"EPSG:28992\" version=\"1.1.1\"/>";
        if (flamingo && layerUrl!=null){
            flamingo.call("map1","removeLayer","fmcLayer");
            flamingo.call("map1","addLayer",newLayer);
        }
    }            
</script>

<form id="myid" target="dataframe">
    <input type="hidden" name="type" />
    <input type="hidden" name="themaid" value="${themaid}"/>
    <input type="hidden" name="edit" />
</form>

<div class="onderbalk">ETL VIEWER<span><tiles:insert name="loginblock"/></span></div>
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
                    <input type="radio" value="NO" name="radiogroup" id="radio1"/> Nieuwe objecten<br />
                    <input type="radio" value="OAO" name="radiogroup" id="radio2"/> Onvolledige administratie objecten<br />
                    <input type="radio" value="OGO" name="radiogroup" id="radio3"/> Onvolledige geografie objecten<br />
                    <input type="radio" value="UO" name="radiogroup" id="radio4"/> Geupdate objecten<br />
                    <input type="radio" value="VO" name="radiogroup" id="radio5"/> Verwijderde objecten<br />
                    <input type="radio" value="FO" name="radiogroup" id="radio6"/> Niet verwerkbare objecten<br/>
                    <input type="radio" value="OO" name="radiogroup" id="radio7"/> Ongewijzigde objecten<br />
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
<div class="onderbalk">ETL DETAILS<span id="actief_thema">Actieve thema: ${themaName}</span></div>
<div id="dataframediv">
    <iframe id="dataframe" name="dataframe" frameborder="0"></iframe>
</div>
<script language="JavaScript" type="text/javascript" src="<html:rewrite page="/scripts/enableJsFlamingo.js"/>"></script>
