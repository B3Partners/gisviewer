package nl.b3p.nbr.wis;

import java.util.ArrayList;
import java.util.Iterator;

/**
 *
 * @author Geert
 */
public class GetAdminData {
    
    ArrayList values = new ArrayList();
    
    public GetAdminData() {
        String[] tmp = new String[2];
        String[] tmp1 = new String[2];
        String[] tmp2 = new String[2];
        String[] tmp3 = new String[2];
        
        tmp[0] = "a1";
        tmp[1] = "<strong>Sloot langs wegnummer 235</strong><br /><br />" +
                "Object: object<br />" +
                "Profiel: profiel<br />" +
                "Beheersgrens: beheersgrens<br />" +
                "Locatie: locatie<br />" +
                "Oppervlakt: 80m2<br />" +
                "Gemeente: Den Bosch<br />" +
                "Wegnummer: 235<br />" +
                "Type: Nat<br />" +
                "Ori&euml;ntatie t.o.v. wegas: Links<br />" +
                "Uitvoering: uitvoering<br />" +
                "Opmerkingen: Geen";
        values.add(tmp);
        
        tmp1[0] = "a2";
        tmp1[1] = "<strong>Sloot langs wegnummer 235</strong><br /><br />" +
                "Object: object<br />" +
                "Profiel: profiel<br />" +
                "Beheersgrens: beheersgrens<br />" +
                "Locatie: locatie<br />" +
                "Oppervlakt: 90m2<br />" +
                "Gemeente: Den Bosch<br />" +
                "Wegnummer: 235<br />" +
                "Type: Nat<br />" +
                "Ori&euml;ntatie t.o.v. wegas: Links<br />" +
                "Uitvoering: uitvoering<br />" +
                "Opmerkingen: Geen";
        values.add(tmp1);
        
        tmp2[0] = "a3";
        tmp2[1] = "<strong>Sloot langs wegnummer 45</strong><br /><br />" +
                "Object: object<br />" +
                "Profiel: profiel<br />" +
                "Beheersgrens: beheersgrens<br />" +
                "Locatie: locatie<br />" +
                "Oppervlakt: 300m2<br />" +
                "Gemeente: Oss<br />" +
                "Wegnummer: 45<br />" +
                "Type: Zaksloot<br />" +
                "Ori&euml;ntatie t.o.v. wegas: Links<br />" +
                "Uitvoering: uitvoering<br />" +
                "Opmerkingen: Moet worden gebaggerd";
        values.add(tmp2);
        
        tmp3[0] = "a4";
        tmp3[1] = "<strong>Sloot langs wegnummer 573</strong><br /><br />" +
                "Object: object<br />" +
                "Profiel: profiel<br />" +
                "Beheersgrens: beheersgrens<br />" +
                "Locatie: locatie<br />" +
                "Oppervlakt: 78m2<br />" +
                "Gemeente: Den Bosch<br />" +
                "Wegnummer: 573<br />" +
                "Type: Droog<br />" +
                "Ori&euml;ntatie t.o.v. wegas: Rechts<br />" +
                "Uitvoering: uitvoering<br />" +
                "Opmerkingen: Drooggevallen sloot, heeft controle nodig";
        values.add(tmp3);
    }
    
    /* 
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
     
     */
    
    public String getData(String id) {
        for(Iterator i = values.iterator(); i.hasNext();) {
            String[] tmp = (String[]) i.next();
            if(tmp[0].equals(id)) return tmp[1];
        }
        return "Not Found...";
    }
    
}