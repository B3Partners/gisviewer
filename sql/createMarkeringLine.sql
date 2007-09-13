update markeringen m
	set the_geom= multi(_makesublinefromhm(CAST(m.van_km/1000 AS VARCHAR),cast(m.tot_km/1000 AS VARCHAR), m.wegnr,false)); 