INSERT INTO vlekkenkaart1999_2006(
            the_geom)
    select multi(buffer(d.the_geom,20)) from dgn_0_14 d where _is_vlek1999(d.the_geom);
INSERT INTO vlekkenkaart1999_2006(
            the_geom)
    select multi(buffer(d.the_geom,20)) from dxf_0_14 d where _is_vlek19992(d.the_geom);