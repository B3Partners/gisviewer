-- Function: _vul_hm_dwarsstreep(wegnr character varying, hmnr character varying, lengte_streep integer)

-- DROP FUNCTION _vul_hm_dwarsstreep(wegnr character varying, hmnr character varying, lengte_streep integer);

CREATE OR REPLACE FUNCTION _create_vlekken_new(geom geometry)
  RETURNS character varying AS
$BODY$DECLARE
	closest geometry;	
BEGIN
	closest = select old.the_geom from v7 old order by distance(geom,old.the_geom) LIMIT 1;
	IF (Disjoint(geom,closest)) THEN
		insert into vlekkenkaart2004_2006 (the_geom) values (buffer(geom,20));
	ELSE
	END IF;
END;$BODY$
  LANGUAGE 'plpgsql' IMMUTABLE STRICT;
