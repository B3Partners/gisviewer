    var plannen = new Object();
    var bestemmingen = new Object();
    var selectedPlan=null;

    var plantypeAttribuutNaam="plantype";
    var planStatusAttribuutNaam="planstatus";
    var tekstAttribuutNaam="documenten";
    /*De select velden*/
    var eigenaarSelectName="eigenaarselect";
    var planSelectName="planselect";
    var plantypeSelectName="plantypeselect";
    var statusSelectName="statusselect";

    var eigenaarSelect=document.getElementById(eigenaarSelectName);
    var planSelect=document.getElementById(planSelectName);
    var plantypeSelect=document.getElementById(plantypeSelectName);
    var statusSelect=document.getElementById(statusSelectName);

    /*Hier begint het zoeken:*/
    JZoeker.zoek(new Array("3"),"*",0,handleGetEigenaar);
    function handleGetEigenaar(list){
        eigenaarSelect.disabled=false;
        if (list!=null && list.length > 0){
            //eigenaarselect
            dwr.util.removeAllOptions(eigenaarSelectName);
            dwr.util.addOptions(eigenaarSelectName,list,"id","label");
        }
    }

        /*Als er een eigenaar is gekozen.*/
        function eigenaarchanged(element){
        if (element.value!=""){
            dwr.util.removeAllOptions(plantypeSelectName);
            dwr.util.removeAllOptions(statusSelectName)
            dwr.util.removeAllOptions(planSelectName);

            dwr.util.addOptions(plantypeSelectName,[ "Bezig met ophalen..."]);
            dwr.util.addOptions(statusSelectName,[ "Bezig met ophalen..."]);
            dwr.util.addOptions(planSelectName,[ "Bezig met ophalen..."]);

            JZoeker.zoek(new Array("1"),element.value,0,handleGetPlannen);
            //geen nieuwe eigenaar kiezen tijdens de zoek opdracht
            eigenaarSelect.disabled=true;
            setSelectedPlan(null);
        }
    }

    function handleGetPlannen(list){
        //klaar met zoeken dus eigenaar veld weer aan.
        eigenaarSelect.disabled=false;
        dwr.util.removeAllOptions(planSelectName);
        dwr.util.addOptions(planSelectName,list,"id","label");
        plannen = new Object();
        //als niks gevonden dan tekstje tonen
        if (list==undefined || list.length==0){
            dwr.util.addOptions(planSelectName,[ "Geen plannen gevonden"]);
        }else{
            plannen=list;
        }
        //update de typeselect filter en statusselect filter
        updateTypeSelect();
        updateStatusSelect();
    }
    /*Update select boxen*/
    function updateTypeSelect(){
        dwr.util.removeAllOptions(plantypeSelectName);
        var typen= getDistinctFromPlannen(plantypeAttribuutNaam);
        dwr.util.addOptions(plantypeSelectName,[{
                naam:"Selecteer een plantype...",
                waarde:""
            }],'waarde','naam');
        dwr.util.addOptions(plantypeSelectName,typen);
    }

    function updateStatusSelect(){
        dwr.util.removeAllOptions(statusSelectName);
        //als er al een type is geselecteerd, dan filteren.
        var filteredPlannen=plannen;
        if (plantypeSelect.value.length>0){
            filteredPlannen=filterPlannen(plantypeAttribuutNaam,plantypeSelect.value, filteredPlannen);
        }
        //alleen de statusen van de gefilterde plannen
        var statussen= getDistinctFromPlannen(planStatusAttribuutNaam,filteredPlannen);
        dwr.util.addOptions(statusSelectName,[{
                naam:"Selecteer een planstatus...",
                waarde:""
            }],'waarde','naam');
        dwr.util.addOptions(statusSelectName,statussen);
    }
    function updatePlanSelect(){
        dwr.util.removeAllOptions(planSelectName);
        var filteredPlannen=plannen;
        if (plantypeSelect.value.length>0){
            filteredPlannen=filterPlannen(plantypeAttribuutNaam,plantypeSelect.value, filteredPlannen);
        }
        if (statusSelect.value.length>0){
            filteredPlannen=filterPlannen(planStatusAttribuutNaam,statusSelect.value, filteredPlannen);
        }
        dwr.util.addOptions(planSelectName,filteredPlannen,"id","label");
        if (filteredPlannen==undefined || filteredPlannen.length==0){
            dwr.util.addOptions(planSelectName,[ "Geen plannen gevonden"]);
        }
    }
    /***
     *onchange events:
     */
    function plantypechanged(element){
        updateStatusSelect();
        updatePlanSelect();
        setSelectedPlan(null);
    }
    function statuschanged(element){
        updatePlanSelect(element.value);
        setSelectedPlan(null);
    }
    function planchanged(element){
        if (element.value!=""){
            var plan;
            var zoekConfigId;
            for (var i=0; i < plannen.length; i++){
                if (plannen[i].id == element.value){
                    plan=plannen[i];
                    break;
                }
            }
            if (plan){
                setSelectedPlan(plan);
                var ext= new Object();
                ext.minx=plan.minx;
                ext.miny=plan.miny;
                ext.maxx=plan.maxx;
                ext.maxy=plan.maxy;
                flamingoController.getMap("map1").moveToExtent(ext);
            }
        }
    }
    /*Haalt een lijst met mogelijke waarden op met de meegegeven attribuutnaam uit de plannen*/
    function getDistinctFromPlannen(attribuutnaam,plannenArray){
        if(plannenArray==undefined){
            plannenArray=plannen;
        }
        var typen = new Array();
        for (var i=0; i < plannenArray.length; i++){
            var attributen=plannenArray[i].attributen;
            for (var e=0; e <attributen.length; e++){
                if(attributen[e].naam==attribuutnaam){
                    if (!arrayContains(typen,attributen[e].waarde)){
                        typen.push(attributen[e].waarde);
                    }
                }
            }
        }
        return typen;
    }
    function filterPlannen(attribuutType,value,plannenArray){
        if(plannenArray==undefined){
            plannenArray=plannen;
        }
        var filteredPlannen=new Array();
        for (var i=0; i < plannenArray.length; i++){
            var attributen=plannenArray[i].attributen;
            for (var e=0; e <attributen.length; e++){
                if(attributen[e].naam==attribuutType){
                    if (value==attributen[e].waarde){
                        filteredPlannen.push(plannenArray[i]);
                    }
                }
            }
        }
        return filteredPlannen;
    }

    function setSelectedPlan(plan){
        selectedPlan=plan;
        if (plan==null){
            document.getElementById("selectedPlan").innerHTML="Geen plan geselecteerd";
        }else{
            //commentaar tool zichtbaar maken:
            document.getElementById("selectedPlan").innerHTML=plan.id;
        }
    }