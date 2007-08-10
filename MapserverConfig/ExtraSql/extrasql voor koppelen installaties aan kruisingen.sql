--85
UPDATE installatie i
   SET kruising_id= (select k.id from kruisingen k where k.prov_wegnr=i.wegnnr and position(i.straatnaam in k.zijweg_naam) > 0 LIMIT 1)
 WHERE kruising_id is null;
--82
UPDATE installatie i
   SET kruising_id= (select k.id from kruisingen k where k.prov_wegnr=i.wegnnr and length(i.straatnaam)>20 and position(substring(i.straatnaam from 0 for 20) in k.zijweg_naam) > 0 LIMIT 1)
 WHERE kruising_id is null;
--82
UPDATE installatie i
   SET kruising_id= (select k.id from kruisingen k where k.prov_wegnr=i.wegnnr and length(i.straatnaam)>6 and position(substring(i.straatnaam from 1 for length(i.straatnaam)-1) in k.zijweg_naam) > 0 LIMIT 1)
 WHERE kruising_id is null;
--82
UPDATE installatie i
   SET kruising_id= (select k.id from kruisingen k where k.prov_wegnr=i.wegnnr and length(i.straatnaam)>15 and position(substring(i.straatnaam from 0 for 20) in k.zijweg_naam) > 0 LIMIT 1)
 WHERE kruising_id is null;
--82
UPDATE installatie i
   SET kruising_id= (select k.id from kruisingen k where k.prov_wegnr=i.wegnnr and length(i.straatnaam)>8 and position(substring(i.straatnaam from 3 for length(i.straatnaam)-3) in k.zijweg_naam) > 0 LIMIT 1)
 WHERE kruising_id is null;
--82
UPDATE installatie i
   SET kruising_id= (select k.id from kruisingen k where k.prov_wegnr=i.wegnnr and length(i.straatnaam)>10 and position(substring(i.straatnaam from 0 for 10) in k.zijweg_naam) > 0 LIMIT 1)
 WHERE kruising_id is null;
--71
UPDATE installatie i
   SET kruising_id= (select k.id from kruisingen k where k.prov_wegnr=i.wegnnr and length(i.straatnaam)>10 and position(substring(i.straatnaam from 5 for length(i.straatnaam)-5) in k.zijweg_naam) > 0 LIMIT 1)
 WHERE kruising_id is null;
--65
UPDATE installatie i
   SET kruising_id= (select k.id from kruisingen k where k.prov_wegnr=i.wegnnr and length(i.straatnaam)>5 and position(substring(i.straatnaam from 0 for 5) in k.zijweg_naam) > 0 LIMIT 1)
 WHERE kruising_id is null;
--57
UPDATE installatie i
   SET kruising_id= (select k.id from kruisingen k where k.prov_wegnr=i.wegnnr and length(i.straatnaam)>12 and position(substring(i.straatnaam from 7 for length(i.straatnaam)-7) in k.zijweg_naam) > 0 LIMIT 1)
 WHERE kruising_id is null;
--52
UPDATE installatie i
   SET kruising_id= (select k.id from kruisingen k where k.prov_wegnr=i.wegnnr and length(i.straatnaam)>14 and position(substring(i.straatnaam from 9 for length(i.straatnaam)-9) in k.zijweg_naam) > 0 LIMIT 1)
 WHERE kruising_id is null;
--42