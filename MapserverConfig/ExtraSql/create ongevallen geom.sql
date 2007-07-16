UPDATE ongevallen o1
   SET the_geom=(select multi(_makesublinefromhm(CAST(o2.hm1 AS VARCHAR),CAST(o2.hm2 AS VARCHAR),o2.wegnr)) from ongevallen o2 where o2.id=o1.id);
