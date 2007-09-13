-- Function: _puntopweg(weg_nnr character varying, aantalkmopweg double precision)

-- DROP FUNCTION _puntopweg(weg_nnr character varying, aantalkmopweg double precision);

CREATE OR REPLACE FUNCTION _puntopweg(weg_nnr character varying, aantalkmopweg double precision)
  RETURNS geometry AS
$BODY$DECLARE
	wollijn geometry;
	hmgeom geometry;
	hmrecord verv_nwb_hmn_p%ROWTYPE;
	hmrecord2 verv_nwb_hmn_p%ROWTYPE;	
	dichtstbijhmwaarde double precision;
	hmteller double precision;
	zoekwaarde double precision;
	hmpaal2waarde double precision;
	hmline geometry;
	meerwaardetovbeginpunt double precision;
	mindistance double precision;
	nearestlinestring geometry;
	waardeoplijn double precision;
	whileteller int;
BEGIN
	--haal het dichtsbij liggende hectometer record op
	SELECT INTO hmrecord * from verv_nwb_hmn_p h where lower(h.n_nr) = lower(weg_nnr) AND ( ((CAST(h.hm AS FLOAT)-aantalkmopweg)*(CAST(h.hm AS FLOAT)-aantalkmopweg))= (select min((CAST(h.hm AS FLOAT)-aantalkmopweg)*(CAST(h.hm AS FLOAT)-aantalkmopweg)) from verv_nwb_hmn_p h where lower(h.n_nr) = lower(weg_nnr) LIMIT 1)) LIMIT 1;
	-- cast de waarde van de hectometer paal in dichtsthmwaarde
	dichtstbijhmwaarde := CAST(hmrecord.hm AS FLOAT);
	-- als de dichts bij liggende waarde gelijk is aan de aantalkmop weg dan is het precies ter hoogte van dit hm bord
	IF dichtstbijhmwaarde = aantalkmopweg THEN
		hmgeom:=hmrecord.the_geom;
	ELSE
		-- als de dichts bij liggende waarde groter of kleiner is als de opgegeven dan moet een 2de hm gevonden worden bij kleiner door een hogere te vinden en bij hoger door een kleinere te vinden.
		--bepaal de meerwaarde van de opgegeven km tov de kleinste hm
		zoekwaarde := 0.5;
		meerwaardetovbeginpunt := aantalkmopweg-dichtstbijhmwaarde;
		IF dichtstbijhmwaarde > aantalkmopweg THEN
			zoekwaarde := -0.5;
			meerwaardetovbeginpunt := dichtstbijhmwaarde-aantalkmopweg;
		END IF;
		-- gebruik hmteller voor het benaderen van een 2de hm paal.
		hmteller := aantalkmopweg;
		hmpaal2waarde := dichtstbijhmwaarde;
		--voor de zekerheid een teller laten meelopen zodat het niet een oneindige while is.
		whileteller:=0;
		WHILE hmpaal2waarde = dichtstbijhmwaarde AND whileteller < 10 LOOP
			whileteller:=whileteller+1;
			hmteller:=hmteller+zoekwaarde;
			SELECT INTO hmrecord2 * from verv_nwb_hmn_p h where lower(h.n_nr) = lower(weg_nnr) AND ( ((CAST(h.hm AS FLOAT)-hmteller)*(CAST(h.hm AS FLOAT)-hmteller))= (select min((CAST(h.hm AS FLOAT)-hmteller)*(CAST(h.hm AS FLOAT)-hmteller)) from verv_nwb_hmn_p h where lower(h.n_nr) = lower(weg_nnr) LIMIT 1)) limit 1;
			hmpaal2waarde:=CAST(hmrecord2.hm AS FLOAT);
		END LOOP;
		-- maak een lijn van de 2 punten
		hmline := MakeLine(GeometryN(hmrecord.the_geom,1),GeometryN(hmrecord2.the_geom,1));
		
		--Als de meerwaardetovbeginpunt groter is dan de lengte dan moet die waarde de lengte worden
		IF meerwaardetovbeginpunt > Length(hmline) THEN
			meerwaardetovbeginpunt:=Length(hmline);
		END IF;
		--bepaal hoever het punt op de lijn ligt (tussen 0 en 1)
		IF Length(hmline) = 0 OR meerwaardetovbeginpunt = 0 THEN
			waardeoplijn=0;
		ELSE
			waardeoplijn:=(Length(hmline)/meerwaardetovbeginpunt);
		END IF;		
		IF waardeoplijn < 0 THEN
			waardeoplijn:=0;
		ELSE IF waardeoplijn > 1 THEN
			waardeoplijn:=1;
			END IF;
		END IF;
		--Zoek het punt op de line tussen de 2 hm palen
		hmgeom:=line_interpolate_point(hmline, waardeoplijn);
	END IF;
	--zoek de dichtsbij liggend wol lijn
	wollijn:= w.the_geom from beh_10_wwl_m w where lower(w.prov_nr) = lower(weg_nnr) order by distance(w.the_geom,hmgeom) LIMIT 1;
	wollijn:=linemerge(wollijn);
	--als het punt een multi point is dan moet het een punt worden (de eerste er uit halen)
	IF GeometryType(hmgeom)= 'MULTIPOINT' THEN
		hmgeom= GeometryN(hmgeom,1);
	END IF;
	--als de wol een multilinestring is dan de dichtsbijliggende wol gedeelte nemen.
	IF GeometryType(wollijn) = 'MULTILINESTRING' THEN
		mindistance := (distance(hmgeom,wollijn)+1000);
		FOR i IN 1 .. NumGeometries(wollijn) LOOP
			IF distance(hmgeom,GeometryN(wollijn,i)) < mindistance THEN
			    mindistance:=distance(hmgeom,GeometryN(wollijn,i));
			    nearestlinestring:=GeometryN(wollijn,i);
			END IF;
		END LOOP;
		wollijn:=nearestlinestring;
	END IF;	
	return line_interpolate_point(wollijn,line_locate_point(wollijn,hmgeom));	
END;$BODY$
  LANGUAGE 'plpgsql' IMMUTABLE STRICT;
ALTER FUNCTION _puntopweg(weg_nnr character varying, aantalkmopweg double precision) OWNER TO postgres;
