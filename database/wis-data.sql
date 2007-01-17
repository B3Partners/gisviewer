#SET FOREIGN_KEY_CHECKS = 0;


#
# Dumping data for table 'applicaties'
#

LOCK TABLES `applicaties` WRITE;
INSERT INTO `applicaties` VALUES(1, 'Accres', 'ViaView', "", 0, 1, 1, 1, "", 'o.a. MicroStation en AutoCAD', 'ODBC db\'s (bv Oracle en Access)', 0, 0, 1, "", 8);
INSERT INTO `applicaties` VALUES(2, 'Groenestijn', "", "", 0, 1, 1, 1, 'Xbase++', 'MicroStation, AutoCAD, IGOS, InfoCAD, ArcView, NedView', 'ODBC db\'s (bv Oracle en Access)', 0, 1, 1, "", 6);
INSERT INTO `applicaties` VALUES(3, 'Veras', "", "", 0, 1, 0, 0, "", "", "", 0, 0, 0, "", 5);
INSERT INTO `applicaties` VALUES(4, 'SPOK', "", "", 0, 1, 0, 0, "", "", "", 0, 0, 0, "", 28);
INSERT INTO `applicaties` VALUES(5, 'Mobiliteitsbeleid', "", "", 0, 1, 0, 0, "", "", "", 0, 0, 0, "", 30);
INSERT INTO `applicaties` VALUES(6, 'Cyclomedia', "", "", 0, 1, 0, 0, "", "", "", 0, 0, 0, "", 26);
INSERT INTO `applicaties` VALUES(7, 'RDW Cross', "", "", 1, 1, 0, 0, "", "", "", 0, 0, 0, "", 27);
INSERT INTO `applicaties` VALUES(8, 'MS Excel', "", "", 0, 0, 1, 0, "", "", "", 0, 0, 0, "", 22);
INSERT INTO `applicaties` VALUES(9, 'MS Access', "", "", 0, 1, 1, 0, "", "", "", 0, 0, 0, "", 22);
INSERT INTO `applicaties` VALUES(10, 'BASEC', "", "", 0, 1, 0, 0, "", "", "", 0, 0, 0, "", 29);
INSERT INTO `applicaties` VALUES(11, 'MS Word', "", "", 0, 0, 1, 0, "", "", "", 0, 0, 0, "", 22);
INSERT INTO `applicaties` VALUES(12, 'AutoCad', "", "", 0, 1, 0, 1, "", "", "", 0, 0, 0, "", 23);
INSERT INTO `applicaties` VALUES(13, 'Microstation', "", "", 0, 1, 0, 1, "", "", "", 0, 0, 0, "", 24);
INSERT INTO `applicaties` VALUES(14, 'Onbekend', "", "", 0, 0, 0, 0, "", "", "", 0, 0, 0, "", 28);
INSERT INTO `applicaties` VALUES(15, 'Basisregistratie Geo', "", "", 0, 1, 0, 1, "", "", "", 0, 0, 0, "", 30);
INSERT INTO `applicaties` VALUES(16, 'Rittenadmin Strooiwagens', "", "", 0, 1, 1, 1, "", "", "", 0, 0, 0, "", 28);
INSERT INTO `applicaties` VALUES(17, 'Collector', "", "", 0, 1, 0, 0, "", "", "", 0, 0, 0, "", 4);
INSERT INTO `applicaties` VALUES(18, 'mi2', "", "", 0, 1, 0, 0, 'Delphi/Foxpro/Uniface. Medio 2007 ook andere lijn met Java en .NET', 'MicroStation en AutoCAD', 'ODBC db\'s (bv Oracle en Access). Vanaf medio 2007 Oracle Spatial', 0, 0, 0, 'vanaf medio 2007 webbased', 2);
INSERT INTO `applicaties` VALUES(19, 'DHV Beheerpakketten', "", "", 0, 1, 0, 0, 'Visual Basic', 'MicroStation, AutoCAD, IGOS, InfoCAD, ArcView, NedView', 'ODBC db\'s (bv Oracle en Access)', 1, 1, 1, "", 4);
INSERT INTO `applicaties` VALUES(20, 'DG Dialog', "", "", 0, 1, 0, 0, 'C++/Uniface', 'o.a. MicroStation, AutoCAD, ArcView, NedView', 'Oracle Spatial', 1, 1, 1, "", 5);
INSERT INTO `applicaties` VALUES(21, 'BS8*Beheer', "", "", 0, 1, 0, 0, 'Delphi/C++', 'o.a. MicroStation, ISI-Omega', 'Oracle', 0, 1, 1, "", 7);
INSERT INTO `applicaties` VALUES(22, 'GBI', "", "", 0, 1, 0, 0, 'Oracle/OpenRoad en .NET voor webinterface', 'MicroStation, AutoCAD, IGOS, InfoCAD, ArcView, NedView', 'Oracle', 1, 1, 1, "", 10);
INSERT INTO `applicaties` VALUES(23, 'Infra', "", "", 0, 1, 0, 0, 'MDL', 'MicroStation', 'ODBC db\'s (bv Oracle en Access)', 0, 1, 1, "", 11);
INSERT INTO `applicaties` VALUES(24, 'Zelfbouw/Maatwerk', "", "", 0, 1, 1, 1, "", "", "", 0, 0, 0, 'deze applicatie wordt later opgesplitst in concrete zelfbouw applicaties', 30);
INSERT INTO `applicaties` VALUES(25, 'Geen', "", "", 0, 0, 0, 0, "", "", "", 0, 0, 0, "", 28);
UNLOCK TABLES;

#
# Dumping data for table 'clusters'
#

LOCK TABLES `clusters` WRITE;
INSERT INTO `clusters` VALUES(1, 'Basis', "", NULL);
INSERT INTO `clusters` VALUES(2, 'Verkeer', "", NULL);
INSERT INTO `clusters` VALUES(3, 'Groen', "", NULL);
INSERT INTO `clusters` VALUES(4, 'Juridisch', "", NULL);
INSERT INTO `clusters` VALUES(5, 'Gebieden', "", 1);
INSERT INTO `clusters` VALUES(6, 'Verkeersmanagement', "", 2);
INSERT INTO `clusters` VALUES(8, 'Kunstwerken', "", 1);
INSERT INTO `clusters` VALUES(13, 'Onbekend', "", NULL);
UNLOCK TABLES;

#
# Dumping data for table 'data_regels'
#

LOCK TABLES `data_regels` WRITE;
UNLOCK TABLES;


#
# Dumping data for table 'etlbatch'
#

LOCK TABLES `etlbatch` WRITE;
UNLOCK TABLES;


#
# Dumping data for table 'functie_items'
#

LOCK TABLES `functie_items` WRITE;
INSERT INTO `functie_items` VALUES(1, "", "", "", "", 1, 0, 3);
INSERT INTO `functie_items` VALUES(2, "", "", "", "", 1, 0, 4);
INSERT INTO `functie_items` VALUES(3, "", "", "", "", 1, 0, 5);
INSERT INTO `functie_items` VALUES(4, "", "", "", "", 1, 0, 6);
INSERT INTO `functie_items` VALUES(5, "", "", "", "", 1, 0, 7);
INSERT INTO `functie_items` VALUES(6, "", "", "", "", 1, 0, 8);
INSERT INTO `functie_items` VALUES(7, "", "", "", "", 1, 0, 9);
INSERT INTO `functie_items` VALUES(8, "", "", "", "", 1, 0, 10);
INSERT INTO `functie_items` VALUES(9, "", "", "", "", 1, 0, 11);
INSERT INTO `functie_items` VALUES(10, "", "", "", "", 1, 0, 12);
INSERT INTO `functie_items` VALUES(11, "", "", "", "", 1, 0, 13);
INSERT INTO `functie_items` VALUES(12, "", "", "", "", 1, 0, 14);
INSERT INTO `functie_items` VALUES(13, "", "", "", "", 1, 0, 15);
INSERT INTO `functie_items` VALUES(14, "", "", "", "", 1, 0, 16);
INSERT INTO `functie_items` VALUES(15, "", "", "", "", 1, 0, 17);
INSERT INTO `functie_items` VALUES(16, "", "", "", "", 1, 0, 18);
INSERT INTO `functie_items` VALUES(17, "", "", "", "", 1, 0, 19);
INSERT INTO `functie_items` VALUES(18, "", "", "", "", 1, 0, 20);
INSERT INTO `functie_items` VALUES(19, "", "", "", "", 1, 0, 21);
INSERT INTO `functie_items` VALUES(20, "", "", "", "", 1, 0, 22);
INSERT INTO `functie_items` VALUES(21, "", "", "", "", 1, 0, 23);
INSERT INTO `functie_items` VALUES(22, "", "", "", "", 1, 0, 24);
INSERT INTO `functie_items` VALUES(23, "", "", "", "", 1, 0, 25);
INSERT INTO `functie_items` VALUES(24, "", "", "", "", 1, 0, 26);
INSERT INTO `functie_items` VALUES(25, "", "", "", "", 1, 0, 27);
INSERT INTO `functie_items` VALUES(26, "", "", "", "", 1, 0, 28);
INSERT INTO `functie_items` VALUES(27, "", "", "", "", 1, 0, 29);
INSERT INTO `functie_items` VALUES(28, "", "", "", "", 1, 0, 30);
INSERT INTO `functie_items` VALUES(29, "", "", "", "", 1, 0, 31);
INSERT INTO `functie_items` VALUES(30, "", "", "", "", 1, 0, 32);
INSERT INTO `functie_items` VALUES(31, "", "", "", "", 1, 0, 33);
INSERT INTO `functie_items` VALUES(32, "", "", "", "", 1, 0, 34);
INSERT INTO `functie_items` VALUES(33, "", "", "", "", 1, 0, 35);
INSERT INTO `functie_items` VALUES(34, "", "", "", "", 1, 0, 36);
INSERT INTO `functie_items` VALUES(35, "", "", "", "", 1, 0, 37);
INSERT INTO `functie_items` VALUES(36, "", "", "", "", 1, 0, 38);
INSERT INTO `functie_items` VALUES(37, "", "", "", "", 1, 0, 39);
INSERT INTO `functie_items` VALUES(38, "", "", "", "", 1, 0, 40);
INSERT INTO `functie_items` VALUES(39, "", "", "", "", 1, 0, 41);
INSERT INTO `functie_items` VALUES(40, "", "", "", "", 1, 0, 42);
INSERT INTO `functie_items` VALUES(41, "", "", "", "", 1, 0, 43);
INSERT INTO `functie_items` VALUES(42, "", "", "", "", 1, 0, 44);
INSERT INTO `functie_items` VALUES(43, "", "", "", "", 1, 0, 45);
INSERT INTO `functie_items` VALUES(44, "", "", "", "", 1, 0, 46);
INSERT INTO `functie_items` VALUES(45, "", "", "", "", 0, 1, 3);
INSERT INTO `functie_items` VALUES(46, "", "", "", "", 0, 1, 4);
INSERT INTO `functie_items` VALUES(47, "", "", "", "", 0, 1, 5);
INSERT INTO `functie_items` VALUES(48, "", "", "", "", 0, 1, 6);
INSERT INTO `functie_items` VALUES(49, "", "", "", "", 0, 1, 7);
INSERT INTO `functie_items` VALUES(50, "", "", "", "", 0, 1, 8);
INSERT INTO `functie_items` VALUES(51, "", "", "", "", 0, 1, 9);
INSERT INTO `functie_items` VALUES(52, "", "", "", "", 0, 1, 10);
INSERT INTO `functie_items` VALUES(53, "", "", "", "", 0, 1, 11);
INSERT INTO `functie_items` VALUES(54, "", "", "", "", 0, 1, 12);
INSERT INTO `functie_items` VALUES(55, "", "", "", "", 0, 1, 13);
INSERT INTO `functie_items` VALUES(56, "", "", "", "", 0, 1, 14);
INSERT INTO `functie_items` VALUES(57, "", "", "", "", 0, 1, 15);
INSERT INTO `functie_items` VALUES(58, "", "", "", "", 0, 1, 16);
INSERT INTO `functie_items` VALUES(59, "", "", "", "", 0, 1, 17);
INSERT INTO `functie_items` VALUES(60, "", "", "", "", 0, 1, 18);
INSERT INTO `functie_items` VALUES(61, "", "", "", "", 0, 1, 19);
INSERT INTO `functie_items` VALUES(62, "", "", "", "", 0, 1, 20);
INSERT INTO `functie_items` VALUES(63, "", "", "", "", 0, 1, 21);
INSERT INTO `functie_items` VALUES(64, "", "", "", "", 0, 1, 22);
INSERT INTO `functie_items` VALUES(65, "", "", "", "", 0, 1, 23);
INSERT INTO `functie_items` VALUES(66, "", "", "", "", 0, 1, 24);
INSERT INTO `functie_items` VALUES(67, "", "", "", "", 0, 1, 25);
INSERT INTO `functie_items` VALUES(68, "", "", "", "", 0, 1, 26);
INSERT INTO `functie_items` VALUES(69, "", "", "", "", 0, 1, 27);
INSERT INTO `functie_items` VALUES(70, "", "", "", "", 0, 1, 28);
INSERT INTO `functie_items` VALUES(71, "", "", "", "", 0, 1, 29);
INSERT INTO `functie_items` VALUES(72, "", "", "", "", 0, 1, 30);
INSERT INTO `functie_items` VALUES(73, "", "", "", "", 0, 1, 31);
INSERT INTO `functie_items` VALUES(74, "", "", "", "", 0, 1, 32);
INSERT INTO `functie_items` VALUES(75, "", "", "", "", 0, 1, 33);
INSERT INTO `functie_items` VALUES(76, "", "", "", "", 0, 1, 34);
INSERT INTO `functie_items` VALUES(77, "", "", "", "", 0, 1, 35);
INSERT INTO `functie_items` VALUES(78, "", "", "", "", 0, 1, 36);
INSERT INTO `functie_items` VALUES(79, "", "", "", "", 0, 1, 37);
INSERT INTO `functie_items` VALUES(80, "", "", "", "", 0, 1, 38);
INSERT INTO `functie_items` VALUES(81, "", "", "", "", 0, 1, 39);
INSERT INTO `functie_items` VALUES(82, "", "", "", "", 0, 1, 40);
INSERT INTO `functie_items` VALUES(83, "", "", "", "", 0, 1, 41);
INSERT INTO `functie_items` VALUES(84, "", "", "", "", 0, 1, 42);
INSERT INTO `functie_items` VALUES(85, "", "", "", "", 0, 1, 43);
INSERT INTO `functie_items` VALUES(86, "", "", "", "", 0, 1, 44);
INSERT INTO `functie_items` VALUES(87, "", "", "", "", 0, 1, 45);
INSERT INTO `functie_items` VALUES(88, "", "", "", "", 0, 1, 46);
UNLOCK TABLES;

#
# Dumping data for table 'leveranciers'
#

LOCK TABLES `leveranciers` WRITE;
INSERT INTO `leveranciers` VALUES(2, 'Arcadis', 'mi2', '033 4771661', 'Peter van Boekel', '055 5815926', '06 27062154', 'p.a.m.boekel@arcadis.nl', 1, 'heeft Winsign-pakket van Uniforn overgenomen. Heet nu "mi2"');
INSERT INTO `leveranciers` VALUES(4, 'DHV', 'DHV Beheerpakketten', '033 4682000', 'Max de Veer', '033 4683340', '06 29098262', 'max.deveer@dhv.nl', 1, "");
INSERT INTO `leveranciers` VALUES(5, 'Grontmij', 'DG Dialog', "", 'Henri Veldhuis', '0165 575763', '06 20013109', 'henri.veldhuis@grontmij.nl', 1, 'Zegt alles te kunnen leveren omdat elk niet bestaand object kan worden aangemaakt in de module Overige Objecten; Het plannen en bewaken van de voortgang van projecten is geen standaardfunctionaliteit van dg DIALOG. Het is in de verschillende modules van dg DIALOG wel mogelijk om vastgesteld onderhoud op te nemen in een toekomstige planning; Momenteel wordt door Grontmij in opdracht van de provincie Zuid Holland een module ontwikkelt voor het beheer van VRI\'s. Oplevering van deze module is gepland voor maart 2007.');
INSERT INTO `leveranciers` VALUES(6, 'Groenestijn Beheersoftware', 'GB GIS', '0317 417647', 'Jan Groenestijn', "", "", 'info@gbor.nl', 1, 'Jan Groenestijn (eigenaar) "kan niets" met lijst van gegevensgebieden; Alleen module voor oevers (niet sloten); Fotolink (geen cyclorama); Kapvergunning (geen algemene verg.)');
INSERT INTO `leveranciers` VALUES(7, 'Beheer Visie', 'BS8*Beheer', '0348 499337', 'Peter Hermsen', "", '06 53638679', 'peter.hermsen@beheervisie.nl', 1, "");
INSERT INTO `leveranciers` VALUES(8, 'KOAC NPC', 'ViaView/Accres', '030 2876950', 'Thijs Adolfs', '030 2876981', "", 'adolfs@koac-npc.nl', 1, 'Fotolink (geen cyclorama);');
INSERT INTO `leveranciers` VALUES(10, 'Oranjewoud', 'GBI', '0513 634567', 'Harmen Tjeerdsma', "", '06 53926449', 'harmen.tjeerdsma@oranjewoud.nl', 0, 'Cyclorama alleen via koppeling externe software; Eigendom alleen in openbare ruimte');
INSERT INTO `leveranciers` VALUES(11, 'Fugro Inpark', 'Infra', '070 3170700', 'Jan Hemmen', '026 3698470', '06 54381535', 'j.hemmen@fugro-inpark.nl', 1, "");
INSERT INTO `leveranciers` VALUES(12, 'Holland Reliëf', "", "", "", "", "", "", 0, "");
INSERT INTO `leveranciers` VALUES(13, 'HawarIT', "", '0515 570333', 'Cees Nieboer', "", "", 'c.nieboer@hawarit.com', 0, 'Heeft delen van de DHV Beheerpakketten gemaakt; Biedt vooral grafische lagen boven DHV, Arcadis, etc.');
INSERT INTO `leveranciers` VALUES(16, 'Witteveen en Bos', "", '0570 697911', 'Dennis Sunnebelt', '0570 697160', "", "", 0, 'de software die ze hebben (alleen op het gebied van geleiderails) is gemaakt door DHV. Dit pakket van DHV wat inventarisaties maakt van bermen/geleiderails heet Prioberm');
INSERT INTO `leveranciers` VALUES(17, 'Infra Engineering', "", "", "", "", "", "", 0, 'ontwikkeld geen software meer voor WIS; Vroeger software ontwikkeld i.s.m. Oranjewoud');
INSERT INTO `leveranciers` VALUES(18, 'Uniform', 'Winsign', "", 'Dijkstra/Smallegange', "", "", "", 0, 'heeft Winsign-pakket verkocht aan Arcadis');
INSERT INTO `leveranciers` VALUES(19, 'Holland Field Engineering', "", '023 5321959', 'dhr. Frenay', "", "", 'info@hollandfield.nl', 0, '"Kan het niet voor elkaar krijgen". (Geen capaciteit/mogelijkheid/know-how/wil (conclusie van Erik))');
INSERT INTO `leveranciers` VALUES(22, 'Microsoft', "", "", "", "", "", "", 0, "");
INSERT INTO `leveranciers` VALUES(23, 'AutoDesk', 'Autocad', '0180 691000', "", "", "", "", 0, "");
INSERT INTO `leveranciers` VALUES(24, 'Bentley', 'Microstation', '023 5560 560', "", "", "", "", 0, "");
INSERT INTO `leveranciers` VALUES(26, 'Cyclomedia', "", "", "", "", "", "", 0, "");
INSERT INTO `leveranciers` VALUES(27, 'RDW', "", "", "", "", "", "", 0, "");
INSERT INTO `leveranciers` VALUES(28, 'Onbekend', "", "", "", "", "", "", 0, "");
INSERT INTO `leveranciers` VALUES(29, 'Dufec', 'BASEC', '013 460 9983', "", "", "", "", 0, "");
INSERT INTO `leveranciers` VALUES(30, 'Provincie Noord-Brabant', 'zelfbouw/maatwerk', "", "", "", "", "", 0, "");
UNLOCK TABLES;

#
# Dumping data for table 'locatie_aanduidingen'
#

LOCK TABLES `locatie_aanduidingen` WRITE;
INSERT INTO `locatie_aanduidingen` VALUES(1, 'RD coordinaten', 'x en y coordinaten van klikpunt');
INSERT INTO `locatie_aanduidingen` VALUES(2, 'WOL/HM', 'indien klikpunt binnen 100 m van hmpaal dan wegnr en hm aanduiding');
INSERT INTO `locatie_aanduidingen` VALUES(3, 'Adres', 'Straat, nr, postcode, plaats, gemeente van klikpunt');
INSERT INTO `locatie_aanduidingen` VALUES(4, 'Regio', 'aanduiding in welke regio klikpunt ligt');
UNLOCK TABLES;

#
# Dumping data for table 'medewerkers'
#

LOCK TABLES `medewerkers` WRITE;
INSERT INTO `medewerkers` VALUES(1, 'Boer, van den C.C.M.', 'Cees', '(073-681) 2237/06-18303177', 'Bureauhoofd', '18/15', 'Cvdboer@brabant.nl');
INSERT INTO `medewerkers` VALUES(2, 'Boome, te C.M.J.', 'Karen', '(0413-29) 6740', 'Bureauhoofd', 'Heeswijk/Dinther', 'CtBoome@brabant.nl');
INSERT INTO `medewerkers` VALUES(3, 'Gaveel, R.H.', 'Rob', '(073-680) 8324/06-18303401', 'Bureauhoofd', '19/15', ' RGaveel@brabant.nl');
INSERT INTO `medewerkers` VALUES(4, 'Helvert, van T.J.A.', 'Terry', '(076-523) 1640', 'Bureauhoofd', 'Breda', 'TvHelvert@brabant.nl');
INSERT INTO `medewerkers` VALUES(5, 'Post, M.', 'Maarten', '(0499-36) 4740/06-18303209', 'Bureauhoofd', 'Best/', ' MPost@brabant.nl');
INSERT INTO `medewerkers` VALUES(6, 'Slagboom, J.C.', 'Hans', '(073-680) 8216', 'Bureauhoofd OVM', '21/18', 'HSlagboom@brabant.nl');
INSERT INTO `medewerkers` VALUES(7, 'Gils, van J.A.W.', 'Joost', '(073-681) 2457', 'Directielid', '20/21', ' JvGils@brabant.nl');
INSERT INTO `medewerkers` VALUES(8, 'Coillie, van E.A.G.', 'Egmond', '(073-680) 8849', 'Vakinhoudelijk medewerker F.', '19/16', 'EvCoillie@brabant.nl');
INSERT INTO `medewerkers` VALUES(9, 'Broek, van den H.A.J.', 'Henk', '(073-681) 2339', 'Medewerker verkeerstellingen', '19/16', ' HAvdBroek@brabant.nl');
INSERT INTO `medewerkers` VALUES(10, 'Egeraat, van M.A.L.', 'Michael', '(073-681) 2450', 'Clustercoördinator Monitoring Ecaluatie en Verkeersmodellen (MEMO)', '18/flex', ' MvEgeraat@brabant.nl');
INSERT INTO `medewerkers` VALUES(11, 'Wolff, de P.', 'Peter', '(073-680) 8519', 'Beleidsmedewerker Verkeersmanagement', '19/flex', ' PdWolff@brabant.nl');
INSERT INTO `medewerkers` VALUES(12, 'Dorst, van M.C.M.', 'Marco', '(0499-36) 4710/06-18303212', 'Beleidsmedewerker verkeer/Coördinator verkeersbeheer', 'Best/', ' MvDorst@brabant.nl');
INSERT INTO `medewerkers` VALUES(13, 'Kort, de P.P.A.', 'Peter', '(076-523) 1610', 'Beleidsmedewerker/plaatsvervangend bureauhoofd', 'Breda/', ' PdKort@brabant.nl');
INSERT INTO `medewerkers` VALUES(14, 'Steens, B.J.P.', 'Bart', '(0413-29) 6710/06-18303175', 'Beleidsmedewerker verkeer, Coördinator verkeersbeheer', 'Heeswijk/Dinther', ' BSteens@brabant.nl');
INSERT INTO `medewerkers` VALUES(15, 'Geurtz, F.J.M.', 'Frank', '(073-680) 8715/(073-681) 2346', 'Projectingenieur A', '19/flex', 'FGeurtz@brabant.nl');
INSERT INTO `medewerkers` VALUES(16, 'Kooijman, R.A.', 'René', '(073-680) 8138', 'Ontwerper B', '19/02', ' RKooijman@brabant.nl');
INSERT INTO `medewerkers` VALUES(17, 'Kappé, J.E.M.', 'Jan', '(073-681) 2455', 'Projectcoördinator', '19/flex', ' JKappe@brabant.nl');
INSERT INTO `medewerkers` VALUES(18, 'Logt, van de Q.A.J.', 'Quirin', '(073-681)2352/06-18303230', 'Projectleider infrastructurele projecten', '18/03', ' QvdLogt@brabant.nl');
INSERT INTO `medewerkers` VALUES(19, 'Strik, C.W.M.', 'Casper', '(073-680) 8716', 'Projectleider', '18/flex', ' CStrik@brabant.nl');
INSERT INTO `medewerkers` VALUES(20, 'Mens, J.G.M.', 'Jacques', '(073-681) 2845', 'Beleidsmedewerker realiseren', '19/flex', ' JMens@brabant.nl');
INSERT INTO `medewerkers` VALUES(21, 'Bont, de H.P.A.P.', 'Harrie', '(0413-29) 6700/06-18303228', 'Directievoerder', 'Heeswijk/Dinther', ' HdBont@brabant.nl');
INSERT INTO `medewerkers` VALUES(22, 'Kaam, van E.H.N.', 'Eric', '(076-523) 1620/06-18303193', 'Projectcoördinator A', 'Breda/', ' EvKaam@brabant.nl');
INSERT INTO `medewerkers` VALUES(23, 'Groenen, F.J.M.C.', 'Frans', '(0499-36) 4714', 'Medewerker verkeerbeheer', 'Best/', ' FGroenen@brabant.nl');
INSERT INTO `medewerkers` VALUES(24, 'Esch, van H.A.M.', 'Henk', '(0413-29) 6715/06-18303264', 'Tijdelijk 29-08-07 Inspecteur Verkeersbeheer', 'Heeswijk/Dinther', ' HvEsch@brabant.nl');
INSERT INTO `medewerkers` VALUES(25, 'Spijk, van C.H.G.', 'Cor', '(0413-29) 6711/06-18303179', 'Medewerker Dynamisch Verkeersmanagement', 'Heeswijk/Dinther', ' Cvspijk@brabant.nl');
INSERT INTO `medewerkers` VALUES(26, 'Sulkers, J.', 'Jaap', '(076-523) 1600', 'Inspecteur verkeersbeheer A', 'Breda/', ' JSulkers@brabant.nl');
INSERT INTO `medewerkers` VALUES(27, 'Zwarteveen, J.A.', 'Hans', '(073-681) 2723/06-18303442', 'Ontwerper', '19/flex', ' HZwarteveen@brabant.nl');
INSERT INTO `medewerkers` VALUES(28, 'Engelhard, F.W.J.', 'Fred', '(073-680) 8520', 'Beheerder verhardingsgegevens, med. calculatie en informatisering', '19/17', ' FEngelhard@brabant.nl');
INSERT INTO `medewerkers` VALUES(29, 'Nistelrooij, van G.C.J.F.', 'Gijs', '(0499-36) 4711/06-18303214', 'Medewerker Dynamisch Verkeersmanagement', 'Best/', 'GvNistelrooy@brabant.nl');
INSERT INTO `medewerkers` VALUES(30, 'Zandvoort, van J.A.L.', 'Hans', '(073-681) 2017', 'Projectleider ontsnippering', '18/flex', ' JvZandvoort@brabant.nl');
INSERT INTO `medewerkers` VALUES(31, 'Deelen, J.C.A.', 'Hans', '(0499-36) 4722/06-18303220', 'Toezichthouder', '19/21', 'HDeelen@brabant.nl');
INSERT INTO `medewerkers` VALUES(32, 'Bongers, C.P.M.', 'Kees', '(0413-29) 6722/06-18303172', 'Toezichthouder', 'Heeswijk/Dinther', ' KBongers@brabant.nl');
INSERT INTO `medewerkers` VALUES(33, 'Tienhoven, van R.A.', 'Sander', '(073-681)2471/06-18303085', 'Verkeerstechnisch adviseur verkeersregelingen', '19/flex', ' SvTienhoven@brabant.nl');
INSERT INTO `medewerkers` VALUES(34, 'Verstappen, W.A.M.', 'William', '(0499-36) 4721/06-18303443', 'Toezichthouder/Directievoerder', 'Best/', ' WVerstappen@brabant.nl');
INSERT INTO `medewerkers` VALUES(35, 'Baarendse, A.M.H.M.', 'Ton', '(073-681) 2345', 'Technisch administratief medewerker civiele kunstwerken', '19/flex', ' TBaarendse@brabant.nl');
INSERT INTO `medewerkers` VALUES(36, 'Ras, T.A.', 'Ron', '(073-681) 2459', 'Medewerker beheer A', '18/09', ' RRas@brabant.nl');
INSERT INTO `medewerkers` VALUES(37, 'Dudar, J.G.H.M.', 'Jim', '(073-681) 2314', 'Beleidsmedewerker', '19/flex', ' JDudar@brabant.nl');
INSERT INTO `medewerkers` VALUES(38, 'Bakker, P.C.H.', 'Paul', '(0413-29) 6700/06-18303357', 'Toezichthouder', 'Heeswijk/Dinther', ' PBakker@brabant.nl');
INSERT INTO `medewerkers` VALUES(39, 'Thielen, C.A.N.', 'Cees', '(076-523) 1600/06-18303151', 'Directie UAV', 'Breda/', ' CThielen@brabant.nl');
INSERT INTO `medewerkers` VALUES(40, 'Korsten, A.J.M.M.', 'Jos', '(073-681) 2463', 'Beleidsmedewerker', '18/02', ' JKorsten@brabant.nl');
INSERT INTO `medewerkers` VALUES(41, 'Verwijmeren, D.C.', 'Dion', '(073-680) 8186', 'Medewerker beheer A', '18/o1', ' DVerwijmeren@brabant.nl');
INSERT INTO `medewerkers` VALUES(42, 'Ceelen, M.A.F.H.', 'Mark', '(0413-29) 6712/06-18303168', 'Juridisch medewerker', 'Heeswijk/Dinther', ' MCeelen@brabant.nl');
INSERT INTO `medewerkers` VALUES(43, 'Thijssen, M.J.L.', 'Mark', '(073-681) 2416', 'Teamleider systeemintegratie en systeemarchitect', '04/09', ' MThijssen@brabant.nl');
INSERT INTO `medewerkers` VALUES(44, 'Smits, G.J.M.', 'Guido', '(073-681) 2322', 'Bureauhoofd Informatie-management', '05/21', ' GSmits@Brabant.nl');
INSERT INTO `medewerkers` VALUES(45, 'Hoefnagels, A.C.A.', 'Louk', '(073-681) 2169', 'Concern-adviseur integrale informatievoorziening', '04/18', ' AHoefnagels@brabant.nl');
INSERT INTO `medewerkers` VALUES(46, 'Berg, van den J.C.', 'Hans', '(073-681) 2540', 'Data-architect', '17/21', ' JCvdBerg@brabant.nl');
INSERT INTO `medewerkers` VALUES(47, 'Bilde, de J.H.L.', 'Jos', '(073-680) 8517', 'Projectleider IIV', '04/03', ' JdBilde@brabant.nl');
INSERT INTO `medewerkers` VALUES(48, 'Hagedoorn, F.P.', 'Frank', '(073-681) 2414', 'Ontwikkelaar informatiesystemen', '04/19', ' fhagedoorn@brabant.nl');
INSERT INTO `medewerkers` VALUES(49, 'Vlamings, A.M.A.M.', 'Ton', '(073-681) 2441', 'Informatie-analist', '04/06', 'TVlamings@brabant.nl');
INSERT INTO `medewerkers` VALUES(50, 'Vriends, G.V.C.', 'Guust', '(073-680) 8344', 'Geografisch informatie analist', '17/18', ' GVriends@brabant.nl');
INSERT INTO `medewerkers` VALUES(51, 'Bevelander MSc, M.', 'Marjan', '(073-681) 2703', 'Teamleider datamanagement', '17/21', ' MBevelander@brabant.nl');
INSERT INTO `medewerkers` VALUES(52, 'Voet, H.A.L.J.', 'Herman', '(073-680) 8574', 'Beleidsmedewerker nieuwe toepassingen geografische informatievoorziening', '17/19', ' HVoet@brabant.nl');
INSERT INTO `medewerkers` VALUES(53, 'Schiphorst, ter A', 'Lex', '(073-681)2610 / 06-18303145', 'Teamleider geodesie', '16/03', ' LtSchiphorst@brabant.nl');
INSERT INTO `medewerkers` VALUES(54, 'Hooiveld, J.P.J.', 'JaccoPeter', '(073-680) 8430', 'Teamleider geografische informatievoorziening frontoffice', '17/07', ' JHooiveld@brabant.nl');
INSERT INTO `medewerkers` VALUES(55, 'Oerle, van A.', 'Toon', "", "", "", "");
UNLOCK TABLES;

#
# Dumping data for table 'moscow'
#

LOCK TABLES `moscow` WRITE;
INSERT INTO `moscow` VALUES(1, 'M', 'Must Have', "");
INSERT INTO `moscow` VALUES(2, 'S', 'Should Have', "");
INSERT INTO `moscow` VALUES(3, 'C', 'Could Have', "");
INSERT INTO `moscow` VALUES(4, 'W', 'Will Not Have', "");
INSERT INTO `moscow` VALUES(5, 'O', 'Onbekend', "");
UNLOCK TABLES;

#
# Dumping data for table 'object_typen'
#

LOCK TABLES `object_typen` WRITE;
INSERT INTO `object_typen` VALUES(1, 'Generiek');
INSERT INTO `object_typen` VALUES(2, 'punt');
INSERT INTO `object_typen` VALUES(3, 'lijn');
INSERT INTO `object_typen` VALUES(4, 'vlak');
UNLOCK TABLES;

#
# Dumping data for table 'onderdeel'
#

LOCK TABLES `onderdeel` WRITE;
INSERT INTO `onderdeel` VALUES(1, 'Onbekend', "", "", 0);
INSERT INTO `onderdeel` VALUES(7, 'Projectleider', 'tijdelijke verantwoordelijke gedurende project', "", 0);
INSERT INTO `onderdeel` VALUES(9, 'EenM//INF', 'uitvoering viaview', 'Den Bosch', 0);
INSERT INTO `onderdeel` VALUES(10, 'EenM//EenMa', '-', 'Den Bosch', 0);
INSERT INTO `onderdeel` VALUES(12, 'EenM//MRNO', 'regio noord-oost', 'Heeswijk-Dinther', 1);
INSERT INTO `onderdeel` VALUES(13, 'EenM//MRW', 'regio west', 'Breda', 1);
INSERT INTO `onderdeel` VALUES(14, 'EenM//MRZO', 'regio zuid-oost', 'Best', 1);
INSERT INTO `onderdeel` VALUES(15, 'EenM//OVM', '-', 'Den Bosch', 0);
INSERT INTO `onderdeel` VALUES(16, 'EenM//UM', 'uitvoering groenestein, collector en veras', 'Den Bosch', 0);
INSERT INTO `onderdeel` VALUES(17, 'MID/IIV/AenI', '-', 'Den Bosch', 0);
INSERT INTO `onderdeel` VALUES(18, 'MID/IIV/GEO', '-', 'Den Bosch', 0);
INSERT INTO `onderdeel` VALUES(19, 'MID/IIV/IM', '-', 'Den Bosch', 0);
INSERT INTO `onderdeel` VALUES(20, 'EenM//MRX', 'alle regios', "", 1);
INSERT INTO `onderdeel` VALUES(21, 'Ontwerper', 'leverancier, bouwer', "", 0);
INSERT INTO `onderdeel` VALUES(22, 'ECL', 'ecologie', "", 0);
UNLOCK TABLES;

#
# Dumping data for table 'onderdeel_medewerkers'
#

LOCK TABLES `onderdeel_medewerkers` WRITE;
INSERT INTO `onderdeel_medewerkers` VALUES(69, 15, 9, 0);
INSERT INTO `onderdeel_medewerkers` VALUES(70, 7, 10, 1);
INSERT INTO `onderdeel_medewerkers` VALUES(71, 3, 9, 0);
INSERT INTO `onderdeel_medewerkers` VALUES(72, 16, 9, 0);
INSERT INTO `onderdeel_medewerkers` VALUES(73, 17, 9, 0);
INSERT INTO `onderdeel_medewerkers` VALUES(74, 20, 9, 0);
INSERT INTO `onderdeel_medewerkers` VALUES(75, 27, 9, 0);
INSERT INTO `onderdeel_medewerkers` VALUES(76, 28, 9, 1);
INSERT INTO `onderdeel_medewerkers` VALUES(77, 33, 9, 0);
INSERT INTO `onderdeel_medewerkers` VALUES(78, 35, 9, 0);
INSERT INTO `onderdeel_medewerkers` VALUES(79, 37, 9, 0);
INSERT INTO `onderdeel_medewerkers` VALUES(80, 2, 12, 0);
INSERT INTO `onderdeel_medewerkers` VALUES(81, 14, 12, 0);
INSERT INTO `onderdeel_medewerkers` VALUES(82, 21, 12, 0);
INSERT INTO `onderdeel_medewerkers` VALUES(83, 24, 12, 0);
INSERT INTO `onderdeel_medewerkers` VALUES(84, 25, 12, 0);
INSERT INTO `onderdeel_medewerkers` VALUES(85, 32, 12, 0);
INSERT INTO `onderdeel_medewerkers` VALUES(86, 38, 12, 0);
INSERT INTO `onderdeel_medewerkers` VALUES(87, 42, 12, 0);
INSERT INTO `onderdeel_medewerkers` VALUES(88, 4, 13, 1);
INSERT INTO `onderdeel_medewerkers` VALUES(89, 13, 13, 0);
INSERT INTO `onderdeel_medewerkers` VALUES(90, 22, 13, 0);
INSERT INTO `onderdeel_medewerkers` VALUES(91, 26, 13, 0);
INSERT INTO `onderdeel_medewerkers` VALUES(92, 39, 13, 0);
INSERT INTO `onderdeel_medewerkers` VALUES(93, 5, 14, 1);
INSERT INTO `onderdeel_medewerkers` VALUES(94, 12, 14, 0);
INSERT INTO `onderdeel_medewerkers` VALUES(95, 23, 14, 0);
INSERT INTO `onderdeel_medewerkers` VALUES(96, 29, 14, 0);
INSERT INTO `onderdeel_medewerkers` VALUES(97, 31, 14, 0);
INSERT INTO `onderdeel_medewerkers` VALUES(98, 34, 14, 0);
INSERT INTO `onderdeel_medewerkers` VALUES(99, 6, 15, 1);
INSERT INTO `onderdeel_medewerkers` VALUES(100, 1, 16, 0);
INSERT INTO `onderdeel_medewerkers` VALUES(101, 8, 16, 0);
INSERT INTO `onderdeel_medewerkers` VALUES(102, 9, 16, 0);
INSERT INTO `onderdeel_medewerkers` VALUES(103, 10, 16, 0);
INSERT INTO `onderdeel_medewerkers` VALUES(104, 11, 16, 0);
INSERT INTO `onderdeel_medewerkers` VALUES(105, 18, 16, 0);
INSERT INTO `onderdeel_medewerkers` VALUES(106, 19, 16, 0);
INSERT INTO `onderdeel_medewerkers` VALUES(107, 30, 16, 0);
INSERT INTO `onderdeel_medewerkers` VALUES(108, 36, 16, 0);
INSERT INTO `onderdeel_medewerkers` VALUES(109, 40, 16, 0);
INSERT INTO `onderdeel_medewerkers` VALUES(110, 41, 16, 0);
INSERT INTO `onderdeel_medewerkers` VALUES(111, 43, 17, 1);
INSERT INTO `onderdeel_medewerkers` VALUES(112, 46, 17, 0);
INSERT INTO `onderdeel_medewerkers` VALUES(113, 51, 17, 0);
INSERT INTO `onderdeel_medewerkers` VALUES(114, 50, 18, 0);
INSERT INTO `onderdeel_medewerkers` VALUES(115, 52, 18, 0);
INSERT INTO `onderdeel_medewerkers` VALUES(116, 53, 18, 1);
INSERT INTO `onderdeel_medewerkers` VALUES(117, 54, 18, 0);
INSERT INTO `onderdeel_medewerkers` VALUES(118, 44, 19, 1);
INSERT INTO `onderdeel_medewerkers` VALUES(119, 45, 19, 0);
INSERT INTO `onderdeel_medewerkers` VALUES(120, 47, 19, 0);
INSERT INTO `onderdeel_medewerkers` VALUES(121, 48, 19, 0);
INSERT INTO `onderdeel_medewerkers` VALUES(122, 49, 19, 0);
UNLOCK TABLES;

#
# Dumping data for table 'regel_attributen'
#

LOCK TABLES `regel_attributen` WRITE;
UNLOCK TABLES;

#
# Dumping data for table 'rollen'
#

LOCK TABLES `rollen` WRITE;
INSERT INTO `rollen` VALUES(1, 'eigenaar');
INSERT INTO `rollen` VALUES(2, 'beheerder');
INSERT INTO `rollen` VALUES(3, 'uitvoerder');
INSERT INTO `rollen` VALUES(4, 'onbekend');
UNLOCK TABLES;

#
# Dumping data for table 'spatial_objects'
#

LOCK TABLES `spatial_objects` WRITE;
UNLOCK TABLES;

#
# Dumping data for table 'thema_applicaties'
#

LOCK TABLES `thema_applicaties` WRITE;
INSERT INTO `thema_applicaties` VALUES(1, 1, 1, 1, 1, 1, 1, 1, 1);
INSERT INTO `thema_applicaties` VALUES(3, 4, 1, 1, 1, 1, 1, 1, 1);
INSERT INTO `thema_applicaties` VALUES(7, 8, 1, 1, 1, 1, 1, 1, 1);
INSERT INTO `thema_applicaties` VALUES(11, 13, 1, 1, 1, 1, 1, 1, 1);
INSERT INTO `thema_applicaties` VALUES(12, 14, 11, 1, 0, 1, 0, 0, 1);
INSERT INTO `thema_applicaties` VALUES(13, 15, 15, 1, 1, 0, 0, 0, 1);
INSERT INTO `thema_applicaties` VALUES(14, 16, 4, 1, 0, 1, 0, 0, 1);
INSERT INTO `thema_applicaties` VALUES(19, 22, 8, 1, 0, 1, 1, 0, 1);
INSERT INTO `thema_applicaties` VALUES(20, 23, 8, 1, 0, 1, 0, 0, 1);
INSERT INTO `thema_applicaties` VALUES(22, 25, 3, 1, 0, 1, 0, 0, 1);
INSERT INTO `thema_applicaties` VALUES(24, 27, 10, 1, 0, 1, 0, 0, 1);
INSERT INTO `thema_applicaties` VALUES(27, 30, 7, 1, 0, 1, 0, 0, 1);
INSERT INTO `thema_applicaties` VALUES(28, 31, 11, 1, 0, 1, 0, 0, 1);
INSERT INTO `thema_applicaties` VALUES(30, 33, 5, 1, 0, 1, 0, 0, 1);
INSERT INTO `thema_applicaties` VALUES(31, 34, 5, 1, 0, 1, 0, 0, 1);
INSERT INTO `thema_applicaties` VALUES(32, 35, 5, 1, 0, 1, 0, 0, 1);
INSERT INTO `thema_applicaties` VALUES(33, 36, 5, 1, 0, 1, 0, 0, 1);
INSERT INTO `thema_applicaties` VALUES(35, 38, 1, 1, 1, 1, 1, 1, 1);
INSERT INTO `thema_applicaties` VALUES(38, 41, 1, 1, 1, 1, 1, 0, 1);
INSERT INTO `thema_applicaties` VALUES(39, 42, 16, 1, 0, 1, 0, 0, 1);
INSERT INTO `thema_applicaties` VALUES(43, 5, 2, 1, 1, 1, 1, 1, 1);
INSERT INTO `thema_applicaties` VALUES(44, 6, 2, 1, 1, 1, 1, 1, 1);
INSERT INTO `thema_applicaties` VALUES(48, 11, 6, 1, 1, 0, 1, 0, 1);
INSERT INTO `thema_applicaties` VALUES(51, 14, 12, 1, 1, 0, 0, 0, 1);
INSERT INTO `thema_applicaties` VALUES(55, 18, 2, 1, 1, 1, 1, 1, 1);
INSERT INTO `thema_applicaties` VALUES(80, 16, 1, 0, 1, 1, 0, 1, 1);
INSERT INTO `thema_applicaties` VALUES(81, 18, 1, 0, 0, 0, 0, 0, 1);
INSERT INTO `thema_applicaties` VALUES(82, 12, 1, 0, 1, 1, 0, 1, 1);
INSERT INTO `thema_applicaties` VALUES(83, 3, 1, 0, 1, 1, 0, 1, 1);
INSERT INTO `thema_applicaties` VALUES(84, 11, 1, 0, 1, 1, 0, 1, 1);
INSERT INTO `thema_applicaties` VALUES(85, 23, 1, 0, 1, 1, 0, 1, 1);
INSERT INTO `thema_applicaties` VALUES(86, 26, 1, 0, 1, 1, 0, 1, 1);
INSERT INTO `thema_applicaties` VALUES(87, 35, 1, 0, 1, 1, 0, 0, 1);
INSERT INTO `thema_applicaties` VALUES(88, 44, 1, 0, 1, 1, 0, 0, 1);
INSERT INTO `thema_applicaties` VALUES(89, 43, 1, 0, 1, 1, 0, 0, 1);
INSERT INTO `thema_applicaties` VALUES(90, 45, 1, 0, 1, 1, 0, 0, 1);
INSERT INTO `thema_applicaties` VALUES(91, 13, 2, 0, 0, 0, 0, 0, 1);
INSERT INTO `thema_applicaties` VALUES(93, 12, 2, 0, 0, 0, 0, 0, 1);
INSERT INTO `thema_applicaties` VALUES(94, 14, 2, 0, 1, 1, 0, 0, 1);
INSERT INTO `thema_applicaties` VALUES(96, 9, 2, 0, 1, 1, 0, 0, 1);
INSERT INTO `thema_applicaties` VALUES(97, 11, 2, 0, 0, 0, 0, 0, 1);
INSERT INTO `thema_applicaties` VALUES(98, 23, 2, 0, 0, 0, 0, 0, 1);
INSERT INTO `thema_applicaties` VALUES(99, 26, 2, 0, 0, 0, 0, 0, 1);
INSERT INTO `thema_applicaties` VALUES(100, 22, 2, 0, 1, 1, 0, 0, 1);
INSERT INTO `thema_applicaties` VALUES(101, 36, 2, 0, 1, 1, 0, 0, 1);
INSERT INTO `thema_applicaties` VALUES(102, 44, 2, 0, 0, 0, 0, 0, 1);
INSERT INTO `thema_applicaties` VALUES(103, 43, 2, 0, 1, 1, 0, 0, 1);
INSERT INTO `thema_applicaties` VALUES(104, 45, 2, 0, 1, 1, 0, 0, 1);
INSERT INTO `thema_applicaties` VALUES(105, 13, 18, 0, 0, 0, 0, 0, 1);
INSERT INTO `thema_applicaties` VALUES(106, 16, 18, 0, 0, 0, 0, 0, 1);
INSERT INTO `thema_applicaties` VALUES(107, 18, 18, 0, 0, 0, 0, 0, 1);
INSERT INTO `thema_applicaties` VALUES(108, 23, 18, 0, 0, 0, 0, 0, 1);
INSERT INTO `thema_applicaties` VALUES(109, 26, 18, 0, 0, 0, 0, 0, 1);
INSERT INTO `thema_applicaties` VALUES(110, 32, 18, 0, 0, 0, 0, 0, 1);
INSERT INTO `thema_applicaties` VALUES(111, 36, 18, 0, 0, 0, 0, 0, 1);
INSERT INTO `thema_applicaties` VALUES(112, 44, 18, 0, 0, 0, 0, 0, 1);
INSERT INTO `thema_applicaties` VALUES(113, 13, 19, 0, 0, 0, 0, 0, 1);
INSERT INTO `thema_applicaties` VALUES(114, 16, 19, 0, 0, 0, 0, 0, 1);
INSERT INTO `thema_applicaties` VALUES(115, 18, 19, 0, 0, 0, 0, 0, 1);
INSERT INTO `thema_applicaties` VALUES(116, 12, 19, 0, 0, 0, 0, 0, 1);
INSERT INTO `thema_applicaties` VALUES(117, 14, 19, 0, 0, 0, 0, 0, 1);
INSERT INTO `thema_applicaties` VALUES(118, 23, 19, 0, 0, 0, 0, 0, 1);
INSERT INTO `thema_applicaties` VALUES(119, 26, 19, 0, 0, 0, 0, 0, 1);
INSERT INTO `thema_applicaties` VALUES(120, 39, 19, 0, 0, 0, 0, 0, 1);
INSERT INTO `thema_applicaties` VALUES(121, 37, 19, 0, 0, 0, 0, 0, 1);
INSERT INTO `thema_applicaties` VALUES(122, 44, 19, 0, 0, 0, 0, 0, 1);
INSERT INTO `thema_applicaties` VALUES(123, 7, 19, 0, 0, 0, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(124, 17, 19, 0, 0, 0, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(125, 3, 19, 0, 0, 0, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(126, 4, 19, 0, 0, 0, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(127, 6, 19, 0, 0, 0, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(129, 9, 19, 0, 0, 0, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(130, 11, 19, 0, 0, 0, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(131, 22, 19, 0, 0, 0, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(132, 21, 19, 0, 0, 0, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(133, 29, 19, 0, 0, 0, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(134, 30, 19, 0, 0, 0, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(135, 25, 19, 0, 0, 0, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(136, 24, 19, 0, 0, 0, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(137, 38, 19, 0, 0, 0, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(138, 41, 19, 0, 0, 0, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(139, 42, 19, 0, 0, 0, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(140, 32, 19, 0, 0, 0, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(141, 43, 19, 0, 0, 0, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(143, 59, 19, 0, 0, 0, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(144, 13, 20, 0, 0, 0, 0, 0, 1);
INSERT INTO `thema_applicaties` VALUES(145, 16, 20, 0, 0, 0, 0, 0, 1);
INSERT INTO `thema_applicaties` VALUES(146, 18, 20, 0, 0, 0, 0, 0, 1);
INSERT INTO `thema_applicaties` VALUES(147, 23, 20, 0, 0, 0, 0, 0, 1);
INSERT INTO `thema_applicaties` VALUES(148, 26, 20, 0, 0, 0, 0, 0, 1);
INSERT INTO `thema_applicaties` VALUES(149, 25, 20, 0, 0, 0, 0, 0, 1);
INSERT INTO `thema_applicaties` VALUES(150, 44, 20, 0, 0, 0, 0, 0, 1);
INSERT INTO `thema_applicaties` VALUES(151, 12, 20, 0, 0, 0, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(152, 7, 20, 0, 0, 0, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(153, 17, 20, 0, 0, 0, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(154, 14, 20, 0, 0, 0, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(156, 4, 20, 0, 0, 0, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(157, 6, 20, 0, 0, 0, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(158, 9, 20, 0, 0, 0, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(160, 11, 20, 0, 0, 0, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(161, 15, 20, 0, 0, 0, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(162, 22, 20, 0, 0, 0, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(163, 21, 20, 0, 0, 0, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(164, 29, 20, 0, 0, 0, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(165, 30, 20, 0, 0, 0, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(166, 24, 20, 0, 0, 0, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(167, 39, 20, 0, 0, 0, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(168, 37, 20, 0, 0, 0, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(169, 38, 20, 0, 0, 0, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(170, 40, 20, 0, 0, 0, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(171, 41, 20, 0, 0, 0, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(172, 42, 20, 0, 0, 0, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(173, 31, 20, 0, 0, 0, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(174, 32, 20, 0, 0, 0, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(175, 36, 20, 0, 0, 0, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(176, 33, 20, 0, 0, 0, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(177, 34, 20, 0, 0, 0, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(178, 35, 20, 0, 0, 0, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(179, 46, 20, 0, 0, 0, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(180, 47, 20, 0, 0, 0, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(181, 43, 20, 0, 0, 0, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(182, 45, 20, 0, 0, 0, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(183, 3, 20, 0, 0, 0, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(184, 59, 20, 0, 0, 0, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(185, 13, 21, 0, 0, 0, 0, 0, 1);
INSERT INTO `thema_applicaties` VALUES(186, 18, 21, 0, 0, 0, 0, 0, 1);
INSERT INTO `thema_applicaties` VALUES(187, 14, 21, 0, 0, 0, 0, 0, 1);
INSERT INTO `thema_applicaties` VALUES(188, 15, 21, 0, 0, 0, 0, 0, 1);
INSERT INTO `thema_applicaties` VALUES(189, 23, 21, 0, 0, 0, 0, 0, 1);
INSERT INTO `thema_applicaties` VALUES(190, 26, 21, 0, 0, 0, 0, 0, 1);
INSERT INTO `thema_applicaties` VALUES(191, 37, 21, 0, 0, 0, 0, 0, 1);
INSERT INTO `thema_applicaties` VALUES(192, 44, 21, 0, 0, 0, 0, 0, 1);
INSERT INTO `thema_applicaties` VALUES(193, 47, 21, 0, 0, 0, 0, 0, 1);
INSERT INTO `thema_applicaties` VALUES(194, 43, 21, 0, 0, 0, 0, 0, 1);
INSERT INTO `thema_applicaties` VALUES(195, 45, 21, 0, 0, 0, 0, 0, 1);
INSERT INTO `thema_applicaties` VALUES(196, 16, 21, 0, 0, 0, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(197, 12, 21, 0, 0, 0, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(198, 7, 21, 0, 0, 0, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(199, 17, 21, 0, 0, 0, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(201, 4, 21, 0, 0, 0, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(202, 6, 21, 0, 0, 0, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(203, 9, 21, 0, 0, 0, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(205, 11, 21, 0, 0, 0, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(206, 22, 21, 0, 0, 0, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(207, 29, 21, 0, 0, 0, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(208, 24, 21, 0, 0, 0, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(209, 39, 21, 0, 0, 0, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(210, 38, 21, 0, 0, 0, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(211, 40, 21, 0, 0, 0, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(212, 41, 21, 0, 0, 0, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(213, 31, 21, 0, 0, 0, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(214, 32, 21, 0, 0, 0, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(215, 35, 21, 0, 0, 0, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(216, 46, 21, 0, 0, 0, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(217, 3, 21, 0, 0, 0, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(218, 59, 21, 0, 0, 0, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(219, 13, 22, 0, 0, 0, 0, 0, 1);
INSERT INTO `thema_applicaties` VALUES(220, 16, 22, 0, 0, 0, 0, 0, 1);
INSERT INTO `thema_applicaties` VALUES(221, 18, 22, 0, 0, 0, 0, 0, 1);
INSERT INTO `thema_applicaties` VALUES(222, 23, 22, 0, 0, 0, 0, 0, 1);
INSERT INTO `thema_applicaties` VALUES(223, 44, 22, 0, 0, 0, 0, 0, 1);
INSERT INTO `thema_applicaties` VALUES(224, 12, 22, 0, 0, 0, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(225, 7, 22, 0, 0, 0, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(226, 17, 22, 0, 0, 0, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(227, 14, 22, 0, 0, 0, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(229, 4, 22, 0, 0, 0, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(230, 6, 22, 0, 0, 0, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(231, 9, 22, 0, 0, 0, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(233, 11, 22, 0, 0, 0, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(234, 15, 22, 0, 0, 0, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(235, 26, 22, 0, 0, 0, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(236, 22, 22, 0, 0, 0, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(237, 24, 22, 0, 0, 0, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(238, 37, 22, 0, 0, 0, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(239, 38, 22, 0, 0, 0, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(240, 40, 22, 0, 0, 0, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(241, 41, 22, 0, 0, 0, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(242, 32, 22, 0, 0, 0, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(243, 35, 22, 0, 0, 0, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(244, 46, 22, 0, 0, 0, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(245, 47, 22, 0, 0, 0, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(246, 43, 22, 0, 0, 0, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(247, 3, 22, 0, 0, 0, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(248, 59, 22, 0, 0, 0, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(249, 13, 23, 0, 0, 0, 0, 0, 1);
INSERT INTO `thema_applicaties` VALUES(250, 18, 23, 0, 0, 0, 0, 0, 1);
INSERT INTO `thema_applicaties` VALUES(251, 12, 23, 0, 0, 0, 0, 0, 1);
INSERT INTO `thema_applicaties` VALUES(252, 26, 23, 0, 0, 0, 0, 0, 1);
INSERT INTO `thema_applicaties` VALUES(253, 22, 23, 0, 0, 0, 0, 0, 1);
INSERT INTO `thema_applicaties` VALUES(254, 37, 23, 0, 0, 0, 0, 0, 1);
INSERT INTO `thema_applicaties` VALUES(255, 35, 23, 0, 0, 0, 0, 0, 1);
INSERT INTO `thema_applicaties` VALUES(256, 44, 23, 0, 0, 0, 0, 0, 1);
INSERT INTO `thema_applicaties` VALUES(257, 47, 23, 0, 0, 0, 0, 0, 1);
INSERT INTO `thema_applicaties` VALUES(258, 43, 23, 0, 0, 0, 0, 0, 1);
INSERT INTO `thema_applicaties` VALUES(259, 7, 23, 0, 0, 0, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(260, 3, 23, 0, 0, 0, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(261, 6, 23, 0, 0, 0, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(262, 23, 23, 0, 0, 0, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(263, 39, 23, 0, 0, 0, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(264, 32, 23, 0, 0, 0, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(265, 46, 23, 0, 0, 0, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(266, 1, 24, 0, 1, 1, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(267, 3, 24, 0, 1, 1, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(268, 4, 24, 0, 1, 1, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(269, 5, 24, 0, 1, 1, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(270, 6, 24, 0, 1, 1, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(271, 7, 24, 0, 1, 1, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(272, 8, 24, 0, 1, 1, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(273, 9, 24, 0, 1, 1, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(274, 11, 24, 0, 1, 1, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(275, 12, 24, 0, 1, 1, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(276, 13, 24, 0, 1, 1, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(277, 14, 24, 0, 1, 1, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(278, 15, 24, 0, 1, 1, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(279, 16, 24, 0, 1, 1, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(280, 17, 24, 0, 1, 1, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(281, 18, 24, 0, 1, 1, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(282, 21, 24, 0, 1, 1, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(283, 22, 24, 0, 1, 1, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(284, 23, 24, 0, 1, 1, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(285, 24, 24, 0, 1, 1, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(286, 25, 24, 0, 1, 1, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(287, 26, 24, 0, 1, 1, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(288, 27, 24, 0, 1, 1, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(289, 51, 24, 0, 1, 1, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(290, 52, 24, 0, 1, 1, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(291, 53, 24, 0, 1, 1, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(292, 54, 24, 0, 1, 1, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(293, 55, 24, 0, 1, 1, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(294, 56, 24, 0, 1, 1, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(295, 57, 24, 0, 1, 1, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(296, 29, 24, 0, 1, 1, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(297, 30, 24, 0, 1, 1, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(298, 31, 24, 0, 1, 1, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(299, 32, 24, 0, 1, 1, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(300, 33, 24, 0, 1, 1, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(301, 34, 24, 0, 1, 1, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(302, 35, 24, 0, 1, 1, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(303, 36, 24, 0, 1, 1, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(304, 37, 24, 0, 1, 1, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(305, 38, 24, 0, 1, 1, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(306, 39, 24, 0, 1, 1, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(307, 40, 24, 0, 1, 1, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(308, 41, 24, 0, 1, 1, 0, 0, 0);
INSERT INTO `thema_applicaties` VALUES(309, 42, 24, 0, 1, 1, 0, 0, 0);
UNLOCK TABLES;

#
# Dumping data for table 'thema_functies'
#

LOCK TABLES `thema_functies` WRITE;
INSERT INTO `thema_functies` VALUES(3, "", "", 1, 25, "");
INSERT INTO `thema_functies` VALUES(4, "", "", 3, 25, "");
INSERT INTO `thema_functies` VALUES(5, "", "", 4, 25, "");
INSERT INTO `thema_functies` VALUES(6, "", "", 5, 25, "");
INSERT INTO `thema_functies` VALUES(7, "", "", 6, 25, "");
INSERT INTO `thema_functies` VALUES(8, "", "", 7, 25, "");
INSERT INTO `thema_functies` VALUES(9, "", "", 8, 25, "");
INSERT INTO `thema_functies` VALUES(10, "", "", 9, 25, "");
INSERT INTO `thema_functies` VALUES(11, "", "", 11, 25, "");
INSERT INTO `thema_functies` VALUES(12, "", "", 12, 25, "");
INSERT INTO `thema_functies` VALUES(13, "", "", 13, 25, "");
INSERT INTO `thema_functies` VALUES(14, "", "", 14, 25, "");
INSERT INTO `thema_functies` VALUES(15, "", "", 15, 25, "");
INSERT INTO `thema_functies` VALUES(16, "", "", 16, 25, "");
INSERT INTO `thema_functies` VALUES(17, "", "", 17, 25, "");
INSERT INTO `thema_functies` VALUES(18, "", "", 18, 25, "");
INSERT INTO `thema_functies` VALUES(19, "", "", 21, 25, "");
INSERT INTO `thema_functies` VALUES(20, "", "", 22, 25, "");
INSERT INTO `thema_functies` VALUES(21, "", "", 23, 25, "");
INSERT INTO `thema_functies` VALUES(22, "", "", 24, 25, "");
INSERT INTO `thema_functies` VALUES(23, "", "", 25, 25, "");
INSERT INTO `thema_functies` VALUES(24, "", "", 26, 25, "");
INSERT INTO `thema_functies` VALUES(25, "", "", 27, 25, "");
INSERT INTO `thema_functies` VALUES(26, "", "", 29, 25, "");
INSERT INTO `thema_functies` VALUES(27, "", "", 30, 25, "");
INSERT INTO `thema_functies` VALUES(28, "", "", 31, 25, "");
INSERT INTO `thema_functies` VALUES(29, "", "", 32, 25, "");
INSERT INTO `thema_functies` VALUES(30, "", "", 33, 25, "");
INSERT INTO `thema_functies` VALUES(31, "", "", 34, 25, "");
INSERT INTO `thema_functies` VALUES(32, "", "", 35, 25, "");
INSERT INTO `thema_functies` VALUES(33, "", "", 36, 25, "");
INSERT INTO `thema_functies` VALUES(34, "", "", 37, 25, "");
INSERT INTO `thema_functies` VALUES(35, "", "", 38, 25, "");
INSERT INTO `thema_functies` VALUES(36, "", "", 39, 25, "");
INSERT INTO `thema_functies` VALUES(37, "", "", 40, 25, "");
INSERT INTO `thema_functies` VALUES(38, "", "", 41, 25, "");
INSERT INTO `thema_functies` VALUES(39, "", "", 42, 25, "");
INSERT INTO `thema_functies` VALUES(40, "", "", 51, 25, "");
INSERT INTO `thema_functies` VALUES(41, "", "", 52, 25, "");
INSERT INTO `thema_functies` VALUES(42, "", "", 53, 25, "");
INSERT INTO `thema_functies` VALUES(43, "", "", 54, 25, "");
INSERT INTO `thema_functies` VALUES(44, "", "", 55, 25, "");
INSERT INTO `thema_functies` VALUES(45, "", "", 56, 25, "");
INSERT INTO `thema_functies` VALUES(46, "", "", 57, 25, "");
UNLOCK TABLES;

#
# Dumping data for table 'thema_items_admin'
#

LOCK TABLES `thema_items_admin` WRITE;
INSERT INTO `thema_items_admin` VALUES(2, 'Wegnr', "", "", 1, 1, "", 0, NULL, NULL, 1);
INSERT INTO `thema_items_admin` VALUES(3, 'ViaView label', "", "", 1, 1, "", 0, NULL, NULL, 1);
INSERT INTO `thema_items_admin` VALUES(4, 'Hectometrering', "", "", 1, 1, "", 0, NULL, NULL, 1);
INSERT INTO `thema_items_admin` VALUES(5, 'Baantype', "", "", 1, 1, 'asfalt, verhard', 0, NULL, NULL, 1);
INSERT INTO `thema_items_admin` VALUES(6, 'Strooktype', "", "", 1, 1, 'asfalt, beton', 0, NULL, NULL, 1);
INSERT INTO `thema_items_admin` VALUES(7, 'Documentlocatie', "", "", 14, 1, "", 0, NULL, NULL, 1);
INSERT INTO `thema_items_admin` VALUES(8, 'Overige regelingen', "", "", 14, 1, 'Fiets/Auto-regeling, Stoplichten', 0, NULL, NULL, 1);
INSERT INTO `thema_items_admin` VALUES(9, 'Verkeersbesluiten', "", "", 14, 1, 'Besluiten worden genomen bij vergadering 22-12-2006', 0, NULL, NULL, 1);
INSERT INTO `thema_items_admin` VALUES(10, 'Vergunningen', "", "", 14, 1, 'Bouwvergunning afgegeven, 05-09-2006', 0, NULL, NULL, 1);
INSERT INTO `thema_items_admin` VALUES(11, 'Vergunning', 'Ja/Nee', "", 7, 1, "", 0, NULL, NULL, 1);
INSERT INTO `thema_items_admin` VALUES(12, 'Contractperiode', "", "", 7, 1, 'Verlopen op 15-09-2006', 0, NULL, NULL, 1);
INSERT INTO `thema_items_admin` VALUES(13, 'Tekeninglocatie', "", "", 14, 1, "", 0, NULL, NULL, 1);
INSERT INTO `thema_items_admin` VALUES(14, 'Materiaal', "", "", 13, 1, 'asfalt', 0, NULL, NULL, 1);
INSERT INTO `thema_items_admin` VALUES(15, 'Leeftijd', 'jaar', "", 13, 1, '2,5 jaar', 0, NULL, NULL, 1);
INSERT INTO `thema_items_admin` VALUES(16, 'Spoorvorming', "", "", 13, 1, 'Lichte spoorvorming', 0, NULL, NULL, 1);
INSERT INTO `thema_items_admin` VALUES(17, 'Stroefheidsmeting', "", "", 13, 1, 'Uitgevoerd: 23-05-2006. Resultaat: Goed', 0, NULL, NULL, 1);
INSERT INTO `thema_items_admin` VALUES(18, 'Opbouw/doorsnede', "", "", 13, 1, 'Beton op zand/kleilaag', 0, NULL, NULL, 1);
INSERT INTO `thema_items_admin` VALUES(19, 'Aran', "", "", 49, 1, "", 0, NULL, NULL, 1);
INSERT INTO `thema_items_admin` VALUES(20, 'Rambol', "", "", 49, 1, "", 0, NULL, NULL, 1);
INSERT INTO `thema_items_admin` VALUES(21, 'Deflectie', "", "", 49, 1, "", 0, NULL, NULL, 1);
INSERT INTO `thema_items_admin` VALUES(22, 'Inspectie', "", "", 49, 1, 'Laatste: 12-09-2006', 0, NULL, NULL, 1);
INSERT INTO `thema_items_admin` VALUES(23, 'Planning', "", "", 12, 1, 'Gepland voor 15-01-2007, Niet op de planning', 0, NULL, NULL, 1);
INSERT INTO `thema_items_admin` VALUES(24, 'Soort', "", "", 12, 1, 'Wegmarkering, Parkeerplaats', 0, NULL, NULL, 1);
INSERT INTO `thema_items_admin` VALUES(25, 'Maatvoering', "", "", 12, 1, "", 0, NULL, NULL, 1);
INSERT INTO `thema_items_admin` VALUES(26, 'Lengte', 'km', "", 12, 1, "", 0, NULL, NULL, 1);
INSERT INTO `thema_items_admin` VALUES(27, 'Materiaalsoort', "", "", 12, 1, 'Verf, Nog niet vastgesteld', 0, NULL, NULL, 1);
INSERT INTO `thema_items_admin` VALUES(28, 'Type', "", "", 26, 1, 'Verkeersbord, MAX 80km/u, Wegwijzering', 0, NULL, NULL, 1);
INSERT INTO `thema_items_admin` VALUES(29, 'Weglengte van geldigheid', 'km', "", 26, 1, "", 0, NULL, NULL, 1);
INSERT INTO `thema_items_admin` VALUES(30, 'Afmeting', 'cm2', "", 26, 1, "", 0, NULL, NULL, 1);
INSERT INTO `thema_items_admin` VALUES(31, 'Nummer', "", "", 26, 1, "", 0, NULL, NULL, 1);
INSERT INTO `thema_items_admin` VALUES(32, 'Eigenaar', "", "", 26, 1, 'Anders, Provincie, ANWB', 0, NULL, NULL, 1);
INSERT INTO `thema_items_admin` VALUES(33, 'Oppervlak', 'm2', "", 6, 1, "", 0, NULL, NULL, 1);
INSERT INTO `thema_items_admin` VALUES(34, 'Gemeente', "", "", 6, 1, 'Den Bosch', 0, NULL, NULL, 1);
INSERT INTO `thema_items_admin` VALUES(35, 'Type', "", "", 6, 1, 'Nat, droog, zaksloot', 0, NULL, NULL, 1);
INSERT INTO `thema_items_admin` VALUES(36, 'Orientatie tov wegas', "", "", 6, 1, 'links, rechts', 0, NULL, NULL, 1);
INSERT INTO `thema_items_admin` VALUES(37, 'Opmerkingen', "", "", 6, 1, 'Moet worden gebaggerd, Drooggevallen sloot, heeft controle nodig', 0, NULL, NULL, 1);
INSERT INTO `thema_items_admin` VALUES(38, 'Oppervlak', 'm2', "", 5, 1, "", 0, NULL, NULL, 1);
INSERT INTO `thema_items_admin` VALUES(39, 'Hoogte tov weg', 'cm', "", 5, 1, "", 0, NULL, NULL, 1);
INSERT INTO `thema_items_admin` VALUES(40, 'Type', "", "", 5, 1, 'Middenberm, buitenberm', 0, NULL, NULL, 1);
INSERT INTO `thema_items_admin` VALUES(41, 'Begroeiing', "", "", 5, 1, 'Semiverhard, gras', 0, NULL, NULL, 1);
INSERT INTO `thema_items_admin` VALUES(42, 'Rand', "", "", 5, 1, 'hard, zacht', 0, NULL, NULL, 1);
INSERT INTO `thema_items_admin` VALUES(43, 'Bomen', 'aantal', "", 18, 1, "", 0, NULL, NULL, 1);
INSERT INTO `thema_items_admin` VALUES(44, 'Groentype', "", "", 18, 1, 'grasveld, houtwal', 0, NULL, NULL, 1);
INSERT INTO `thema_items_admin` VALUES(45, 'Type onderzoek', "", "", 27, 1, 'kruispunttelling', 0, NULL, NULL, 1);
INSERT INTO `thema_items_admin` VALUES(46, 'Naam locatie', "", "", 27, 1, 'N384', 0, NULL, NULL, 1);
INSERT INTO `thema_items_admin` VALUES(47, 'Naam meting', "", "", 27, 1, "", 0, NULL, NULL, 1);
INSERT INTO `thema_items_admin` VALUES(48, 'Details', "", "", 27, 1, 'Voor details zie rapport 15-11-2006', 0, NULL, NULL, 1);
INSERT INTO `thema_items_admin` VALUES(49, 'Wegnr', "", "", 25, 1, "", 0, NULL, NULL, 1);
INSERT INTO `thema_items_admin` VALUES(50, 'Tijdstip', "", "", 25, 1, '15:06, 22-11-2006', 0, NULL, NULL, 1);
INSERT INTO `thema_items_admin` VALUES(51, 'Type ongeval', "", "", 25, 1, 'Aanrijding tussen 2 auto\'s, Aanrijding fiets-auto', 0, NULL, NULL, 1);
INSERT INTO `thema_items_admin` VALUES(52, 'Type manoeuvre', "", "", 25, 1, 'Inhalen (auto) van fietser', 0, NULL, NULL, 1);
UNLOCK TABLES;

#
# Dumping data for table 'thema_items_spatial'
#

LOCK TABLES `thema_items_spatial` WRITE;
INSERT INTO `thema_items_spatial` VALUES( 1, "", "",  1, 0, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `thema_items_spatial` VALUES( 2, "", "", 14, 0, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `thema_items_spatial` VALUES( 3, "", "",  7, 0, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `thema_items_spatial` VALUES( 4, "", "",  3, 0, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `thema_items_spatial` VALUES( 5, "", "",  4, 0, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `thema_items_spatial` VALUES( 6, "", "",  5, 0, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `thema_items_spatial` VALUES( 7, "", "",  6, 0, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `thema_items_spatial` VALUES( 8, "", "",  8, 0, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `thema_items_spatial` VALUES( 9, "", "",  9, 0, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `thema_items_spatial` VALUES(10, "", "", 11, 0, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `thema_items_spatial` VALUES(11, "", "", 12, 0, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `thema_items_spatial` VALUES(12, "", "", 13, 0, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `thema_items_spatial` VALUES(13, "", "", 15, 0, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `thema_items_spatial` VALUES(14, "", "", 16, 0, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `thema_items_spatial` VALUES(15, "", "", 17, 0, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `thema_items_spatial` VALUES(16, "", "", 18, 0, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `thema_items_spatial` VALUES(18, "", "", 21, 0, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `thema_items_spatial` VALUES(19, "", "", 22, 0, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `thema_items_spatial` VALUES(20, "", "", 23, 0, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `thema_items_spatial` VALUES(21, "", "", 24, 0, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `thema_items_spatial` VALUES(22, "", "", 25, 0, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `thema_items_spatial` VALUES(23, "", "", 26, 0, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `thema_items_spatial` VALUES(24, "", "", 27, 0, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `thema_items_spatial` VALUES(26, "", "", 29, 0, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `thema_items_spatial` VALUES(27, "", "", 30, 0, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `thema_items_spatial` VALUES(28, "", "", 51, 0, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `thema_items_spatial` VALUES(29, "", "", 52, 0, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `thema_items_spatial` VALUES(30, "", "", 53, 0, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `thema_items_spatial` VALUES(31, "", "", 54, 0, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `thema_items_spatial` VALUES(32, "", "", 55, 0, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `thema_items_spatial` VALUES(33, "", "", 56, 0, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `thema_items_spatial` VALUES(34, "", "", 57, 0, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `thema_items_spatial` VALUES(35, "", "", 58, 0, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `thema_items_spatial` VALUES(36, "", "", 59, 0, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `thema_items_spatial` VALUES(37, "", "", 60, 0, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `thema_items_spatial` VALUES(40, "", "", 31, 0, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `thema_items_spatial` VALUES(41, "", "", 32, 0, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `thema_items_spatial` VALUES(42, "", "", 33, 0, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `thema_items_spatial` VALUES(43, "", "", 34, 0, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `thema_items_spatial` VALUES(44, "", "", 35, 0, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `thema_items_spatial` VALUES(45, "", "", 36, 0, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `thema_items_spatial` VALUES(46, "", "", 37, 0, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `thema_items_spatial` VALUES(47, "", "", 38, 0, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `thema_items_spatial` VALUES(48, "", "", 39, 0, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `thema_items_spatial` VALUES(49, "", "", 40, 0, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `thema_items_spatial` VALUES(50, "", "", 41, 0, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO `thema_items_spatial` VALUES(51, "", "", 42, 0, NULL, NULL, NULL, NULL, NULL, NULL);
UNLOCK TABLES;

#
# Dumping data for table 'themas'
#

LOCK TABLES `themas` WRITE;
INSERT INTO `themas` VALUES(1, '1', 'Weg Inclusief functie', 1, 1010, 1, "", 0, 0);
INSERT INTO `themas` VALUES(3, '1', 'Junctie; kruispunt', 1, 1020, 1, "", 0, 0);
INSERT INTO `themas` VALUES(4, '1', 'Baan (10.000), Strook (70.000)', 1, 1030, 1, "", 0, 0);
INSERT INTO `themas` VALUES(5, '1', 'Berm', 1, 1040, 3, "", 0, 0);
INSERT INTO `themas` VALUES(6, '1', 'Sloot', 1, 1050, 3, "", 0, 0);
INSERT INTO `themas` VALUES(7, '1', 'Uitrit', 1, 1060, 1, "", 0, 0);
INSERT INTO `themas` VALUES(8, '1', 'Fiets/Voetpad (scheiden)', 1, 1070, 1, "", 0, 0);
INSERT INTO `themas` VALUES(9, '1', 'Weg Oriëntatie Lijn / HM Bord/objecten', 1, 1080, 1, "", 0, 0);
INSERT INTO `themas` VALUES(11, '1', 'Cyclorama', 1, 1090, 1, "", 0, 0);
INSERT INTO `themas` VALUES(12, '1', 'Markering', 1, 1100, 2, "", 0, 0);
INSERT INTO `themas` VALUES(13, '1', 'Verharding', 1, 1110, 2, "", 0, 0);
INSERT INTO `themas` VALUES(14, '1', 'Regeling Beheer Onderhoud', 1, 1120, 1, 'autocad is bron maar komt deze in viewer? Of alleen x,y of vlak voor locatie?', 0, 0);
INSERT INTO `themas` VALUES(15, '1', 'Eigendom/Perceel', 1, 1130, 1, "", 0, 0);
INSERT INTO `themas` VALUES(16, '1', 'Kunstwerk', 1, 1140, 8, 'nog in gebruik?', 0, 0);
INSERT INTO `themas` VALUES(17, '1', 'Pomp Installatie', 1, 1150, 8, '8 stuks,1x maand visuele inspectie', 0, 0);
INSERT INTO `themas` VALUES(18, '1', 'Groen, Bomen, enz./Begroeing', 1, 1160, 3, "", 0, 0);
INSERT INTO `themas` VALUES(19, '1', 'Ontsnipperingsmaatregelen', 5, 9010, 13, 'geen thema, doel om oppervlakte te verkleinen', 0, 0);
INSERT INTO `themas` VALUES(21, '1', 'DVM Object (Dynamisch Verk Management)', 2, 2010, 6, 'tellussen beheerd door Henk vd Broek', 0, 0);
INSERT INTO `themas` VALUES(22, '1', 'VRI Installatie', 2, 2020, 6, "", 0, 0);
INSERT INTO `themas` VALUES(23, '1', 'Verlichting', 2, 2030, 2, 'Excel Provhuis->Access->CDROM->Regios', 0, 0);
INSERT INTO `themas` VALUES(24, '1', 'Bushalten', 2, 2040, 2, "", 0, 0);
INSERT INTO `themas` VALUES(25, '1', 'Ongevallen', 2, 2050, 2, 'black spots evt als onderdeel hiervan', 0, 0);
INSERT INTO `themas` VALUES(26, '1', 'Verkeersbord/bebording', 2, 2060, 2, "", 0, 0);
INSERT INTO `themas` VALUES(27, '1', 'Telling telpunt', 2, 2070, 2, "", 0, 0);
INSERT INTO `themas` VALUES(28, '1', 'Gebieden', 5, 9080, 13, 'opgesplitst in specifieke gebieden', 0, 0);
INSERT INTO `themas` VALUES(29, '1', 'Geluid/Stilte/Zones', 2, 2090, 5, "", 0, 0);
INSERT INTO `themas` VALUES(30, '1', 'Transportschema (RDW)', 2, 2100, 2, '1 persoon inlog', 0, 0);
INSERT INTO `themas` VALUES(31, '1', 'Tankstation', 3, 3010, 2, "", 0, 0);
INSERT INTO `themas` VALUES(32, '1', 'Bebouwde Kom WW WVW', 3, 3020, 4, "", 0, 0);
INSERT INTO `themas` VALUES(33, '1', 'Claims privaat + publiek', 3, 3030, 4, "", 0, 0);
INSERT INTO `themas` VALUES(34, '1', 'Contracten', 3, 3040, 4, "", 0, 0);
INSERT INTO `themas` VALUES(35, '1', 'Besluit Verkeer WVW 45', 3, 3050, 4, "", 0, 0);
INSERT INTO `themas` VALUES(36, '1', 'Vergunning Ontheffing', 3, 3060, 4, "", 0, 0);
INSERT INTO `themas` VALUES(37, '1', 'Wegwijzer/Mast/Vlag', 3, 3070, 2, "", 0, 0);
INSERT INTO `themas` VALUES(38, '1', 'Parallelweg (eigen)Geluidswering', 3, 3080, 13, "", 0, 0);
INSERT INTO `themas` VALUES(39, '1', 'Geleiderail', 3, 3090, 1, "", 0, 0);
INSERT INTO `themas` VALUES(40, '1', 'Spoorwegovergang', 3, 3100, 1, "", 0, 0);
INSERT INTO `themas` VALUES(41, '1', 'Wegdeel', 3, 3110, 1, "", 0, 0);
INSERT INTO `themas` VALUES(42, '1', 'Route Gladheidsbestrijding', 3, 3120, 2, "", 0, 0);
INSERT INTO `themas` VALUES(43, '1', 'Wegmeubilair overig', 4, 4010, 2, "", 0, 0);
INSERT INTO `themas` VALUES(44, '1', 'Riolering eigen& vergund', 4, 4020, 13, "", 0, 0);
INSERT INTO `themas` VALUES(45, '1', 'Belemmeringen jur WKPD)', 4, 4030, 13, "", 0, 0);
INSERT INTO `themas` VALUES(46, '1', 'Kabels & Leidingen eigen', 4, 4040, 13, "", 0, 0);
INSERT INTO `themas` VALUES(47, '1', 'Lopende & geplande projecten', 4, 4050, 13, "", 0, 0);
INSERT INTO `themas` VALUES(48, '2', 'Extern', 5, 9020, 13, 'Niet helemaal duidelijk, externe bronnen', 0, 0);
INSERT INTO `themas` VALUES(49, '2', 'Metingen Verharding (Rambol ed)', 5, 9030, 2, "", 0, 0);
INSERT INTO `themas` VALUES(50, '2', 'Doorsnede', 5, 9040, 3, 'functie niet meer duidelijk: eruit', 0, 0);
INSERT INTO `themas` VALUES(51, '2', 'Beheersgrens', 2, 2081, 5, "", 0, 0);
INSERT INTO `themas` VALUES(52, '2', 'Gemeentegrens', 2, 2082, 5, "", 0, 0);
INSERT INTO `themas` VALUES(53, '2', 'Bebouwde kom', 2, 2083, 5, "", 0, 0);
INSERT INTO `themas` VALUES(54, '2', 'GGA-gebieden', 2, 2084, 5, "", 0, 0);
INSERT INTO `themas` VALUES(55, '2', 'Waterschap', 2, 2085, 5, "", 0, 0);
INSERT INTO `themas` VALUES(56, '2', 'Ecologische gebieden', 2, 2086, 5, "", 0, 0);
INSERT INTO `themas` VALUES(57, '2', 'Bestemmingsplan', 2, 2087, 5, "", 0, 0);
INSERT INTO `themas` VALUES(58, '2', 'Onderhoudsvak Groen', 5, 9050, 3, "", 0, 0);
INSERT INTO `themas` VALUES(59, '2', 'Onderhoudsvak Verkeer', 5, 9060, 2, "", 0, 0);
INSERT INTO `themas` VALUES(60, '2', 'Black spots ongevallen', 5, 9070, 2, "", 0, 0);
UNLOCK TABLES;


#
# Dumping data for table 'thema_verantwoordelijkheden'
#

LOCK TABLES `thema_verantwoordelijkheden` WRITE;
INSERT INTO `thema_verantwoordelijkheden` VALUES(9, 3, NULL, 18, 2, 1, 0);
INSERT INTO `thema_verantwoordelijkheden` VALUES(10, 9, NULL, 18, 2, 1, 0);
INSERT INTO `thema_verantwoordelijkheden` VALUES(11, 24, NULL, 18, 2, 1, 0);
INSERT INTO `thema_verantwoordelijkheden` VALUES(12, 28, NULL, 18, 2, 1, 0);
INSERT INTO `thema_verantwoordelijkheden` VALUES(13, 29, NULL, 18, 2, 1, 0);
INSERT INTO `thema_verantwoordelijkheden` VALUES(14, 37, NULL, 18, 2, 1, 0);
INSERT INTO `thema_verantwoordelijkheden` VALUES(15, 39, NULL, 18, 2, 1, 0);
INSERT INTO `thema_verantwoordelijkheden` VALUES(16, 40, NULL, 18, 2, 1, 0);
INSERT INTO `thema_verantwoordelijkheden` VALUES(17, 22, NULL, 12, 2, 1, 0);
INSERT INTO `thema_verantwoordelijkheden` VALUES(18, 32, NULL, 12, 2, 1, 0);
INSERT INTO `thema_verantwoordelijkheden` VALUES(19, 42, NULL, 12, 2, 1, 0);
INSERT INTO `thema_verantwoordelijkheden` VALUES(20, 58, NULL, 16, 2, 1, 0);
INSERT INTO `thema_verantwoordelijkheden` VALUES(21, 5, NULL, 16, 2, 1, 0);
INSERT INTO `thema_verantwoordelijkheden` VALUES(22, 6, NULL, 16, 2, 1, 0);
INSERT INTO `thema_verantwoordelijkheden` VALUES(23, 18, NULL, 16, 2, 1, 0);
INSERT INTO `thema_verantwoordelijkheden` VALUES(26, 22, NULL, 13, 2, 1, 0);
INSERT INTO `thema_verantwoordelijkheden` VALUES(27, 32, NULL, 13, 2, 1, 0);
INSERT INTO `thema_verantwoordelijkheden` VALUES(28, 42, NULL, 13, 2, 1, 0);
INSERT INTO `thema_verantwoordelijkheden` VALUES(29, 22, NULL, 14, 2, 1, 0);
INSERT INTO `thema_verantwoordelijkheden` VALUES(30, 32, NULL, 14, 2, 1, 0);
INSERT INTO `thema_verantwoordelijkheden` VALUES(31, 42, NULL, 14, 2, 1, 0);
INSERT INTO `thema_verantwoordelijkheden` VALUES(51, 14, 41, NULL, 2, 1, 0);
INSERT INTO `thema_verantwoordelijkheden` VALUES(52, 60, 8, NULL, 2, 1, 0);
INSERT INTO `thema_verantwoordelijkheden` VALUES(53, 25, 8, NULL, 2, 1, 0);
INSERT INTO `thema_verantwoordelijkheden` VALUES(54, 59, 28, NULL, 2, 1, 0);
INSERT INTO `thema_verantwoordelijkheden` VALUES(55, 1, 28, NULL, 2, 1, 0);
INSERT INTO `thema_verantwoordelijkheden` VALUES(56, 4, 28, NULL, 2, 1, 0);
INSERT INTO `thema_verantwoordelijkheden` VALUES(57, 8, 28, NULL, 2, 1, 0);
INSERT INTO `thema_verantwoordelijkheden` VALUES(58, 13, 28, NULL, 2, 1, 0);
INSERT INTO `thema_verantwoordelijkheden` VALUES(59, 38, 28, NULL, 2, 1, 0);
INSERT INTO `thema_verantwoordelijkheden` VALUES(60, 49, 28, NULL, 2, 1, 0);
INSERT INTO `thema_verantwoordelijkheden` VALUES(61, 27, 9, NULL, 2, 1, 0);
INSERT INTO `thema_verantwoordelijkheden` VALUES(62, 41, 9, NULL, 2, 1, 0);
INSERT INTO `thema_verantwoordelijkheden` VALUES(63, 15, 53, NULL, 2, 1, 0);
INSERT INTO `thema_verantwoordelijkheden` VALUES(64, 16, 35, NULL, 2, 1, 0);
INSERT INTO `thema_verantwoordelijkheden` VALUES(65, 33, 55, NULL, 2, 1, 0);
INSERT INTO `thema_verantwoordelijkheden` VALUES(66, 34, 55, NULL, 2, 1, 0);
INSERT INTO `thema_verantwoordelijkheden` VALUES(67, 35, 55, NULL, 2, 1, 0);
INSERT INTO `thema_verantwoordelijkheden` VALUES(68, 36, 55, NULL, 2, 1, 0);
INSERT INTO `thema_verantwoordelijkheden` VALUES(69, 31, 36, NULL, 2, 1, 0);
INSERT INTO `thema_verantwoordelijkheden` VALUES(70, 1, NULL, 20, 1, 0, 1);
INSERT INTO `thema_verantwoordelijkheden` VALUES(71, 4, NULL, 20, 1, 0, 1);
INSERT INTO `thema_verantwoordelijkheden` VALUES(72, 5, NULL, 20, 1, 0, 1);
INSERT INTO `thema_verantwoordelijkheden` VALUES(73, 6, NULL, 20, 1, 0, 1);
INSERT INTO `thema_verantwoordelijkheden` VALUES(74, 7, NULL, 20, 1, 0, 1);
INSERT INTO `thema_verantwoordelijkheden` VALUES(75, 8, NULL, 20, 1, 0, 1);
INSERT INTO `thema_verantwoordelijkheden` VALUES(76, 9, NULL, 20, 1, 0, 1);
INSERT INTO `thema_verantwoordelijkheden` VALUES(77, 11, NULL, 21, 1, 0, 1);
INSERT INTO `thema_verantwoordelijkheden` VALUES(78, 11, NULL, 20, 1, 0, 1);
INSERT INTO `thema_verantwoordelijkheden` VALUES(79, 12, NULL, 21, 1, 0, 1);
INSERT INTO `thema_verantwoordelijkheden` VALUES(80, 12, NULL, 20, 1, 0, 1);
INSERT INTO `thema_verantwoordelijkheden` VALUES(81, 13, NULL, 20, 1, 0, 1);
INSERT INTO `thema_verantwoordelijkheden` VALUES(82, 14, NULL, 7, 1, 0, 1);
INSERT INTO `thema_verantwoordelijkheden` VALUES(83, 14, NULL, 20, 1, 0, 1);
INSERT INTO `thema_verantwoordelijkheden` VALUES(84, 15, NULL, 21, 1, 0, 1);
INSERT INTO `thema_verantwoordelijkheden` VALUES(85, 16, NULL, 20, 1, 0, 1);
INSERT INTO `thema_verantwoordelijkheden` VALUES(86, 17, NULL, 20, 1, 0, 1);
INSERT INTO `thema_verantwoordelijkheden` VALUES(87, 18, NULL, 20, 1, 0, 1);
INSERT INTO `thema_verantwoordelijkheden` VALUES(88, 21, NULL, 20, 1, 0, 1);
INSERT INTO `thema_verantwoordelijkheden` VALUES(89, 22, NULL, 20, 1, 0, 1);
INSERT INTO `thema_verantwoordelijkheden` VALUES(90, 23, NULL, 20, 1, 0, 1);
INSERT INTO `thema_verantwoordelijkheden` VALUES(91, 25, NULL, 20, 1, 0, 1);
INSERT INTO `thema_verantwoordelijkheden` VALUES(92, 26, NULL, 20, 1, 0, 1);
INSERT INTO `thema_verantwoordelijkheden` VALUES(93, 27, NULL, 20, 1, 0, 1);
INSERT INTO `thema_verantwoordelijkheden` VALUES(94, 29, NULL, 7, 1, 0, 1);
INSERT INTO `thema_verantwoordelijkheden` VALUES(95, 30, NULL, 20, 1, 0, 1);
INSERT INTO `thema_verantwoordelijkheden` VALUES(96, 1, 40, 16, 2, 0, 1);
INSERT INTO `thema_verantwoordelijkheden` VALUES(97, 4, NULL, 20, 2, 0, 1);
INSERT INTO `thema_verantwoordelijkheden` VALUES(98, 5, NULL, 20, 2, 0, 1);
INSERT INTO `thema_verantwoordelijkheden` VALUES(99, 6, NULL, 20, 2, 0, 1);
INSERT INTO `thema_verantwoordelijkheden` VALUES(100, 7, NULL, 20, 2, 0, 1);
INSERT INTO `thema_verantwoordelijkheden` VALUES(101, 8, NULL, 20, 2, 0, 1);
INSERT INTO `thema_verantwoordelijkheden` VALUES(102, 9, NULL, 18, 2, 0, 1);
INSERT INTO `thema_verantwoordelijkheden` VALUES(103, 11, NULL, 18, 2, 0, 1);
INSERT INTO `thema_verantwoordelijkheden` VALUES(104, 12, NULL, 20, 2, 0, 1);
INSERT INTO `thema_verantwoordelijkheden` VALUES(105, 13, NULL, 9, 2, 0, 1);
INSERT INTO `thema_verantwoordelijkheden` VALUES(106, 14, 40, 16, 2, 0, 1);
INSERT INTO `thema_verantwoordelijkheden` VALUES(107, 16, 37, 9, 2, 0, 1);
INSERT INTO `thema_verantwoordelijkheden` VALUES(108, 17, NULL, 9, 2, 0, 1);
INSERT INTO `thema_verantwoordelijkheden` VALUES(109, 18, NULL, 20, 2, 0, 1);
INSERT INTO `thema_verantwoordelijkheden` VALUES(110, 21, NULL, 16, 2, 0, 1);
INSERT INTO `thema_verantwoordelijkheden` VALUES(111, 22, NULL, 16, 2, 0, 1);
INSERT INTO `thema_verantwoordelijkheden` VALUES(112, 23, NULL, 20, 2, 0, 1);
INSERT INTO `thema_verantwoordelijkheden` VALUES(113, 25, NULL, 16, 2, 0, 1);
INSERT INTO `thema_verantwoordelijkheden` VALUES(114, 26, NULL, 20, 2, 0, 1);
INSERT INTO `thema_verantwoordelijkheden` VALUES(115, 27, NULL, 16, 2, 0, 1);
INSERT INTO `thema_verantwoordelijkheden` VALUES(116, 29, NULL, 22, 2, 0, 1);
INSERT INTO `thema_verantwoordelijkheden` VALUES(117, 30, NULL, 16, 2, 0, 1);
INSERT INTO `thema_verantwoordelijkheden` VALUES(118, 1, 40, 16, 3, 0, 1);
INSERT INTO `thema_verantwoordelijkheden` VALUES(119, 4, NULL, 9, 3, 0, 1);
INSERT INTO `thema_verantwoordelijkheden` VALUES(120, 5, NULL, 16, 3, 0, 1);
INSERT INTO `thema_verantwoordelijkheden` VALUES(121, 6, NULL, 16, 3, 0, 1);
INSERT INTO `thema_verantwoordelijkheden` VALUES(122, 7, NULL, 9, 3, 0, 1);
INSERT INTO `thema_verantwoordelijkheden` VALUES(123, 8, NULL, 9, 3, 0, 1);
INSERT INTO `thema_verantwoordelijkheden` VALUES(124, 9, NULL, 18, 3, 0, 1);
INSERT INTO `thema_verantwoordelijkheden` VALUES(125, 11, 28, 18, 3, 0, 1);
INSERT INTO `thema_verantwoordelijkheden` VALUES(126, 12, NULL, 20, 3, 0, 1);
INSERT INTO `thema_verantwoordelijkheden` VALUES(127, 13, NULL, 9, 3, 0, 1);
INSERT INTO `thema_verantwoordelijkheden` VALUES(128, 14, NULL, 16, 3, 0, 1);
INSERT INTO `thema_verantwoordelijkheden` VALUES(129, 16, 35, 9, 3, 0, 1);
INSERT INTO `thema_verantwoordelijkheden` VALUES(130, 17, NULL, 21, 3, 0, 1);
INSERT INTO `thema_verantwoordelijkheden` VALUES(131, 18, NULL, 16, 3, 0, 1);
INSERT INTO `thema_verantwoordelijkheden` VALUES(132, 21, 33, 18, 3, 0, 1);
INSERT INTO `thema_verantwoordelijkheden` VALUES(133, 22, 33, 18, 3, 0, 1);
INSERT INTO `thema_verantwoordelijkheden` VALUES(134, 23, NULL, 7, 3, 0, 1);
INSERT INTO `thema_verantwoordelijkheden` VALUES(135, 25, NULL, 16, 3, 0, 1);
INSERT INTO `thema_verantwoordelijkheden` VALUES(136, 27, NULL, 16, 3, 0, 1);
INSERT INTO `thema_verantwoordelijkheden` VALUES(137, 29, NULL, 22, 3, 0, 1);
INSERT INTO `thema_verantwoordelijkheden` VALUES(138, 30, NULL, 7, 3, 0, 1);
INSERT INTO `thema_verantwoordelijkheden` VALUES(139, 51, NULL, 16, 1, 0, 1);
INSERT INTO `thema_verantwoordelijkheden` VALUES(140, 52, NULL, 16, 1, 0, 1);
INSERT INTO `thema_verantwoordelijkheden` VALUES(141, 53, NULL, 16, 1, 0, 1);
INSERT INTO `thema_verantwoordelijkheden` VALUES(142, 54, NULL, 16, 1, 0, 1);
INSERT INTO `thema_verantwoordelijkheden` VALUES(143, 55, NULL, 16, 1, 0, 1);
INSERT INTO `thema_verantwoordelijkheden` VALUES(144, 56, NULL, 16, 1, 0, 1);
INSERT INTO `thema_verantwoordelijkheden` VALUES(145, 57, NULL, 16, 1, 0, 1);
INSERT INTO `thema_verantwoordelijkheden` VALUES(146, 3, NULL, NULL, 1, 1, 0);
INSERT INTO `thema_verantwoordelijkheden` VALUES(147, 3, NULL, NULL, 3, 1, 0);
INSERT INTO `thema_verantwoordelijkheden` VALUES(148, 24, NULL, NULL, 1, 1, 0);
INSERT INTO `thema_verantwoordelijkheden` VALUES(149, 24, NULL, NULL, 3, 1, 0);
INSERT INTO `thema_verantwoordelijkheden` VALUES(150, 26, NULL, NULL, 3, 1, 0);
INSERT INTO `thema_verantwoordelijkheden` VALUES(151, 31, NULL, NULL, 3, 1, 0);
INSERT INTO `thema_verantwoordelijkheden` VALUES(152, 31, NULL, NULL, 1, 1, 0);
INSERT INTO `thema_verantwoordelijkheden` VALUES(153, 32, NULL, NULL, 3, 1, 0);
INSERT INTO `thema_verantwoordelijkheden` VALUES(154, 32, NULL, NULL, 1, 1, 0);
INSERT INTO `thema_verantwoordelijkheden` VALUES(155, 33, NULL, NULL, 1, 1, 0);
INSERT INTO `thema_verantwoordelijkheden` VALUES(156, 33, NULL, NULL, 3, 1, 0);
INSERT INTO `thema_verantwoordelijkheden` VALUES(157, 34, NULL, NULL, 1, 1, 0);
INSERT INTO `thema_verantwoordelijkheden` VALUES(158, 34, NULL, NULL, 3, 1, 0);
INSERT INTO `thema_verantwoordelijkheden` VALUES(159, 35, NULL, NULL, 1, 1, 0);
INSERT INTO `thema_verantwoordelijkheden` VALUES(160, 35, NULL, NULL, 3, 1, 0);
INSERT INTO `thema_verantwoordelijkheden` VALUES(161, 36, NULL, NULL, 1, 1, 0);
INSERT INTO `thema_verantwoordelijkheden` VALUES(162, 36, NULL, NULL, 3, 1, 0);
INSERT INTO `thema_verantwoordelijkheden` VALUES(163, 37, NULL, NULL, 1, 1, 0);
INSERT INTO `thema_verantwoordelijkheden` VALUES(164, 37, NULL, NULL, 3, 1, 0);
INSERT INTO `thema_verantwoordelijkheden` VALUES(165, 38, NULL, NULL, 1, 1, 0);
INSERT INTO `thema_verantwoordelijkheden` VALUES(166, 38, NULL, NULL, 3, 1, 0);
INSERT INTO `thema_verantwoordelijkheden` VALUES(167, 39, NULL, NULL, 1, 1, 0);
INSERT INTO `thema_verantwoordelijkheden` VALUES(168, 39, NULL, NULL, 3, 1, 0);
INSERT INTO `thema_verantwoordelijkheden` VALUES(169, 40, NULL, NULL, 1, 1, 0);
INSERT INTO `thema_verantwoordelijkheden` VALUES(170, 40, NULL, NULL, 3, 1, 0);
INSERT INTO `thema_verantwoordelijkheden` VALUES(171, 41, NULL, NULL, 1, 1, 0);
INSERT INTO `thema_verantwoordelijkheden` VALUES(172, 41, NULL, NULL, 3, 1, 0);
INSERT INTO `thema_verantwoordelijkheden` VALUES(173, 42, NULL, NULL, 1, 1, 0);
INSERT INTO `thema_verantwoordelijkheden` VALUES(174, 42, NULL, NULL, 3, 1, 0);
INSERT INTO `thema_verantwoordelijkheden` VALUES(175, 49, NULL, NULL, 1, 1, 0);
INSERT INTO `thema_verantwoordelijkheden` VALUES(176, 49, NULL, NULL, 3, 1, 0);
INSERT INTO `thema_verantwoordelijkheden` VALUES(177, 58, NULL, NULL, 1, 1, 0);
INSERT INTO `thema_verantwoordelijkheden` VALUES(178, 58, NULL, NULL, 3, 1, 0);
INSERT INTO `thema_verantwoordelijkheden` VALUES(179, 59, NULL, NULL, 1, 1, 0);
INSERT INTO `thema_verantwoordelijkheden` VALUES(180, 59, NULL, NULL, 3, 1, 0);
INSERT INTO `thema_verantwoordelijkheden` VALUES(181, 60, NULL, NULL, 1, 1, 0);
INSERT INTO `thema_verantwoordelijkheden` VALUES(182, 60, NULL, NULL, 3, 1, 0);
INSERT INTO `thema_verantwoordelijkheden` VALUES(183, 51, NULL, NULL, 2, 1, 0);
INSERT INTO `thema_verantwoordelijkheden` VALUES(184, 51, NULL, NULL, 3, 1, 0);
INSERT INTO `thema_verantwoordelijkheden` VALUES(185, 52, NULL, NULL, 2, 1, 0);
INSERT INTO `thema_verantwoordelijkheden` VALUES(186, 52, NULL, NULL, 3, 1, 0);
INSERT INTO `thema_verantwoordelijkheden` VALUES(187, 53, NULL, NULL, 2, 1, 0);
INSERT INTO `thema_verantwoordelijkheden` VALUES(188, 53, NULL, NULL, 3, 1, 0);
INSERT INTO `thema_verantwoordelijkheden` VALUES(189, 54, NULL, NULL, 2, 1, 0);
INSERT INTO `thema_verantwoordelijkheden` VALUES(190, 54, NULL, NULL, 3, 1, 0);
INSERT INTO `thema_verantwoordelijkheden` VALUES(191, 55, NULL, NULL, 2, 1, 0);
INSERT INTO `thema_verantwoordelijkheden` VALUES(192, 55, NULL, NULL, 3, 1, 0);
INSERT INTO `thema_verantwoordelijkheden` VALUES(193, 56, NULL, NULL, 2, 1, 0);
INSERT INTO `thema_verantwoordelijkheden` VALUES(194, 56, NULL, NULL, 3, 1, 0);
INSERT INTO `thema_verantwoordelijkheden` VALUES(195, 57, NULL, NULL, 2, 1, 0);
INSERT INTO `thema_verantwoordelijkheden` VALUES(196, 57, NULL, NULL, 3, 1, 0);
UNLOCK TABLES;


#
# Dumping data for table 'waarde_typen'
#

LOCK TABLES `waarde_typen` WRITE;
INSERT INTO `waarde_typen` VALUES(1, 'string');
INSERT INTO `waarde_typen` VALUES(2, 'integer');
INSERT INTO `waarde_typen` VALUES(3, 'double');
INSERT INTO `waarde_typen` VALUES(4, 'date');
UNLOCK TABLES;

#
# Dumping data for table 'workshop_medewerkers'
#

LOCK TABLES `workshop_medewerkers` WRITE;
INSERT INTO `workshop_medewerkers` VALUES(1, 3, 1, 1);
INSERT INTO `workshop_medewerkers` VALUES(2, 3, 2, 1);
INSERT INTO `workshop_medewerkers` VALUES(3, 3, 3, 1);
INSERT INTO `workshop_medewerkers` VALUES(4, 3, 4, 1);
INSERT INTO `workshop_medewerkers` VALUES(5, 3, 5, 1);
INSERT INTO `workshop_medewerkers` VALUES(6, 3, 6, 1);
INSERT INTO `workshop_medewerkers` VALUES(7, 3, 7, 1);
INSERT INTO `workshop_medewerkers` VALUES(8, 8, 8, 1);
INSERT INTO `workshop_medewerkers` VALUES(9, 8, 9, 1);
INSERT INTO `workshop_medewerkers` VALUES(10, 8, 10, 1);
INSERT INTO `workshop_medewerkers` VALUES(11, 8, 11, 1);
INSERT INTO `workshop_medewerkers` VALUES(12, 8, 12, 1);
INSERT INTO `workshop_medewerkers` VALUES(13, 8, 13, 1);
INSERT INTO `workshop_medewerkers` VALUES(14, 8, 14, 1);
INSERT INTO `workshop_medewerkers` VALUES(15, 9, 15, 1);
INSERT INTO `workshop_medewerkers` VALUES(16, 9, 16, 1);
INSERT INTO `workshop_medewerkers` VALUES(17, 9, 17, 1);
INSERT INTO `workshop_medewerkers` VALUES(18, 9, 18, 1);
INSERT INTO `workshop_medewerkers` VALUES(19, 9, 19, 1);
INSERT INTO `workshop_medewerkers` VALUES(20, 9, 20, 1);
INSERT INTO `workshop_medewerkers` VALUES(21, 9, 21, 1);
INSERT INTO `workshop_medewerkers` VALUES(22, 10, 22, 1);
INSERT INTO `workshop_medewerkers` VALUES(23, 10, 23, 1);
INSERT INTO `workshop_medewerkers` VALUES(24, 10, 24, 1);
INSERT INTO `workshop_medewerkers` VALUES(25, 10, 25, 1);
INSERT INTO `workshop_medewerkers` VALUES(26, 10, 26, 1);
INSERT INTO `workshop_medewerkers` VALUES(27, 10, 27, 1);
INSERT INTO `workshop_medewerkers` VALUES(28, 10, 28, 1);
INSERT INTO `workshop_medewerkers` VALUES(29, 10, 29, 1);
INSERT INTO `workshop_medewerkers` VALUES(30, 2, 30, 1);
INSERT INTO `workshop_medewerkers` VALUES(31, 2, 31, 1);
INSERT INTO `workshop_medewerkers` VALUES(32, 2, 32, 1);
INSERT INTO `workshop_medewerkers` VALUES(33, 5, 33, 1);
INSERT INTO `workshop_medewerkers` VALUES(34, 5, 34, 1);
INSERT INTO `workshop_medewerkers` VALUES(35, 4, 35, 1);
INSERT INTO `workshop_medewerkers` VALUES(36, 4, 36, 1);
INSERT INTO `workshop_medewerkers` VALUES(37, 4, 37, 1);
INSERT INTO `workshop_medewerkers` VALUES(38, 4, 38, 1);
INSERT INTO `workshop_medewerkers` VALUES(39, 4, 39, 1);
INSERT INTO `workshop_medewerkers` VALUES(40, 6, 40, 1);
INSERT INTO `workshop_medewerkers` VALUES(41, 6, 41, 1);
INSERT INTO `workshop_medewerkers` VALUES(42, 6, 42, 1);
INSERT INTO `workshop_medewerkers` VALUES(43, 7, 43, 1);
INSERT INTO `workshop_medewerkers` VALUES(44, 7, 44, 1);
INSERT INTO `workshop_medewerkers` VALUES(45, 7, 45, 1);
INSERT INTO `workshop_medewerkers` VALUES(46, 7, 46, 1);
INSERT INTO `workshop_medewerkers` VALUES(47, 7, 47, 1);
INSERT INTO `workshop_medewerkers` VALUES(48, 7, 48, 1);
INSERT INTO `workshop_medewerkers` VALUES(49, 7, 49, 1);
INSERT INTO `workshop_medewerkers` VALUES(50, 7, 50, 1);
INSERT INTO `workshop_medewerkers` VALUES(51, 1, 51, 1);
INSERT INTO `workshop_medewerkers` VALUES(52, 1, 52, 1);
INSERT INTO `workshop_medewerkers` VALUES(53, 1, 53, 1);
INSERT INTO `workshop_medewerkers` VALUES(54, 1, 54, 1);
INSERT INTO `workshop_medewerkers` VALUES(55, 1, 50, 1);
INSERT INTO `workshop_medewerkers` VALUES(56, 1, 44, 1);
INSERT INTO `workshop_medewerkers` VALUES(57, 5, 29, 1);
INSERT INTO `workshop_medewerkers` VALUES(58, 5, 27, 1);
INSERT INTO `workshop_medewerkers` VALUES(59, 10, 19, 1);
INSERT INTO `workshop_medewerkers` VALUES(60, 4, 15, 1);
INSERT INTO `workshop_medewerkers` VALUES(61, 5, 14, 1);
INSERT INTO `workshop_medewerkers` VALUES(62, 7, 10, 1);
INSERT INTO `workshop_medewerkers` VALUES(63, 1, 10, 1);
INSERT INTO `workshop_medewerkers` VALUES(64, 1, 5, 1);
INSERT INTO `workshop_medewerkers` VALUES(65, 9, 3, 1);
INSERT INTO `workshop_medewerkers` VALUES(66, 1, 2, 1);
INSERT INTO `workshop_medewerkers` VALUES(67, 1, 1, 1);
UNLOCK TABLES;

#
# Dumping data for table 'workshops'
#

LOCK TABLES `workshops` WRITE;
INSERT INTO `workshops` VALUES(1, 10, 'Afstemming organisatiegrenzen en beheer (basis)gegevens ');
INSERT INTO `workshops` VALUES(2, 5, 'Groen ');
INSERT INTO `workshops` VALUES(3, 1, 'Inriching processen op hoofdniveau');
INSERT INTO `workshops` VALUES(4, 7, 'Kunstwerken/Tankstations ');
INSERT INTO `workshops` VALUES(5, 6, 'Pompen/Verlichting/DSI\'s/VRI\'s/DVM/Kabels&Leidingen ');
INSERT INTO `workshops` VALUES(6, 8, 'Regelingen ');
INSERT INTO `workshops` VALUES(7, 9, 'Systeemarchitectuur ');
INSERT INTO `workshops` VALUES(8, 2, 'Verkeersmanagement, ongevallen, intensiteiten ');
INSERT INTO `workshops` VALUES(9, 3, 'Voorbereiden en realiseren infrastructurele werken ');
INSERT INTO `workshops` VALUES(10, 4, 'Weg/Bebording/ANWB ');
INSERT INTO `workshops` VALUES(12, 11, 'Management presentatie bevindingen');
UNLOCK TABLES;

#SET FOREIGN_KEY_CHECKS = 1;

