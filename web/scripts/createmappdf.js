function setMapImageSrc(url){
    document.getElementById("mapImage").style.width = '474px';
    document.getElementById("mapImage").style.height = 'auto';
    document.getElementById("mapImage").src=url;
    document.getElementById("mapUrl").value=url;
    if(setDefaultImageSizeFromMap){
        if (url.toLowerCase().indexOf("width=")>=0){
            var beginIndex=url.toLowerCase().indexOf("width=")+6;
            var endIndex=url.toLowerCase().indexOf("&",beginIndex);
            if (endIndex==-1){
                endIndex=url.length;
            }
            var imageSize=url.substring(beginIndex, endIndex);
            if(document.getElementById("imageSize")!=undefined){
                document.getElementById("imageSize").value=imageSize;
                $("#slider").slider("option", "value", parseInt(imageSize));
            }
        }
    }
}

mapImageLoad = function() {
    //doe bij de eerste keer laden:
    if (window.opener){
        if (window.opener.lastGetMapRequest!=undefined)
            setMapImageSrc(window.opener.lastGetMapRequest);
        if(window.opener.activeAnalyseThemaTitle!=undefined){
            document.getElementById('title').value=window.opener.activeAnalyseThemaTitle;
        }
    }
}
attachOnload(mapImageLoad);