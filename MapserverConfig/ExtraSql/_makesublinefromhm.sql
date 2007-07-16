-- Function: _makesublinefromhm(paramhm1 character varying, paramhm2 character varying, paramwegnr character varying)

-- DROP FUNCTION _makesublinefromhm(paramhm1 character varying, paramhm2 character varying, paramwegnr character varying);

CREATE OR REPLACE FUNCTION _makesublinefromhm(paramhm1 character varying, paramhm2 character varying, paramwegnr character varying)
  RETURNS geometry AS
$BODY$DECLARE
	line geometry;
	hm1 geometry;
	hm2 geometry;
	h1 float;
	h2 float;
	returnvalue geometry;
	linelocate1 float;
	linelocate2 float;
BEGIN
	h1= CAST (paramhm1 as float);
	h2= CAST (paramhm2 as float);
	line= w.the_geom from beh_10_wwl_m w where w.prov_nr = paramwegnr order by distance(hm1,w.the_geom) LIMIT 1;
	--hm1 = h.the_geom from verv_nwb_hmn_p h where h.n_nr = paramwegnr AND ( ((CAST(h.hm AS FLOAT)-h1)*(CAST(h.hm AS FLOAT)-h1))= (select min((CAST(h.hm AS FLOAT)-h1)*(CAST(h.hm AS FLOAT)-CAST(paramhm1 AS FLOAT))) from verv_nwb_hmn_p h where h.n_nr = paramWegnr LIMIT 1)) limit 1;
	--hm2 = h.the_geom from verv_nwb_hmn_p h where h.n_nr = paramwegnr AND ( ((CAST(h.hm AS FLOAT)-h2)*(CAST(h.hm AS FLOAT)-h2))= (select min((CAST(h.hm AS FLOAT)-h2)*(CAST(h.hm AS FLOAT)-CAST(paramhm2 AS FLOAT))) from verv_nwb_hmn_p h where h.n_nr = paramWegnr LIMIT 1)) limit 1;
	hm1 = _puntopweg(paramwegnr,h1);
	hm2 = _puntopweg(paramwegnr,h2);
	IF GeometryType(hm1)= 'MULTIPOINT' THEN
		hm1=GeometryN(hm1,1);
	END IF;
	IF GeometryType(hm2)= 'MULTIPOINT' THEN
		hm2=GeometryN(hm2,1);
	END IF;
	line = linemerge(line);
	line= GeomUnion(line);
	--RETURN line;
	--return hm1;
	IF GeometryType(line)='LINESTRING' THEN
		linelocate1=line_locate_point(line,hm1);
		linelocate2=line_locate_point(line,hm2);
		IF linelocate1 > linelocate2 THEN
			returnvalue= line_substring(line,linelocate2,linelocate1);
		ELSE
			returnvalue= line_substring(line,linelocate1,linelocate2);
		END IF;
	ELSE
		returnvalue= null;
	END IF;
	IF GeometryType(returnvalue)='LINESTRING' THEN
		RETURN returnvalue;
	ELSE
		RETURN null;
	END IF;
	
END;$BODY$
  LANGUAGE 'plpgsql' IMMUTABLE STRICT;
ALTER FUNCTION _makesublinefromhm(paramhm1 character varying, paramhm2 character varying, paramwegnr character varying) OWNER TO postgres;
