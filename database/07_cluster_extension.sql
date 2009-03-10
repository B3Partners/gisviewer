ALTER TABLE clusters ADD COLUMN default_cluster boolean;
ALTER TABLE clusters ALTER COLUMN default_cluster SET DEFAULT false;
ALTER TABLE clusters ADD COLUMN hide_legend boolean;
ALTER TABLE clusters ALTER COLUMN hide_legend SET DEFAULT false;
ALTER TABLE clusters ADD COLUMN hide_tree boolean;
ALTER TABLE clusters ALTER COLUMN hide_tree SET DEFAULT false;
ALTER TABLE clusters ADD COLUMN background_cluster boolean;
ALTER TABLE clusters ALTER COLUMN background_cluster SET DEFAULT false;
ALTER TABLE clusters ADD COLUMN extra_level boolean;
ALTER TABLE clusters ALTER COLUMN extra_level SET DEFAULT false

update clusters set default_cluster = false;
update clusters set hide_legend = false;
update clusters set hide_tree = false;
update clusters set background_cluster = false;
update clusters set extra_level = false;

ALTER TABLE clusters ALTER COLUMN default_cluster SET NOT NULL;
ALTER TABLE clusters ALTER COLUMN hide_legend SET NOT NULL;
ALTER TABLE clusters ALTER COLUMN hide_tree SET NOT NULL;
ALTER TABLE clusters ALTER COLUMN background_cluster SET NOT NULL;
ALTER TABLE clusters ALTER COLUMN extra_level SET NOT NULL;
