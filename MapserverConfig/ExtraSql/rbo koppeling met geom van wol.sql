UPDATE rbo r
   SET id_wol= (select w.id from beh_10_wwl_m w where w.prov_nr = r.provwegnr LIMIT 1);