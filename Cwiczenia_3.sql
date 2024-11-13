-- zadanie 1
create temporary table buildings as
select a.polygon_id, a.geom from buildings_2019 as a
                                     left join buildings_2018 as b on st_within(a.geom, b.geom)
where a.geom is distinct from b.geom;

-- zadanie 2
select a.type, count(*)from t2019_kar_poi_table as a
                                left join t2018_kar_poi_table as b on a.poi_id = b.poi_id
                                join buildings as c on st_within(a.geom, st_buffer(c.geom, 500))
where a.geom is distinct from b.geom
group by a.type;

-- zadanie 3
create table streets_reprojected as
    select gid, link_id, st_name, ref_in_id, nref_in_id, func_class, speed_cat, fr_speed_l,
           to_speed_l, dir_travel, ST_Transform(ST_SetSRID(geom, 4326), 3068) as geom from t2019_kar_streets;

-- zadanie 4
create table input_points (id integer, geom geometry);
insert into input_points (id, geom)
values (1,st_setsrid(st_makepoint(8.36093, 49.03174), 4326)),
           (2,st_setsrid(st_makepoint(8.39876, 49.00644), 4326));

-- zadanie 5
update input_points
set geom = ST_Transform(geom, 4314);

-- zadanie 6
select n.* from t2019_kar_streets_node as n
join (
    select ST_MakeLine(geom order by id) as geom
    from input_points
) as line on ST_DWithin(ST_Transform(n.geom, 4314), line.geom, 200);

-- zadanie 7
select COUNT(poi.*)
from (select geom from t2019_kar_poi_table where type = 'Sporting Goods Store') as poi,
     (select geom from t2019_kar_land_use_a where type = 'Park (City/County)') as park
where ST_DWithin(poi.geom, park.geom, 300);

-- zadanie 8
create table T2019_KAR_BRIDGES as
select ST_Intersection(r.geom, w.geom) as geom
from t2019_kar_railways as r
         join t2019_kar_water_lines as w on ST_Intersects(r.geom, w.geom);

