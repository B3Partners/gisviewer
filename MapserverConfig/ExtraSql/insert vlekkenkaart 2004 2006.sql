INSERT INTO vlekkenkaart2004_2006 v(the_geom)
	select buffer(new.the_geom,20) from dgn new where Disjoint(new.the_geom,(select old.the_geom from v7 old order by distance (new.the_geom,old.the_geom) limit 1));

INSERT INTO vlekkenkaart2004_2006 v(the_geom)
	select buffer(old.the_geom,20) from v7 old where Disjoint(old.the_geom,(select new.the_geom from dgn new order by distance (new.the_geom,old.the_geom) limit 1));