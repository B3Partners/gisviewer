INSERT INTO vlekkenkaart2004_2006 (the_geom)
	select buffer(n.the_geom,20) from dgn n where Disjoint(n.the_geom,(select o.the_geom from v7 o order by distance (n.the_geom,o.the_geom) limit 1));

--INSERT INTO vlekkenkaart2004_2006 (the_geom)
--	select buffer(o.the_geom,20) from v7 o where Disjoint(o.the_geom,(select n.the_geom from dgn n order by distance (n.the_geom,o.the_geom) limit 1));