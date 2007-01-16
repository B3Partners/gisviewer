create table applicaties (
	id serial not null auto_increment,
	pakket varchar(255),
	module varchar(255),
	beschrijving varchar(255),
	extern bit not null,
	acceptabel bit not null,
	administratief bit not null,
	spatial bit not null,
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
create table clusters (
	id serial not null auto_increment,
	naam varchar(255),
	omschrijving varchar(255),
	parent integer,
	primary key (id)
) type=InnoDB;
create table data_regels (
	id serial not null auto_increment,
	thema integer,
	etlbatch integer,
	timestamp date,
	primary key (id)
) type=InnoDB;
create table etlbatch (
	id serial not null auto_increment,
	omschrijving varchar(255),
	timestamp date,
	primary key (id)
) type=InnoDB;
create table functie_items (
	id serial not null auto_increment,
	label varchar(255),
	omschrijving varchar(255),
	eenheid varchar(255),
	voorbeelden varchar(255),
	invoer bit not null,
	uitvoer bit not null,
	functie integer,
	primary key (id)
) type=InnoDB;
create table leveranciers (
	id serial not null auto_increment,
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
create table locatie_aanduidingen (
	id serial not null auto_increment,
	naam varchar(255),
	omschrijving varchar(255),
	primary key (id)
) type=InnoDB;
create table medewerkers (
	id serial not null auto_increment,
	achternaam varchar(255),
	voornaam varchar(255),
	telefoon varchar(255),
	functie varchar(255),
	locatie varchar(255),
	email varchar(255),
	primary key (id)
) type=InnoDB;
create table moscow (
	id serial not null auto_increment,
	code varchar(255),
	naam varchar(255),
	omschrijving varchar(255),
	primary key (id)
) type=InnoDB;
create table object_typen (
	id serial not null auto_increment,
	naam varchar(255),
	primary key (id)
) type=InnoDB;
create table onderdeel (
	id serial not null auto_increment,
	naam varchar(255),
	omschrijving varchar(255),
	locatie varchar(255),
	regio bit not null,
	primary key (id)
) type=InnoDB;
create table onderdeel_medewerkers (
	id serial not null auto_increment,
	medewerker integer,
	onderdeel integer,
	vertegenwoordiger bit not null,
	primary key (id)
) type=InnoDB;
create table regel_attributen (
	id serial not null auto_increment,
	tia integer,
	regel integer,
	waarde varchar(255),
	primary key (id)
) type=InnoDB;
create table rollen (
	id serial not null auto_increment,
	naam varchar(255),
	primary key (id)
) type=InnoDB;
create table spatial_objects (
	id serial not null auto_increment,
	tis integer,
	regel integer,
	geometry varchar(255),
	timestamp date,
	primary key (id)
) type=InnoDB;
create table thema_applicaties (
	id serial not null auto_increment,
	thema integer,
	applicatie integer,
	ingebruik bit not null,
	spatial bit not null,
	administratief bit not null,
	voorkeur bit not null,
	definitief bit not null,
	standaard bit not null,
	primary key (id)
) type=InnoDB;
create table thema_functies (
	id serial not null auto_increment,
	naam varchar(255),
	omschrijving varchar(255),
	thema integer,
	applicatie integer,
	protocol varchar(255),
	primary key (id)
) type=InnoDB;
create table thema_items_admin (
	id serial not null auto_increment,
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
create table thema_items_spatial (
	id serial not null auto_increment,
	kenmerk varchar(255),
	omschrijving varchar(255),
	thema integer,
	type integer not null,
	lrood tinyint not null,
	lgroen tinyint not null,
	lblauw tinyint not null,
	vrood tinyint not null,
	vgroen tinyint not null,
	vblauw tinyint not null,
	primary key (id)
) type=InnoDB;
create table thema_verantwoordelijkheden (
	id serial not null auto_increment,
	thema integer,
	medewerker integer,
	rol integer,
	huidige_situatie bit not null,
	gewenste_situatie bit not null,
	primary key (id)
) type=InnoDB;
create table themas (
	id serial not null auto_increment,
	code varchar(255),
	naam varchar(255),
	moscow integer,
	cluster integer not null,
	belangnr integer not null,
	opmerkingen varchar(255),
	analyse_thema bit not null,
	locatie_thema bit not null,
	primary key (id)
) type=InnoDB;
create table waarde_typen (
	id serial not null auto_increment,
	naam varchar(255),
	primary key (id)
) type=InnoDB;
create table workshop_medewerkers (
	id serial not null auto_increment,
	workshop integer,
	medewerker integer,
	aanwezig bit not null,
	primary key (id)
) type=InnoDB;
create table workshops (
	id serial not null auto_increment,
	volgnr integer not null,
	naam varchar(255),
	primary key (id)
) type=InnoDB;


alter table applicaties add index FK5CA4041F5E6911E7 (leverancier),
	add constraint FK5CA4041F5E6911E7 foreign key (leverancier) references leveranciers (id);
alter table clusters add index FK4B672DB94CB900BD (parent),
	add constraint FK4B672DB94CB900BD foreign key (parent) references clusters (id);
alter table data_regels add index FKAE3611CD169835AE (etlbatch),
	add constraint FKAE3611CD169835AE foreign key (etlbatch) references etlbatch (id);
alter table data_regels add index FKAE3611CD3D64D847 (thema),
	add constraint FKAE3611CD3D64D847 foreign key (thema) references themas (id);
alter table functie_items add index FK505E190D2D374D24 (functie),
	add constraint FK505E190D2D374D24 foreign key (functie) references thema_functies (id);
alter table onderdeel_medewerkers add index FKEBA08541FA69FB5F (medewerker),
	add constraint FKEBA08541FA69FB5F foreign key (medewerker) references medewerkers (id);
alter table onderdeel_medewerkers add index FKEBA08541C9D017C0 (onderdeel),
	add constraint FKEBA08541C9D017C0 foreign key (onderdeel) references onderdeel (id);
alter table regel_attributen add index FK78712BD673BE1EEC (tia),
	add constraint FK78712BD673BE1EEC foreign key (tia) references thema_items_admin (id);
alter table regel_attributen add index FK78712BD67B16151 (regel),
	add constraint FK78712BD67B16151 foreign key (regel) references data_regels (id);
alter table spatial_objects add index FK62E0C4D942263873 (tis),
	add constraint FK62E0C4D942263873 foreign key (tis) references thema_items_spatial (id);
alter table spatial_objects add index FK62E0C4D97B16151 (regel),
	add constraint FK62E0C4D97B16151 foreign key (regel) references data_regels (id);
alter table thema_applicaties add index FK667058A53D64D847 (thema),
	add constraint FK667058A53D64D847 foreign key (thema) references themas (id);
alter table thema_applicaties add index FK667058A5849C1C3F (applicatie),
	add constraint FK667058A5849C1C3F foreign key (applicatie) references applicaties (id);
alter table thema_functies add index FK93B8DBE13D64D847 (thema),
	add constraint FK93B8DBE13D64D847 foreign key (thema) references themas (id);
alter table thema_functies add index FK93B8DBE1849C1C3F (applicatie),
	add constraint FK93B8DBE1849C1C3F foreign key (applicatie) references applicaties (id);
alter table thema_items_admin add index FKF1CFD296614A2841 (waarde_type),
	add constraint FKF1CFD296614A2841 foreign key (waarde_type) references waarde_typen (id);
alter table thema_items_admin add index FKF1CFD2963D64D847 (thema),
	add constraint FKF1CFD2963D64D847 foreign key (thema) references themas (id);
alter table thema_items_admin add index FKF1CFD296EB9A88E8 (moscow),
	add constraint FKF1CFD296EB9A88E8 foreign key (moscow) references moscow (id);
alter table thema_items_spatial add index FK892BB68B3D64D847 (thema),
	add constraint FK892BB68B3D64D847 foreign key (thema) references themas (id);
alter table thema_verantwoordelijkheden add index FK3931C958FA69FB5F (medewerker),
	add constraint FK3931C958FA69FB5F foreign key (medewerker) references medewerkers (id);
alter table thema_verantwoordelijkheden add index FK3931C958FA69FB6F (onderdeel),
	add constraint FK3931C958FA69FB6F foreign key (onderdeel) references onderdeel (id);
alter table thema_verantwoordelijkheden add index FK3931C95833CF3AE9 (rol),
	add constraint FK3931C95833CF3AE9 foreign key (rol) references rollen (id);
alter table thema_verantwoordelijkheden add index FK3931C9583D64D847 (thema),
	add constraint FK3931C9583D64D847 foreign key (thema) references themas (id);
alter table themas add index FKCBDB434EDFA4B56D (cluster),
	add constraint FKCBDB434EDFA4B56D foreign key (cluster) references clusters (id);
alter table themas add index FKCBDB434EEB9A88E8 (moscow),
	add constraint FKCBDB434EEB9A88E8 foreign key (moscow) references moscow (id);
alter table workshop_medewerkers add index FK8E8718E7BAF559F (workshop),
	add constraint FK8E8718E7BAF559F foreign key (workshop) references workshops (id);
alter table workshop_medewerkers add index FK8E8718EFA69FB5F (medewerker),
	add constraint FK8E8718EFA69FB5F foreign key (medewerker) references medewerkers (id);
