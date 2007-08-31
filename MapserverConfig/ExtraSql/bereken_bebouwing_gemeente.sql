UPDATE algm_grs_2006_1_gem_v g
   SET oppbebouwing=(select round(sum(Area(intersection(b.the_geom,g.the_geom)))) from algm_kom_10_wgw_v b where intersects(g.the_geom,b.the_geom))
 
