package nl.b3p.gis.viewer;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import nl.b3p.gis.viewer.db.Gegevensbron;
import nl.b3p.gis.viewer.db.ThemaData;
import nl.b3p.gis.viewer.services.LabelsUtil;
import nl.b3p.gis.viewer.services.SpatialUtil;
import nl.b3p.zoeker.configuratie.Bron;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ActionForward;
import org.apache.struts.validator.DynaValidatorForm;
import nl.b3p.combineimages.CombineImagesServlet;
import nl.b3p.commons.services.FormUtils;
import nl.b3p.gis.geotools.DataStoreUtil;
import nl.b3p.gis.geotools.FilterBuilder;
import nl.b3p.imagetool.CombineImageSettings;
import org.geotools.geometry.jts.ReferencedEnvelope;
import org.opengis.feature.Feature;
import org.opengis.filter.Filter;

public class GetViewerDataDigitreeAction extends GetViewerDataAction {

    private static final Log logger = LogFactory.getLog(GetViewerDataDigitreeAction.class);

    /**
     * Methode is attributen ophaalt welke nodig zijn voor het tonen van de
     * aanvullende info.
     * @param mapping ActionMapping
     * @param dynaForm DynaValidatorForm
     * @param request HttpServletRequest
     * @param response HttpServletResponse
     *
     * @return ActionForward
     *
     * @throws Exception
     *
     * thema_items
     * regels
     */
    @Override
    public ActionForward aanvullendeinfo(ActionMapping mapping, DynaValidatorForm dynaForm, HttpServletRequest request, HttpServletResponse response) throws Exception {
        Gegevensbron gb = getGegevensbron(mapping, dynaForm, request);

        boolean addKaart = false;
        if (FormUtils.nullIfEmpty(request.getParameter("addKaart")) != null) {
            addKaart = true;
        }
        
        if(addKaart){
            CombineImageSettings settings = ImageAction.getCombineImageSettingsDigitree(request);
            String imageId = CombineImagesServlet.uniqueName("");
            request.getSession().setAttribute(imageId, settings);
            request.setAttribute("imageId", imageId);
        }

        if (gb == null) {
            return mapping.findForward("aanvullendeinfo");
        }

        String gegevensbronId = (String) request.getParameter("gegevensbronid");

        if (gegevensbronId != null) {
            gb = SpatialUtil.getGegevensbron(gegevensbronId);

            String fkId = (String) request.getParameter("id");
            request.setAttribute("fkId", fkId);
        }

        List<ThemaData> thema_items = SpatialUtil.getThemaData(gb, false);
        /* Digitree vervangen voor extra labels */
        thema_items = replaceExtraColumns(thema_items, request);

        request.setAttribute("thema_items", thema_items);

        Bron b = gb.getBron(request);

        if (b != null) {
            List regels = getThemaObjectsWithId(gb, thema_items, request);
            request.setAttribute("regels", regels);
        }
        return mapping.findForward("aanvullendeinfo");
    }

    private List replaceExtraColumns(List data, HttpServletRequest request) {

        Object r = request.getAttribute("labels");
        Map labels = new HashMap();

        if (r == null) {
            LabelsUtil.getExtraLabels(request);
            labels = (Map)request.getAttribute("labels");
        } else {
            labels = (Map)request.getAttribute("labels");
        }

        String val1 = (String)labels.get("extra1");
        String val2 = (String)labels.get("extra2");
        String val3 = (String)labels.get("extra3");
        String val4 = (String)labels.get("extra4");
        String val5 = (String)labels.get("extra5");
        String val6 = (String)labels.get("extra6");
        String val7 = (String)labels.get("extra7");
        String val8 = (String)labels.get("extra8");
        String val9 = (String)labels.get("extra9");
        String val10 = (String)labels.get("extra10");
        
        String val11 = (String)labels.get("vta1");
        String val12 = (String)labels.get("vta2");
        String val13 = (String)labels.get("vta3");
        String val14 = (String)labels.get("vta4");
        String val15 = (String)labels.get("vta5");
        String val16 = (String)labels.get("vta6");

        Iterator iter = data.iterator();
        List labeledList = new ArrayList();

        while (iter.hasNext()) {
            ThemaData td = (ThemaData)iter.next();

            if (td.getLabel().equals("extra1")) {
                if ( (val1 != null) && (!val1.equals("")) )
                    td.setLabel(val1);
            }

            if (td.getLabel().equals("extra2")) {
                if ( (val2 != null) && (!val2.equals("")) )
                    td.setLabel(val2);
            }

            if (td.getLabel().equals("extra3")) {
                if ( (val3 != null) && (!val3.equals("")) )
                    td.setLabel(val3);
            }

            if (td.getLabel().equals("extra4")) {
                if ( (val4 != null) && (!val4.equals("")) )
                    td.setLabel(val4);
            }

            if (td.getLabel().equals("extra5")) {
                if ( (val5 != null) && (!val5.equals("")) )
                    td.setLabel(val5);
            }

            if (td.getLabel().equals("extra6")) {
                if ( (val6 != null) && (!val6.equals("")) )
                    td.setLabel(val6);
            }

            if (td.getLabel().equals("extra7")) {
                if ( (val7 != null) && (!val7.equals("")) )
                    td.setLabel(val7);
            }

            if (td.getLabel().equals("extra8")) {
                if ( (val8 != null) && (!val8.equals("")) )
                    td.setLabel(val8);
            }

            if (td.getLabel().equals("extra9")) {
                if ( (val9 != null) && (!val9.equals("")) )
                    td.setLabel(val9);
            }

            if (td.getLabel().equals("extra10")) {
                if ( (val10 != null) && (!val10.equals("")) )
                    td.setLabel(val10);
            }
            
            if (td.getLabel().equals("Aanvulling VTA 1") || td.getLabel().equals("vta1")) {
                if ( (val11 != null) && (!val11.equals("")) )
                    td.setLabel(val11);
            }
            
            if (td.getLabel().equals("Aanvulling VTA 2") || td.getLabel().equals("vta2")) {
                if ( (val12 != null) && (!val12.equals("")) )
                    td.setLabel(val12);
            }
            
            if (td.getLabel().equals("Aanvulling VTA 3") || td.getLabel().equals("vta3")) {
                if ( (val13 != null) && (!val13.equals("")) )
                    td.setLabel(val13);
            }
            
            if (td.getLabel().equals("Aanvulling VTA 4") || td.getLabel().equals("vta4")) {
                if ( (val14 != null) && (!val14.equals("")) )
                    td.setLabel(val14);
            }
            
            if (td.getLabel().equals("Aanvulling VTA 5") || td.getLabel().equals("vta5")) {
                if ( (val15 != null) && (!val15.equals("")) )
                    td.setLabel(val15);
            }
            
            if (td.getLabel().equals("Aanvulling VTA 6") || td.getLabel().equals("vta6")) {
                if ( (val16 != null) && (!val16.equals("")) )
                    td.setLabel(val16);
            }

            labeledList.add(td);
        }

        getHibernateSession().clear();

        return labeledList;
    }

    @Override
    public List getThemaObjectsWithId(Gegevensbron gb, List thema_items, HttpServletRequest request) throws Exception {
        if (gb == null) {
            return null;
        }
        if (thema_items == null || thema_items.isEmpty()) {
            return null;
        }

        String adminPk = DataStoreUtil.convertFullnameToQName(gb.getAdmin_pk()).getLocalPart();
        String id = null;
        Filter filter = null;
        if (adminPk != null) {

            id = request.getParameter(adminPk);

            /* Als er een foreign key is ingevuld dan een filter toevoegen op
             * dit veld */
            String fkField = gb.getAdmin_fk();
            String fkId = null;

            if (fkField != null) {
                fkId = (String) request.getAttribute("fkId");

                if (fkId != null) {
                    filter = FilterBuilder.createEqualsFilter(fkField, fkId);
                }
            }

            /* alleen adminpk als filter adden als foreign key leeg is */
            if (id != null && fkId == null) {
                filter = FilterBuilder.createEqualsFilter(adminPk, id);
            } else {
                // tbv data2info meerdere id's
                String primaryKeys = request.getParameter("primaryKeys");
                if (primaryKeys != null) {
                    String[] primaryKeysArray = primaryKeys.split(",");
                    filter = FilterBuilder.createOrEqualsFilter(adminPk, primaryKeysArray);
                }
            }
        }

        List regels = new ArrayList();

        boolean addKaart = false;
        if (FormUtils.nullIfEmpty(request.getParameter("addKaart")) != null) {
            addKaart = true;
        }

        List<ReferencedEnvelope> kaartEnvelopes = new ArrayList<ReferencedEnvelope>();
        Bron b = gb.getBron(request);
        List<String> propnames = DataStoreUtil.themaData2PropertyNames(thema_items);
        List<Feature> features = DataStoreUtil.getFeatures(b, gb, null, filter, propnames, null, true);
        for (int i = 0; i < features.size(); i++) {
            Feature f = (Feature) features.get(i);
            if (addKaart) {
                ReferencedEnvelope env = DataStoreUtil.convertFeature2Envelop(f);
                if (env != null) {
                    kaartEnvelopes.add(env);
                }
            }
            regels.add(getRegel(f, gb, thema_items));
        }
        if (addKaart) {
            request.setAttribute("envelops", kaartEnvelopes);
        }
        return regels;
    }

}
