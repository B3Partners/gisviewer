/*
 * B3P Gisviewer is an extension to Flamingo MapComponents making
 * it a complete webbased GIS viewer and configuration tool that
 * works in cooperation with B3P Kaartenbalie.
 *
 * Copyright 2006, 2007, 2008 B3Partners BV
 * 
 * This file is part of B3P Gisviewer.
 * 
 * B3P Gisviewer is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * B3P Gisviewer is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with B3P Gisviewer.  If not, see <http://www.gnu.org/licenses/>.
 */
package nl.b3p.gis.viewer.db;

import java.sql.DriverManager;
import java.sql.SQLException;

/**
 *
 * @author Roy Braam
 */
public class Connecties {

    public static final String TYPE_JDBC = "jdbc";
    public static final String TYPE_WFS = "wfs";
    public static final String DIALECT_POSTGRESQL = "postgresql";
    public static final String DIALECT_MYSQL = "mysql";
    private int id;
    private String naam;
    private String connectie_url;
    private String gebruikersnaam;
    private String wachtwoord;
    private String type;
    private String dialect;

    /** Creates a new instance of Connectie */
    public Connecties() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getNaam() {
        return naam;
    }

    public void setNaam(String naam) {
        this.naam = naam;
    }

    public String getConnectie_url() {
        return connectie_url;
    }

    public void setConnectie_url(String connectie_url) {
        this.connectie_url = connectie_url;
        type = null;
        dialect = null;
        if (connectie_url != null && connectie_url.length() > 0) {
            //controleer of het een jdbc connectie is
            if (connectie_url.toLowerCase().startsWith("jdbc:")) {
                this.setType(TYPE_JDBC);
                //als postgres is:                
                if (connectie_url.toLowerCase().substring(5, connectie_url.length()).startsWith("postgresql:")) {
                    this.setDialect(DIALECT_POSTGRESQL);
                } else if (connectie_url.toLowerCase().substring(5, connectie_url.length()).startsWith("mysql:")) {
                    this.setDialect(DIALECT_MYSQL);
                }
            } else {
                this.setType(TYPE_WFS);
            }
        }
    }

    public String getGebruikersnaam() {
        return gebruikersnaam;
    }

    public void setGebruikersnaam(String gebruikersnaam) {
        this.gebruikersnaam = gebruikersnaam;
    }

    public String getWachtwoord() {
        return wachtwoord;
    }

    public void setWachtwoord(String wachtwoord) {
        this.wachtwoord = wachtwoord;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getDialect() {
        return dialect;
    }

    public void setDialect(String dialect) {
        this.dialect = dialect;
    }

    public java.sql.Connection getJdbcConnection() throws SQLException {
        if (getType().equalsIgnoreCase(TYPE_JDBC)) {
            if (getDialect().equalsIgnoreCase(DIALECT_POSTGRESQL)) {
                DriverManager.registerDriver(new org.postgresql.Driver());
            } else if (getDialect().equalsIgnoreCase(DIALECT_MYSQL)) {
                DriverManager.registerDriver(new com.mysql.jdbc.Driver());
            } else {
                return null;
            }
            return DriverManager.getConnection(this.getConnectie_url(), getGebruikersnaam(), getWachtwoord());
        } else {
            return null;
        }

    }
}
