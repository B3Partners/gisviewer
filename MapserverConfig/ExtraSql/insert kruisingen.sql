INSERT INTO kruisingen(
            kruisende_straatnaam, the_geom)
    select n.stt_naam, multi(endpoint(n.the_geom)) from nwb n 
	where lower(n.wegbehsrt) = 'g' and
		(Touches(endpoint(n.the_geom),(select n1.the_geom from nwb n1 
			where lower(n1.wegbehsrt) = 'p' and n1.wegnummer = 'N632' 
			order by distance(n.the_geom,n1.the_geom) limit 1)) );
