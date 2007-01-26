package nl.b3p.nbr.wis;

import java.util.ArrayList;
import java.util.Random;

public class GetMapData {
    
    protected final static double deg_x0 = 7.2;
    protected final static double deg_y0 = 53.5;
    protected final static double deg_x1 = 3.3;
    protected final static double deg_y1 = 50.5;
    protected final static double simple_x0 = 275248.2;
    protected final static double simple_y0 = 614037.9;
    protected final static double simple_x1 = 6897.578;
    protected final static double simple_y1 = 280876.62;
    
    public GetMapData() {}
    
    public String getData(String x_input, String y_input) {
        Random generator = new Random();
        double x = Double.parseDouble(x_input);
        double y = Double.parseDouble(y_input);
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
    
    private static double forward_x_simple(double l) {
        double ll = l * (180.0d / Math.PI);
        double deg_x = ll;
        double simple_x  = (simple_x1 - simple_x0) / (deg_x1 - deg_x0) * (deg_x - deg_x0) + simple_x0;
        return simple_x;
    }
    
    private static double forward_y_simple(double f) {
        double ff = f * (180.0d / Math.PI);
        double deg_y = ff;
        double simple_y  = (simple_y1 - simple_y0) / (deg_y1 - deg_y0) * (deg_y - deg_y0) + simple_y0;
        return simple_y;
        
    }
}