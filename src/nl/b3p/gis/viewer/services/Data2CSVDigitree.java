package nl.b3p.gis.viewer.services;

import java.io.IOException;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Set;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import nl.b3p.commons.csv.CsvOutputStream;
import nl.b3p.gis.geotools.DataStoreUtil;
import nl.b3p.gis.geotools.FilterBuilder;
import nl.b3p.gis.viewer.db.Gegevensbron;
import nl.b3p.gis.viewer.db.ThemaData;
import nl.b3p.gis.viewer.db.Themas;
import nl.b3p.zoeker.configuratie.Bron;
import org.apache.commons.fileupload.FileUploadBase;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.Transaction;
import org.opengis.feature.Feature;
import org.opengis.feature.Property;
import org.opengis.filter.Filter;

/**
 *
 * @author Roy
 */
public class Data2CSVDigitree extends Data2CSV {

    private static final Log log = LogFactory.getLog(Data2CSVDigitree.class);
    private static String HTMLTITLE = "Data naar CSV";

    private static final String[] PROPERTY_NAMES = {
        "boomid",
        "upload_rdx", "upload_rdy",
        "mutatiedatum","mutatietijd","inspecteur","aktie","project","boomsrt",
        "plantjaar","boomhoogte", "eindbeeld","scheefstand","scheuren","holten",
        "stamvoetschade", "stamschade","kroonschade","inrot","houtboorder",
        "zwam","zwam_stamvoet", "zwam_stam","zwam_kroon","dood_hout",
        "plakoksel","stamschot", "wortelopslag","takken","opdruk",
        "vta1","vta2","vta3","vta4","vta5", "vta6","aantastingen",
        "maatregelen_kort","nader_onderzoek", "maatregelen_lang",
        "risicoklasse","uitvoerdatum","bereikbaarheid", "wegtype",
        "opmerkingen","extra1","extra2","extra3","extra4","extra5",
        "extra6","extra7","extra8","extra9","extra10","boomnaam"
    };
    
    private static final String[] HEADER_CSV = {
        "BOOMID",
        "RDX", "RDY",
        "MUTATIEDATUM","MUTATIETIJD","INSPECTEUR","AKTIE","PROJECT","BOOMSRT",
        "PLANTJAAR","BOOMHOOGTE", "EINDBEELD","SCHEEFSTAND","SCHEUREN","HOLTEN",
        "STAMVOETSCHADE", "STAMSCHADE","KROONSCHADE","INROT","HOUTBOORDER",
        "ZWAM","ZWAM_STAMVOET", "ZWAM_STAM","ZWAM_KROON","DOOD_HOUT",
        "PLAKOKSEL","STAMSCHOT", "WORTELOPSLAG","TAKKEN","OPDRUK",
        "VTA1","VTA2","VTA3","VTA4","VTA5", "VTA6","AANTASTINGEN",
        "MAATREGELEN_KORT","NADER_ONDERZOEK", "MAATREGELEN_LANG",
        "RISICOKLASSE","UITVOERDATUM","BEREIKBAARHEID", "WEGTYPE",
        "OPMERKINGEN","EXTRA1","EXTRA2","EXTRA3","EXTRA4","EXTRA5",
        "EXTRA6","EXTRA7","EXTRA8","EXTRA9","EXTRA10","BOOMNAAM"
    };

    /* Teruggeven kolomnamen voor in CSV bestand */
    @Override
    public String[] getThemaPropertyNames(Gegevensbron gb) {
        return PROPERTY_NAMES;
    }

    public String[] getCSVHeader() {
        return HEADER_CSV;
    }

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     */
    @Override
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String gegevensbronId = request.getParameter("themaId");
        String objectIds = request.getParameter("objectIds");
        String seperator = request.getParameter("seperator");

        if (seperator == null || seperator.length() != 1) {
            seperator = ";";
        }
        char sep = seperator.charAt(0);
        CsvOutputStream cos=null;
        OutputStream out=null;
        Transaction tx = HibernateUtil.getSessionFactory().getCurrentSession().beginTransaction();
        try {
            Gegevensbron gb = SpatialUtil.getGegevensbron(gegevensbronId);

            String decoded = URLDecoder.decode(objectIds,"UTF-8");
            String[] ids = decoded.split(",");

            GisPrincipal user = GisPrincipal.getGisPrincipal(request);
            if (user == null) {
                writeErrorMessage(response, "Kan de data niet ophalen omdat u niet bent ingelogd.");
                return;
            }

            Bron b = gb.getBron(request);

            if (b == null){
                throw new ServletException("Gegevensbron (id " + gb.getId() + ") Bron null.");
            }

            List data = null;
            String[] propertyNames = getThemaPropertyNames(gb);
            try {
                data = getData(b, gb, ids, propertyNames);
            } catch (Exception ex) {
                writeErrorMessage(response, ex.getMessage());
                log.error("Fout bij laden csv data.",ex);
                return;
            }

            response.setContentType("text/csv");
            response.setHeader(FileUploadBase.CONTENT_DISPOSITION, "attachment; filename=\"" + gb.getNaam() + ".csv\";");
            out = response.getOutputStream();
            cos = new CsvOutputStream(new OutputStreamWriter(out), sep, false);
            cos.writeRecord(getCSVHeader());
            for (int i = 0; i < data.size(); i++) {
                String[] row = (String[]) data.get(i);
                cos.writeRecord(row);
            }
        } finally {
            if (cos != null) {
                cos.close();
            }
            HibernateUtil.getSessionFactory().getCurrentSession().close();
            if (out != null) {
                out.close();
            }

        }
    }

    @Override
    public List getData(Bron b, Gegevensbron gb, String[] pks, String[] propertyNames)throws IOException, Exception {

        Filter filter = FilterBuilder.createOrEqualsFilter(
                DataStoreUtil.convertFullnameToQName(gb.getAdmin_pk()).getLocalPart(), pks);
        List<ThemaData> items = SpatialUtil.getThemaData(gb, false);
        List<String> propnames = DataStoreUtil.themaData2PropertyNames(items);
        ArrayList<Feature> features=DataStoreUtil.getFeatures(b, gb, null, filter, propnames, null, false);
        ArrayList result = new ArrayList();
        for (int i=0; i < features.size(); i++) {
            Feature f = features.get(i);
            String[] row = new String[propertyNames.length];

            for (int p=0; p< propertyNames.length; p++) {
                Property property = f.getProperty(propertyNames[p]);
                if (property!=null && property.getValue()!=null && property.getValue().toString()!=null){
                    String value = property.getValue().toString().trim();
                    row[p] = value;
                }else{
                    row[p] = "";
                }
            }
            result.add(row);
        }
        return result;
    }

    /**
     * Writes a error message to the response
     */
    private void writeErrorMessage(HttpServletResponse response, String message) throws IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter pw = response.getWriter();
        pw.println("<html>");
        pw.println("<head>");
        pw.println("<title>" + HTMLTITLE + "</title>");
        pw.println("<script type=\"text/javascript\"> if(window.parent && (typeof window.parent.showCsvError == 'function')) { window.parent.showCsvError(); } </script>");
        pw.println("</head>");
        pw.println("<body>");
        pw.println("<h1>Fout</h1>");
        pw.println("<h3>" + message + "</h3>");
        pw.println("</body>");
        pw.println("</html>");
    }
}
