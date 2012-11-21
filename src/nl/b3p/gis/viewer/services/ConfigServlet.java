/*
 * Copyright (C) 2012 B3Partners B.V.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
package nl.b3p.gis.viewer.services;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

/**
 *
 * @author Boy de Wit
 */
public class ConfigServlet extends HttpServlet {

    private static final Log log = LogFactory.getLog(ConfigServlet.class);

    private static String jdbcUrlGisdata = null;
    private static String jdbcUrlKaartenbalie = null;
    
    private static String databaseUserName = null;
    private static String databasePassword = null;
    
    private static String databaseLabelTable = null;

    @Override
    public void init(ServletConfig config) throws ServletException {
        log.debug("ConfigServlet init.");
        
        super.init(config);
        try {
            if (config.getInitParameter("jdbcUrlGisdata") != null) {
                jdbcUrlGisdata = config.getInitParameter("jdbcUrlGisdata");
            }
            if (config.getInitParameter("jdbcUrlKaartenbalie") != null) {
                jdbcUrlKaartenbalie = config.getInitParameter("jdbcUrlKaartenbalie");
            }
            if (config.getInitParameter("databaseUserName") != null) {
                databaseUserName = config.getInitParameter("databaseUserName");
            }
            if (config.getInitParameter("databasePassword") != null) {
                databasePassword = config.getInitParameter("databasePassword");
            }
            if (config.getInitParameter("databaseLabelTable") != null) {
                databaseLabelTable = config.getInitParameter("databaseLabelTable");
            }            
        } catch (Exception e) {
            log.error("",e);
            throw new ServletException(e);
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. ">
    protected void processRequest(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }    
    // </editor-fold>

    // <editor-fold defaultstate="collapsed" desc="Getters and setters.">
    public static String getDatabaseLabelTable() {
        return databaseLabelTable;
    }

    public static void setDatabaseLabelTable(String databaseLabelTable) {
        ConfigServlet.databaseLabelTable = databaseLabelTable;
    }

    public static String getDatabasePassword() {
        return databasePassword;
    }

    public static void setDatabasePassword(String databasePassword) {
        ConfigServlet.databasePassword = databasePassword;
    }

    public static String getDatabaseUserName() {
        return databaseUserName;
    }

    public static void setDatabaseUserName(String databaseUserName) {
        ConfigServlet.databaseUserName = databaseUserName;
    }

    public static String getJdbcUrlGisdata() {
        return jdbcUrlGisdata;
    }

    public static void setJdbcUrlGisdata(String jdbcUrlGisdata) {
        ConfigServlet.jdbcUrlGisdata = jdbcUrlGisdata;
    }

    public static String getJdbcUrlKaartenbalie() {
        return jdbcUrlKaartenbalie;
    }

    public static void setJdbcUrlKaartenbalie(String jdbcUrlKaartenbalie) {
        ConfigServlet.jdbcUrlKaartenbalie = jdbcUrlKaartenbalie;
    }
    // </editor-fold>
}
