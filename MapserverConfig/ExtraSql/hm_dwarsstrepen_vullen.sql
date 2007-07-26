--DELETE FROM hm_dwarsstrepen;
--INSERT INTO hm_dwarsstrepen(
  --          n_nr, hm, the_geom)
    -- select h.n_nr, h.hm,_maak_hm_dwarsstreep(h.the_geom,h.hm,h.n_nr,100) from verv_nwb_hmn_p h;

update hm_dwarsstrepen hu
	set richting=(select _direction_nearest_line (w.the_geom,h.the_geom,90) from verv_nwb_hmn_p h, beh_10_wwl_m w where h.hm= hu.hm and h.n_nr = hu.n_nr order by distance(h.the_geom,w.the_geom) limit 1);