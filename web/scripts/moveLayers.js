var selectedLayer;
function selectLayer(element){
    if (selectedLayer){
        selectedLayer.className="orderLayerClass";
    }
    element.className="orderLayerClassSelected";
    selectedLayer=element;
}
function switchLayers(element1,element2){
    var name=element1.name;
    var className=element1.className;
    var innerHTML=element1.innerHTML;
    var id=element1.id;

    element1.name=element2.name;
    element1.className=element2.className;
    element1.innerHTML=element2.innerHTML;
    element1.id=element2.id;

    element2.name=name;
    element2.className=className;
    element2.innerHTML=innerHTML;
    element2.id=id;
}
function moveSelected(amount){
    if (selectedLayer){
        var orderLayerBox= document.getElementById("orderLayerBox");
        var orderLayers=orderLayerBox.childNodes;
        for (var i=0; i < orderLayers.length; i++){
            if (orderLayers[i].name==selectedLayer.name){
                if (i+amount > -1 && i+amount < orderLayers.length){
                    switchLayers(orderLayers[i+amount],orderLayers[i]);
                    selectedLayer=orderLayers[i+amount];
                    return;
                }
            }
        }      
    }else{
        alert("Selecteer eerst een kaart om te verplaatsen");
    }
}
function moveSelectedDown(){
    moveSelected(1);
}
function moveSelectedUp(){
    moveSelected(-1);
}