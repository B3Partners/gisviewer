DELETE FROM hm_dwarsstrepen;
INSERT INTO hm_dwarsstrepen(
            n_nr, hm, the_geom)
    select h.n_nr, h.hm,_maak_hm_dwarsstreep(h.the_geom,200) from verv_nwb_hmn_p h;
