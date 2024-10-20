--DROP DATABASE IF EXISTS firma;
--CREATE DATABASE firma;

DROP SCHEMA IF EXISTS ksiegowosc CASCADE;
CREATE  SCHEMA ksiegowosc;

CREATE TABLE ksiegowosc.pracownicy (
                                       id_pracownika INT  NOT NULL PRIMARY KEY,
                                       imie VARCHAR(50) NOT NULL,
                                       nazwisko VARCHAR(50) NOT NULL,
                                       adres VARCHAR(100) NOT NULL,
                                       telefon VARCHAR(15)
);

CREATE TABLE ksiegowosc.godziny (
                                    id_godziny INT NOT NULL PRIMARY KEY,
                                    data DATE NOT NULL,
                                    liczba_godzin DECIMAL(5, 2) NOT NULL,
                                    id_pracownika INT NOT NULL
);

CREATE TABLE ksiegowosc.pensja (
                                   id_pensji INT NOT NULL PRIMARY KEY,
                                   stanowisko VARCHAR(50) NOT NULL,
                                   kwota DECIMAL(10, 2) NOT NULL
);

CREATE TABLE ksiegowosc.premie (
                                   id_premii INT NOT NULL PRIMARY KEY,
                                   rodzaj VARCHAR(50) NOT NULL,
                                   kwota DECIMAL(10, 2) NOT NULL
);

CREATE TABLE ksiegowosc.wynagrodzenie (
                                          id_wynagrodzenia INT NOT NULL PRIMARY KEY,
                                          data DATE NOT NULL,
                                          id_pracownika INT NOT NULL,
                                          id_godziny INT NOT NULL,
                                          id_pensji INT NOT NULL,
                                          id_premii INT NOT NULL
);


ALTER TABLE ksiegowosc.godziny
    ADD FOREIGN KEY (id_pracownika) REFERENCES ksiegowosc.pracownicy(id_pracownika);


ALTER TABLE ksiegowosc.wynagrodzenie
    ADD FOREIGN KEY (id_pracownika) REFERENCES ksiegowosc.pracownicy(id_pracownika),
    ADD FOREIGN KEY (id_godziny) REFERENCES ksiegowosc.godziny(id_godziny),
    ADD FOREIGN KEY (id_pensji) REFERENCES ksiegowosc.pensja(id_pensji),
    ADD FOREIGN KEY (id_premii) REFERENCES ksiegowosc.premie(id_premii);

COMMENT ON TABLE ksiegowosc.pracownicy IS 'Tabela przechowująca informacje o pracownikach.';

COMMENT ON TABLE ksiegowosc.godziny IS 'Tabela przechowująca informacje o przepracowanych godzinach przez pracowników.';

COMMENT ON TABLE ksiegowosc.pensja IS 'Tabela przechowująca informacje o wynagrodzeniach pracowników.';

COMMENT ON TABLE ksiegowosc.premie IS 'Tabela przechowująca informacje o premiach dla pracowników.';

COMMENT ON TABLE ksiegowosc.wynagrodzenie IS 'Tabela przechowująca informacje o wynagrodzeniach pracowników, uwzględniająca pensje i premie.';


INSERT INTO ksiegowosc.pracownicy (id_pracownika, imie, nazwisko, adres, telefon)
VALUES
    (1, 'Jan', 'Kowalski', 'ul. Kwiatowa 1, Warszawa', '123456789'),
    (2, 'Anna', 'Nowak', 'ul. Leśna 5, Kraków', '987654321'),
    (3, 'Piotr', 'Wiśniewski', 'ul. Słoneczna 10, Gdańsk', '654987321'),
    (4, 'Maria', 'Wójcik', 'ul. Polna 8, Wrocław', '456123789'),
    (5, 'Michał', 'Kaczmarek', 'ul. Ogrodowa 3, Poznań', '789456123'),
    (6, 'Katarzyna', 'Lewandowska', 'ul. Miodowa 15, Łódź', '321654987'),
    (7, 'Paweł', 'Dąbrowski', 'ul. Lipowa 12, Szczecin', '654321987'),
    (8, 'Małgorzata', 'Szymańska', 'ul. Zielona 7, Lublin', '987321654'),
    (9, 'Andrzej', 'Woźniak', 'ul. Kwiatowa 1, Katowice', '147258369'),
    (10, 'Agnieszka', 'Kamińska', 'ul. Brzozowa 9, Białystok', '369852147');


INSERT INTO ksiegowosc.godziny (id_godziny, data, liczba_godzin, id_pracownika)
VALUES
    (1, '2024-04-01', 168.00, 1),
    (2, '2024-04-02', 207.50, 2),
    (3, '2024-04-03', 8.25, 3),
    (4, '2024-04-04', 8.00, 4),
    (5, '2024-04-05', 7.75, 5),
    (6, '2024-04-06', 8.50, 6),
    (7, '2024-04-07', 8.00, 7),
    (8, '2024-04-08', 7.25, 8),
    (9, '2024-04-09', 8.75, 9),
    (10, '2024-04-10', 7.00, 10);


INSERT INTO ksiegowosc.pensja (id_pensji, stanowisko, kwota)
VALUES
    (1, 'Księgowy', 5000.00),
    (2, 'Analityk', 5500.00),
    (3, 'Sekretarka', 4500.00),
    (4, 'Manager', 7000.00),
    (5, 'Specjalista', 6000.00),
    (6, 'Doradca', 6500.00),
    (7, 'Pracownik biura', 4800.00),
    (8, 'Asystent', 4200.00),
    (9, 'Audytor', 900.00),
    (10, 'Kierownik', 7500.00);


INSERT INTO ksiegowosc.premie (id_premii, rodzaj, kwota)
VALUES
    (1, 'Wynikowa', 1000.00),
    (2, 'Motywacyjna', 750.00),
    (3, 'Świąteczna', 500.00),
    (4, 'Specjalna', 1200.00),
    (5, 'Za staż', 0.00),
    (6, 'Zespołowa', 1500.00),
    (7, 'Uznaniowa', 900.00),
    (8, 'Wydajnościowa', 1100.00),
    (9, 'Dodatkowa', 600.00),
    (10, 'Rozwojowa', 850.00);


INSERT INTO ksiegowosc.wynagrodzenie (id_wynagrodzenia, data, id_pracownika, id_godziny, id_pensji, id_premii)
VALUES
    (1, '2024-04-01', 1, 1, 1, 1),
    (2, '2024-04-02', 2, 2, 2, 2),
    (3, '2024-04-03', 3, 3, 3, 3),
    (4, '2024-04-04', 4, 4, 4, 4),
    (5, '2024-04-05', 5, 5, 5, 5),
    (6, '2024-04-06', 6, 6, 6, 6),
    (7, '2024-04-07', 7, 7, 7, 7),
    (8, '2024-04-08', 8, 8, 8, 8),
    (9, '2024-04-09', 9, 9, 9, 9),
    (10, '2024-04-10', 10, 10, 10, 10);

--PODPUNKT A
SELECT id_pracownika, nazwisko FROM ksiegowosc.pracownicy;
--PODPUNKT B
SELECT p.id_pracownika
FROM ksiegowosc.pracownicy p
JOIN ksiegowosc.wynagrodzenie w ON p.id_pracownika = w.id_pracownika
JOIN ksiegowosc.pensja p2 ON p2.id_pensji = w.id_pensji
WHERE kwota > 1000;
--PODPUNKT C
SELECT p.id_pracownika
FROM ksiegowosc.pracownicy p
JOIN ksiegowosc.wynagrodzenie w ON p.id_pracownika = w.id_pracownika
JOIN ksiegowosc.premie p2 ON p2.id_premii = w.id_premii
JOIN ksiegowosc.pensja p3 ON p3.id_pensji = w.id_pensji
WHERE p2.kwota = 0 AND p3.kwota > 3000;
--PODPUNKT D
SELECT imie , nazwisko FROM ksiegowosc.pracownicy
WHERE imie LIKE 'J%';
--PODPUNKT E
SELECT *
FROM ksiegowosc.pracownicy
WHERE nazwisko LIKE '%n%' AND imie LIKE '%a';
--PODPUNKT F
SELECT p.imie, p.nazwisko, SUM(g.liczba_godzin) - 160 AS nadgodziny
FROM ksiegowosc.pracownicy p
JOIN ksiegowosc.wynagrodzenie w ON p.id_pracownika = w.id_pracownika
JOIN ksiegowosc.godziny g ON w.id_godziny = g.id_godziny
WHERE g.liczba_godzin > 160
GROUP BY p.imie, p.nazwisko;
--PODPUNKT G
SELECT p.imie, p.nazwisko
FROM ksiegowosc.pracownicy p
JOIN ksiegowosc.wynagrodzenie w ON p.id_pracownika = w.id_pracownika
JOIN ksiegowosc.pensja pe ON w.id_pensji = pe.id_pensji
WHERE pe.kwota BETWEEN 1500 AND 3000;
--PODPUNKT H
SELECT p.imie, p.nazwisko
FROM ksiegowosc.pracownicy p
JOIN ksiegowosc.wynagrodzenie w ON p.id_pracownika = w.id_pracownika
JOIN ksiegowosc.pensja pe ON w.id_pensji = pe.id_pensji
JOIN ksiegowosc.godziny g ON w.id_godziny = g.id_godziny
JOIN ksiegowosc.premie pr ON w.id_premii = pr.id_premii
WHERE (g.liczba_godzin > 160 AND pr.kwota = 0);
--PODPUNKT I
SELECT p.imie, p.nazwisko, pe.kwota AS pensja
FROM ksiegowosc.pracownicy p
JOIN ksiegowosc.wynagrodzenie w ON p.id_pracownika = w.id_pracownika
JOIN ksiegowosc.pensja pe ON w.id_pensji = pe.id_pensji
ORDER BY pe.kwota;
--PODPUNKT J
SELECT p.imie, p.nazwisko, pe.kwota AS pensja, pr.kwota AS premia
FROM ksiegowosc.pracownicy p
         JOIN ksiegowosc.wynagrodzenie w ON p.id_pracownika = w.id_pracownika
         JOIN ksiegowosc.pensja pe ON w.id_pensji = pe.id_pensji
         JOIN ksiegowosc.premie pr ON w.id_premii = pr.id_premii
ORDER BY pe.kwota DESC, pr.kwota DESC;
--PODPUNKT K
SELECT stanowisko, COUNT(*) AS liczba_pracownikow
FROM ksiegowosc.pensja
GROUP BY stanowisko;
--PODPUNKT L
SELECT
    AVG(kwota) AS srednia_placa,
    MIN(kwota) AS minimalna_placa,
    MAX(kwota) AS maksymalna_placa
FROM ksiegowosc.pensja
WHERE stanowisko = 'Kierownik';
--PODPUNKT M
SELECT SUM(kwota) AS suma_wynagrodzen
FROM ksiegowosc.pensja;
--PODPUNKT N
SELECT stanowisko, SUM(kwota) AS suma_wynagrodzen
FROM ksiegowosc.pensja
GROUP BY stanowisko;
--PODPUNKT O
SELECT p.stanowisko, COUNT(*) AS liczba_premii
FROM ksiegowosc.pensja p
         JOIN ksiegowosc.wynagrodzenie w ON p.id_pensji = w.id_pensji
JOIN ksiegowosc.premie pr ON w.id_premii = pr.id_premii
WHERE pr.kwota != 0
GROUP BY p.stanowisko;
--PODPUNKT P
DELETE FROM ksiegowosc.pensja
WHERE kwota < 1200;
