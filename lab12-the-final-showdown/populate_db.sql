DROP TABLE INTREBARI;
DROP TABLE RASPUNSURI;

CREATE TABLE INTREBARI (
  DOMENIU VARCHAR2(5),
  ID VARCHAR2(8) NOT NULL PRIMARY KEY,
  TEXT_INTREBARE VARCHAR2(1000) NOT NULL
)
/

CREATE TABLE RASPUNSURI(
  Q_ID VARCHAR2(8),
  ID VARCHAR2(8) NOT NULL PRIMARY KEY,
  TEXT_RASPUNS VARCHAR2(1000) NOT NULL,
  CORECT VARCHAR2(1)
)
/


-- Domeniul 1 (geometrie)
INSERT INTO INTREBARI VALUES('D1','Q1','Care din urmatoarele figur geometrice au 4 laturi ?');
INSERT INTO RASPUNSURI VALUES ('Q1','A1','Patrat','1');
INSERT INTO RASPUNSURI VALUES ('Q1','A2','Cerc','0');
INSERT INTO RASPUNSURI VALUES ('Q1','A3','Triunghi','0');
INSERT INTO RASPUNSURI VALUES ('Q1','A4','Romb','1');
INSERT INTO RASPUNSURI VALUES ('Q1','A5','Dreptunghi','1');
INSERT INTO RASPUNSURI VALUES ('Q1','A6','Paralelogram','1');
INSERT INTO RASPUNSURI VALUES ('Q1','A7','Hexagon','0');
INSERT INTO RASPUNSURI VALUES ('Q1','A8','Dodecagon','0');
INSERT INTO RASPUNSURI VALUES ('Q1','A9','Pentagon','0');
INSERT INTO RASPUNSURI VALUES ('Q1','A10','Poligon','0');

INSERT INTO INTREBARI VALUES('D1','Q2','Care din urmatoarele figuri geometrice au mai mult de 4 colturi ?');
INSERT INTO RASPUNSURI VALUES ('Q2','A11','Patrat','0');
INSERT INTO RASPUNSURI VALUES ('Q2','A12','Cerc','1');
INSERT INTO RASPUNSURI VALUES ('Q2','A13','Triunghi','0');
INSERT INTO RASPUNSURI VALUES ('Q2','A14','Romb','0');
INSERT INTO RASPUNSURI VALUES ('Q2','A15','Dreptunghi','0');
INSERT INTO RASPUNSURI VALUES ('Q2','A16','Paralelogram','0');
INSERT INTO RASPUNSURI VALUES ('Q2','A17','Hexagon','1');
INSERT INTO RASPUNSURI VALUES ('Q2','A18','Dodecagon','1');
INSERT INTO RASPUNSURI VALUES ('Q2','A19','Pentagon','1');
INSERT INTO RASPUNSURI VALUES ('Q2','A20','Poligon','0');

INSERT INTO INTREBARI VALUES('D1','Q3','Care din urmatoarele afirmatii sunt adevarate ?');
INSERT INTO RASPUNSURI VALUES ('Q3','A21','Triunghiul are 4 laturi','0');
INSERT INTO RASPUNSURI VALUES ('Q3','A22','Cercul are o infinitate de varfuri','1');
INSERT INTO RASPUNSURI VALUES ('Q3','A23','Suma unghiurilor unui triunghi este de 180 de grade','1');
INSERT INTO RASPUNSURI VALUES ('Q3','A24','Suma unghiurilor unui patrat este de 180 de grade','0');
INSERT INTO RASPUNSURI VALUES ('Q3','A25','Un patrat este un romb cu un unghi drept','1');
INSERT INTO RASPUNSURI VALUES ('Q3','A26','Un poligon este o linie franta inchisa','1');
INSERT INTO RASPUNSURI VALUES ('Q3','A27','Intr-un triunghi dreptunghic suma catetelor este egala cu ipotenuza','0');

INSERT INTO INTREBARI VALUES('D1','Q4','Care din urmatoarele figuri au toate laturile egale ?');
INSERT INTO RASPUNSURI VALUES ('Q4','A28','Triunghiul dreptunghic','0');
INSERT INTO RASPUNSURI VALUES ('Q4','A29','Triunghiul isoscel','0');
INSERT INTO RASPUNSURI VALUES ('Q4','A30','Triunghiul echilateral','1');
INSERT INTO RASPUNSURI VALUES ('Q4','A31','Patratul','1');
INSERT INTO RASPUNSURI VALUES ('Q4','A32','Rombul','1');
INSERT INTO RASPUNSURI VALUES ('Q4','A33','Dreptunghiul','0');
INSERT INTO RASPUNSURI VALUES ('Q4','A34','Hexagonul neregulat','0');
-- INSERT INTO RASPUNSURI VALUES ('Q4','A34','Pentagonul regulat','1');







-- Domeniul 2 (numere)
INSERT INTO INTREBARI VALUES('D2','Q5','Care din urmatoarele sunt numere prime ?');
INSERT INTO RASPUNSURI VALUES ('Q5','A35','3','1');
INSERT INTO RASPUNSURI VALUES ('Q5','A36','7','1');
INSERT INTO RASPUNSURI VALUES ('Q5','A37','5','1');
INSERT INTO RASPUNSURI VALUES ('Q5','A38','13','1');
INSERT INTO RASPUNSURI VALUES ('Q5','A39','17','1');
INSERT INTO RASPUNSURI VALUES ('Q5','A40','9','0');
INSERT INTO RASPUNSURI VALUES ('Q5','A41','16','0');
INSERT INTO RASPUNSURI VALUES ('Q5','A42','22','0');
INSERT INTO RASPUNSURI VALUES ('Q5','A43','121','0');
INSERT INTO RASPUNSURI VALUES ('Q5','A44','14','0');

INSERT INTO INTREBARI VALUES('D2','Q6','Care din urmatoarele sunt numere pare ?');
INSERT INTO RASPUNSURI VALUES ('Q6','A45','2','1');
INSERT INTO RASPUNSURI VALUES ('Q6','A46','4','1');
INSERT INTO RASPUNSURI VALUES ('Q6','A47','6','1');
INSERT INTO RASPUNSURI VALUES ('Q6','A48','12','1');
INSERT INTO RASPUNSURI VALUES ('Q6','A49','100','1');
INSERT INTO RASPUNSURI VALUES ('Q6','A50','13','0');
INSERT INTO RASPUNSURI VALUES ('Q6','A51','15','0');
INSERT INTO RASPUNSURI VALUES ('Q6','A52','1','0');
INSERT INTO RASPUNSURI VALUES ('Q6','A53','7','0');
INSERT INTO RASPUNSURI VALUES ('Q6','A54','9','0');

INSERT INTO INTREBARI VALUES('D2','Q7','Care din urmatoarele numere sunt din sirul lui Fibonacci ?');
INSERT INTO RASPUNSURI VALUES ('Q7','A55','1','1');
INSERT INTO RASPUNSURI VALUES ('Q7','A56','2','1');
INSERT INTO RASPUNSURI VALUES ('Q7','A57','3','1');
INSERT INTO RASPUNSURI VALUES ('Q7','A58','5','1');
INSERT INTO RASPUNSURI VALUES ('Q7','A59','8','1');
INSERT INTO RASPUNSURI VALUES ('Q7','A60','13','1');
INSERT INTO RASPUNSURI VALUES ('Q7','A61','21','1');
INSERT INTO RASPUNSURI VALUES ('Q7','A62','22','0');
INSERT INTO RASPUNSURI VALUES ('Q7','A63','23','0');




-- Domeniul 3 (Flori)
INSERT INTO INTREBARI VALUES('D3','Q8','Care flori sunt sau pot fi albe ?');
INSERT INTO RASPUNSURI VALUES ('Q8','A64','Ghiocelul','1');
INSERT INTO RASPUNSURI VALUES ('Q8','A65','Margareta','1');
INSERT INTO RASPUNSURI VALUES ('Q8','A66','Trandafirul','1');
INSERT INTO RASPUNSURI VALUES ('Q8','A67','Floarea de soc','1');
INSERT INTO RASPUNSURI VALUES ('Q8','A68','Papadia','0');
INSERT INTO RASPUNSURI VALUES ('Q8','A69','Floarea de cires','1');
INSERT INTO RASPUNSURI VALUES ('Q8','A70','Crinul','1');
INSERT INTO RASPUNSURI VALUES ('Q8','A71','Bumbisorul','1');
INSERT INTO RASPUNSURI VALUES ('Q8','A72','Floarea soarelui','0');

INSERT INTO INTREBARI VALUES('D3','Q9','Care din urmatorele nume de fete sunt si nume de flori ?');
INSERT INTO RASPUNSURI VALUES ('Q9','A73','Crina','1');
INSERT INTO RASPUNSURI VALUES ('Q9','A74','Margareta','1');
INSERT INTO RASPUNSURI VALUES ('Q9','A75', 'Lacramioara','1');
INSERT INTO RASPUNSURI VALUES ('Q9','A76','Madalina','0');
INSERT INTO RASPUNSURI VALUES ('Q9','A77','Maria','0');
INSERT INTO RASPUNSURI VALUES ('Q9','A78','Larisa','0');
INSERT INTO RASPUNSURI VALUES ('Q9','A79','Georgiana','0');
INSERT INTO RASPUNSURI VALUES ('Q9','A80','Brandusa','1');
INSERT INTO RASPUNSURI VALUES ('Q9','A81','Ana','0');

-- Domeniul 4 (Teoria numerelor)
INSERT INTO INTREBARI VALUES('D4','Q10','Cate litere are alfabetul roman?');
INSERT INTO RASPUNSURI VALUES ('Q10','A82','26','0');
INSERT INTO RASPUNSURI VALUES ('Q10','A83','31','1');
INSERT INTO RASPUNSURI VALUES ('Q10','A84','Ce e asta?','0');
INSERT INTO RASPUNSURI VALUES ('Q10','A85','26.5','0');
INSERT INTO RASPUNSURI VALUES ('Q10','A86','-12','0');
INSERT INTO RASPUNSURI VALUES ('Q10','A87','Pe toate.','0');

-- Domeniul 5 (Existentialism)
INSERT INTO INTREBARI VALUES('D5','Q11','Pe ce planeta traiesti?');
INSERT INTO RASPUNSURI VALUES ('Q11','A88','Pe pamant.','1');
INSERT INTO RASPUNSURI VALUES ('Q11','A89','Traiesc in nori.','0');
INSERT INTO RASPUNSURI VALUES ('Q11','A90','Pe juiter.','0');
INSERT INTO RASPUNSURI VALUES ('Q11','A91','Depinde.','0');
INSERT INTO RASPUNSURI VALUES ('Q11','A92','Pe luna.','0');
INSERT INTO RASPUNSURI VALUES ('Q11','A93','Pe toate.','0');

-- Domeniul 6 (Animale)
INSERT INTO INTREBARI VALUES('D6','Q12','Care animal este mamifer ?');
INSERT INTO RASPUNSURI VALUES ('Q12','A94','Ariciul','1');
INSERT INTO RASPUNSURI VALUES ('Q12','A95','Capra neagra','1');
INSERT INTO RASPUNSURI VALUES ('Q12','A96','Lupul','1');
INSERT INTO RASPUNSURI VALUES ('Q12','A97','Ursul','1');
INSERT INTO RASPUNSURI VALUES ('Q12','A98','Gaina','0');
INSERT INTO RASPUNSURI VALUES ('Q12','A99','Barza','0');
INSERT INTO RASPUNSURI VALUES ('Q12','A100','Sarpele','0');
INSERT INTO RASPUNSURI VALUES ('Q12','A101','Delfinul','1');
INSERT INTO RASPUNSURI VALUES ('Q12','A102','Broasca testoasa','0');

-- Domeniul 7 (Povesti)
INSERT INTO INTREBARI VALUES('D7','Q13','Cati pitici avea Cenusareasa ?');
INSERT INTO RASPUNSURI VALUES ('Q13','A103','0','1');
INSERT INTO RASPUNSURI VALUES ('Q13','A104','Niciunul','1');
INSERT INTO RASPUNSURI VALUES ('Q13','A105','1','0');
INSERT INTO RASPUNSURI VALUES ('Q13','A106','3','0');
INSERT INTO RASPUNSURI VALUES ('Q13','A107','7','0');
INSERT INTO RASPUNSURI VALUES ('Q13','A108','8','0');
INSERT INTO RASPUNSURI VALUES ('Q13','A109','Pe toti','0');
INSERT INTO RASPUNSURI VALUES ('Q13','A110','Unul si bun','0');
INSERT INTO RASPUNSURI VALUES ('Q13','A111','Nu stiu','0');

-- Domeniul 8 (Istorie)
INSERT INTO INTREBARI VALUES('D8','Q14','Cine a fost Alexandru Ioan Cuza ?');
INSERT INTO RASPUNSURI VALUES ('Q14','A112','a fost primul domnitor al Principatelor Unite si al statului national Romania','1');
INSERT INTO RASPUNSURI VALUES ('Q14','A113','un om inrobit de doua patimi Iubirea pentru patrie si cea pentru femei frumoase','1');
INSERT INTO RASPUNSURI VALUES ('Q14','A114','un om pasionat de cai','1');
INSERT INTO RASPUNSURI VALUES ('Q14','A115','un pictor roman','0');
INSERT INTO RASPUNSURI VALUES ('Q14','A116','primul scriitor de opera literara','0');
INSERT INTO RASPUNSURI VALUES ('Q14','A117','a fost ultimul domnitor al Principatelor Unite si al statului national Romania','0');
INSERT INTO RASPUNSURI VALUES ('Q14','A118','un domnitor roman nascut in anul 1820','1');
INSERT INTO RASPUNSURI VALUES ('Q14','A119','un domnitor roman nascut in anul 1859','0');
INSERT INTO RASPUNSURI VALUES ('Q14','A120','Domnitor in 1859-1866','1');

-- Domeniul 9 (Scriitori)
INSERT INTO INTREBARI VALUES('D9','Q15','Care este/sunt scriitori romani ?');
INSERT INTO RASPUNSURI VALUES ('Q15','A121','Mihai Eminescu','1');
INSERT INTO RASPUNSURI VALUES ('Q15','A122','Ion Luca Caragiale','1');
INSERT INTO RASPUNSURI VALUES ('Q15','A123','Mircea Cartarescu','1');
INSERT INTO RASPUNSURI VALUES ('Q15','A124','Mircea Eliade','1');
INSERT INTO RASPUNSURI VALUES ('Q15','A125','Ion Creanga','1');
INSERT INTO RASPUNSURI VALUES ('Q15','A126','Liviu Rebreanu','1');
INSERT INTO RASPUNSURI VALUES ('Q15','A127','Nicolae Grigorescu','0');
INSERT INTO RASPUNSURI VALUES ('Q15','A128','Nicolae Tonitza','0');
INSERT INTO RASPUNSURI VALUES ('Q15','A129','Stefan Luchian','0');
INSERT INTO RASPUNSURI VALUES ('Q15','A130','Ion Andreescu','0');


-- Domeniul 10 (Filme)
INSERT INTO INTREBARI VALUES('D10','Q16','Care dintre urmatoarele filme il au drept regizor pe Quentin Tarantino ?');
INSERT INTO RASPUNSURI VALUES ('Q16','A131','From Dusk till Dawn','1');
INSERT INTO RASPUNSURI VALUES ('Q16','A132','Pulp Fiction','1');
INSERT INTO RASPUNSURI VALUES ('Q16','A133','Django','1');
INSERT INTO RASPUNSURI VALUES ('Q16','A134','Eyes wide shut','0');
INSERT INTO RASPUNSURI VALUES ('Q16','A135','Terminator','0');
INSERT INTO RASPUNSURI VALUES ('Q16','A136','Godfather','0');
INSERT INTO RASPUNSURI VALUES ('Q16','A137','Kill Bill','1');
INSERT INTO RASPUNSURI VALUES ('Q16','A138','Ender’s Game','0');
INSERT INTO RASPUNSURI VALUES ('Q16','A139','Coboram la prima','0');
INSERT INTO RASPUNSURI VALUES ('Q16','A140','The Notebook','0');

COMMIT;