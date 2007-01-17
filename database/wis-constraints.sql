
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
