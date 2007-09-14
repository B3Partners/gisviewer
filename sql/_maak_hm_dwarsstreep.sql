-- Function: _maak_hm_dwarsstreep(hmpoint geometry, lengte_streep integer)

-- DROP FUNCTION _maak_hm_dwarsstreep(hmpoint geometry, lengte_streep integer);

CREATE OR REPLACE FUNCTION _maak_hm_dwarsstreep(hmpoint geometry, lengte_streep integer)
  RETURNS geometry AS
$BODY$DECLARE
	paramhmpoint geometry;
	nearestroad geometry;
	angle double precision;
	xtrans double precision;
	ytrans double precision;
BEGIN
	paramhmpoint=hmpoint;
	IF GeometryType(paramhmpoint)='MULTIPOINT' THEN
		paramhmpoint=GeometryN(hmpoint,1);
	END IF;
	nearestroad := w.the_geom from beh_10_wwl_m w order by distance(paramhmpoint,w.the_geom) LIMIT 1;
	angle := _direction_nearest_line(nearestroad,paramhmpoint,90);
	-- angle from deg to rad
	angle:= (pi()/180) * angle;
	xtrans := cos(angle)*(lengte_streep/2);
	ytrans := sin(angle)*(lengte_streep/2);
	IF xtrans = 0 OR ytrans= 0 THEN
		return null;
	END IF;	
	return MakeLine(Translate(paramhmpoint,xtrans,ytrans,0.0),Translate(paramhmpoint,-xtrans,-ytrans,0.0));
END;$BODY$
  LANGUAGE 'plpgsql' IMMUTABLE STRICT;
ALTER FUNCTION _maak_hm_dwarsstreep(hmpoint geometry, lengte_streep integer) OWNER TO postgres;