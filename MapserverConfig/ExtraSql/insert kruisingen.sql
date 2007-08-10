DELETE FROM kruisingen;
INSERT INTO kruisingen(
            kruisende_straatnaam, the_geom)
    select lower(n.stt_naam), multi(endpoint(n.the_geom)) from nwb n 
	where lower(n.wegbehsrt) = 'g' and
		(Touches(endpoint(n.the_geom),(select n1.the_geom from nwb n1 
			where lower(n1.wegbehsrt) = 'p'
			order by distance(n.the_geom,n1.the_geom) limit 1)) );

INSERT INTO kruisingen(
            kruisende_straatnaam, the_geom)
    select lower(n.stt_naam, multi(startpoint(n.the_geom)) from nwb n 
	where 
		-- NIET DE ZELFDE PUNTEN. MAAR UITGEZET OMDAT WE DE NAMEN NIET WETEN. DUS MOETEN WEL ALLEMAAL GEMAAKT WORDEN ZODAT ALLE MOGELIJKE NAMEN VOOR EEN KRUISPUNT ER IN STAAN.
		--NOT multi(startpoint(n.the_geom)) ~= (select n2.the_geom from nwb n2 order by distance(startpoint(n.the_geom),n2.the_geom) limit 1)and
		lower(n.wegbehsrt) = 'g' and
		(Touches(startpoint(n.the_geom),(select n1.the_geom from nwb n1 
			where lower(n1.wegbehsrt) = 'p'
			order by distance(n.the_geom,n1.the_geom) limit 1)) );

UPDATE kruisingen k
   SET prov_wegnr= (select n.wegnummer from nwb n where n.wegbehsrt='P' and TOUCHES(k.the_geom,n.the_geom) LIMIT 1);
