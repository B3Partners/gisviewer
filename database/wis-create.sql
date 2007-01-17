SET FOREIGN_KEY_CHECKS = 0;
#
# Table structure for table 'applicaties'
#

DROP TABLE IF EXISTS `applicaties`;
create table applicaties (
	id integer not null auto_increment, 
	pakket varchar(255), 
	module varchar(255), 
	beschrijving varchar(255), 
	extern bit not null, 
	acceptabel bit not null, 
	administratief bit not null, 
	geodata bit not null, 
	taal varchar(255), 
	spatial_koppeling varchar(255), 
	db_koppeling varchar(255), 
	webbased bit not null, 
	gps bit not null, 
	crow bit not null, 
	opmerking varchar(255), 
	leverancier integer, 
	primary key (id)
) type=InnoDB;

#
# Table structure for table 'clusters'
#

DROP TABLE IF EXISTS `clusters`;
create table clusters (
	id integer not null auto_increment,
	naam varchar(255),
	omschrijving varchar(255),
	parent integer,
	primary key (id)
) type=InnoDB;
#
# Table structure for table 'data_regels'
#

DROP TABLE IF EXISTS `data_regels`;
create table data_regels (
id integer not null auto_increment,
	thema integer,
	etlbatch integer,
	timestamp date,
	primary key (id)
) type=InnoDB;
#
# Table structure for table 'etlbatch'
#

DROP TABLE IF EXISTS `etlbatch`;
create table etlbatch (
id integer not null auto_increment,
	omschrijving varchar(255),
	timestamp date,
	primary key (id)
) type=InnoDB;

#
# Table structure for table 'functie_items'
#

DROP TABLE IF EXISTS `functie_items`;
create table functie_items (
	id integer not null auto_increment,
	label varchar(255),
	omschrijving varchar(255),
	eenheid varchar(255),
	voorbeelden varchar(255),
	invoer bit not null,
	uitvoer bit not null,
	functie integer,
	primary key (id)
) type=InnoDB;
#
# Table structure for table 'leveranciers'
#

DROP TABLE IF EXISTS `leveranciers`;
create table leveranciers (
	id integer not null auto_increment,
	naam varchar(255),
	pakket varchar(255),
	telefoon1 varchar(255),
	contact varchar(255),
	telefoon2 varchar(255),
	telefoon3 varchar(255),
	email varchar(255),
	info bit not null,
	opmerkingen varchar(255),
	primary key (id)
) type=InnoDB;

#
# Table structure for table 'locatie_aanduidingen'
#

DROP TABLE IF EXISTS `locatie_aanduidingen`;
create table locatie_aanduidingen (
	id integer not null auto_increment,
	naam varchar(255),
	omschrijving varchar(255),
	primary key (id)
) type=InnoDB;

#
# Table structure for table 'medewerkers'
#

DROP TABLE IF EXISTS `medewerkers`;
create table medewerkers (
	id integer not null auto_increment,
	achternaam varchar(255),
	voornaam varchar(255),
	telefoon varchar(255),
	functie varchar(255),
	locatie varchar(255),
	email varchar(255),
	primary key (id)
) type=InnoDB;

#
# Table structure for table 'moscow'
#

DROP TABLE IF EXISTS `moscow`;
create table moscow (
	id integer not null auto_increment,
	code varchar(255),
	naam varchar(255),
	omschrijving varchar(255),
	primary key (id)
) type=InnoDB;

#
# Table structure for table 'object_typen'
#
DROP TABLE IF EXISTS `object_typen`;
create table object_typen (
	id integer not null auto_increment,
	naam varchar(255),
	primary key (id)
) type=InnoDB;

#
# Table structure for table 'onderdeel'
#

DROP TABLE IF EXISTS `onderdeel`;
create table onderdeel (
	id integer not null auto_increment,
	naam varchar(255),
	omschrijving varchar(255),
	locatie varchar(255),
	regio bit not null,
	primary key (id)
) type=InnoDB;


#
# Table structure for table 'onderdeel_medewerkers'
#

DROP TABLE IF EXISTS `onderdeel_medewerkers`;
create table onderdeel_medewerkers (
	id integer not null auto_increment,
	medewerker integer,
	onderdeel integer,
	vertegenwoordiger bit not null,
	primary key (id)
) type=InnoDB;

#
# Table structure for table 'regel_attributen'
#

DROP TABLE IF EXISTS `regel_attributen`;
create table regel_attributen (
	id integer not null auto_increment,
	tia integer,
	regel integer,
	waarde varchar(255),
	primary key (id)
) type=InnoDB;

#
# Dumping data for table 'regel_attributen'
#

LOCK TABLES `regel_attributen` WRITE;
UNLOCK TABLES;

#
# Table structure for table 'rollen'
#
DROP TABLE IF EXISTS `rollen`;
create table rollen (
	id integer not null auto_increment,
	naam varchar(255),
	primary key (id)
) type=InnoDB;

#
# Table structure for table 'spatial_objects'
#

DROP TABLE IF EXISTS `spatial_objects`;
create table spatial_objects (
	id integer not null auto_increment,
	tis integer,
	regel integer,
	geometry varchar(255),
	timestamp date,
	primary key (id)
) type=InnoDB;

#
# Table structure for table 'thema_applicaties'
#

DROP TABLE IF EXISTS `thema_applicaties`;
create table thema_applicaties (
	id integer not null auto_increment,
	thema integer,
	applicatie integer,
	ingebruik bit not null,
	geodata bit not null,
	administratief bit not null,
	voorkeur bit not null,
	definitief bit not null,
	standaard bit not null,
	primary key (id)
) type=InnoDB;

#
# Table structure for table 'ThemaFuncties'
#

DROP TABLE IF EXISTS `thema_functies`;
create table thema_functies (
	id integer not null auto_increment,
	naam varchar(255),
	omschrijving varchar(255),
	thema integer,
	applicatie integer,
	protocol varchar(255),
	primary key (id)
) type=InnoDB;


#
# Table structure for table 'thema_items_admin'
#

DROP TABLE IF EXISTS `thema_items_admin`;
create table thema_items_admin (
	id integer not null auto_increment,
	label varchar(255),
	eenheid varchar(255),
	omschrijving varchar(255),
	basisregel bit not null,
	voorbeelden varchar(255),
	kenmerk bit not null,
	kolombreedte integer not null,
	thema integer,
	moscow integer,
	waarde_type integer,
	primary key (id)
) type=InnoDB;

#
# Table structure for table 'thema_items_spatial'
#

DROP TABLE IF EXISTS `thema_items_spatial`;
create table thema_items_spatial (
	id integer not null auto_increment,
	kenmerk varchar(255),
	omschrijving varchar(255),
	thema integer,
	type integer not null,
	lrood tinyint,
	lgroen tinyint,
	lblauw tinyint,
	vrood tinyint,
	vgroen tinyint,
	vblauw tinyint,
	primary key (id)
) type=InnoDB;


#
# Table structure for table 'themas'
#

DROP TABLE IF EXISTS `themas`;
create table themas (
	id integer not null auto_increment,
	code varchar(255),
	naam varchar(255),
	moscow integer,
	belangnr integer not null,
	cluster integer not null,
	opmerkingen varchar(255),
	analyse_thema bit not null,
	locatie_thema bit not null,
	primary key (id)
) type=InnoDB;

#
# Table structure for table 'thema_verantwoordelijkheden'
#

DROP TABLE IF EXISTS `thema_verantwoordelijkheden`;
create table thema_verantwoordelijkheden (
	id integer not null auto_increment,
	thema integer,
	medewerker integer,
	onderdeel integer,
	rol integer,
	huidige_situatie bit not null,
	gewenste_situatie bit not null,
	primary key (id)
) type=InnoDB;


#
# Table structure for table 'waarde_typen'
#
DROP TABLE IF EXISTS `waarde_typen`;
create table waarde_typen (
	id integer not null auto_increment,
	naam varchar(255),
	primary key (id)
) type=InnoDB;

#
# Table structure for table 'workshop_medewerkers'
#

DROP TABLE IF EXISTS `workshop_medewerkers`;
create table workshop_medewerkers (
	id integer not null auto_increment,
	workshop integer,
	medewerker integer,
	aanwezig bit not null,
	primary key (id)
) type=InnoDB;

#
# Table structure for table 'workshops'
#

DROP TABLE IF EXISTS `workshops`;
create table workshops (
	id integer not null auto_increment,
	volgnr integer not null,
	naam varchar(255),
	primary key (id)
) type=InnoDB;

SET FOREIGN_KEY_CHECKS = 1;
