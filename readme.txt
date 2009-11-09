- Database van de gisviewer configuratie aanmaken (schema export in b3p-gisviewer)
- Script van de b3p-zoeker uitvoeren (schema export in b3p-zoeker). Als dit in de zelfde database kan als de gisviewer configuratie
dan is er geen aanpassing van de persistence.xml nodig.
- Context goed configureren (database connectie)
- Web.xml goed configureren (kb url)

Voor samenwerking met KB:
- in security-config de key etc. goed zetten (moet het zelfde zijn als kaartenbalie)