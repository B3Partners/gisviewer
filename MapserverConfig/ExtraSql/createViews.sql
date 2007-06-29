-- De 3 views zijn nodig omdat niet alle dtb data getoond moet worden in de data preferred laag. Deze views worden gebruikt in mapserver.

create view dtb_lines_preferred as
SELECT d.oid, d.igds_class, d.igds_style, d.igds_weight, d.igds_color, d.igds_graphic_group, d.igds_level, d.igds_color_blue, d.igds_color_green, d.igds_color_red, d.igds_fill_color, d.igds_fill_color_blue, d.igds_fill_color_green, d.igds_fill_color_red, d.igds_level_comment, d.igds_level_group_id, d.igds_level_name, d.igds_rotation, d.the_geom
   FROM dtb_lines d
  WHERE d.igds_level = 11 OR d.igds_level = 68 OR d.igds_level = 70 OR d.igds_level = 72 OR d.igds_level = 75 OR d.igds_level = 78 OR d.igds_level = 79 OR d.igds_level = 80 OR d.igds_level = 81 OR d.igds_level = 83 OR d.igds_level = 84 OR d.igds_level = 85 OR d.igds_level = 86 OR d.igds_level = 88 OR d.igds_level = 89 OR d.igds_level = 90 OR d.igds_level = 91 OR d.igds_level = 93 OR d.igds_level = 96 OR d.igds_level = 99;
  
create view dtb_points_preferred as
SELECT d.oid, d.igds_class, d.igds_style, d.igds_weight, d.igds_color, d.igds_graphic_group, d.igds_level, d.igds_color_blue, d.igds_color_green, d.igds_color_red, d.igds_fill_color, d.igds_fill_color_blue, d.igds_fill_color_green, d.igds_fill_color_red, d.igds_level_comment, d.igds_level_group_id, d.igds_level_name, d.igds_rotation, d.the_geom
	FROM dtb_points d
	WHERE d.igds_level = 11 OR d.igds_level = 68 OR d.igds_level = 70 OR d.igds_level = 72 OR d.igds_level = 75 OR d.igds_level = 78 OR d.igds_level = 79 OR d.igds_level = 80 OR d.igds_level = 81 OR d.igds_level = 83 OR d.igds_level = 84 OR d.igds_level = 85 OR d.igds_level = 86 OR d.igds_level = 88 OR d.igds_level = 89 OR d.igds_level = 90 OR d.igds_level = 91 OR d.igds_level = 93 OR d.igds_level = 96 OR d.igds_level = 99;

create view dtb_polygons_preferred as
SELECT d.oid, d.igds_class, d.igds_style, d.igds_weight, d.igds_color, d.igds_graphic_group, d.igds_level, d.igds_color_blue, d.igds_color_green, d.igds_color_red, d.igds_fill_color, d.igds_fill_color_blue, d.igds_fill_color_green, d.igds_fill_color_red, d.igds_level_comment, d.igds_level_group_id, d.igds_level_name, d.igds_rotation, d.the_geom
	FROM dtb_polygons d
	WHERE d.igds_level = 11 OR d.igds_level = 68 OR d.igds_level = 70 OR d.igds_level = 72 OR d.igds_level = 75 OR d.igds_level = 78 OR d.igds_level = 79 OR d.igds_level = 80 OR d.igds_level = 81 OR d.igds_level = 83 OR d.igds_level = 84 OR d.igds_level = 85 OR d.igds_level = 86 OR d.igds_level = 88 OR d.igds_level = 89 OR d.igds_level = 90 OR d.igds_level = 91 OR d.igds_level = 93 OR d.igds_level = 96 OR d.igds_level = 99;