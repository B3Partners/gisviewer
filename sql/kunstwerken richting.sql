--Weet niet zeker of dit de goede is.
update kunstwerken ku
	set weg_richting=(select _direction_nearest_line (w.the_geom,k.the_geom,90) from kunstwerken k, beh_10_wwl_m w where k.id= ku.id order by distance(k.the_geom,w.the_geom) limit 1);