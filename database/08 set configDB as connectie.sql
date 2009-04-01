/*
Dit script is nodig om de data die in de config database staat te laten werken!
Maar dit is natuurlijk niet de bedoeling! Plaats de data nooit in de configuratie db.
Dit is eerder wel altijd gedaan (productie kaartenbalie.nl) dus hiervoor is dit script.
Dit eerst draaien voordat je nieuwe themas gaat configureren.
*/

INSERT INTO connecties(naam,connectie_url,gebruikersnaam,wachtwoord)
VALUES('configuratie database', 'jdbc:postgresql://localhost:5432/gisviewer','gisviewer','gisviewer');

UPDATE themas
set connectie= (select max(c.id) from connecties c)
where connectie=null;
