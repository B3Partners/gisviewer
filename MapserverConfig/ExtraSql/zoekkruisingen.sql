select * from nwb n 
	where lower(n.wegbehsrt) = 'g' and 
		(Touches(endpoint(n.the_geom),(select n1.the_geom from nwb n1 
			where lower(n1.wegbehsrt) = 'p' 
			order by distance(n.the_geom,n1.the_geom) limit 1)) 
		or 
		Touches(startpoint(n.the_geom),(select n1.the_geom from nwb n1 
			where lower(n1.wegbehsrt) = 'p' 
			order by distance(n.the_geom,n1.the_geom) limit 1))
		);