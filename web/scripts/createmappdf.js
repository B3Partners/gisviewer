function setMapImageSrc(url){
    document.getElementById("mapImage").style.width = '474px';
    document.getElementById("mapImage").style.height = 'auto';
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
                $j("#slider").slider("option", "value", parseInt(imageSize));
            }
            if(document.getElementById("startImageSize")!=undefined){
                document.getElementById("startImageSize").value=imageSize;
            }
        }
    }
}

function resetImageSize() {
    if(document.getElementById("startImageSize")!=undefined){
        var startSize = document.getElementById("startImageSize").value;
        $j("#slider").slider("option", "value", parseInt(startSize));
        document.getElementById("imageSize").value=startSize;
    }
}

mapImageLoad = function() {
    //doe bij de eerste keer laden om slider te initialiseren
    setMapImageSrc(firstUrl);
}
attachOnload(mapImageLoad);