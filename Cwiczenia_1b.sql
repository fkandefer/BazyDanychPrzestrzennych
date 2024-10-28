--podpunkt 1
select matchid, player
from gole
WHERE gole.teamid = 'POL';

--podpunkt 2
select *
from gole
WHERE gole.player = 'Jakub Blaszczykowski'
  AND gole.matchid = 1004;

--podpunkt 3
select g.player, g.teamid, m.stadium, m.mdate
from mecze m
         JOIN gole g ON id = matchid
WHERE g.teamid = 'POL';

--podpunkt 4
select m.team1, m.team2, g.player
from mecze m
         JOIN gole g ON id = matchid
WHERE g.player like 'Mario%';

--podpunkt 5
select g.player, g.teamid,  d.coach, g.gtime
from gole g
         JOIN druzyny d ON g.teamid = d.id
WHERE g.gtime < 10;

--podpunkt 6
select d.teamname, d.coach, m.mdate, m.stadium
from druzyny d
            JOIN mecze m ON d.id = m.team1 OR d.id = m.team2
    WHERE d.coach = 'Franciszek Smuda';

--podpunkt 7
select g.player
from gole g
            JOIN mecze m ON g.matchid = m.id
WHERE m.stadium = 'National Stadium, Warsaw'
group by g.player;

--podpunkt 8
select  g.player, g.gtime
from mecze m
            JOIN gole g ON g.matchid = m.id
where m.team1 = 'GER' OR m.team2 = 'GER' AND g.teamid <> 'GER';

--podpunkt 9
select d.teamname, count(g.player)
from druzyny d
         JOIN gole g ON d.id = g.teamid
group by d.teamname
order by count(g.player) desc;

--podpunkt 10
select m.stadium, count(g.player)
from mecze m
         JOIN gole g ON m.id = g.matchid
group by m.stadium
order by count(g.player) desc;
