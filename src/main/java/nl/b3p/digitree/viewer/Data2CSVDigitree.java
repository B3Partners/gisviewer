package nl.b3p.digitree.viewer;

import nl.b3p.gis.viewer.db.Gegevensbron;
import nl.b3p.gis.viewer.services.Data2CSV;

/**
 * Opm CvL: waarom niet gewoon configureren in gisviewerConfig????
 * Volgens mij kan dit dan weg.
 * 
 * @author Roy
 */
public class Data2CSVDigitree extends Data2CSV {

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

    @Override
    public String[] getThemaLabelNames(Gegevensbron gb) {
        return HEADER_CSV;
    }
}
