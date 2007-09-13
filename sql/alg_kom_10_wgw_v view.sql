-- View: "algm_kom_10_wgw_v"

-- DROP VIEW algm_kom_10_wgw_v;

CREATE OR REPLACE VIEW algm_kom_10_wgw_v AS 
 SELECT a.kom, a.gemeente, a.nr_prov_bl, a.begindatum, a.einddatum, a.shape_area, a.shape_len, a.the_geom, a.id
   FROM algm_kom_10_wgw a
  WHERE a.einddatum IS NULL OR a.einddatum > now();

ALTER TABLE algm_kom_10_wgw_v OWNER TO postgres;