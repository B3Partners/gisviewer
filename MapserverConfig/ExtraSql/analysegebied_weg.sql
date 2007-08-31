INSERT INTO analysegebied_weg(
          wegnummer, the_geom)
    select w.prov_nr, multi(buffer(w.the_geom,50)) FROM beh_10_wwl_m w where end_date is null OR end_date > now();
