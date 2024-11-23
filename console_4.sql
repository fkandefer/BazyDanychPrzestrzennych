-- zadanie 1

create table obiekty (
    nazwa text ,
    geometria  geometry
    );

insert into obiekty (nazwa, geometria)
values ( 'obiekt1',  st_collect(
        st_geomfromtext('multilinestring((0 1, 1 1), (5 1, 6 1))'),
        st_geomfromtext('circularstring(1 1, 2 0, 3 1, 4 2, 5 1)')
        )),
          ( 'obiekt2',
           st_collect(
                   st_collect(
                           st_geomfromtext('linestring(10 2, 10 6, 14 6)'),
                           st_geomfromtext('circularstring(10 2, 12 0, 14 2, 16 4, 14 6)')
                   ),
                   st_geomfromtext('circularstring(11 2, 13 2, 11 2)')
           )
       ),
            ( 'obiekt3',
             st_geomfromtext('linestring(7 15, 10 17, 12 13, 7 15)')
             ),
            ( 'obiekt4',
             st_geomfromtext('linestring(20 20, 25 25, 27 24, 25 22, 26 21, 22 19, 20.5 19.5)')
             ),
       ('obiekt5',
        st_collect(
                st_geomfromtext('pointz(30 30 59)'),
                st_geomfromtext('pointz(38 32 234)')
        )),
    ( 'obiekt6',
      st_collect(
          st_geomfromtext('linestring(1 1, 3 2)'),
          st_geomfromtext('linestring(4 2,4 2)')
      )
    );


-- zadanie 2

select st_area(st_buffer(st_shortestline((select geometria from obiekty where nazwa = 'obiekt3'),
    (select geometria from obiekty where nazwa = 'obiekt4' )), 5)) as pole_bufora;

-- zadanie 3

update obiekty
set geometria = st_geomfromtext('linestring(20 20, 25 25, 27 24, 25 22, 26 21, 22 19, 20.5 19.5, 20 20)')
where nazwa = 'obiekt4';

update obiekty
set geometria = st_makepolygon(geometria)
where nazwa = 'obiekt4';

select st_geometrytype(geometria)
    from obiekty where nazwa = 'obiekt4';

-- zadanie 3

insert into obiekty (nazwa, geometria)
values ('obiekt7',
        st_union(
                (select geometria from obiekty where nazwa = 'obiekt3'),
                (select geometria from obiekty where nazwa = 'obiekt4')
        )
);


-- zadanie 4

SELECT  sum(ST_Area(
               ST_Buffer(geometria, 5)))
                   FROM obiekty as pole
                   WHERE ST_HasArc(geometria) = false;


drop table obiekty;