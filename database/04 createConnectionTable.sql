CREATE TABLE connecties
(
   id serial, 
   naam character varying(100) NOT NULL, 
   connectie_url character varying(255), 
   gebruikersnaam character varying(50), 
   wachtwoord character varying(50), 
    PRIMARY KEY (id)
) WITHOUT OIDS;

ALTER TABLE themas ADD CONSTRAINT themas_connecties_fkey FOREIGN KEY (connectie) REFERENCES connecties (id)    ON UPDATE NO ACTION ON DELETE NO ACTION;

