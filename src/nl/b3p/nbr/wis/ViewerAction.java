/*
 * ViewerAction.java
 *
 * Created on 29 november 2006, 9:49
 */

package nl.b3p.nbr.wis;

import java.util.ArrayList;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ActionForward;
/**
 *
 * @author Roy
 * @version
 */

public class ViewerAction extends Action {
    
    /* forward name="success" path="" */
    private final static String SUCCESS = "success";
    
    /**
     * This is the action called from the Struts framework.
     * @param mapping The ActionMapping used to select this instance.
     * @param form The optional ActionForm bean for this request.
     * @param request The HTTP Request we are processing.
     * @param response The HTTP Response we are processing.
     * @throws java.lang.Exception
     * @return
     */
    public ActionForward execute(ActionMapping mapping, ActionForm  form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        
        ArrayList layers= new ArrayList();
        
        LayerItem li1 = new LayerItem("BASIS");
        li1.addChild(new LayerItem("Weg"));
        li1.addChild(new LayerItem("Beheersgrens"));
        li1.addChild(new LayerItem("Bebouwde kom"));
        li1.addChild(new LayerItem("GGA-gebieden"));
        li1.addChild(new LayerItem("Waterschap"));
        li1.addChild(new LayerItem("Ecologisch"));
        li1.addChild(new LayerItem("Bestemminsplan"));
        li1.addChild(new LayerItem("Geluid/stilzone"));
        li1.addChild(new LayerItem("Kunstwerk"));
        li1.addChild(new LayerItem("Bebouwde kom"));
        li1.addChild(new LayerItem("Algemeen"));
        li1.addChild(new LayerItem("Uitrit"));
        
        LayerItem li2= new LayerItem("VERKEER");
        LayerItem li20 = new LayerItem("Verharding");
        li2.addChild(li20);
        LayerItem li21 = new LayerItem("Metingen");
        li2.addChild(li21);
        li2.addChild(new LayerItem("Markering"));
        li2.addChild(new LayerItem("Bebording"));
        li2.addChild(new LayerItem("DVM"));
        li2.addChild(new LayerItem("Verlichting"));
        li2.addChild(new LayerItem("Ongevallen"));
        li2.addChild(new LayerItem("Tellingen"));
        
        String [] s = new String [5];
        s[0]="Materiaal";
        s[1]="Leeftijd";
        s[2]="Spoorvorming";
        s[3]="Stroefheidsmeting";
        s[4]="Opbouw/doorsnede";
        li20.addLabelData(s);
        s = new String [5];
        s[0]="Asfalt";
        s[1]="4 jaar";
        s[2]="Vrijwel geen";
        s[3]="Uitgevoerd: 23-05-2006. Resultaat: Goed";
        s[4]="Asfalt op kleilaag";
        li20.addAdmindata(s);
        s= new String [5];
        s[0]="Steen";
        s[1]="2,5 jaar";
        s[2]="Lichte spoorvorming";
        s[3]="Moet nog worden uitgevoerd";
        s[4]="Steen op zandlaag";
        li20.addAdmindata(s);
        s = new String [5];
        s[0]="Beton";
        s[1]="0,5 jaar";
        s[2]="Geen";
        s[3]="Wordt niet uitgevoerd (tijdelijke weg)";
        s[4]="Beton op zand/kleilaag";
        li20.addAdmindata(s);
        
        s = new String[5];
        s[0]="Aran";
        s[1]="Rambol";
        s[2]="Deflectie";
        s[3]="Stroefheid";
        s[4]="Inspectie";
        li21.addLabelData(s);
        s = new String [5];
        s[0]="22";
        s[1]="95";
        s[2]="37";
        s[3]="Hoog";
        s[4]="Laatste: 12-09-2006";
        li21.addAdmindata(s);
        s= new String [5];
        s[0]="48";
        s[1]="86";
        s[2]="15";
        s[3]="Laag";
        s[4]="Laatste: 22-02-2005";
        li21.addAdmindata(s);
        s = new String [5];
        s[0]="547";
        s[1]="4";
        s[2]="256";
        s[3]="Gemiddeld";
        s[4]="Nog niet uitgevoerd";
        li21.addAdmindata(s);
        
        LayerItem li3= new LayerItem("GROEN");
        LayerItem li30=new LayerItem("Sloot");
        li3.addChild(li30);
        li3.addChild(new LayerItem("Berm"));
        li3.addChild(new LayerItem("Doorsnede"));
        s = new String [5];
        s[0]="Oppervlak";
        s[1]="Gemeente";
        s[2]="Type";
        s[3]="Ori&euml;ntatie t.o.v. wegas";
        s[4]="Opmerkingen";
        li30.addLabelData(s);
        s = new String [5];
        s[0]="80m2";
        s[1]="Den Bosch";
        s[2]="Nat";
        s[3]="Links";
        s[4]="Geen";
        li30.addAdmindata(s);
        s= new String [5];
        s[0]="300m2";
        s[1]="Oss";
        s[2]="Zaksloot";
        s[3]="Links";
        s[4]="Moet worden gebaggerd";
        li30.addAdmindata(s);
        s = new String [5];
        s[0]="78m2";
        s[1]="Den Bosch";
        s[2]="Droog";
        s[3]="Rechts";
        s[4]="Drooggevallen sloot, heeft controle nodig";
        li30.addAdmindata(s);
        
        layers.add(li1);
        layers.add(li2);
        layers.add(li3);
               
        
        request.setAttribute("layers",layers);
        
        return mapping.findForward(SUCCESS);
        
    }
}
