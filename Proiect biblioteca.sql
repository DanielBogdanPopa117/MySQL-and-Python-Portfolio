CREATE DATABASE biblioteca; #DROP DATABASE se foloseste pentru a sterge baza de date
USE biblioteca; #selectam baza de date

CREATE TABLE IF NOT EXISTS autori(
id INT AUTO_INCREMENT PRIMARY KEY,
nume VARCHAR(100),
tara VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS carti(
id INT AUTO_INCREMENT PRIMARY KEY,
titlu VARCHAR(200),
autor_id INT,
gen VARCHAR(50),
data_publicarii DATE,
FOREIGN KEY (autor_id) REFERENCES autori(id)
);

CREATE TABLE IF NOT EXISTS imprumuturi(
id INT AUTO_INCREMENT PRIMARY KEY,
carte_id INT,
data_imprumut DATE,
data_returnare DATE,
cititor VARCHAR(100),
FOREIGN KEY (carte_id) REFERENCES carti(id)
);

INSERT INTO autori(nume, tara) VALUES
('Thomas Mann', 'Germania'),
('Dimitrie Cantemir', 'Romania'),
('Blaise Pascal', 'Franta');

INSERT INTO carti(titlu, autor_id, gen, data_publicarii) VALUES
('Muntele vrajit', 1, 'Beletristica', '1924-11-24'),
('Istoria ieroglifica', 2, 'Beletristica', '1883-01-01'),
('Cugetari', 3, 'Filozofie', '1670-01-01'),
('Doctor Faustus', 1, 'Beletristica', '1947-01-03'),
('Divanul', 2, 'Didactico-Moralizator', '1698-01-04');

INSERT INTO imprumuturi(carte_id, data_imprumut, data_returnare, cititor) VALUES
(1, '2024-02-08', '2024-03-09', 'Tudor Andrei'),
(2, '2025-01-03', '2025-02-01', 'Popa Daniel'),
(4, '2023-04-20', '2023-05-18', 'Alexandru Cristian');

#extragem toate datele din tabelele carti si autori
SELECT* FROM carti;
SELECT* FROM autori; 

 #extragem cartile publicate dupa anul 1900
SELECT titlu, data_publicarii FROM carti
WHERE data_publicarii > '1900-01-01'; 

#extragem cartile impreuna cu detaliile acestora din cele doua tabele carti si autori folosind JOIN 
SELECT titlu, gen, data_publicarii, nume, tara FROM carti
JOIN autori
ON carti.autor_id = autori.id;

#o interogare care sa extraga cartile scrise de autori din Romania si care sunt din genul Beletristica
SELECT titlu, gen, tara FROM carti
JOIN autori
ON carti.autor_id = autori.id
WHERE autori.tara = 'Romania' AND carti.gen = 'Beletristica';

#modificam data te returnare a cartii "Istoria ieroglifica" la 2025-01-25
UPDATE imprumuturi
SET data_returnare = '2025-01-25'
WHERE carte_id = 2;

#stergem imprumutul cartii "Muntele vrajit"
DELETE from imprumuturi
Where id = 1; #am ales id si nu carte_id pentru a evita stergerea tuturor imprumuturilor acestei carti (daca sunt mai multe)

#gasim toate cartile care au cuvantul "Doctor" in titlu
SELECT * FROM carti
WHERE titlu LIKE '%Doctor%';

#gasim cartile publicate intre 1600 si 1800
SELECT * FROM carti
WHERE data_publicarii BETWEEN '1600-01-01' AND '1800-01-01';

#gasim toate cartile care sunt din genul beletristica sau filozofie
SELECT * FROM carti
WHERE gen = 'Beletristica' OR 'Filozofie';
#sau WHERE gen IN ('Beletristica', 'Filozofie');

#afisam toate imprumuturile cu detaliile despre carti si cititori
SELECT imprumuturi.id, carti.titlu, imprumuturi.cititor, imprumuturi.data_imprumut, imprumuturi.data_returnare
FROM imprumuturi
JOIN carti
ON imprumuturi.carte_id = carti.id;

#afisam toate cartile impreuna cu autorii lor si tarile acestora
SELECT titlu, gen, data_publicarii, nume, tara FROM carti
JOIN autori ON carti.autor_id = autori.id;

#gasim toate cartile imprumutate si autorii lor
SELECT carti.titlu, autori.nume, imprumuturi.cititor, imprumuturi.data_imprumut
FROM imprumuturi
JOIN carti ON imprumuturi.carte_id = carti.id
JOIN autori ON carti.autor_id = autori.id;

#gasim cele mai recente 3 carti adaugate in biblioteca
SELECT titlu, data_publicarii FROM carti
ORDER BY data_publicarii DESC
Limit 3;

#gasim ultimii doi cititori care au imprumutat carti
SELECT data_imprumut, cititor FROM imprumuturi
ORDER BY data_imprumut DESC
LIMIT 2;

#aflam cate carti sunt in fiecare gen
SELECT gen, COUNT(*) as numar_carti FROM carti
GROUP BY gen;

#gasim care este cea mai noua si cea mai veche carte din biblioteca folosind subinterogari
SELECT titlu, data_publicarii FROM carti
WHERE data_publicarii = (SELECT MIN(data_publicarii) FROM carti)
OR data_publicarii = (SELECT MAX(data_publicarii) FROM carti);

#verificam cate imprumuturi a avut fiecare cititor
SELECT cititor, COUNT(*) AS numar_imprumuturi FROM imprumuturi
GROUP BY cititor;

#afisam cartile care au fost imprumutate cel putin o data
SELECT titlu FROM CARTI
WHERE id IN (SELECT carte_id FROM imprumuturi);

#gasim cititorii care au imprumutat carti din genul filozofie
SELECT DISTINCT cititor
FROM imprumuturi
WHERE carte_id IN (SELECT id FROM carti WHERE gen = 'Filozofie');
