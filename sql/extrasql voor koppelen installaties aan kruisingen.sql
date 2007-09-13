Update Installatie i
	set kruising_id=null;

UPDATE installatie i
   SET kruising_id= (select k.id from kruisingen k where lower(k.zijweg_naam) = lower(i.straatnaam) and lower(i.wegnnr)=lower(k.prov_wegnr) limit 1);

UPDATE installatie i
   SET kruising_id= (select k.id from kruisingen k where lower(i.wegnnr)=lower(k.prov_wegnr) and position(lower(k.zijweg_naam) in lower(i.straatnaam))>0 limit 1);
