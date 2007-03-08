package nl.b3p.nbr.wis;

import java.util.ArrayList;
import java.util.Random;

public class GetMapData {
    
    public GetMapData() {}
    
    public String getData(String x_input, String y_input) {
        
        double x = Double.parseDouble(x_input);
        double y = Double.parseDouble(y_input);
        double distance = 1000.0;
        int srid = 28992; // RD-new
        
        // bepaal dichstbijzijnde hm paal
        
        
        // bepaal gemeente

        Random generator = new Random();
        String rdX = "" + Math.round(x);
        String rdY = "" + Math.round(y);
        String rd = "X: " + rdX + "<br />" +
                    "Y: " + rdY + "<br />";
        String[] wegen = new String[]{"N322", "N324", "N321", "N65", "N261", "N277", "N282", "N12", "N269", "N270"};
        int wegnr = generator.nextInt(10);
        int paalnummer = generator.nextInt(175) + 50;
        int kommagetal = generator.nextInt(10);
        String[] aanduiding = new String[]{"Re", "Li", "b"};
        int aanduidingnr = generator.nextInt(3);
        
        String ret = "<b>RD Co&ouml;rdinaten</b><br />" + rd + "<br />" +
                "<b>Hectometerpaal aanduiding</b><br />" + paalnummer + "," + kommagetal + " " + aanduiding[aanduidingnr] + "<br /><br />" +
                "<b>Wegnaam</b><br />" + wegen[wegnr] + "<br /><br />" +
                "<b>Gemeente</b><br />Niet bekend";
        return ret;
    }
    
}