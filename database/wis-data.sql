SET FOREIGN_KEY_CHECKS = 0;

#
# Table structure for table 'Applicaties'
#

DROP TABLE IF EXISTS `Applicaties`;
CREATE TABLE `Applicaties` (
  `id` INT NOT NULL DEFAULT 0,
  `pakket` VARCHAR(50),
  `module` VARCHAR(50),
  `beschrijving` VARCHAR(255),
  `extern` BIT,
  `acceptabel` BIT,
  `administratief` BIT,
  `spatial` BIT,
  `taal` VARCHAR(255),
  `spatial_koppeling` VARCHAR(255),
  `db_koppeling` VARCHAR(255),
  `webbased` BIT,
  `gps` BIT,
  `crow` BIT,
  `opmerking` VARCHAR(255),
  `leverancier_id` INT DEFAULT 0,
  INDEX `id` (`id`),
  INDEX `leverancier_id` (`leverancier_id`),
  INDEX `LeveranciersApplicaties` (`leverancier_id`),
  PRIMARY KEY (`id`)
);

#
# Dumping data for table 'Applicaties'
#

LOCK TABLES `Applicaties` WRITE;
INSERT INTO `Applicaties` VALUES(0, 'Geen', "", "", 0, 0, 0, 0, "", "", "", 0, 0, 0, "", 28);
INSERT INTO `Applicaties` VALUES(1, 'Accres', 'ViaView', "", 0, -1, -1, -1, "", 'o.a. MicroStation en AutoCAD', 'ODBC db\'s (bv Oracle en Access)', 0, 0, -1, "", 8);
INSERT INTO `Applicaties` VALUES(2, 'Groenestijn', "", "", 0, -1, -1, -1, 'Xbase++', 'MicroStation, AutoCAD, IGOS, InfoCAD, ArcView, NedView', 'ODBC db\'s (bv Oracle en Access)', 0, -1, -1, "", 6);
INSERT INTO `Applicaties` VALUES(3, 'Veras', "", "", 0, -1, 0, 0, "", "", "", 0, 0, 0, "", 5);
INSERT INTO `Applicaties` VALUES(4, 'SPOK', "", "", 0, -1, 0, 0, "", "", "", 0, 0, 0, "", 28);
INSERT INTO `Applicaties` VALUES(5, 'Mobiliteitsbeleid', "", "", 0, -1, 0, 0, "", "", "", 0, 0, 0, "", 30);
INSERT INTO `Applicaties` VALUES(6, 'Cyclomedia', "", "", 0, -1, 0, 0, "", "", "", 0, 0, 0, "", 26);
INSERT INTO `Applicaties` VALUES(7, 'RDW Cross', "", "", -1, -1, 0, 0, "", "", "", 0, 0, 0, "", 27);
INSERT INTO `Applicaties` VALUES(8, 'MS Excel', "", "", 0, 0, -1, 0, "", "", "", 0, 0, 0, "", 22);
INSERT INTO `Applicaties` VALUES(9, 'MS Access', "", "", 0, -1, -1, 0, "", "", "", 0, 0, 0, "", 22);
INSERT INTO `Applicaties` VALUES(10, 'BASEC', "", "", 0, -1, 0, 0, "", "", "", 0, 0, 0, "", 29);
INSERT INTO `Applicaties` VALUES(11, 'MS Word', "", "", 0, 0, -1, 0, "", "", "", 0, 0, 0, "", 22);
INSERT INTO `Applicaties` VALUES(12, 'AutoCad', "", "", 0, -1, 0, -1, "", "", "", 0, 0, 0, "", 23);
INSERT INTO `Applicaties` VALUES(13, 'Microstation', "", "", 0, -1, 0, -1, "", "", "", 0, 0, 0, "", 24);
INSERT INTO `Applicaties` VALUES(14, 'Onbekend', "", "", 0, 0, 0, 0, "", "", "", 0, 0, 0, "", 28);
INSERT INTO `Applicaties` VALUES(15, 'Basisregistratie Geo', "", "", 0, -1, 0, -1, "", "", "", 0, 0, 0, "", 30);
INSERT INTO `Applicaties` VALUES(16, 'Rittenadmin Strooiwagens', "", "", 0, -1, -1, -1, "", "", "", 0, 0, 0, "", 28);
INSERT INTO `Applicaties` VALUES(17, 'Collector', "", "", 0, -1, 0, 0, "", "", "", 0, 0, 0, "", 4);
INSERT INTO `Applicaties` VALUES(18, 'mi2', "", "", 0, -1, 0, 0, 'Delphi/Foxpro/Uniface. Medio 2007 ook andere lijn met Java en .NET', 'MicroStation en AutoCAD', 'ODBC db\'s (bv Oracle en Access). Vanaf medio 2007 Oracle Spatial', 0, 0, 0, 'vanaf medio 2007 webbased', 2);
INSERT INTO `Applicaties` VALUES(19, 'DHV Beheerpakketten', "", "", 0, -1, 0, 0, 'Visual Basic', 'MicroStation, AutoCAD, IGOS, InfoCAD, ArcView, NedView', 'ODBC db\'s (bv Oracle en Access)', -1, -1, -1, "", 4);
INSERT INTO `Applicaties` VALUES(20, 'DG Dialog', "", "", 0, -1, 0, 0, 'C++/Uniface', 'o.a. MicroStation, AutoCAD, ArcView, NedView', 'Oracle Spatial', -1, -1, -1, "", 5);
INSERT INTO `Applicaties` VALUES(21, 'BS8*Beheer', "", "", 0, -1, 0, 0, 'Delphi/C++', 'o.a. MicroStation, ISI-Omega', 'Oracle', 0, -1, -1, "", 7);
INSERT INTO `Applicaties` VALUES(22, 'GBI', "", "", 0, -1, 0, 0, 'Oracle/OpenRoad en .NET voor webinterface', 'MicroStation, AutoCAD, IGOS, InfoCAD, ArcView, NedView', 'Oracle', -1, -1, -1, "", 10);
INSERT INTO `Applicaties` VALUES(23, 'Infra', "", "", 0, -1, 0, 0, 'MDL', 'MicroStation', 'ODBC db\'s (bv Oracle en Access)', 0, -1, -1, "", 11);
INSERT INTO `Applicaties` VALUES(24, 'Zelfbouw/Maatwerk', "", "", 0, -1, -1, -1, "", "", "", 0, 0, 0, 'deze applicatie wordt later opgesplitst in concrete zelfbouw applicaties', 30);
UNLOCK TABLES;

#
# Table structure for table 'Clusters'
#

DROP TABLE IF EXISTS `Clusters`;
CREATE TABLE `Clusters` (
  `id` INT NOT NULL DEFAULT 0,
  `naam` VARCHAR(50),
  `omschrijving` VARCHAR(50),
  `parent_id` INT DEFAULT 0,
  INDEX `id` (`id`),
  INDEX `parent_id` (`parent_id`),
  PRIMARY KEY (`id`)
);

#
# Dumping data for table 'Clusters'
#

LOCK TABLES `Clusters` WRITE;
INSERT INTO `Clusters` VALUES(0, 'Onbekend', "", 0);
INSERT INTO `Clusters` VALUES(1, 'Basis', "", 0);
INSERT INTO `Clusters` VALUES(2, 'Verkeer', "", 0);
INSERT INTO `Clusters` VALUES(3, 'Groen', "", 0);
INSERT INTO `Clusters` VALUES(4, 'Juridisch', "", 0);
INSERT INTO `Clusters` VALUES(5, 'Gebieden', "", 1);
INSERT INTO `Clusters` VALUES(6, 'Verkeersmanagement', "", 2);
INSERT INTO `Clusters` VALUES(7, "", "", 0);
INSERT INTO `Clusters` VALUES(8, 'Kunstwerken', "", 1);
INSERT INTO `Clusters` VALUES(9, "", "", 0);
INSERT INTO `Clusters` VALUES(10, "", "", 0);
INSERT INTO `Clusters` VALUES(11, "", "", 0);
INSERT INTO `Clusters` VALUES(12, "", "", 0);
UNLOCK TABLES;

#
# Table structure for table 'DataRegels'
#

DROP TABLE IF EXISTS `DataRegels`;
CREATE TABLE `DataRegels` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `thema_id` INT DEFAULT 0,
  `etl_batch_id` INT DEFAULT 0,
  `timestamp` CHAR(19),
  INDEX `etl_batch_id` (`etl_batch_id`),
  INDEX `ETLbatchDataRegels` (`etl_batch_id`),
  INDEX `id` (`id`),
  PRIMARY KEY (`id`),
  INDEX `ThemasDataRegels` (`thema_id`)
);

#
# Dumping data for table 'DataRegels'
#

LOCK TABLES `DataRegels` WRITE;
UNLOCK TABLES;

#
# Table structure for table 'ETLbatch'
#

DROP TABLE IF EXISTS `ETLbatch`;
CREATE TABLE `ETLbatch` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `omschrijving` VARCHAR(255),
  `timestamp` CHAR(19),
  INDEX `etl_batch_id` (`omschrijving`),
  INDEX `id` (`id`),
  PRIMARY KEY (`id`)
);

#
# Dumping data for table 'ETLbatch'
#

LOCK TABLES `ETLbatch` WRITE;
UNLOCK TABLES;

#
# Table structure for table 'FunctieItems'
#

DROP TABLE IF EXISTS `FunctieItems`;
CREATE TABLE `FunctieItems` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `label` VARCHAR(50),
  `omschrijving` VARCHAR(255),
  `eenheid` VARCHAR(50),
  `voorbeelden` VARCHAR(255),
  `invoer` BIT,
  `uitvoer` BIT,
  `functie_id` INT DEFAULT 0,
  INDEX `eenheid` (`eenheid`),
  INDEX `functie_id` (`functie_id`),
  INDEX `id` (`id`),
  PRIMARY KEY (`id`),
  INDEX `ThemaFunctiesFunctieItems` (`functie_id`)
);

#
# Dumping data for table 'FunctieItems'
#

LOCK TABLES `FunctieItems` WRITE;
INSERT INTO `FunctieItems` VALUES(1, "", "", "", "", -1, 0, 3);
INSERT INTO `FunctieItems` VALUES(2, "", "", "", "", -1, 0, 4);
INSERT INTO `FunctieItems` VALUES(3, "", "", "", "", -1, 0, 5);
INSERT INTO `FunctieItems` VALUES(4, "", "", "", "", -1, 0, 6);
INSERT INTO `FunctieItems` VALUES(5, "", "", "", "", -1, 0, 7);
INSERT INTO `FunctieItems` VALUES(6, "", "", "", "", -1, 0, 8);
INSERT INTO `FunctieItems` VALUES(7, "", "", "", "", -1, 0, 9);
INSERT INTO `FunctieItems` VALUES(8, "", "", "", "", -1, 0, 10);
INSERT INTO `FunctieItems` VALUES(9, "", "", "", "", -1, 0, 11);
INSERT INTO `FunctieItems` VALUES(10, "", "", "", "", -1, 0, 12);
INSERT INTO `FunctieItems` VALUES(11, "", "", "", "", -1, 0, 13);
INSERT INTO `FunctieItems` VALUES(12, "", "", "", "", -1, 0, 14);
INSERT INTO `FunctieItems` VALUES(13, "", "", "", "", -1, 0, 15);
INSERT INTO `FunctieItems` VALUES(14, "", "", "", "", -1, 0, 16);
INSERT INTO `FunctieItems` VALUES(15, "", "", "", "", -1, 0, 17);
INSERT INTO `FunctieItems` VALUES(16, "", "", "", "", -1, 0, 18);
INSERT INTO `FunctieItems` VALUES(17, "", "", "", "", -1, 0, 19);
INSERT INTO `FunctieItems` VALUES(18, "", "", "", "", -1, 0, 20);
INSERT INTO `FunctieItems` VALUES(19, "", "", "", "", -1, 0, 21);
INSERT INTO `FunctieItems` VALUES(20, "", "", "", "", -1, 0, 22);
INSERT INTO `FunctieItems` VALUES(21, "", "", "", "", -1, 0, 23);
INSERT INTO `FunctieItems` VALUES(22, "", "", "", "", -1, 0, 24);
INSERT INTO `FunctieItems` VALUES(23, "", "", "", "", -1, 0, 25);
INSERT INTO `FunctieItems` VALUES(24, "", "", "", "", -1, 0, 26);
INSERT INTO `FunctieItems` VALUES(25, "", "", "", "", -1, 0, 27);
INSERT INTO `FunctieItems` VALUES(26, "", "", "", "", -1, 0, 28);
INSERT INTO `FunctieItems` VALUES(27, "", "", "", "", -1, 0, 29);
INSERT INTO `FunctieItems` VALUES(28, "", "", "", "", -1, 0, 30);
INSERT INTO `FunctieItems` VALUES(29, "", "", "", "", -1, 0, 31);
INSERT INTO `FunctieItems` VALUES(30, "", "", "", "", -1, 0, 32);
INSERT INTO `FunctieItems` VALUES(31, "", "", "", "", -1, 0, 33);
INSERT INTO `FunctieItems` VALUES(32, "", "", "", "", -1, 0, 34);
INSERT INTO `FunctieItems` VALUES(33, "", "", "", "", -1, 0, 35);
INSERT INTO `FunctieItems` VALUES(34, "", "", "", "", -1, 0, 36);
INSERT INTO `FunctieItems` VALUES(35, "", "", "", "", -1, 0, 37);
INSERT INTO `FunctieItems` VALUES(36, "", "", "", "", -1, 0, 38);
INSERT INTO `FunctieItems` VALUES(37, "", "", "", "", -1, 0, 39);
INSERT INTO `FunctieItems` VALUES(38, "", "", "", "", -1, 0, 40);
INSERT INTO `FunctieItems` VALUES(39, "", "", "", "", -1, 0, 41);
INSERT INTO `FunctieItems` VALUES(40, "", "", "", "", -1, 0, 42);
INSERT INTO `FunctieItems` VALUES(41, "", "", "", "", -1, 0, 43);
INSERT INTO `FunctieItems` VALUES(42, "", "", "", "", -1, 0, 44);
INSERT INTO `FunctieItems` VALUES(43, "", "", "", "", -1, 0, 45);
INSERT INTO `FunctieItems` VALUES(44, "", "", "", "", -1, 0, 46);
INSERT INTO `FunctieItems` VALUES(45, "", "", "", "", 0, -1, 3);
INSERT INTO `FunctieItems` VALUES(46, "", "", "", "", 0, -1, 4);
INSERT INTO `FunctieItems` VALUES(47, "", "", "", "", 0, -1, 5);
INSERT INTO `FunctieItems` VALUES(48, "", "", "", "", 0, -1, 6);
INSERT INTO `FunctieItems` VALUES(49, "", "", "", "", 0, -1, 7);
INSERT INTO `FunctieItems` VALUES(50, "", "", "", "", 0, -1, 8);
INSERT INTO `FunctieItems` VALUES(51, "", "", "", "", 0, -1, 9);
INSERT INTO `FunctieItems` VALUES(52, "", "", "", "", 0, -1, 10);
INSERT INTO `FunctieItems` VALUES(53, "", "", "", "", 0, -1, 11);
INSERT INTO `FunctieItems` VALUES(54, "", "", "", "", 0, -1, 12);
INSERT INTO `FunctieItems` VALUES(55, "", "", "", "", 0, -1, 13);
INSERT INTO `FunctieItems` VALUES(56, "", "", "", "", 0, -1, 14);
INSERT INTO `FunctieItems` VALUES(57, "", "", "", "", 0, -1, 15);
INSERT INTO `FunctieItems` VALUES(58, "", "", "", "", 0, -1, 16);
INSERT INTO `FunctieItems` VALUES(59, "", "", "", "", 0, -1, 17);
INSERT INTO `FunctieItems` VALUES(60, "", "", "", "", 0, -1, 18);
INSERT INTO `FunctieItems` VALUES(61, "", "", "", "", 0, -1, 19);
INSERT INTO `FunctieItems` VALUES(62, "", "", "", "", 0, -1, 20);
INSERT INTO `FunctieItems` VALUES(63, "", "", "", "", 0, -1, 21);
INSERT INTO `FunctieItems` VALUES(64, "", "", "", "", 0, -1, 22);
INSERT INTO `FunctieItems` VALUES(65, "", "", "", "", 0, -1, 23);
INSERT INTO `FunctieItems` VALUES(66, "", "", "", "", 0, -1, 24);
INSERT INTO `FunctieItems` VALUES(67, "", "", "", "", 0, -1, 25);
INSERT INTO `FunctieItems` VALUES(68, "", "", "", "", 0, -1, 26);
INSERT INTO `FunctieItems` VALUES(69, "", "", "", "", 0, -1, 27);
INSERT INTO `FunctieItems` VALUES(70, "", "", "", "", 0, -1, 28);
INSERT INTO `FunctieItems` VALUES(71, "", "", "", "", 0, -1, 29);
INSERT INTO `FunctieItems` VALUES(72, "", "", "", "", 0, -1, 30);
INSERT INTO `FunctieItems` VALUES(73, "", "", "", "", 0, -1, 31);
INSERT INTO `FunctieItems` VALUES(74, "", "", "", "", 0, -1, 32);
INSERT INTO `FunctieItems` VALUES(75, "", "", "", "", 0, -1, 33);
INSERT INTO `FunctieItems` VALUES(76, "", "", "", "", 0, -1, 34);
INSERT INTO `FunctieItems` VALUES(77, "", "", "", "", 0, -1, 35);
INSERT INTO `FunctieItems` VALUES(78, "", "", "", "", 0, -1, 36);
INSERT INTO `FunctieItems` VALUES(79, "", "", "", "", 0, -1, 37);
INSERT INTO `FunctieItems` VALUES(80, "", "", "", "", 0, -1, 38);
INSERT INTO `FunctieItems` VALUES(81, "", "", "", "", 0, -1, 39);
INSERT INTO `FunctieItems` VALUES(82, "", "", "", "", 0, -1, 40);
INSERT INTO `FunctieItems` VALUES(83, "", "", "", "", 0, -1, 41);
INSERT INTO `FunctieItems` VALUES(84, "", "", "", "", 0, -1, 42);
INSERT INTO `FunctieItems` VALUES(85, "", "", "", "", 0, -1, 43);
INSERT INTO `FunctieItems` VALUES(86, "", "", "", "", 0, -1, 44);
INSERT INTO `FunctieItems` VALUES(87, "", "", "", "", 0, -1, 45);
INSERT INTO `FunctieItems` VALUES(88, "", "", "", "", 0, -1, 46);
UNLOCK TABLES;

#
# Table structure for table 'Leveranciers'
#

DROP TABLE IF EXISTS `Leveranciers`;
CREATE TABLE `Leveranciers` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `naam` VARCHAR(255),
  `pakket` VARCHAR(255),
  `telefoon1` VARCHAR(255),
  `contact` VARCHAR(255),
  `telefoon2` VARCHAR(255),
  `telefoon3` VARCHAR(255),
  `email` VARCHAR(255),
  `info` BIT,
  `opmerkingen` LONGTEXT,
  PRIMARY KEY (`Id`)
);

#
# Dumping data for table 'Leveranciers'
#

LOCK TABLES `Leveranciers` WRITE;
INSERT INTO `Leveranciers` VALUES(2, 'Arcadis', 'mi2', '033 4771661', 'Peter van Boekel', '055 5815926', '06 27062154', 'p.a.m.boekel@arcadis.nl', -1, 'heeft Winsign-pakket van Uniforn overgenomen. Heet nu "mi2"');
INSERT INTO `Leveranciers` VALUES(4, 'DHV', 'DHV Beheerpakketten', '033 4682000', 'Max de Veer', '033 4683340', '06 29098262', 'max.deveer@dhv.nl', -1, "");
INSERT INTO `Leveranciers` VALUES(5, 'Grontmij', 'DG Dialog', "", 'Henri Veldhuis', '0165 575763', '06 20013109', 'henri.veldhuis@grontmij.nl', -1, 'Zegt alles te kunnen leveren omdat elk niet bestaand object kan worden aangemaakt in de module Overige Objecten; Het plannen en bewaken van de voortgang van projecten is geen standaardfunctionaliteit van dg DIALOG. Het is in de verschillende modules van dg DIALOG wel mogelijk om vastgesteld onderhoud op te nemen in een toekomstige planning; Momenteel wordt door Grontmij in opdracht van de provincie Zuid Holland een module ontwikkelt voor het beheer van VRI\'s. Oplevering van deze module is gepland voor maart 2007.');
INSERT INTO `Leveranciers` VALUES(6, 'Groenestijn Beheersoftware', 'GB GIS', '0317 417647', 'Jan Groenestijn', "", "", 'info@gbor.nl', -1, 'Jan Groenestijn (eigenaar) "kan niets" met lijst van gegevensgebieden; Alleen module voor oevers (niet sloten); Fotolink (geen cyclorama); Kapvergunning (geen algemene verg.)');
INSERT INTO `Leveranciers` VALUES(7, 'Beheer Visie', 'BS8*Beheer', '0348 499337', 'Peter Hermsen', "", '06 53638679', 'peter.hermsen@beheervisie.nl', -1, "");
INSERT INTO `Leveranciers` VALUES(8, 'KOAC NPC', 'ViaView/Accres', '030 2876950', 'Thijs Adolfs', '030 2876981', "", 'adolfs@koac-npc.nl', -1, 'Fotolink (geen cyclorama);');
INSERT INTO `Leveranciers` VALUES(10, 'Oranjewoud', 'GBI', '0513 634567', 'Harmen Tjeerdsma', "", '06 53926449', 'harmen.tjeerdsma@oranjewoud.nl', 0, 'Cyclorama alleen via koppeling externe software; Eigendom alleen in openbare ruimte');
INSERT INTO `Leveranciers` VALUES(11, 'Fugro Inpark', 'Infra', '070 3170700', 'Jan Hemmen', '026 3698470', '06 54381535', 'j.hemmen@fugro-inpark.nl', -1, "");
INSERT INTO `Leveranciers` VALUES(12, 'Holland Reliëf', "", "", "", "", "", "", 0, "");
INSERT INTO `Leveranciers` VALUES(13, 'HawarIT', "", '0515 570333', 'Cees Nieboer', "", "", 'c.nieboer@hawarit.com', 0, 'Heeft delen van de DHV Beheerpakketten gemaakt; Biedt vooral grafische lagen boven DHV, Arcadis, etc.');
INSERT INTO `Leveranciers` VALUES(16, 'Witteveen en Bos', "", '0570 697911', 'Dennis Sunnebelt', '0570 697160', "", "", 0, 'de software die ze hebben (alleen op het gebied van geleiderails) is gemaakt door DHV. Dit pakket van DHV wat inventarisaties maakt van bermen/geleiderails heet Prioberm');
INSERT INTO `Leveranciers` VALUES(17, 'Infra Engineering', "", "", "", "", "", "", 0, 'ontwikkeld geen software meer voor WIS; Vroeger software ontwikkeld i.s.m. Oranjewoud');
INSERT INTO `Leveranciers` VALUES(18, 'Uniform', 'Winsign', "", 'Dijkstra/Smallegange', "", "", "", 0, 'heeft Winsign-pakket verkocht aan Arcadis');
INSERT INTO `Leveranciers` VALUES(19, 'Holland Field Engineering', "", '023 5321959', 'dhr. Frenay', "", "", 'info@hollandfield.nl', 0, '"Kan het niet voor elkaar krijgen". (Geen capaciteit/mogelijkheid/know-how/wil (conclusie van Erik))');
INSERT INTO `Leveranciers` VALUES(22, 'Microsoft', "", "", "", "", "", "", 0, "");
INSERT INTO `Leveranciers` VALUES(23, 'AutoDesk', 'Autocad', '0180 691000', "", "", "", "", 0, "");
INSERT INTO `Leveranciers` VALUES(24, 'Bentley', 'Microstation', '023 5560 560', "", "", "", "", 0, "");
INSERT INTO `Leveranciers` VALUES(26, 'Cyclomedia', "", "", "", "", "", "", 0, "");
INSERT INTO `Leveranciers` VALUES(27, 'RDW', "", "", "", "", "", "", 0, "");
INSERT INTO `Leveranciers` VALUES(28, 'Onbekend', "", "", "", "", "", "", 0, "");
INSERT INTO `Leveranciers` VALUES(29, 'Dufec', 'BASEC', '013 460 9983', "", "", "", "", 0, "");
INSERT INTO `Leveranciers` VALUES(30, 'Provincie Noord-Brabant', 'zelfbouw/maatwerk', "", "", "", "", "", 0, "");
UNLOCK TABLES;

#
# Table structure for table 'LocatieAanduidingen'
#

DROP TABLE IF EXISTS `LocatieAanduidingen`;
CREATE TABLE `LocatieAanduidingen` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `naam` VARCHAR(50),
  `omschrijving` VARCHAR(255),
  INDEX `id` (`id`),
  PRIMARY KEY (`id`)
);

#
# Dumping data for table 'LocatieAanduidingen'
#

LOCK TABLES `LocatieAanduidingen` WRITE;
INSERT INTO `LocatieAanduidingen` VALUES(1, 'RD coordinaten', 'x en y coordinaten van klikpunt');
INSERT INTO `LocatieAanduidingen` VALUES(2, 'WOL/HM', 'indien klikpunt binnen 100 m van hmpaal dan wegnr en hm aanduiding');
INSERT INTO `LocatieAanduidingen` VALUES(3, 'Adres', 'Straat, nr, postcode, plaats, gemeente van klikpunt');
INSERT INTO `LocatieAanduidingen` VALUES(4, 'Regio', 'aanduiding in welke regio klikpunt ligt');
UNLOCK TABLES;

#
# Table structure for table 'Medewerkers'
#

DROP TABLE IF EXISTS `Medewerkers`;
CREATE TABLE `Medewerkers` (
  `Id` INT NOT NULL AUTO_INCREMENT,
  `Achternaam` VARCHAR(255),
  `Voornaam` VARCHAR(255),
  `Telefoon/mobiel` VARCHAR(255),
  `Functie` VARCHAR(255),
  `Locatie` VARCHAR(255),
  `E-mail` VARCHAR(255),
  PRIMARY KEY (`Id`)
);

#
# Dumping data for table 'Medewerkers'
#

LOCK TABLES `Medewerkers` WRITE;
INSERT INTO `Medewerkers` VALUES(1, 'Boer, van den C.C.M.', 'Cees', '(073-681) 2237/06-18303177', 'Bureauhoofd', '18/15', 'Cvdboer@brabant.nl');
INSERT INTO `Medewerkers` VALUES(2, 'Boome, te C.M.J.', 'Karen', '(0413-29) 6740', 'Bureauhoofd', 'Heeswijk/Dinther', 'CtBoome@brabant.nl');
INSERT INTO `Medewerkers` VALUES(3, 'Gaveel, R.H.', 'Rob', '(073-680) 8324/06-18303401', 'Bureauhoofd', '19/15', ' RGaveel@brabant.nl');
INSERT INTO `Medewerkers` VALUES(4, 'Helvert, van T.J.A.', 'Terry', '(076-523) 1640', 'Bureauhoofd', 'Breda', 'TvHelvert@brabant.nl');
INSERT INTO `Medewerkers` VALUES(5, 'Post, M.', 'Maarten', '(0499-36) 4740/06-18303209', 'Bureauhoofd', 'Best/', ' MPost@brabant.nl');
INSERT INTO `Medewerkers` VALUES(6, 'Slagboom, J.C.', 'Hans', '(073-680) 8216', 'Bureauhoofd OVM', '21/18', 'HSlagboom@brabant.nl');
INSERT INTO `Medewerkers` VALUES(7, 'Gils, van J.A.W.', 'Joost', '(073-681) 2457', 'Directielid', '20/21', ' JvGils@brabant.nl');
INSERT INTO `Medewerkers` VALUES(8, 'Coillie, van E.A.G.', 'Egmond', '(073-680) 8849', 'Vakinhoudelijk medewerker F.', '19/16', 'EvCoillie@brabant.nl');
INSERT INTO `Medewerkers` VALUES(9, 'Broek, van den H.A.J.', 'Henk', '(073-681) 2339', 'Medewerker verkeerstellingen', '19/16', ' HAvdBroek@brabant.nl');
INSERT INTO `Medewerkers` VALUES(10, 'Egeraat, van M.A.L.', 'Michael', '(073-681) 2450', 'Clustercoördinator Monitoring Ecaluatie en Verkeersmodellen (MEMO)', '18/flex', ' MvEgeraat@brabant.nl');
INSERT INTO `Medewerkers` VALUES(11, 'Wolff, de P.', 'Peter', '(073-680) 8519', 'Beleidsmedewerker Verkeersmanagement', '19/flex', ' PdWolff@brabant.nl');
INSERT INTO `Medewerkers` VALUES(12, 'Dorst, van M.C.M.', 'Marco', '(0499-36) 4710/06-18303212', 'Beleidsmedewerker verkeer/Coördinator verkeersbeheer', 'Best/', ' MvDorst@brabant.nl');
INSERT INTO `Medewerkers` VALUES(13, 'Kort, de P.P.A.', 'Peter', '(076-523) 1610', 'Beleidsmedewerker/plaatsvervangend bureauhoofd', 'Breda/', ' PdKort@brabant.nl');
INSERT INTO `Medewerkers` VALUES(14, 'Steens, B.J.P.', 'Bart', '(0413-29) 6710/06-18303175', 'Beleidsmedewerker verkeer, Coördinator verkeersbeheer', 'Heeswijk/Dinther', ' BSteens@brabant.nl');
INSERT INTO `Medewerkers` VALUES(15, 'Geurtz, F.J.M.', 'Frank', '(073-680) 8715/(073-681) 2346', 'Projectingenieur A', '19/flex', 'FGeurtz@brabant.nl');
INSERT INTO `Medewerkers` VALUES(16, 'Kooijman, R.A.', 'René', '(073-680) 8138', 'Ontwerper B', '19/02', ' RKooijman@brabant.nl');
INSERT INTO `Medewerkers` VALUES(17, 'Kappé, J.E.M.', 'Jan', '(073-681) 2455', 'Projectcoördinator', '19/flex', ' JKappe@brabant.nl');
INSERT INTO `Medewerkers` VALUES(18, 'Logt, van de Q.A.J.', 'Quirin', '(073-681)2352/06-18303230', 'Projectleider infrastructurele projecten', '18/03', ' QvdLogt@brabant.nl');
INSERT INTO `Medewerkers` VALUES(19, 'Strik, C.W.M.', 'Casper', '(073-680) 8716', 'Projectleider', '18/flex', ' CStrik@brabant.nl');
INSERT INTO `Medewerkers` VALUES(20, 'Mens, J.G.M.', 'Jacques', '(073-681) 2845', 'Beleidsmedewerker realiseren', '19/flex', ' JMens@brabant.nl');
INSERT INTO `Medewerkers` VALUES(21, 'Bont, de H.P.A.P.', 'Harrie', '(0413-29) 6700/06-18303228', 'Directievoerder', 'Heeswijk/Dinther', ' HdBont@brabant.nl');
INSERT INTO `Medewerkers` VALUES(22, 'Kaam, van E.H.N.', 'Eric', '(076-523) 1620/06-18303193', 'Projectcoördinator A', 'Breda/', ' EvKaam@brabant.nl');
INSERT INTO `Medewerkers` VALUES(23, 'Groenen, F.J.M.C.', 'Frans', '(0499-36) 4714', 'Medewerker verkeerbeheer', 'Best/', ' FGroenen@brabant.nl');
INSERT INTO `Medewerkers` VALUES(24, 'Esch, van H.A.M.', 'Henk', '(0413-29) 6715/06-18303264', 'Tijdelijk 29-08-07 Inspecteur Verkeersbeheer', 'Heeswijk/Dinther', ' HvEsch@brabant.nl');
INSERT INTO `Medewerkers` VALUES(25, 'Spijk, van C.H.G.', 'Cor', '(0413-29) 6711/06-18303179', 'Medewerker Dynamisch Verkeersmanagement', 'Heeswijk/Dinther', ' Cvspijk@brabant.nl');
INSERT INTO `Medewerkers` VALUES(26, 'Sulkers, J.', 'Jaap', '(076-523) 1600', 'Inspecteur verkeersbeheer A', 'Breda/', ' JSulkers@brabant.nl');
INSERT INTO `Medewerkers` VALUES(27, 'Zwarteveen, J.A.', 'Hans', '(073-681) 2723/06-18303442', 'Ontwerper', '19/flex', ' HZwarteveen@brabant.nl');
INSERT INTO `Medewerkers` VALUES(28, 'Engelhard, F.W.J.', 'Fred', '(073-680) 8520', 'Beheerder verhardingsgegevens, med. calculatie en informatisering', '19/17', ' FEngelhard@brabant.nl');
INSERT INTO `Medewerkers` VALUES(29, 'Nistelrooij, van G.C.J.F.', 'Gijs', '(0499-36) 4711/06-18303214', 'Medewerker Dynamisch Verkeersmanagement', 'Best/', 'GvNistelrooy@brabant.nl');
INSERT INTO `Medewerkers` VALUES(30, 'Zandvoort, van J.A.L.', 'Hans', '(073-681) 2017', 'Projectleider ontsnippering', '18/flex', ' JvZandvoort@brabant.nl');
INSERT INTO `Medewerkers` VALUES(31, 'Deelen, J.C.A.', 'Hans', '(0499-36) 4722/06-18303220', 'Toezichthouder', '19/21', 'HDeelen@brabant.nl');
INSERT INTO `Medewerkers` VALUES(32, 'Bongers, C.P.M.', 'Kees', '(0413-29) 6722/06-18303172', 'Toezichthouder', 'Heeswijk/Dinther', ' KBongers@brabant.nl');
INSERT INTO `Medewerkers` VALUES(33, 'Tienhoven, van R.A.', 'Sander', '(073-681)2471/06-18303085', 'Verkeerstechnisch adviseur verkeersregelingen', '19/flex', ' SvTienhoven@brabant.nl');
INSERT INTO `Medewerkers` VALUES(34, 'Verstappen, W.A.M.', 'William', '(0499-36) 4721/06-18303443', 'Toezichthouder/Directievoerder', 'Best/', ' WVerstappen@brabant.nl');
INSERT INTO `Medewerkers` VALUES(35, 'Baarendse, A.M.H.M.', 'Ton', '(073-681) 2345', 'Technisch administratief medewerker civiele kunstwerken', '19/flex', ' TBaarendse@brabant.nl');
INSERT INTO `Medewerkers` VALUES(36, 'Ras, T.A.', 'Ron', '(073-681) 2459', 'Medewerker beheer A', '18/09', ' RRas@brabant.nl');
INSERT INTO `Medewerkers` VALUES(37, 'Dudar, J.G.H.M.', 'Jim', '(073-681) 2314', 'Beleidsmedewerker', '19/flex', ' JDudar@brabant.nl');
INSERT INTO `Medewerkers` VALUES(38, 'Bakker, P.C.H.', 'Paul', '(0413-29) 6700/06-18303357', 'Toezichthouder', 'Heeswijk/Dinther', ' PBakker@brabant.nl');
INSERT INTO `Medewerkers` VALUES(39, 'Thielen, C.A.N.', 'Cees', '(076-523) 1600/06-18303151', 'Directie UAV', 'Breda/', ' CThielen@brabant.nl');
INSERT INTO `Medewerkers` VALUES(40, 'Korsten, A.J.M.M.', 'Jos', '(073-681) 2463', 'Beleidsmedewerker', '18/02', ' JKorsten@brabant.nl');
INSERT INTO `Medewerkers` VALUES(41, 'Verwijmeren, D.C.', 'Dion', '(073-680) 8186', 'Medewerker beheer A', '18/o1', ' DVerwijmeren@brabant.nl');
INSERT INTO `Medewerkers` VALUES(42, 'Ceelen, M.A.F.H.', 'Mark', '(0413-29) 6712/06-18303168', 'Juridisch medewerker', 'Heeswijk/Dinther', ' MCeelen@brabant.nl');
INSERT INTO `Medewerkers` VALUES(43, 'Thijssen, M.J.L.', 'Mark', '(073-681) 2416', 'Teamleider systeemintegratie en systeemarchitect', '04/09', ' MThijssen@brabant.nl');
INSERT INTO `Medewerkers` VALUES(44, 'Smits, G.J.M.', 'Guido', '(073-681) 2322', 'Bureauhoofd Informatie-management', '05/21', ' GSmits@Brabant.nl');
INSERT INTO `Medewerkers` VALUES(45, 'Hoefnagels, A.C.A.', 'Louk', '(073-681) 2169', 'Concern-adviseur integrale informatievoorziening', '04/18', ' AHoefnagels@brabant.nl');
INSERT INTO `Medewerkers` VALUES(46, 'Berg, van den J.C.', 'Hans', '(073-681) 2540', 'Data-architect', '17/21', ' JCvdBerg@brabant.nl');
INSERT INTO `Medewerkers` VALUES(47, 'Bilde, de J.H.L.', 'Jos', '(073-680) 8517', 'Projectleider IIV', '04/03', ' JdBilde@brabant.nl');
INSERT INTO `Medewerkers` VALUES(48, 'Hagedoorn, F.P.', 'Frank', '(073-681) 2414', 'Ontwikkelaar informatiesystemen', '04/19', ' fhagedoorn@brabant.nl');
INSERT INTO `Medewerkers` VALUES(49, 'Vlamings, A.M.A.M.', 'Ton', '(073-681) 2441', 'Informatie-analist', '04/06', 'TVlamings@brabant.nl');
INSERT INTO `Medewerkers` VALUES(50, 'Vriends, G.V.C.', 'Guust', '(073-680) 8344', 'Geografisch informatie analist', '17/18', ' GVriends@brabant.nl');
INSERT INTO `Medewerkers` VALUES(51, 'Bevelander MSc, M.', 'Marjan', '(073-681) 2703', 'Teamleider datamanagement', '17/21', ' MBevelander@brabant.nl');
INSERT INTO `Medewerkers` VALUES(52, 'Voet, H.A.L.J.', 'Herman', '(073-680) 8574', 'Beleidsmedewerker nieuwe toepassingen geografische informatievoorziening', '17/19', ' HVoet@brabant.nl');
INSERT INTO `Medewerkers` VALUES(53, 'Schiphorst, ter A', 'Lex', '(073-681)2610 / 06-18303145', 'Teamleider geodesie', '16/03', ' LtSchiphorst@brabant.nl');
INSERT INTO `Medewerkers` VALUES(54, 'Hooiveld, J.P.J.', 'JaccoPeter', '(073-680) 8430', 'Teamleider geografische informatievoorziening frontoffice', '17/07', ' JHooiveld@brabant.nl');
INSERT INTO `Medewerkers` VALUES(55, 'Oerle, van A.', 'Toon', "", "", "", "");
UNLOCK TABLES;

#
# Table structure for table 'Moscow'
#

DROP TABLE IF EXISTS `Moscow`;
CREATE TABLE `Moscow` (
  `id` INT NOT NULL DEFAULT 0,
  `code` VARCHAR(50),
  `naam` VARCHAR(20),
  `omschrijving` VARCHAR(50),
  INDEX `id` (`code`),
  INDEX `id1` (`id`),
  PRIMARY KEY (`id`)
);

#
# Dumping data for table 'Moscow'
#

LOCK TABLES `Moscow` WRITE;
INSERT INTO `Moscow` VALUES(0, 'O', 'Onbekend', "");
INSERT INTO `Moscow` VALUES(1, 'M', 'Must Have', "");
INSERT INTO `Moscow` VALUES(2, 'S', 'Should Have', "");
INSERT INTO `Moscow` VALUES(3, 'C', 'Could Have', "");
INSERT INTO `Moscow` VALUES(4, 'W', 'Will Not Have', "");
UNLOCK TABLES;

#
# Table structure for table 'Onderdeel'
#

DROP TABLE IF EXISTS `Onderdeel`;
CREATE TABLE `Onderdeel` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `naam` VARCHAR(50),
  `omschrijving` VARCHAR(50),
  `locatie` VARCHAR(50),
  `regio` BIT,
  INDEX `id` (`id`),
  PRIMARY KEY (`id`)
);

#
# Dumping data for table 'Onderdeel'
#

LOCK TABLES `Onderdeel` WRITE;
INSERT INTO `Onderdeel` VALUES(1, 'Onbekend', "", "", 0);
INSERT INTO `Onderdeel` VALUES(7, 'Projectleider', 'tijdelijke verantwoordelijke gedurende project', "", 0);
INSERT INTO `Onderdeel` VALUES(9, 'EenM//INF', 'uitvoering viaview', 'Den Bosch', 0);
INSERT INTO `Onderdeel` VALUES(10, 'EenM//EenMa', '-', 'Den Bosch', 0);
INSERT INTO `Onderdeel` VALUES(12, 'EenM//MRNO', 'regio noord-oost', 'Heeswijk-Dinther', -1);
INSERT INTO `Onderdeel` VALUES(13, 'EenM//MRW', 'regio west', 'Breda', -1);
INSERT INTO `Onderdeel` VALUES(14, 'EenM//MRZO', 'regio zuid-oost', 'Best', -1);
INSERT INTO `Onderdeel` VALUES(15, 'EenM//OVM', '-', 'Den Bosch', 0);
INSERT INTO `Onderdeel` VALUES(16, 'EenM//UM', 'uitvoering groenestein, collector en veras', 'Den Bosch', 0);
INSERT INTO `Onderdeel` VALUES(17, 'MID/IIV/AenI', '-', 'Den Bosch', 0);
INSERT INTO `Onderdeel` VALUES(18, 'MID/IIV/GEO', '-', 'Den Bosch', 0);
INSERT INTO `Onderdeel` VALUES(19, 'MID/IIV/IM', '-', 'Den Bosch', 0);
INSERT INTO `Onderdeel` VALUES(20, 'EenM//MRX', 'alle regios', "", -1);
INSERT INTO `Onderdeel` VALUES(21, 'Ontwerper', 'leverancier, bouwer', "", 0);
INSERT INTO `Onderdeel` VALUES(22, 'ECL', 'ecologie', "", 0);
UNLOCK TABLES;

#
# Table structure for table 'OnderdeelMedewerkers'
#

DROP TABLE IF EXISTS `OnderdeelMedewerkers`;
CREATE TABLE `OnderdeelMedewerkers` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `medewerker_id` INT DEFAULT 0,
  `onderdeel_id` INT DEFAULT 1,
  `vertegenwoordiger` BIT,
  INDEX `groep_id` (`onderdeel_id`),
  INDEX `GroepGroepMedewerkers` (`onderdeel_id`),
  INDEX `id` (`id`),
  INDEX `medewerker_id` (`medewerker_id`),
  INDEX `MedewerkersOnderdeelMedewerkers` (`medewerker_id`),
  PRIMARY KEY (`id`)
);

#
# Dumping data for table 'OnderdeelMedewerkers'
#

LOCK TABLES `OnderdeelMedewerkers` WRITE;
INSERT INTO `OnderdeelMedewerkers` VALUES(69, 15, 9, 0);
INSERT INTO `OnderdeelMedewerkers` VALUES(70, 7, 10, -1);
INSERT INTO `OnderdeelMedewerkers` VALUES(71, 3, 9, 0);
INSERT INTO `OnderdeelMedewerkers` VALUES(72, 16, 9, 0);
INSERT INTO `OnderdeelMedewerkers` VALUES(73, 17, 9, 0);
INSERT INTO `OnderdeelMedewerkers` VALUES(74, 20, 9, 0);
INSERT INTO `OnderdeelMedewerkers` VALUES(75, 27, 9, 0);
INSERT INTO `OnderdeelMedewerkers` VALUES(76, 28, 9, -1);
INSERT INTO `OnderdeelMedewerkers` VALUES(77, 33, 9, 0);
INSERT INTO `OnderdeelMedewerkers` VALUES(78, 35, 9, 0);
INSERT INTO `OnderdeelMedewerkers` VALUES(79, 37, 9, 0);
INSERT INTO `OnderdeelMedewerkers` VALUES(80, 2, 12, 0);
INSERT INTO `OnderdeelMedewerkers` VALUES(81, 14, 12, 0);
INSERT INTO `OnderdeelMedewerkers` VALUES(82, 21, 12, 0);
INSERT INTO `OnderdeelMedewerkers` VALUES(83, 24, 12, 0);
INSERT INTO `OnderdeelMedewerkers` VALUES(84, 25, 12, 0);
INSERT INTO `OnderdeelMedewerkers` VALUES(85, 32, 12, 0);
INSERT INTO `OnderdeelMedewerkers` VALUES(86, 38, 12, 0);
INSERT INTO `OnderdeelMedewerkers` VALUES(87, 42, 12, 0);
INSERT INTO `OnderdeelMedewerkers` VALUES(88, 4, 13, -1);
INSERT INTO `OnderdeelMedewerkers` VALUES(89, 13, 13, 0);
INSERT INTO `OnderdeelMedewerkers` VALUES(90, 22, 13, 0);
INSERT INTO `OnderdeelMedewerkers` VALUES(91, 26, 13, 0);
INSERT INTO `OnderdeelMedewerkers` VALUES(92, 39, 13, 0);
INSERT INTO `OnderdeelMedewerkers` VALUES(93, 5, 14, -1);
INSERT INTO `OnderdeelMedewerkers` VALUES(94, 12, 14, 0);
INSERT INTO `OnderdeelMedewerkers` VALUES(95, 23, 14, 0);
INSERT INTO `OnderdeelMedewerkers` VALUES(96, 29, 14, 0);
INSERT INTO `OnderdeelMedewerkers` VALUES(97, 31, 14, 0);
INSERT INTO `OnderdeelMedewerkers` VALUES(98, 34, 14, 0);
INSERT INTO `OnderdeelMedewerkers` VALUES(99, 6, 15, -1);
INSERT INTO `OnderdeelMedewerkers` VALUES(100, 1, 16, 0);
INSERT INTO `OnderdeelMedewerkers` VALUES(101, 8, 16, 0);
INSERT INTO `OnderdeelMedewerkers` VALUES(102, 9, 16, 0);
INSERT INTO `OnderdeelMedewerkers` VALUES(103, 10, 16, 0);
INSERT INTO `OnderdeelMedewerkers` VALUES(104, 11, 16, 0);
INSERT INTO `OnderdeelMedewerkers` VALUES(105, 18, 16, 0);
INSERT INTO `OnderdeelMedewerkers` VALUES(106, 19, 16, 0);
INSERT INTO `OnderdeelMedewerkers` VALUES(107, 30, 16, 0);
INSERT INTO `OnderdeelMedewerkers` VALUES(108, 36, 16, 0);
INSERT INTO `OnderdeelMedewerkers` VALUES(109, 40, 16, 0);
INSERT INTO `OnderdeelMedewerkers` VALUES(110, 41, 16, 0);
INSERT INTO `OnderdeelMedewerkers` VALUES(111, 43, 17, -1);
INSERT INTO `OnderdeelMedewerkers` VALUES(112, 46, 17, 0);
INSERT INTO `OnderdeelMedewerkers` VALUES(113, 51, 17, 0);
INSERT INTO `OnderdeelMedewerkers` VALUES(114, 50, 18, 0);
INSERT INTO `OnderdeelMedewerkers` VALUES(115, 52, 18, 0);
INSERT INTO `OnderdeelMedewerkers` VALUES(116, 53, 18, -1);
INSERT INTO `OnderdeelMedewerkers` VALUES(117, 54, 18, 0);
INSERT INTO `OnderdeelMedewerkers` VALUES(118, 44, 19, -1);
INSERT INTO `OnderdeelMedewerkers` VALUES(119, 45, 19, 0);
INSERT INTO `OnderdeelMedewerkers` VALUES(120, 47, 19, 0);
INSERT INTO `OnderdeelMedewerkers` VALUES(121, 48, 19, 0);
INSERT INTO `OnderdeelMedewerkers` VALUES(122, 49, 19, 0);
UNLOCK TABLES;

#
# Table structure for table 'RegelAttributen'
#

DROP TABLE IF EXISTS `RegelAttributen`;
CREATE TABLE `RegelAttributen` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `admin_id` INT DEFAULT 0,
  `regel_id` INT DEFAULT 0,
  `waarde` VARCHAR(50),
  INDEX `admin_id` (`admin_id`),
  INDEX `DataRegelsRegelAttributen` (`regel_id`),
  INDEX `id` (`id`),
  PRIMARY KEY (`id`),
  INDEX `regel_id` (`regel_id`),
  INDEX `ThemaItemsAdminRegelAttributen` (`admin_id`)
);

#
# Dumping data for table 'RegelAttributen'
#

LOCK TABLES `RegelAttributen` WRITE;
UNLOCK TABLES;

#
# Table structure for table 'SpatialObjects'
#

DROP TABLE IF EXISTS `SpatialObjects`;
CREATE TABLE `SpatialObjects` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `spatial_id` INT DEFAULT 0,
  `regel_id` INT DEFAULT 0,
  `geometry` VARCHAR(50),
  `timestamp` CHAR(19),
  INDEX `DataRegelsSpatialObjects` (`regel_id`),
  INDEX `id` (`id`),
  INDEX `itemsspatial_id` (`spatial_id`),
  PRIMARY KEY (`id`),
  INDEX `regel_id` (`regel_id`),
  INDEX `ThemaItemsSpatialSpatialObjects` (`spatial_id`)
);

#
# Dumping data for table 'SpatialObjects'
#

LOCK TABLES `SpatialObjects` WRITE;
UNLOCK TABLES;

#
# Table structure for table 'ThemaApplicaties'
#

DROP TABLE IF EXISTS `ThemaApplicaties`;
CREATE TABLE `ThemaApplicaties` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `thema_id` INT DEFAULT 0,
  `applicatie_id` INT DEFAULT 0,
  `ingebruik` BIT,
  `spatial` BIT,
  `administratief` BIT,
  `voorkeur` BIT,
  `definitief` BIT,
  `standaard` BIT,
  INDEX `applicatie_id` (`applicatie_id`),
  INDEX `ApplicatiesThemaApplicaties` (`applicatie_id`),
  INDEX `id` (`id`),
  PRIMARY KEY (`id`),
  INDEX `thema_id` (`thema_id`),
  INDEX `ThemasThemaApplicaties` (`thema_id`)
);

#
# Dumping data for table 'ThemaApplicaties'
#

LOCK TABLES `ThemaApplicaties` WRITE;
INSERT INTO `ThemaApplicaties` VALUES(1, 1, 1, -1, -1, -1, -1, -1, -1);
INSERT INTO `ThemaApplicaties` VALUES(3, 4, 1, -1, -1, -1, -1, -1, -1);
INSERT INTO `ThemaApplicaties` VALUES(7, 8, 1, -1, -1, -1, -1, -1, -1);
INSERT INTO `ThemaApplicaties` VALUES(11, 13, 1, -1, -1, -1, -1, -1, -1);
INSERT INTO `ThemaApplicaties` VALUES(12, 14, 11, -1, 0, -1, 0, 0, -1);
INSERT INTO `ThemaApplicaties` VALUES(13, 15, 15, -1, -1, 0, 0, 0, -1);
INSERT INTO `ThemaApplicaties` VALUES(14, 16, 4, -1, 0, -1, 0, 0, -1);
INSERT INTO `ThemaApplicaties` VALUES(19, 22, 8, -1, 0, -1, -1, 0, -1);
INSERT INTO `ThemaApplicaties` VALUES(20, 23, 8, -1, 0, -1, 0, 0, -1);
INSERT INTO `ThemaApplicaties` VALUES(22, 25, 3, -1, 0, -1, 0, 0, -1);
INSERT INTO `ThemaApplicaties` VALUES(24, 27, 10, -1, 0, -1, 0, 0, -1);
INSERT INTO `ThemaApplicaties` VALUES(27, 30, 7, -1, 0, -1, 0, 0, -1);
INSERT INTO `ThemaApplicaties` VALUES(28, 31, 11, -1, 0, -1, 0, 0, -1);
INSERT INTO `ThemaApplicaties` VALUES(30, 33, 5, -1, 0, -1, 0, 0, -1);
INSERT INTO `ThemaApplicaties` VALUES(31, 34, 5, -1, 0, -1, 0, 0, -1);
INSERT INTO `ThemaApplicaties` VALUES(32, 35, 5, -1, 0, -1, 0, 0, -1);
INSERT INTO `ThemaApplicaties` VALUES(33, 36, 5, -1, 0, -1, 0, 0, -1);
INSERT INTO `ThemaApplicaties` VALUES(35, 38, 1, -1, -1, -1, -1, -1, -1);
INSERT INTO `ThemaApplicaties` VALUES(38, 41, 1, -1, -1, -1, -1, 0, -1);
INSERT INTO `ThemaApplicaties` VALUES(39, 42, 16, -1, 0, -1, 0, 0, -1);
INSERT INTO `ThemaApplicaties` VALUES(43, 5, 2, -1, -1, -1, -1, -1, -1);
INSERT INTO `ThemaApplicaties` VALUES(44, 6, 2, -1, -1, -1, -1, -1, -1);
INSERT INTO `ThemaApplicaties` VALUES(48, 11, 6, -1, -1, 0, -1, 0, -1);
INSERT INTO `ThemaApplicaties` VALUES(51, 14, 12, -1, -1, 0, 0, 0, -1);
INSERT INTO `ThemaApplicaties` VALUES(55, 18, 2, -1, -1, -1, -1, -1, -1);
INSERT INTO `ThemaApplicaties` VALUES(80, 16, 1, 0, -1, -1, 0, -1, -1);
INSERT INTO `ThemaApplicaties` VALUES(81, 18, 1, 0, 0, 0, 0, 0, -1);
INSERT INTO `ThemaApplicaties` VALUES(82, 12, 1, 0, -1, -1, 0, -1, -1);
INSERT INTO `ThemaApplicaties` VALUES(83, 3, 1, 0, -1, -1, 0, -1, -1);
INSERT INTO `ThemaApplicaties` VALUES(84, 11, 1, 0, -1, -1, 0, -1, -1);
INSERT INTO `ThemaApplicaties` VALUES(85, 23, 1, 0, -1, -1, 0, -1, -1);
INSERT INTO `ThemaApplicaties` VALUES(86, 26, 1, 0, -1, -1, 0, -1, -1);
INSERT INTO `ThemaApplicaties` VALUES(87, 35, 1, 0, -1, -1, 0, 0, -1);
INSERT INTO `ThemaApplicaties` VALUES(88, 44, 1, 0, -1, -1, 0, 0, -1);
INSERT INTO `ThemaApplicaties` VALUES(89, 43, 1, 0, -1, -1, 0, 0, -1);
INSERT INTO `ThemaApplicaties` VALUES(90, 45, 1, 0, -1, -1, 0, 0, -1);
INSERT INTO `ThemaApplicaties` VALUES(91, 13, 2, 0, 0, 0, 0, 0, -1);
INSERT INTO `ThemaApplicaties` VALUES(93, 12, 2, 0, 0, 0, 0, 0, -1);
INSERT INTO `ThemaApplicaties` VALUES(94, 14, 2, 0, -1, -1, 0, 0, -1);
INSERT INTO `ThemaApplicaties` VALUES(96, 9, 2, 0, -1, -1, 0, 0, -1);
INSERT INTO `ThemaApplicaties` VALUES(97, 11, 2, 0, 0, 0, 0, 0, -1);
INSERT INTO `ThemaApplicaties` VALUES(98, 23, 2, 0, 0, 0, 0, 0, -1);
INSERT INTO `ThemaApplicaties` VALUES(99, 26, 2, 0, 0, 0, 0, 0, -1);
INSERT INTO `ThemaApplicaties` VALUES(100, 22, 2, 0, -1, -1, 0, 0, -1);
INSERT INTO `ThemaApplicaties` VALUES(101, 36, 2, 0, -1, -1, 0, 0, -1);
INSERT INTO `ThemaApplicaties` VALUES(102, 44, 2, 0, 0, 0, 0, 0, -1);
INSERT INTO `ThemaApplicaties` VALUES(103, 43, 2, 0, -1, -1, 0, 0, -1);
INSERT INTO `ThemaApplicaties` VALUES(104, 45, 2, 0, -1, -1, 0, 0, -1);
INSERT INTO `ThemaApplicaties` VALUES(105, 13, 18, 0, 0, 0, 0, 0, -1);
INSERT INTO `ThemaApplicaties` VALUES(106, 16, 18, 0, 0, 0, 0, 0, -1);
INSERT INTO `ThemaApplicaties` VALUES(107, 18, 18, 0, 0, 0, 0, 0, -1);
INSERT INTO `ThemaApplicaties` VALUES(108, 23, 18, 0, 0, 0, 0, 0, -1);
INSERT INTO `ThemaApplicaties` VALUES(109, 26, 18, 0, 0, 0, 0, 0, -1);
INSERT INTO `ThemaApplicaties` VALUES(110, 32, 18, 0, 0, 0, 0, 0, -1);
INSERT INTO `ThemaApplicaties` VALUES(111, 36, 18, 0, 0, 0, 0, 0, -1);
INSERT INTO `ThemaApplicaties` VALUES(112, 44, 18, 0, 0, 0, 0, 0, -1);
INSERT INTO `ThemaApplicaties` VALUES(113, 13, 19, 0, 0, 0, 0, 0, -1);
INSERT INTO `ThemaApplicaties` VALUES(114, 16, 19, 0, 0, 0, 0, 0, -1);
INSERT INTO `ThemaApplicaties` VALUES(115, 18, 19, 0, 0, 0, 0, 0, -1);
INSERT INTO `ThemaApplicaties` VALUES(116, 12, 19, 0, 0, 0, 0, 0, -1);
INSERT INTO `ThemaApplicaties` VALUES(117, 14, 19, 0, 0, 0, 0, 0, -1);
INSERT INTO `ThemaApplicaties` VALUES(118, 23, 19, 0, 0, 0, 0, 0, -1);
INSERT INTO `ThemaApplicaties` VALUES(119, 26, 19, 0, 0, 0, 0, 0, -1);
INSERT INTO `ThemaApplicaties` VALUES(120, 39, 19, 0, 0, 0, 0, 0, -1);
INSERT INTO `ThemaApplicaties` VALUES(121, 37, 19, 0, 0, 0, 0, 0, -1);
INSERT INTO `ThemaApplicaties` VALUES(122, 44, 19, 0, 0, 0, 0, 0, -1);
INSERT INTO `ThemaApplicaties` VALUES(123, 7, 19, 0, 0, 0, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(124, 17, 19, 0, 0, 0, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(125, 3, 19, 0, 0, 0, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(126, 4, 19, 0, 0, 0, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(127, 6, 19, 0, 0, 0, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(129, 9, 19, 0, 0, 0, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(130, 11, 19, 0, 0, 0, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(131, 22, 19, 0, 0, 0, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(132, 21, 19, 0, 0, 0, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(133, 29, 19, 0, 0, 0, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(134, 30, 19, 0, 0, 0, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(135, 25, 19, 0, 0, 0, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(136, 24, 19, 0, 0, 0, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(137, 38, 19, 0, 0, 0, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(138, 41, 19, 0, 0, 0, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(139, 42, 19, 0, 0, 0, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(140, 32, 19, 0, 0, 0, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(141, 43, 19, 0, 0, 0, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(143, 59, 19, 0, 0, 0, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(144, 13, 20, 0, 0, 0, 0, 0, -1);
INSERT INTO `ThemaApplicaties` VALUES(145, 16, 20, 0, 0, 0, 0, 0, -1);
INSERT INTO `ThemaApplicaties` VALUES(146, 18, 20, 0, 0, 0, 0, 0, -1);
INSERT INTO `ThemaApplicaties` VALUES(147, 23, 20, 0, 0, 0, 0, 0, -1);
INSERT INTO `ThemaApplicaties` VALUES(148, 26, 20, 0, 0, 0, 0, 0, -1);
INSERT INTO `ThemaApplicaties` VALUES(149, 25, 20, 0, 0, 0, 0, 0, -1);
INSERT INTO `ThemaApplicaties` VALUES(150, 44, 20, 0, 0, 0, 0, 0, -1);
INSERT INTO `ThemaApplicaties` VALUES(151, 12, 20, 0, 0, 0, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(152, 7, 20, 0, 0, 0, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(153, 17, 20, 0, 0, 0, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(154, 14, 20, 0, 0, 0, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(156, 4, 20, 0, 0, 0, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(157, 6, 20, 0, 0, 0, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(158, 9, 20, 0, 0, 0, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(160, 11, 20, 0, 0, 0, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(161, 15, 20, 0, 0, 0, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(162, 22, 20, 0, 0, 0, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(163, 21, 20, 0, 0, 0, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(164, 29, 20, 0, 0, 0, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(165, 30, 20, 0, 0, 0, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(166, 24, 20, 0, 0, 0, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(167, 39, 20, 0, 0, 0, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(168, 37, 20, 0, 0, 0, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(169, 38, 20, 0, 0, 0, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(170, 40, 20, 0, 0, 0, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(171, 41, 20, 0, 0, 0, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(172, 42, 20, 0, 0, 0, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(173, 31, 20, 0, 0, 0, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(174, 32, 20, 0, 0, 0, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(175, 36, 20, 0, 0, 0, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(176, 33, 20, 0, 0, 0, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(177, 34, 20, 0, 0, 0, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(178, 35, 20, 0, 0, 0, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(179, 46, 20, 0, 0, 0, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(180, 47, 20, 0, 0, 0, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(181, 43, 20, 0, 0, 0, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(182, 45, 20, 0, 0, 0, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(183, 3, 20, 0, 0, 0, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(184, 59, 20, 0, 0, 0, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(185, 13, 21, 0, 0, 0, 0, 0, -1);
INSERT INTO `ThemaApplicaties` VALUES(186, 18, 21, 0, 0, 0, 0, 0, -1);
INSERT INTO `ThemaApplicaties` VALUES(187, 14, 21, 0, 0, 0, 0, 0, -1);
INSERT INTO `ThemaApplicaties` VALUES(188, 15, 21, 0, 0, 0, 0, 0, -1);
INSERT INTO `ThemaApplicaties` VALUES(189, 23, 21, 0, 0, 0, 0, 0, -1);
INSERT INTO `ThemaApplicaties` VALUES(190, 26, 21, 0, 0, 0, 0, 0, -1);
INSERT INTO `ThemaApplicaties` VALUES(191, 37, 21, 0, 0, 0, 0, 0, -1);
INSERT INTO `ThemaApplicaties` VALUES(192, 44, 21, 0, 0, 0, 0, 0, -1);
INSERT INTO `ThemaApplicaties` VALUES(193, 47, 21, 0, 0, 0, 0, 0, -1);
INSERT INTO `ThemaApplicaties` VALUES(194, 43, 21, 0, 0, 0, 0, 0, -1);
INSERT INTO `ThemaApplicaties` VALUES(195, 45, 21, 0, 0, 0, 0, 0, -1);
INSERT INTO `ThemaApplicaties` VALUES(196, 16, 21, 0, 0, 0, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(197, 12, 21, 0, 0, 0, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(198, 7, 21, 0, 0, 0, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(199, 17, 21, 0, 0, 0, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(201, 4, 21, 0, 0, 0, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(202, 6, 21, 0, 0, 0, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(203, 9, 21, 0, 0, 0, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(205, 11, 21, 0, 0, 0, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(206, 22, 21, 0, 0, 0, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(207, 29, 21, 0, 0, 0, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(208, 24, 21, 0, 0, 0, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(209, 39, 21, 0, 0, 0, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(210, 38, 21, 0, 0, 0, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(211, 40, 21, 0, 0, 0, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(212, 41, 21, 0, 0, 0, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(213, 31, 21, 0, 0, 0, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(214, 32, 21, 0, 0, 0, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(215, 35, 21, 0, 0, 0, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(216, 46, 21, 0, 0, 0, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(217, 3, 21, 0, 0, 0, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(218, 59, 21, 0, 0, 0, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(219, 13, 22, 0, 0, 0, 0, 0, -1);
INSERT INTO `ThemaApplicaties` VALUES(220, 16, 22, 0, 0, 0, 0, 0, -1);
INSERT INTO `ThemaApplicaties` VALUES(221, 18, 22, 0, 0, 0, 0, 0, -1);
INSERT INTO `ThemaApplicaties` VALUES(222, 23, 22, 0, 0, 0, 0, 0, -1);
INSERT INTO `ThemaApplicaties` VALUES(223, 44, 22, 0, 0, 0, 0, 0, -1);
INSERT INTO `ThemaApplicaties` VALUES(224, 12, 22, 0, 0, 0, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(225, 7, 22, 0, 0, 0, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(226, 17, 22, 0, 0, 0, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(227, 14, 22, 0, 0, 0, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(229, 4, 22, 0, 0, 0, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(230, 6, 22, 0, 0, 0, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(231, 9, 22, 0, 0, 0, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(233, 11, 22, 0, 0, 0, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(234, 15, 22, 0, 0, 0, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(235, 26, 22, 0, 0, 0, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(236, 22, 22, 0, 0, 0, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(237, 24, 22, 0, 0, 0, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(238, 37, 22, 0, 0, 0, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(239, 38, 22, 0, 0, 0, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(240, 40, 22, 0, 0, 0, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(241, 41, 22, 0, 0, 0, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(242, 32, 22, 0, 0, 0, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(243, 35, 22, 0, 0, 0, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(244, 46, 22, 0, 0, 0, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(245, 47, 22, 0, 0, 0, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(246, 43, 22, 0, 0, 0, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(247, 3, 22, 0, 0, 0, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(248, 59, 22, 0, 0, 0, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(249, 13, 23, 0, 0, 0, 0, 0, -1);
INSERT INTO `ThemaApplicaties` VALUES(250, 18, 23, 0, 0, 0, 0, 0, -1);
INSERT INTO `ThemaApplicaties` VALUES(251, 12, 23, 0, 0, 0, 0, 0, -1);
INSERT INTO `ThemaApplicaties` VALUES(252, 26, 23, 0, 0, 0, 0, 0, -1);
INSERT INTO `ThemaApplicaties` VALUES(253, 22, 23, 0, 0, 0, 0, 0, -1);
INSERT INTO `ThemaApplicaties` VALUES(254, 37, 23, 0, 0, 0, 0, 0, -1);
INSERT INTO `ThemaApplicaties` VALUES(255, 35, 23, 0, 0, 0, 0, 0, -1);
INSERT INTO `ThemaApplicaties` VALUES(256, 44, 23, 0, 0, 0, 0, 0, -1);
INSERT INTO `ThemaApplicaties` VALUES(257, 47, 23, 0, 0, 0, 0, 0, -1);
INSERT INTO `ThemaApplicaties` VALUES(258, 43, 23, 0, 0, 0, 0, 0, -1);
INSERT INTO `ThemaApplicaties` VALUES(259, 7, 23, 0, 0, 0, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(260, 3, 23, 0, 0, 0, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(261, 6, 23, 0, 0, 0, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(262, 23, 23, 0, 0, 0, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(263, 39, 23, 0, 0, 0, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(264, 32, 23, 0, 0, 0, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(265, 46, 23, 0, 0, 0, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(266, 1, 24, 0, -1, -1, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(267, 3, 24, 0, -1, -1, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(268, 4, 24, 0, -1, -1, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(269, 5, 24, 0, -1, -1, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(270, 6, 24, 0, -1, -1, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(271, 7, 24, 0, -1, -1, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(272, 8, 24, 0, -1, -1, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(273, 9, 24, 0, -1, -1, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(274, 11, 24, 0, -1, -1, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(275, 12, 24, 0, -1, -1, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(276, 13, 24, 0, -1, -1, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(277, 14, 24, 0, -1, -1, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(278, 15, 24, 0, -1, -1, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(279, 16, 24, 0, -1, -1, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(280, 17, 24, 0, -1, -1, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(281, 18, 24, 0, -1, -1, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(282, 21, 24, 0, -1, -1, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(283, 22, 24, 0, -1, -1, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(284, 23, 24, 0, -1, -1, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(285, 24, 24, 0, -1, -1, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(286, 25, 24, 0, -1, -1, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(287, 26, 24, 0, -1, -1, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(288, 27, 24, 0, -1, -1, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(289, 51, 24, 0, -1, -1, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(290, 52, 24, 0, -1, -1, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(291, 53, 24, 0, -1, -1, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(292, 54, 24, 0, -1, -1, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(293, 55, 24, 0, -1, -1, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(294, 56, 24, 0, -1, -1, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(295, 57, 24, 0, -1, -1, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(296, 29, 24, 0, -1, -1, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(297, 30, 24, 0, -1, -1, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(298, 31, 24, 0, -1, -1, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(299, 32, 24, 0, -1, -1, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(300, 33, 24, 0, -1, -1, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(301, 34, 24, 0, -1, -1, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(302, 35, 24, 0, -1, -1, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(303, 36, 24, 0, -1, -1, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(304, 37, 24, 0, -1, -1, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(305, 38, 24, 0, -1, -1, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(306, 39, 24, 0, -1, -1, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(307, 40, 24, 0, -1, -1, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(308, 41, 24, 0, -1, -1, 0, 0, 0);
INSERT INTO `ThemaApplicaties` VALUES(309, 42, 24, 0, -1, -1, 0, 0, 0);
UNLOCK TABLES;

#
# Table structure for table 'ThemaFuncties'
#

DROP TABLE IF EXISTS `ThemaFuncties`;
CREATE TABLE `ThemaFuncties` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `naam` VARCHAR(50),
  `omschrijving` VARCHAR(255),
  `thema_id` INT DEFAULT 0,
  `applicatie_id` INT DEFAULT 0,
  `protocol` VARCHAR(255),
  INDEX `applicatie_id` (`applicatie_id`),
  INDEX `ApplicatieApplicatieFuncties` (`applicatie_id`),
  INDEX `id` (`id`),
  PRIMARY KEY (`id`),
  INDEX `thema_id` (`thema_id`),
  INDEX `ThemasThemaFuncties` (`thema_id`)
);

#
# Dumping data for table 'ThemaFuncties'
#

LOCK TABLES `ThemaFuncties` WRITE;
INSERT INTO `ThemaFuncties` VALUES(3, "", "", 1, 0, "");
INSERT INTO `ThemaFuncties` VALUES(4, "", "", 3, 0, "");
INSERT INTO `ThemaFuncties` VALUES(5, "", "", 4, 0, "");
INSERT INTO `ThemaFuncties` VALUES(6, "", "", 5, 0, "");
INSERT INTO `ThemaFuncties` VALUES(7, "", "", 6, 0, "");
INSERT INTO `ThemaFuncties` VALUES(8, "", "", 7, 0, "");
INSERT INTO `ThemaFuncties` VALUES(9, "", "", 8, 0, "");
INSERT INTO `ThemaFuncties` VALUES(10, "", "", 9, 0, "");
INSERT INTO `ThemaFuncties` VALUES(11, "", "", 11, 0, "");
INSERT INTO `ThemaFuncties` VALUES(12, "", "", 12, 0, "");
INSERT INTO `ThemaFuncties` VALUES(13, "", "", 13, 0, "");
INSERT INTO `ThemaFuncties` VALUES(14, "", "", 14, 0, "");
INSERT INTO `ThemaFuncties` VALUES(15, "", "", 15, 0, "");
INSERT INTO `ThemaFuncties` VALUES(16, "", "", 16, 0, "");
INSERT INTO `ThemaFuncties` VALUES(17, "", "", 17, 0, "");
INSERT INTO `ThemaFuncties` VALUES(18, "", "", 18, 0, "");
INSERT INTO `ThemaFuncties` VALUES(19, "", "", 21, 0, "");
INSERT INTO `ThemaFuncties` VALUES(20, "", "", 22, 0, "");
INSERT INTO `ThemaFuncties` VALUES(21, "", "", 23, 0, "");
INSERT INTO `ThemaFuncties` VALUES(22, "", "", 24, 0, "");
INSERT INTO `ThemaFuncties` VALUES(23, "", "", 25, 0, "");
INSERT INTO `ThemaFuncties` VALUES(24, "", "", 26, 0, "");
INSERT INTO `ThemaFuncties` VALUES(25, "", "", 27, 0, "");
INSERT INTO `ThemaFuncties` VALUES(26, "", "", 29, 0, "");
INSERT INTO `ThemaFuncties` VALUES(27, "", "", 30, 0, "");
INSERT INTO `ThemaFuncties` VALUES(28, "", "", 31, 0, "");
INSERT INTO `ThemaFuncties` VALUES(29, "", "", 32, 0, "");
INSERT INTO `ThemaFuncties` VALUES(30, "", "", 33, 0, "");
INSERT INTO `ThemaFuncties` VALUES(31, "", "", 34, 0, "");
INSERT INTO `ThemaFuncties` VALUES(32, "", "", 35, 0, "");
INSERT INTO `ThemaFuncties` VALUES(33, "", "", 36, 0, "");
INSERT INTO `ThemaFuncties` VALUES(34, "", "", 37, 0, "");
INSERT INTO `ThemaFuncties` VALUES(35, "", "", 38, 0, "");
INSERT INTO `ThemaFuncties` VALUES(36, "", "", 39, 0, "");
INSERT INTO `ThemaFuncties` VALUES(37, "", "", 40, 0, "");
INSERT INTO `ThemaFuncties` VALUES(38, "", "", 41, 0, "");
INSERT INTO `ThemaFuncties` VALUES(39, "", "", 42, 0, "");
INSERT INTO `ThemaFuncties` VALUES(40, "", "", 51, 0, "");
INSERT INTO `ThemaFuncties` VALUES(41, "", "", 52, 0, "");
INSERT INTO `ThemaFuncties` VALUES(42, "", "", 53, 0, "");
INSERT INTO `ThemaFuncties` VALUES(43, "", "", 54, 0, "");
INSERT INTO `ThemaFuncties` VALUES(44, "", "", 55, 0, "");
INSERT INTO `ThemaFuncties` VALUES(45, "", "", 56, 0, "");
INSERT INTO `ThemaFuncties` VALUES(46, "", "", 57, 0, "");
UNLOCK TABLES;

#
# Table structure for table 'ThemaItemsAdmin'
#

DROP TABLE IF EXISTS `ThemaItemsAdmin`;
CREATE TABLE `ThemaItemsAdmin` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `label` VARCHAR(50),
  `eenheid` VARCHAR(50),
  `omschrijving` VARCHAR(255),
  `thema_id` INT DEFAULT 0,
  `basisregel` BIT DEFAULT -1,
  `voorbeelden` VARCHAR(255),
  `kenmerk` BIT,
  `kolombreedte` INT DEFAULT 0,
  `moscow_id` INT DEFAULT 0,
  `waarde_type` VARCHAR(50),
  INDEX `eenheid` (`eenheid`),
  INDEX `id2` (`id`),
  INDEX `moscow_id` (`moscow_id`),
  PRIMARY KEY (`id`),
  INDEX `thema_id` (`thema_id`),
  INDEX `ThemaItemAdmin` (`thema_id`)
);

#
# Dumping data for table 'ThemaItemsAdmin'
#

LOCK TABLES `ThemaItemsAdmin` WRITE;
INSERT INTO `ThemaItemsAdmin` VALUES(2, 'Wegnr', "", "", 1, -1, "", 0, NULL, NULL, "");
INSERT INTO `ThemaItemsAdmin` VALUES(3, 'ViaView label', "", "", 1, -1, "", 0, NULL, NULL, "");
INSERT INTO `ThemaItemsAdmin` VALUES(4, 'Hectometrering', "", "", 1, -1, "", 0, NULL, NULL, "");
INSERT INTO `ThemaItemsAdmin` VALUES(5, 'Baantype', "", "", 1, -1, 'asfalt, verhard', 0, NULL, NULL, "");
INSERT INTO `ThemaItemsAdmin` VALUES(6, 'Strooktype', "", "", 1, -1, 'asfalt, beton', 0, NULL, NULL, "");
INSERT INTO `ThemaItemsAdmin` VALUES(7, 'Documentlocatie', "", "", 14, -1, "", 0, NULL, NULL, "");
INSERT INTO `ThemaItemsAdmin` VALUES(8, 'Overige regelingen', "", "", 14, -1, 'Fiets/Auto-regeling, Stoplichten', 0, NULL, NULL, "");
INSERT INTO `ThemaItemsAdmin` VALUES(9, 'Verkeersbesluiten', "", "", 14, -1, 'Besluiten worden genomen bij vergadering 22-12-2006', 0, NULL, NULL, "");
INSERT INTO `ThemaItemsAdmin` VALUES(10, 'Vergunningen', "", "", 14, -1, 'Bouwvergunning afgegeven, 05-09-2006', 0, NULL, NULL, "");
INSERT INTO `ThemaItemsAdmin` VALUES(11, 'Vergunning', 'Ja/Nee', "", 7, -1, "", 0, NULL, NULL, "");
INSERT INTO `ThemaItemsAdmin` VALUES(12, 'Contractperiode', "", "", 7, -1, 'Verlopen op 15-09-2006', 0, NULL, NULL, "");
INSERT INTO `ThemaItemsAdmin` VALUES(13, 'Tekeninglocatie', "", "", 14, -1, "", 0, NULL, NULL, "");
INSERT INTO `ThemaItemsAdmin` VALUES(14, 'Materiaal', "", "", 13, -1, 'asfalt', 0, NULL, NULL, "");
INSERT INTO `ThemaItemsAdmin` VALUES(15, 'Leeftijd', 'jaar', "", 13, -1, '2,5 jaar', 0, NULL, NULL, "");
INSERT INTO `ThemaItemsAdmin` VALUES(16, 'Spoorvorming', "", "", 13, -1, '
Lichte spoorvorming', 0, NULL, NULL, "");
INSERT INTO `ThemaItemsAdmin` VALUES(17, 'Stroefheidsmeting', "", "", 13, -1, 'Uitgevoerd: 23-05-2006. Resultaat: Goed', 0, NULL, NULL, "");
INSERT INTO `ThemaItemsAdmin` VALUES(18, 'Opbouw/doorsnede', "", "", 13, -1, 'Beton op zand/kleilaag', 0, NULL, NULL, "");
INSERT INTO `ThemaItemsAdmin` VALUES(19, 'Aran', "", "", 49, -1, "", 0, NULL, NULL, "");
INSERT INTO `ThemaItemsAdmin` VALUES(20, 'Rambol', "", "", 49, -1, "", 0, NULL, NULL, "");
INSERT INTO `ThemaItemsAdmin` VALUES(21, 'Deflectie', "", "", 49, -1, "", 0, NULL, NULL, "");
INSERT INTO `ThemaItemsAdmin` VALUES(22, 'Inspectie', "", "", 49, -1, 'Laatste: 12-09-2006', 0, NULL, NULL, "");
INSERT INTO `ThemaItemsAdmin` VALUES(23, 'Planning', "", "", 12, -1, 'Gepland voor 15-01-2007, Niet op de planning', 0, NULL, NULL, "");
INSERT INTO `ThemaItemsAdmin` VALUES(24, 'Soort', "", "", 12, -1, 'Wegmarkering, 
Parkeerplaats', 0, NULL, NULL, "");
INSERT INTO `ThemaItemsAdmin` VALUES(25, 'Maatvoering', "", "", 12, -1, "", 0, NULL, NULL, "");
INSERT INTO `ThemaItemsAdmin` VALUES(26, 'Lengte', 'km', "", 12, -1, "", 0, NULL, NULL, "");
INSERT INTO `ThemaItemsAdmin` VALUES(27, 'Materiaalsoort', "", "", 12, -1, '
Verf, 
Nog niet vastgesteld', 0, NULL, NULL, "");
INSERT INTO `ThemaItemsAdmin` VALUES(28, 'Type', "", "", 26, -1, 'Verkeersbord, MAX 80km/u, Wegwijzering', 0, NULL, NULL, "");
INSERT INTO `ThemaItemsAdmin` VALUES(29, 'Weglengte van geldigheid', 'km', "", 26, -1, "", 0, NULL, NULL, "");
INSERT INTO `ThemaItemsAdmin` VALUES(30, 'Afmeting', 'cm2', "", 26, -1, "", 0, NULL, NULL, "");
INSERT INTO `ThemaItemsAdmin` VALUES(31, 'Nummer', "", "", 26, -1, "", 0, NULL, NULL, "");
INSERT INTO `ThemaItemsAdmin` VALUES(32, 'Eigenaar', "", "", 26, -1, 'Anders, Provincie, ANWB', 0, NULL, NULL, "");
INSERT INTO `ThemaItemsAdmin` VALUES(33, 'Oppervlak', 'm2', "", 6, -1, "", 0, NULL, NULL, "");
INSERT INTO `ThemaItemsAdmin` VALUES(34, 'Gemeente', "", "", 6, -1, 'Den Bosch
Den Bosch
Den Bosch
Den Bosch
Den Bosch', 0, NULL, NULL, "");
INSERT INTO `ThemaItemsAdmin` VALUES(35, 'Type', "", "", 6, -1, 'Nat, droog, zaksloot', 0, NULL, NULL, "");
INSERT INTO `ThemaItemsAdmin` VALUES(36, 'Orientatie tov wegas', "", "", 6, -1, 'links, rechts', 0, NULL, NULL, "");
INSERT INTO `ThemaItemsAdmin` VALUES(37, 'Opmerkingen', "", "", 6, -1, 'Moet worden gebaggerd, Drooggevallen sloot, heeft controle nodig', 0, NULL, NULL, "");
INSERT INTO `ThemaItemsAdmin` VALUES(38, 'Oppervlak', 'm2', "", 5, -1, "", 0, NULL, NULL, "");
INSERT INTO `ThemaItemsAdmin` VALUES(39, 'Hoogte tov weg', 'cm', "", 5, -1, "", 0, NULL, NULL, "");
INSERT INTO `ThemaItemsAdmin` VALUES(40, 'Type', "", "", 5, -1, 'Middenberm, buitenberm', 0, NULL, NULL, "");
INSERT INTO `ThemaItemsAdmin` VALUES(41, 'Begroeiing', "", "", 5, -1, 'Semiverhard, gras', 0, NULL, NULL, "");
INSERT INTO `ThemaItemsAdmin` VALUES(42, 'Rand', "", "", 5, -1, 'hard, zacht', 0, NULL, NULL, "");
INSERT INTO `ThemaItemsAdmin` VALUES(43, 'Bomen', 'aantal', "", 18, -1, "", 0, NULL, NULL, "");
INSERT INTO `ThemaItemsAdmin` VALUES(44, 'Groentype', "", "", 18, -1, 'grasveld, houtwal', 0, NULL, NULL, "");
INSERT INTO `ThemaItemsAdmin` VALUES(45, 'Type onderzoek', "", "", 27, -1, 'kruispunttelling', 0, NULL, NULL, "");
INSERT INTO `ThemaItemsAdmin` VALUES(46, 'Naam locatie', "", "", 27, -1, 'N384', 0, NULL, NULL, "");
INSERT INTO `ThemaItemsAdmin` VALUES(47, 'Naam meting', "", "", 27, -1, "", 0, NULL, NULL, "");
INSERT INTO `ThemaItemsAdmin` VALUES(48, 'Details', "", "", 27, -1, 'Voor details zie rapport 15-11-2006', 0, NULL, NULL, "");
INSERT INTO `ThemaItemsAdmin` VALUES(49, 'Wegnr', "", "", 25, -1, "", 0, NULL, NULL, "");
INSERT INTO `ThemaItemsAdmin` VALUES(50, 'Tijdstip', "", "", 25, -1, '15:06, 22-11-2006', 0, NULL, NULL, "");
INSERT INTO `ThemaItemsAdmin` VALUES(51, 'Type ongeval', "", "", 25, -1, 'Aanrijding tussen 2 auto\'s, Aanrijding fiets-auto', 0, NULL, NULL, "");
INSERT INTO `ThemaItemsAdmin` VALUES(52, 'Type manoeuvre', "", "", 25, -1, 'Inhalen (auto) van fietser', 0, NULL, NULL, "");
INSERT INTO `ThemaItemsAdmin` VALUES(54, "", "", "", 3, -1, "", 0, NULL, NULL, "");
INSERT INTO `ThemaItemsAdmin` VALUES(55, "", "", "", 4, -1, "", 0, NULL, NULL, "");
INSERT INTO `ThemaItemsAdmin` VALUES(56, "", "", "", 6, -1, "", 0, NULL, NULL, "");
INSERT INTO `ThemaItemsAdmin` VALUES(57, "", "", "", 8, -1, "", 0, NULL, NULL, "");
INSERT INTO `ThemaItemsAdmin` VALUES(58, "", "", "", 9, -1, "", 0, NULL, NULL, "");
INSERT INTO `ThemaItemsAdmin` VALUES(59, "", "", "", 11, -1, "", 0, NULL, NULL, "");
INSERT INTO `ThemaItemsAdmin` VALUES(60, "", "", "", 15, -1, "", 0, NULL, NULL, "");
INSERT INTO `ThemaItemsAdmin` VALUES(61, "", "", "", 16, -1, "", 0, NULL, NULL, "");
INSERT INTO `ThemaItemsAdmin` VALUES(62, "", "", "", 17, -1, "", 0, NULL, NULL, "");
INSERT INTO `ThemaItemsAdmin` VALUES(63, "", "", "", 21, -1, "", 0, NULL, NULL, "");
INSERT INTO `ThemaItemsAdmin` VALUES(64, "", "", "", 22, -1, "", 0, NULL, NULL, "");
INSERT INTO `ThemaItemsAdmin` VALUES(65, "", "", "", 23, -1, "", 0, NULL, NULL, "");
INSERT INTO `ThemaItemsAdmin` VALUES(66, "", "", "", 24, -1, "", 0, NULL, NULL, "");
INSERT INTO `ThemaItemsAdmin` VALUES(67, "", "", "", 26, -1, "", 0, NULL, NULL, "");
INSERT INTO `ThemaItemsAdmin` VALUES(68, "", "", "", 29, -1, "", 0, NULL, NULL, "");
INSERT INTO `ThemaItemsAdmin` VALUES(69, "", "", "", 30, -1, "", 0, NULL, NULL, "");
INSERT INTO `ThemaItemsAdmin` VALUES(70, "", "", "", 31, -1, "", 0, NULL, NULL, "");
INSERT INTO `ThemaItemsAdmin` VALUES(71, "", "", "", 32, -1, "", 0, NULL, NULL, "");
INSERT INTO `ThemaItemsAdmin` VALUES(72, "", "", "", 33, -1, "", 0, NULL, NULL, "");
INSERT INTO `ThemaItemsAdmin` VALUES(73, "", "", "", 34, -1, "", 0, NULL, NULL, "");
INSERT INTO `ThemaItemsAdmin` VALUES(74, "", "", "", 35, -1, "", 0, NULL, NULL, "");
INSERT INTO `ThemaItemsAdmin` VALUES(75, "", "", "", 36, -1, "", 0, NULL, NULL, "");
INSERT INTO `ThemaItemsAdmin` VALUES(76, "", "", "", 37, -1, "", 0, NULL, NULL, "");
INSERT INTO `ThemaItemsAdmin` VALUES(77, "", "", "", 38, -1, "", 0, NULL, NULL, "");
INSERT INTO `ThemaItemsAdmin` VALUES(78, "", "", "", 39, -1, "", 0, NULL, NULL, "");
INSERT INTO `ThemaItemsAdmin` VALUES(79, "", "", "", 40, -1, "", 0, NULL, NULL, "");
INSERT INTO `ThemaItemsAdmin` VALUES(80, "", "", "", 41, -1, "", 0, NULL, NULL, "");
INSERT INTO `ThemaItemsAdmin` VALUES(81, "", "", "", 42, -1, "", 0, NULL, NULL, "");
INSERT INTO `ThemaItemsAdmin` VALUES(82, "", "", "", 51, -1, "", 0, NULL, NULL, "");
INSERT INTO `ThemaItemsAdmin` VALUES(83, "", "", "", 52, -1, "", 0, NULL, NULL, "");
INSERT INTO `ThemaItemsAdmin` VALUES(84, "", "", "", 53, -1, "", 0, NULL, NULL, "");
INSERT INTO `ThemaItemsAdmin` VALUES(85, "", "", "", 54, -1, "", 0, NULL, NULL, "");
INSERT INTO `ThemaItemsAdmin` VALUES(86, "", "", "", 55, -1, "", 0, NULL, NULL, "");
INSERT INTO `ThemaItemsAdmin` VALUES(87, "", "", "", 56, -1, "", 0, NULL, NULL, "");
INSERT INTO `ThemaItemsAdmin` VALUES(88, "", "", "", 57, -1, "", 0, NULL, NULL, "");
UNLOCK TABLES;

#
# Table structure for table 'ThemaItemsSpatial'
#

DROP TABLE IF EXISTS `ThemaItemsSpatial`;
CREATE TABLE `ThemaItemsSpatial` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `kenmerk` VARCHAR(50),
  `omschrijving` VARCHAR(50),
  `thema_id` INT DEFAULT 0,
  `type` VARCHAR(50),
  `lrood` INT DEFAULT 0,
  `lgroen` INT DEFAULT 0,
  `lblauw` INT DEFAULT 0,
  `vrood` INT DEFAULT 0,
  `vgroen` INT DEFAULT 0,
  `vblauw` INT DEFAULT 0,
  INDEX `eenheid` (`type`),
  INDEX `id2` (`id`),
  PRIMARY KEY (`id`),
  INDEX `thema_id` (`thema_id`),
  INDEX `ThemaItemSpatial` (`thema_id`)
);

#
# Dumping data for table 'ThemaItemsSpatial'
#

LOCK TABLES `ThemaItemsSpatial` WRITE;
INSERT INTO `ThemaItemsSpatial` VALUES(1, "", "", 1, "", NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `ThemaItemsSpatial` VALUES(2, "", "", 14, "", NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `ThemaItemsSpatial` VALUES(3, "", "", 7, "", NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `ThemaItemsSpatial` VALUES(4, "", "", 3, "", NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `ThemaItemsSpatial` VALUES(5, "", "", 4, "", NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `ThemaItemsSpatial` VALUES(6, "", "", 5, "", NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `ThemaItemsSpatial` VALUES(7, "", "", 6, "", NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `ThemaItemsSpatial` VALUES(8, "", "", 8, "", NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `ThemaItemsSpatial` VALUES(9, "", "", 9, "", NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `ThemaItemsSpatial` VALUES(10, "", "", 11, "", NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `ThemaItemsSpatial` VALUES(11, "", "", 12, "", NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `ThemaItemsSpatial` VALUES(12, "", "", 13, "", NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `ThemaItemsSpatial` VALUES(13, "", "", 15, "", NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `ThemaItemsSpatial` VALUES(14, "", "", 16, "", NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `ThemaItemsSpatial` VALUES(15, "", "", 17, "", NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `ThemaItemsSpatial` VALUES(16, "", "", 18, "", NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `ThemaItemsSpatial` VALUES(18, "", "", 21, "", NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `ThemaItemsSpatial` VALUES(19, "", "", 22, "", NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `ThemaItemsSpatial` VALUES(20, "", "", 23, "", NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `ThemaItemsSpatial` VALUES(21, "", "", 24, "", NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `ThemaItemsSpatial` VALUES(22, "", "", 25, "", NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `ThemaItemsSpatial` VALUES(23, "", "", 26, "", NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `ThemaItemsSpatial` VALUES(24, "", "", 27, "", NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `ThemaItemsSpatial` VALUES(26, "", "", 29, "", NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `ThemaItemsSpatial` VALUES(27, "", "", 30, "", NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `ThemaItemsSpatial` VALUES(28, "", "", 51, "", NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `ThemaItemsSpatial` VALUES(29, "", "", 52, "", NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `ThemaItemsSpatial` VALUES(30, "", "", 53, "", NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `ThemaItemsSpatial` VALUES(31, "", "", 54, "", NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `ThemaItemsSpatial` VALUES(32, "", "", 55, "", NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `ThemaItemsSpatial` VALUES(33, "", "", 56, "", NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `ThemaItemsSpatial` VALUES(34, "", "", 57, "", NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `ThemaItemsSpatial` VALUES(35, "", "", 58, "", NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `ThemaItemsSpatial` VALUES(36, "", "", 59, "", NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `ThemaItemsSpatial` VALUES(37, "", "", 60, "", NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `ThemaItemsSpatial` VALUES(40, "", "", 31, "", NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `ThemaItemsSpatial` VALUES(41, "", "", 32, "", NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `ThemaItemsSpatial` VALUES(42, "", "", 33, "", NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `ThemaItemsSpatial` VALUES(43, "", "", 34, "", NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `ThemaItemsSpatial` VALUES(44, "", "", 35, "", NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `ThemaItemsSpatial` VALUES(45, "", "", 36, "", NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `ThemaItemsSpatial` VALUES(46, "", "", 37, "", NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `ThemaItemsSpatial` VALUES(47, "", "", 38, "", NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `ThemaItemsSpatial` VALUES(48, "", "", 39, "", NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `ThemaItemsSpatial` VALUES(49, "", "", 40, "", NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `ThemaItemsSpatial` VALUES(50, "", "", 41, "", NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `ThemaItemsSpatial` VALUES(51, "", "", 42, "", NULL, NULL, NULL, NULL, NULL, NULL);
UNLOCK TABLES;

#
# Table structure for table 'Themas'
#

DROP TABLE IF EXISTS `Themas`;
CREATE TABLE `Themas` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `code` VARCHAR(50),
  `naam` VARCHAR(50),
  `moscow_id` INT DEFAULT 0,
  `belangnr` INT DEFAULT 0,
  `cluster_id` INT DEFAULT 0,
  `opmerkingen` VARCHAR(255),
  `analyse_thema` BIT,
  `locatie_thema` BIT,
  INDEX `cluster_id` (`cluster_id`),
  INDEX `ClusterThema` (`cluster_id`),
  INDEX `code` (`code`),
  INDEX `id` (`id`),
  INDEX `MoscowThema` (`moscow_id`),
  PRIMARY KEY (`id`)
);

#
# Dumping data for table 'Themas'
#

LOCK TABLES `Themas` WRITE;
INSERT INTO `Themas` VALUES(1, '1', 'Weg Inclusief functie', 1, 1010, 1, "", 0, 0);
INSERT INTO `Themas` VALUES(3, '1', 'Junctie; kruispunt', 1, 1020, 1, "", 0, 0);
INSERT INTO `Themas` VALUES(4, '1', 'Baan (10.000), Strook (70.000)', 1, 1030, 1, "", 0, 0);
INSERT INTO `Themas` VALUES(5, '1', 'Berm', 1, 1040, 3, "", 0, 0);
INSERT INTO `Themas` VALUES(6, '1', 'Sloot', 1, 1050, 3, "", 0, 0);
INSERT INTO `Themas` VALUES(7, '1', 'Uitrit', 1, 1060, 1, "", 0, 0);
INSERT INTO `Themas` VALUES(8, '1', 'Fiets/Voetpad (scheiden)', 1, 1070, 1, "", 0, 0);
INSERT INTO `Themas` VALUES(9, '1', 'Weg Oriëntatie Lijn / HM Bord/objecten', 1, 1080, 1, "", 0, 0);
INSERT INTO `Themas` VALUES(11, '1', 'Cyclorama', 1, 1090, 1, "", 0, 0);
INSERT INTO `Themas` VALUES(12, '1', 'Markering', 1, 1100, 2, "", 0, 0);
INSERT INTO `Themas` VALUES(13, '1', 'Verharding', 1, 1110, 2, "", 0, 0);
INSERT INTO `Themas` VALUES(14, '1', 'Regeling Beheer Onderhoud', 1, 1120, 1, 'autocad is bron maar komt deze in viewer? Of alleen x,y of vlak voor locatie?', 0, 0);
INSERT INTO `Themas` VALUES(15, '1', 'Eigendom/Perceel', 1, 1130, 1, "", 0, 0);
INSERT INTO `Themas` VALUES(16, '1', 'Kunstwerk', 1, 1140, 8, 'nog in gebruik?', 0, 0);
INSERT INTO `Themas` VALUES(17, '1', 'Pomp Installatie', 1, 1150, 8, '8 stuks,1x maand visuele inspectie', 0, 0);
INSERT INTO `Themas` VALUES(18, '1', 'Groen, Bomen, enz./Begroeing', 1, 1160, 3, "", 0, 0);
INSERT INTO `Themas` VALUES(19, '1', 'Ontsnipperingsmaatregelen', 0, 9010, 0, 'geen thema, doel om oppervlakte te verkleinen', 0, 0);
INSERT INTO `Themas` VALUES(21, '1', 'DVM Object (Dynamisch Verk Management)', 2, 2010, 6, 'tellussen beheerd door Henk vd Broek', 0, 0);
INSERT INTO `Themas` VALUES(22, '1', 'VRI Installatie', 2, 2020, 6, "", 0, 0);
INSERT INTO `Themas` VALUES(23, '1', 'Verlichting', 2, 2030, 2, 'Excel Provhuis->Access->CDROM->Regios', 0, 0);
INSERT INTO `Themas` VALUES(24, '1', 'Bushalten', 2, 2040, 2, "", 0, 0);
INSERT INTO `Themas` VALUES(25, '1', 'Ongevallen', 2, 2050, 2, 'black spots evt als onderdeel hiervan', 0, 0);
INSERT INTO `Themas` VALUES(26, '1', 'Verkeersbord/bebording', 2, 2060, 2, "", 0, 0);
INSERT INTO `Themas` VALUES(27, '1', 'Telling telpunt', 2, 2070, 2, "", 0, 0);
INSERT INTO `Themas` VALUES(28, '1', 'Gebieden', 0, 9080, 0, 'opgesplitst in specifieke gebieden', 0, 0);
INSERT INTO `Themas` VALUES(29, '1', 'Geluid/Stilte/Zones', 2, 2090, 5, "", 0, 0);
INSERT INTO `Themas` VALUES(30, '1', 'Transportschema (RDW)', 2, 2100, 2, '1 persoon inlog', 0, 0);
INSERT INTO `Themas` VALUES(31, '1', 'Tankstation', 3, 3010, 2, "", 0, 0);
INSERT INTO `Themas` VALUES(32, '1', 'Bebouwde Kom WW WVW', 3, 3020, 4, "", 0, 0);
INSERT INTO `Themas` VALUES(33, '1', 'Claims privaat + publiek', 3, 3030, 4, "", 0, 0);
INSERT INTO `Themas` VALUES(34, '1', 'Contracten', 3, 3040, 4, "", 0, 0);
INSERT INTO `Themas` VALUES(35, '1', 'Besluit Verkeer WVW 45', 3, 3050, 4, "", 0, 0);
INSERT INTO `Themas` VALUES(36, '1', 'Vergunning Ontheffing', 3, 3060, 4, "", 0, 0);
INSERT INTO `Themas` VALUES(37, '1', 'Wegwijzer/Mast/Vlag', 3, 3070, 2, "", 0, 0);
INSERT INTO `Themas` VALUES(38, '1', 'Parallelweg (eigen)Geluidswering', 3, 3080, 0, "", 0, 0);
INSERT INTO `Themas` VALUES(39, '1', 'Geleiderail', 3, 3090, 1, "", 0, 0);
INSERT INTO `Themas` VALUES(40, '1', 'Spoorwegovergang', 3, 3100, 1, "", 0, 0);
INSERT INTO `Themas` VALUES(41, '1', 'Wegdeel', 3, 3110, 1, "", 0, 0);
INSERT INTO `Themas` VALUES(42, '1', 'Route Gladheidsbestrijding', 3, 3120, 2, "", 0, 0);
INSERT INTO `Themas` VALUES(43, '1', 'Wegmeubilair overig', 4, 4010, 2, "", 0, 0);
INSERT INTO `Themas` VALUES(44, '1', 'Riolering eigen& vergund', 4, 4020, 0, "", 0, 0);
INSERT INTO `Themas` VALUES(45, '1', 'Belemmeringen jur WKPD)', 4, 4030, 0, "", 0, 0);
INSERT INTO `Themas` VALUES(46, '1', 'Kabels & Leidingen eigen', 4, 4040, 0, "", 0, 0);
INSERT INTO `Themas` VALUES(47, '1', 'Lopende & geplande projecten', 4, 4050, 0, "", 0, 0);
INSERT INTO `Themas` VALUES(48, '2', 'Extern', 0, 9020, 0, 'Niet helemaal duidelijk, externe bronnen', 0, 0);
INSERT INTO `Themas` VALUES(49, '2', 'Metingen Verharding (Rambol ed)', 0, 9030, 2, "", 0, 0);
INSERT INTO `Themas` VALUES(50, '2', 'Doorsnede', 0, 9040, 3, 'functie niet meer duidelijk: eruit', 0, 0);
INSERT INTO `Themas` VALUES(51, '2', 'Beheersgrens', 2, 2081, 5, "", 0, 0);
INSERT INTO `Themas` VALUES(52, '2', 'Gemeentegrens', 2, 2082, 5, "", 0, 0);
INSERT INTO `Themas` VALUES(53, '2', 'Bebouwde kom', 2, 2083, 5, "", 0, 0);
INSERT INTO `Themas` VALUES(54, '2', 'GGA-gebieden', 2, 2084, 5, "", 0, 0);
INSERT INTO `Themas` VALUES(55, '2', 'Waterschap', 2, 2085, 5, "", 0, 0);
INSERT INTO `Themas` VALUES(56, '2', 'Ecologische gebieden', 2, 2086, 5, "", 0, 0);
INSERT INTO `Themas` VALUES(57, '2', 'Bestemmingsplan', 2, 2087, 5, "", 0, 0);
INSERT INTO `Themas` VALUES(58, '2', 'Onderhoudsvak Groen', 0, 9050, 3, "", 0, 0);
INSERT INTO `Themas` VALUES(59, '2', 'Onderhoudsvak Verkeer', 0, 9060, 2, "", 0, 0);
INSERT INTO `Themas` VALUES(60, '2', 'Black spots ongevallen', 0, 9070, 2, "", 0, 0);
UNLOCK TABLES;

#
# Table structure for table 'ThemaVerantwoordelijkheden'
#

DROP TABLE IF EXISTS `ThemaVerantwoordelijkheden`;
CREATE TABLE `ThemaVerantwoordelijkheden` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `thema_id` INT,
  `medewerker_id` INT,
  `onderdeel_id` INT,
  `rol` VARCHAR(50),
  `huidige_situatie` BIT DEFAULT -1,
  `gewenste_situatie` BIT DEFAULT 0,
  INDEX `groep_id` (`onderdeel_id`),
  INDEX `GroepThemaGroepen` (`onderdeel_id`),
  INDEX `id` (`id`),
  INDEX `medewerker_id` (`medewerker_id`),
  INDEX `MedewerkersThemaOnderdelen` (`medewerker_id`),
  PRIMARY KEY (`id`),
  INDEX `thema_id` (`thema_id`),
  INDEX `ThemasThemaGroepen` (`thema_id`)
);

#
# Dumping data for table 'ThemaVerantwoordelijkheden'
#

LOCK TABLES `ThemaVerantwoordelijkheden` WRITE;
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(9, 3, NULL, 18, 'beheerder', -1, 0);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(10, 9, NULL, 18, 'beheerder', -1, 0);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(11, 24, NULL, 18, 'beheerder', -1, 0);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(12, 28, NULL, 18, 'beheerder', -1, 0);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(13, 29, NULL, 18, 'beheerder', -1, 0);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(14, 37, NULL, 18, 'beheerder', -1, 0);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(15, 39, NULL, 18, 'beheerder', -1, 0);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(16, 40, NULL, 18, 'beheerder', -1, 0);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(17, 22, NULL, 12, 'beheerder', -1, 0);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(18, 32, NULL, 12, 'beheerder', -1, 0);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(19, 42, NULL, 12, 'beheerder', -1, 0);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(20, 58, NULL, 16, 'beheerder', -1, 0);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(21, 5, NULL, 16, 'beheerder', -1, 0);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(22, 6, NULL, 16, 'beheerder', -1, 0);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(23, 18, NULL, 16, 'beheerder', -1, 0);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(26, 22, NULL, 13, 'beheerder', -1, 0);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(27, 32, NULL, 13, 'beheerder', -1, 0);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(28, 42, NULL, 13, 'beheerder', -1, 0);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(29, 22, NULL, 14, 'beheerder', -1, 0);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(30, 32, NULL, 14, 'beheerder', -1, 0);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(31, 42, NULL, 14, 'beheerder', -1, 0);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(51, 14, 41, NULL, 'beheerder', -1, 0);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(52, 60, 8, NULL, 'beheerder', -1, 0);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(53, 25, 8, NULL, 'beheerder', -1, 0);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(54, 59, 28, NULL, 'beheerder', -1, 0);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(55, 1, 28, NULL, 'beheerder', -1, 0);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(56, 4, 28, NULL, 'beheerder', -1, 0);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(57, 8, 28, NULL, 'beheerder', -1, 0);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(58, 13, 28, NULL, 'beheerder', -1, 0);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(59, 38, 28, NULL, 'beheerder', -1, 0);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(60, 49, 28, NULL, 'beheerder', -1, 0);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(61, 27, 9, NULL, 'beheerder', -1, 0);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(62, 41, 9, NULL, 'beheerder', -1, 0);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(63, 15, 53, NULL, 'beheerder', -1, 0);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(64, 16, 35, NULL, 'beheerder', -1, 0);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(65, 33, 55, NULL, 'beheerder', -1, 0);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(66, 34, 55, NULL, 'beheerder', -1, 0);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(67, 35, 55, NULL, 'beheerder', -1, 0);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(68, 36, 55, NULL, 'beheerder', -1, 0);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(69, 31, 36, NULL, 'beheerder', -1, 0);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(70, 1, NULL, 20, 'eigenaar', 0, -1);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(71, 4, NULL, 20, 'eigenaar', 0, -1);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(72, 5, NULL, 20, 'eigenaar', 0, -1);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(73, 6, NULL, 20, 'eigenaar', 0, -1);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(74, 7, NULL, 20, 'eigenaar', 0, -1);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(75, 8, NULL, 20, 'eigenaar', 0, -1);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(76, 9, NULL, 20, 'eigenaar', 0, -1);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(77, 11, NULL, 21, 'eigenaar', 0, -1);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(78, 11, NULL, 20, 'eigenaar', 0, -1);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(79, 12, NULL, 21, 'eigenaar', 0, -1);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(80, 12, NULL, 20, 'eigenaar', 0, -1);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(81, 13, NULL, 20, 'eigenaar', 0, -1);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(82, 14, NULL, 7, 'eigenaar', 0, -1);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(83, 14, NULL, 20, 'eigenaar', 0, -1);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(84, 15, NULL, 21, 'eigenaar', 0, -1);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(85, 16, NULL, 20, 'eigenaar', 0, -1);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(86, 17, NULL, 20, 'eigenaar', 0, -1);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(87, 18, NULL, 20, 'eigenaar', 0, -1);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(88, 21, NULL, 20, 'eigenaar', 0, -1);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(89, 22, NULL, 20, 'eigenaar', 0, -1);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(90, 23, NULL, 20, 'eigenaar', 0, -1);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(91, 25, NULL, 20, 'eigenaar', 0, -1);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(92, 26, NULL, 20, 'eigenaar', 0, -1);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(93, 27, NULL, 20, 'eigenaar', 0, -1);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(94, 29, NULL, 7, 'eigenaar', 0, -1);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(95, 30, NULL, 20, 'eigenaar', 0, -1);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(96, 1, 40, 16, 'beheerder', 0, -1);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(97, 4, NULL, 20, 'beheerder', 0, -1);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(98, 5, NULL, 20, 'beheerder', 0, -1);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(99, 6, NULL, 20, 'beheerder', 0, -1);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(100, 7, NULL, 20, 'beheerder', 0, -1);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(101, 8, NULL, 20, 'beheerder', 0, -1);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(102, 9, NULL, 18, 'beheerder', 0, -1);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(103, 11, NULL, 18, 'beheerder', 0, -1);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(104, 12, NULL, 20, 'beheerder', 0, -1);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(105, 13, NULL, 9, 'beheerder', 0, -1);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(106, 14, 40, 16, 'beheerder', 0, -1);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(107, 16, 37, 9, 'beheerder', 0, -1);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(108, 17, NULL, 9, 'beheerder', 0, -1);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(109, 18, NULL, 20, 'beheerder', 0, -1);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(110, 21, NULL, 16, 'beheerder', 0, -1);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(111, 22, NULL, 16, 'beheerder', 0, -1);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(112, 23, NULL, 20, 'beheerder', 0, -1);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(113, 25, NULL, 16, 'beheerder', 0, -1);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(114, 26, NULL, 20, 'beheerder', 0, -1);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(115, 27, NULL, 16, 'beheerder', 0, -1);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(116, 29, NULL, 22, 'beheerder', 0, -1);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(117, 30, NULL, 16, 'beheerder', 0, -1);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(118, 1, 40, 16, 'uitvoerder', 0, -1);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(119, 4, NULL, 9, 'uitvoerder', 0, -1);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(120, 5, NULL, 16, 'uitvoerder', 0, -1);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(121, 6, NULL, 16, 'uitvoerder', 0, -1);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(122, 7, NULL, 9, 'uitvoerder', 0, -1);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(123, 8, NULL, 9, 'uitvoerder', 0, -1);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(124, 9, NULL, 18, 'uitvoerder', 0, -1);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(125, 11, 28, 18, 'uitvoerder', 0, -1);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(126, 12, NULL, 20, 'uitvoerder', 0, -1);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(127, 13, NULL, 9, 'uitvoerder', 0, -1);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(128, 14, NULL, 16, 'uitvoerder', 0, -1);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(129, 16, 35, 9, 'uitvoerder', 0, -1);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(130, 17, NULL, 21, 'uitvoerder', 0, -1);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(131, 18, NULL, 16, 'uitvoerder', 0, -1);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(132, 21, 33, 18, 'uitvoerder', 0, -1);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(133, 22, 33, 18, 'uitvoerder', 0, -1);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(134, 23, NULL, 7, 'uitvoerder', 0, -1);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(135, 25, NULL, 16, 'uitvoerder', 0, -1);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(136, 27, NULL, 16, 'uitvoerder', 0, -1);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(137, 29, NULL, 22, 'uitvoerder', 0, -1);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(138, 30, NULL, 7, 'uitvoerder', 0, -1);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(139, 51, NULL, 16, 'eigenaar', 0, -1);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(140, 52, NULL, 16, 'eigenaar', 0, -1);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(141, 53, NULL, 16, 'eigenaar', 0, -1);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(142, 54, NULL, 16, 'eigenaar', 0, -1);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(143, 55, NULL, 16, 'eigenaar', 0, -1);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(144, 56, NULL, 16, 'eigenaar', 0, -1);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(145, 57, NULL, 16, 'eigenaar', 0, -1);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(146, 3, NULL, NULL, 'eigenaar', -1, 0);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(147, 3, NULL, NULL, 'uitvoerder', -1, 0);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(148, 24, NULL, NULL, 'eigenaar', -1, 0);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(149, 24, NULL, NULL, 'uitvoerder', -1, 0);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(150, 26, NULL, NULL, 'uitvoerder', -1, 0);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(151, 31, NULL, NULL, 'uitvoerder', -1, 0);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(152, 31, NULL, NULL, 'eigenaar', -1, 0);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(153, 32, NULL, NULL, 'uitvoerder', -1, 0);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(154, 32, NULL, NULL, 'eigenaar', -1, 0);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(155, 33, NULL, NULL, 'eigenaar', -1, 0);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(156, 33, NULL, NULL, 'uitvoerder', -1, 0);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(157, 34, NULL, NULL, 'eigenaar', -1, 0);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(158, 34, NULL, NULL, 'uitvoerder', -1, 0);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(159, 35, NULL, NULL, 'eigenaar', -1, 0);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(160, 35, NULL, NULL, 'uitvoerder', -1, 0);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(161, 36, NULL, NULL, 'eigenaar', -1, 0);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(162, 36, NULL, NULL, 'uitvoerder', -1, 0);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(163, 37, NULL, NULL, 'eigenaar', -1, 0);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(164, 37, NULL, NULL, 'uitvoerder', -1, 0);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(165, 38, NULL, NULL, 'eigenaar', -1, 0);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(166, 38, NULL, NULL, 'uitvoerder', -1, 0);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(167, 39, NULL, NULL, 'eigenaar', -1, 0);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(168, 39, NULL, NULL, 'uitvoerder', -1, 0);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(169, 40, NULL, NULL, 'eigenaar', -1, 0);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(170, 40, NULL, NULL, 'uitvoerder', -1, 0);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(171, 41, NULL, NULL, 'eigenaar', -1, 0);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(172, 41, NULL, NULL, 'uitvoerder', -1, 0);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(173, 42, NULL, NULL, 'eigenaar', -1, 0);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(174, 42, NULL, NULL, 'uitvoerder', -1, 0);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(175, 49, NULL, NULL, 'eigenaar', -1, 0);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(176, 49, NULL, NULL, 'uitvoerder', -1, 0);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(177, 58, NULL, NULL, 'eigenaar', -1, 0);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(178, 58, NULL, NULL, 'uitvoerder', -1, 0);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(179, 59, NULL, NULL, 'eigenaar', -1, 0);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(180, 59, NULL, NULL, 'uitvoerder', -1, 0);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(181, 60, NULL, NULL, 'eigenaar', -1, 0);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(182, 60, NULL, NULL, 'uitvoerder', -1, 0);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(183, 51, NULL, NULL, 'beheerder', -1, 0);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(184, 51, NULL, NULL, 'uitvoerder', -1, 0);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(185, 52, NULL, NULL, 'beheerder', -1, 0);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(186, 52, NULL, NULL, 'uitvoerder', -1, 0);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(187, 53, NULL, NULL, 'beheerder', -1, 0);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(188, 53, NULL, NULL, 'uitvoerder', -1, 0);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(189, 54, NULL, NULL, 'beheerder', -1, 0);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(190, 54, NULL, NULL, 'uitvoerder', -1, 0);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(191, 55, NULL, NULL, 'beheerder', -1, 0);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(192, 55, NULL, NULL, 'uitvoerder', -1, 0);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(193, 56, NULL, NULL, 'beheerder', -1, 0);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(194, 56, NULL, NULL, 'uitvoerder', -1, 0);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(195, 57, NULL, NULL, 'beheerder', -1, 0);
INSERT INTO `ThemaVerantwoordelijkheden` VALUES(196, 57, NULL, NULL, 'uitvoerder', -1, 0);
UNLOCK TABLES;

#
# Table structure for table 'WorkshopMedewerkers'
#

DROP TABLE IF EXISTS `WorkshopMedewerkers`;
CREATE TABLE `WorkshopMedewerkers` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `workshop_id` INT DEFAULT 0,
  `medewerker_id` INT DEFAULT 0,
  `aanwezig` BIT DEFAULT -1,
  INDEX `id` (`id`),
  INDEX `medewerker_id` (`medewerker_id`),
  INDEX `MedewerkersWorkshopMedewerkers` (`medewerker_id`),
  PRIMARY KEY (`id`),
  INDEX `workshop_id` (`workshop_id`),
  INDEX `WorkshopsWorkshopMedewerkers` (`workshop_id`)
);

#
# Dumping data for table 'WorkshopMedewerkers'
#

LOCK TABLES `WorkshopMedewerkers` WRITE;
INSERT INTO `WorkshopMedewerkers` VALUES(1, 3, 1, -1);
INSERT INTO `WorkshopMedewerkers` VALUES(2, 3, 2, -1);
INSERT INTO `WorkshopMedewerkers` VALUES(3, 3, 3, -1);
INSERT INTO `WorkshopMedewerkers` VALUES(4, 3, 4, -1);
INSERT INTO `WorkshopMedewerkers` VALUES(5, 3, 5, -1);
INSERT INTO `WorkshopMedewerkers` VALUES(6, 3, 6, -1);
INSERT INTO `WorkshopMedewerkers` VALUES(7, 3, 7, -1);
INSERT INTO `WorkshopMedewerkers` VALUES(8, 8, 8, -1);
INSERT INTO `WorkshopMedewerkers` VALUES(9, 8, 9, -1);
INSERT INTO `WorkshopMedewerkers` VALUES(10, 8, 10, -1);
INSERT INTO `WorkshopMedewerkers` VALUES(11, 8, 11, -1);
INSERT INTO `WorkshopMedewerkers` VALUES(12, 8, 12, -1);
INSERT INTO `WorkshopMedewerkers` VALUES(13, 8, 13, -1);
INSERT INTO `WorkshopMedewerkers` VALUES(14, 8, 14, -1);
INSERT INTO `WorkshopMedewerkers` VALUES(15, 9, 15, -1);
INSERT INTO `WorkshopMedewerkers` VALUES(16, 9, 16, -1);
INSERT INTO `WorkshopMedewerkers` VALUES(17, 9, 17, -1);
INSERT INTO `WorkshopMedewerkers` VALUES(18, 9, 18, -1);
INSERT INTO `WorkshopMedewerkers` VALUES(19, 9, 19, -1);
INSERT INTO `WorkshopMedewerkers` VALUES(20, 9, 20, -1);
INSERT INTO `WorkshopMedewerkers` VALUES(21, 9, 21, -1);
INSERT INTO `WorkshopMedewerkers` VALUES(22, 10, 22, -1);
INSERT INTO `WorkshopMedewerkers` VALUES(23, 10, 23, -1);
INSERT INTO `WorkshopMedewerkers` VALUES(24, 10, 24, -1);
INSERT INTO `WorkshopMedewerkers` VALUES(25, 10, 25, -1);
INSERT INTO `WorkshopMedewerkers` VALUES(26, 10, 26, -1);
INSERT INTO `WorkshopMedewerkers` VALUES(27, 10, 27, -1);
INSERT INTO `WorkshopMedewerkers` VALUES(28, 10, 28, -1);
INSERT INTO `WorkshopMedewerkers` VALUES(29, 10, 29, -1);
INSERT INTO `WorkshopMedewerkers` VALUES(30, 2, 30, -1);
INSERT INTO `WorkshopMedewerkers` VALUES(31, 2, 31, -1);
INSERT INTO `WorkshopMedewerkers` VALUES(32, 2, 32, -1);
INSERT INTO `WorkshopMedewerkers` VALUES(33, 5, 33, -1);
INSERT INTO `WorkshopMedewerkers` VALUES(34, 5, 34, -1);
INSERT INTO `WorkshopMedewerkers` VALUES(35, 4, 35, -1);
INSERT INTO `WorkshopMedewerkers` VALUES(36, 4, 36, -1);
INSERT INTO `WorkshopMedewerkers` VALUES(37, 4, 37, -1);
INSERT INTO `WorkshopMedewerkers` VALUES(38, 4, 38, -1);
INSERT INTO `WorkshopMedewerkers` VALUES(39, 4, 39, -1);
INSERT INTO `WorkshopMedewerkers` VALUES(40, 6, 40, -1);
INSERT INTO `WorkshopMedewerkers` VALUES(41, 6, 41, -1);
INSERT INTO `WorkshopMedewerkers` VALUES(42, 6, 42, -1);
INSERT INTO `WorkshopMedewerkers` VALUES(43, 7, 43, -1);
INSERT INTO `WorkshopMedewerkers` VALUES(44, 7, 44, -1);
INSERT INTO `WorkshopMedewerkers` VALUES(45, 7, 45, -1);
INSERT INTO `WorkshopMedewerkers` VALUES(46, 7, 46, -1);
INSERT INTO `WorkshopMedewerkers` VALUES(47, 7, 47, -1);
INSERT INTO `WorkshopMedewerkers` VALUES(48, 7, 48, -1);
INSERT INTO `WorkshopMedewerkers` VALUES(49, 7, 49, -1);
INSERT INTO `WorkshopMedewerkers` VALUES(50, 7, 50, -1);
INSERT INTO `WorkshopMedewerkers` VALUES(51, 1, 51, -1);
INSERT INTO `WorkshopMedewerkers` VALUES(52, 1, 52, -1);
INSERT INTO `WorkshopMedewerkers` VALUES(53, 1, 53, -1);
INSERT INTO `WorkshopMedewerkers` VALUES(54, 1, 54, -1);
INSERT INTO `WorkshopMedewerkers` VALUES(55, 1, 50, -1);
INSERT INTO `WorkshopMedewerkers` VALUES(56, 1, 44, -1);
INSERT INTO `WorkshopMedewerkers` VALUES(57, 5, 29, -1);
INSERT INTO `WorkshopMedewerkers` VALUES(58, 5, 27, -1);
INSERT INTO `WorkshopMedewerkers` VALUES(59, 10, 19, -1);
INSERT INTO `WorkshopMedewerkers` VALUES(60, 4, 15, -1);
INSERT INTO `WorkshopMedewerkers` VALUES(61, 5, 14, -1);
INSERT INTO `WorkshopMedewerkers` VALUES(62, 7, 10, -1);
INSERT INTO `WorkshopMedewerkers` VALUES(63, 1, 10, -1);
INSERT INTO `WorkshopMedewerkers` VALUES(64, 1, 5, -1);
INSERT INTO `WorkshopMedewerkers` VALUES(65, 9, 3, -1);
INSERT INTO `WorkshopMedewerkers` VALUES(66, 1, 2, -1);
INSERT INTO `WorkshopMedewerkers` VALUES(67, 1, 1, -1);
UNLOCK TABLES;

#
# Table structure for table 'Workshops'
#

DROP TABLE IF EXISTS `Workshops`;
CREATE TABLE `Workshops` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `volgnr` INT DEFAULT 0,
  `naam` VARCHAR(255),
  INDEX `id` (`id`),
  PRIMARY KEY (`id`)
);

#
# Dumping data for table 'Workshops'
#

LOCK TABLES `Workshops` WRITE;
INSERT INTO `Workshops` VALUES(1, 10, 'Afstemming organisatiegrenzen en beheer (basis)gegevens ');
INSERT INTO `Workshops` VALUES(2, 5, 'Groen ');
INSERT INTO `Workshops` VALUES(3, 1, 'Inriching processen op hoofdniveau');
INSERT INTO `Workshops` VALUES(4, 7, 'Kunstwerken/Tankstations ');
INSERT INTO `Workshops` VALUES(5, 6, 'Pompen/Verlichting/DSI\'s/VRI\'s/DVM/Kabels&Leidingen ');
INSERT INTO `Workshops` VALUES(6, 8, 'Regelingen ');
INSERT INTO `Workshops` VALUES(7, 9, 'Systeemarchitectuur ');
INSERT INTO `Workshops` VALUES(8, 2, 'Verkeersmanagement, ongevallen, intensiteiten ');
INSERT INTO `Workshops` VALUES(9, 3, 'Voorbereiden en realiseren infrastructurele werken ');
INSERT INTO `Workshops` VALUES(10, 4, 'Weg/Bebording/ANWB ');
INSERT INTO `Workshops` VALUES(12, 11, 'Management presentatie bevindingen');
UNLOCK TABLES;

SET FOREIGN_KEY_CHECKS = 1;
