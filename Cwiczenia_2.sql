
--3
create extension postgis;


--4
create table buildings (
  id int primary key,
  geom geometry(Polygon, 0),
  name text
);

create table roads (
  id int primary key,
  geom geometry(LineString, 0),
  name text
);

create table poi(
    id int primary key,
    geom geometry(Point, 0),
    name text
    );

--5
insert into buildings
values
(1, ST_GeomFromText('POLYGON((8 4, 10.5 4, 10.5 1.5, 8 1.5, 8 4))'), 'Building A'),
(2, ST_GeomFromText('POLYGON((4 5, 4 7, 6 7, 6 5, 4 5))'), 'Building B'),
(3, ST_GeomFromText('POLYGON((3 6, 3 8, 5 8, 5 6, 3 6))'), 'Building C'),
(4, ST_GeomFromText('POLYGON((9 8, 9 9, 10 9, 10 8, 9 8))'), 'Building D'),
(6, ST_GeomFromText('POLYGON((1 2, 2 2, 2 1, 1 1, 1 2))'), 'Building F');

insert into roads
values
(1, ST_GeomFromText('LINESTRING(0 4.5, 12 4.5)'), 'Road X'),
(2, ST_GeomFromText('LINESTRING(7.5 0, 7.5 10.5)'), 'Road Y');

insert into poi
values
(1, ST_GeomFromText('POINT(1 3.5)'), 'G'),
(2, ST_GeomFromText('POINT(5.5 1.5)'), 'H'),
(3, ST_GeomFromText('POINT(9.5 6)'), 'I'),
(4, ST_GeomFromText('POINT(6.5 6)'), 'J'),
(5, ST_GeomFromText('POINT(6 9.5)'), 'K');


--6a
select sum(st_length(geom)) as length
from roads;


--6b
select st_asewkt(geom) as wkt, st_area(geom) as pole, st_perimeter(geom) as obwód
from buildings
where name LIKE '%A%';


--6c
select name as nazwa, st_area(geom) as pole
from buildings
order by name;


--6d
select name as nazwa, st_area(geom) as pole
from buildings
order by st_area(geom) desc
limit 2;


--6e
select st_distance(buildings.geom , poi.geom) as odleglosc
from buildings, poi
where buildings.name = 'Building C' and poi.name = 'K';


--6f
select st_area(st_difference(b1.geom, st_buffer(b2.geom, 0.5))) as powierzchnia
from buildings b1, buildings b2
where b1.name = 'Building C' and b2.name = 'Building B';


--6g
select buildings.name as budynki
from buildings, roads r1
where r1.name= 'Road X' and st_y(st_centroid(buildings.geom)) > st_y(st_centroid(r1.geom));


--6h
select st_area(st_symdifference(b1.geom, ST_GeomFromText('POLYGON((4 7, 6 7, 6 8, 4 8, 4 7))'))) as powierzchnia
from buildings b1
where b1.name = 'Building C';
