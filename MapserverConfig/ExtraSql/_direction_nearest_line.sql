-- Function: _direction_nearest_line(amultils geometry, amultipts geometry, rotation integer)

-- DROP FUNCTION _direction_nearest_line(amultils geometry, amultipts geometry, rotation integer);

CREATE OR REPLACE FUNCTION _direction_nearest_line(amultils geometry, amultipts geometry, rotation integer)
  RETURNS double precision AS
$BODY$DECLARE
    mindistance float8;
    nearestlinestring geometry;
    nearestpoint geometry;
    apoint geometry;
    i integer;
    angle double precision;
    pointExpand geometry;
    roadIntersect geometry;    
BEGIN
    IF amultipts = null THEN
	RETURN NULL;
    END IF;
    apoint:= GeometryN(amultipts,1);
    mindistance := min(distance(apoint,amultils));    
    pointExpand:=buffer(apoint,mindistance*1.5);
    roadIntersect:=Intersection(pointExpand,amultils);
    roadIntersect:=linemerge(roadIntersect);
    IF (x(EndPoint(roadIntersect))-x(StartPoint(roadIntersect))) = 0 THEN
	angle=90;
    ELSE
	angle:= atan((y(EndPoint(roadIntersect))-y(StartPoint(roadIntersect)))/(x(EndPoint(roadIntersect))-x(StartPoint(roadIntersect))))*(180/pi());
    END IF;
    angle:= angle+rotation;
    WHILE angle > 360 LOOP
	angle:= angle-360;
    END LOOP;
    IF angle = null THEN
	RETURN 0.0;
    ELSE
	RETURN round(angle);
    END IF;
END;
$BODY$
  LANGUAGE 'plpgsql' IMMUTABLE STRICT;
ALTER FUNCTION _direction_nearest_line(amultils geometry, amultipts geometry, rotation integer) OWNER TO postgres;

-- Function: _direction_nearest_line(amultils geometry, amultipts geometry, rotation integer)

--DROP FUNCTION _direction_nearest_line(amultils geometry, amultipts geometry, rotation integer);

CREATE OR REPLACE FUNCTION _direction_nearest_line(amultils geometry, amultipts geometry, rotation integer)
  RETURNS double precision AS
$BODY$DECLARE
    mindistance float8;
    nearestlinestring geometry;
    nearestpoint geometry;
    apoint geometry;
    i integer;
    angle double precision;
    pointExpand geometry;
    roadIntersect geometry;    
BEGIN
    IF amultipts = null THEN
	RETURN NULL;
    END IF;
    apoint:= GeometryN(amultipts,1);
    mindistance := min(distance(apoint,amultils));    
    pointExpand:=buffer(apoint,mindistance*1.5);
    roadIntersect:=Intersection(pointExpand,amultils);
    roadIntersect:=linemerge(roadIntersect);
    IF (x(EndPoint(roadIntersect))-x(StartPoint(roadIntersect))) = 0 THEN
	angle=90;
    ELSE
	angle:= atan((y(EndPoint(roadIntersect))-y(StartPoint(roadIntersect)))/(x(EndPoint(roadIntersect))-x(StartPoint(roadIntersect))))*(180/pi());
    END IF;
    angle:= angle+rotation;
    WHILE angle > 360 LOOP
	angle:= angle-360;
    END LOOP;
    RETURN round(angle);
END;
$BODY$
  LANGUAGE 'plpgsql' IMMUTABLE STRICT;
ALTER FUNCTION _direction_nearest_line(amultils geometry, amultipts geometry, rotation integer) OWNER TO postgres;

--update kunstwerken ku
--	set weg_richting=(select _direction_nearest_line (w.the_geom,k.the_geom,90) from kunstwerken k, beh_10_wwl_m w where k.id= ku.id order by distance(k.the_geom,w.the_geom) limit 1);