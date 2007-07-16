update markeringen m
	set the_geom= line_substring((select w.the_geom from beh_10_wwl_m w where w.weg_id = m.wegnr),m.van_km,m.tot_km) where m.van_km != null and m.tot_km != null