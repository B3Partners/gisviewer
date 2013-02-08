<%@include file="/WEB-INF/jsp/taglibs.jsp" %>
<%@ page isELIgnored="false"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
        <title>Upload tijdelijke punten</title>
    </head>
    <body>
        <style type="text/css">
            p {
                margin-left: 5px;
            }
        </style>    

        <script type="text/javascript">
            function getParent() {
                if (window.opener){
                    return window.opener;
                }else if (window.parent){
                    return window.parent;
                }else{
                    messagePopup("", "No parent found", "error");
                    return null;
                }
            }

            function checkboxChecked() {
                var checked = $j("#uploadCsvLayerOn").attr('checked');
                var ouder = getParent();
                
                ouder.checkTempUploadedPointsWms(checked);
            }
        </script>

        <p>
            U kunt hier een csv bestand uploaden. De punten met label worden
            tijdelijk op de kaart getoond zolang de internet browser geopend blijft.
        </p>

        <html:form action="/uploadtemppoints" enctype="multipart/form-data">
            <html:hidden property="action" />
            <html:hidden property="alt_action" />    

            <p>1) Selecteer het gebruikte veld scheidingsteken.</p>

            <p>
                <html:select property="csvSeparatorChar">
                    <html:option value=";">puntkomma</html:option>
                    <html:option value=",">komma</html:option>
                </html:select>
            </p>

            <p>2) Selecteer het bestand.</p>

            <p><html:file size="30" property="uploadFile" /></p>

            <p>
                3) Bestand uploaden
                <html:submit property="save" accesskey="s" styleClass="knop saveButton" >
                    Upload
                </html:submit>
            </p>

            <p>4) Kaartlaag tonen <input type="checkbox" id="uploadCsvLayerOn" onclick="checkboxChecked();"></p>

        </html:form>
    </body>
</html>