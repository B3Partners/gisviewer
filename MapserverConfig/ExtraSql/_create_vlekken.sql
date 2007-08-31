-- Function: _create_vlekken_new(geom geometry)

-- DROP FUNCTION _create_vlekken_new(geom geometry);

CREATE OR REPLACE FUNCTION _create_vlekken_new(geom geometry)
  RETURNS character varying AS
$BODY$DECLARE
	closest geometry;	
BEGIN
	closest = o.the_geom from v7 o order by distance(geom,o.the_geom) LIMIT 1;
	IF (Disjoint(geom,closest)) THEN
		insert into vlekkenkaart2004_2006 (the_geom) values (buffer(geom,20));
	ELSE
	END IF;
END;$BODY$
  LANGUAGE 'plpgsql' IMMUTABLE STRICT;
ALTER FUNCTION _create_vlekken_new(geom geometry) OWNER TO root;

-- Function: _create_vlekken_old(geom geometry)

-- DROP FUNCTION _create_vlekken_old(geom geometry);

CREATE OR REPLACE FUNCTION _create_vlekken_old(geom geometry)
  RETURNS character varying AS
$BODY$DECLARE
	closest geometry;	
BEGIN
	closest = n.the_geom from dgn n order by distance(geom,n.the_geom) LIMIT 1;
	IF (Disjoint(geom,closest)) THEN
		insert into vlekkenkaart2004_2006 (the_geom) values (buffer(geom,20));
	ELSE
	END IF;
END;$BODY$
  LANGUAGE 'plpgsql' IMMUTABLE STRICT;
ALTER FUNCTION _create_vlekken_old(geom geometry) OWNER TO root;
