update dvm d set 
the_geom = (select multi(_puntopweg(d.pw,d.hm)) from dvm d1 where d1.id = d.id);