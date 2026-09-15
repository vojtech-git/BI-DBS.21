-- smazání všech záznamů z tabulek

CREATE or replace FUNCTION clean_tables() RETURNS void AS $$
declare
  l_stmt text;
begin
  select 'truncate ' || string_agg(format('%I.%I', schemaname, tablename) , ',')
    into l_stmt
  from pg_tables
  where schemaname in ('public');

  execute l_stmt || ' cascade';
end;
$$ LANGUAGE plpgsql;
select clean_tables();

-- reset sekvenci

CREATE or replace FUNCTION restart_sequences() RETURNS void AS $$
DECLARE
i TEXT;
BEGIN
 FOR i IN (SELECT column_default FROM information_schema.columns WHERE column_default SIMILAR TO 'nextval%')
  LOOP
         EXECUTE 'ALTER SEQUENCE'||' ' || substring(substring(i from '''[a-z_]*')from '[a-z_]+') || ' '||' RESTART 1;';
  END LOOP;
END $$ LANGUAGE plpgsql;
select restart_sequences();
-- konec resetu

-- konec mazání
-- mohli bchom použít i jednotlivé příkazy truncate na každo tabulku


insert into zbozi (id_zbozi, nazev, pocet) values (1, 'Nut - Macadamia', 25);
insert into zbozi (id_zbozi, nazev, pocet) values (2, 'Sprouts Dikon', 40);
insert into zbozi (id_zbozi, nazev, pocet) values (3, 'Wine - Red, Lurton Merlot De', 33);
insert into zbozi (id_zbozi, nazev, pocet) values (4, 'Oregano - Fresh', 58);
insert into zbozi (id_zbozi, nazev, pocet) values (5, 'Wine - Guy Sage Touraine', 13);
insert into zbozi (id_zbozi, nazev, pocet) values (6, 'Mangoes', 56);
insert into zbozi (id_zbozi, nazev, pocet) values (7, 'Shrimp - 16/20, Peeled Deviened', 6);
insert into zbozi (id_zbozi, nazev, pocet) values (8, 'Pastrami', 72);
insert into zbozi (id_zbozi, nazev, pocet) values (9, 'Pickerel - Fillets', 86);
insert into zbozi (id_zbozi, nazev, pocet) values (10, 'Capon - Breast, Double, Wing On', 94);
insert into zbozi (id_zbozi, nazev, pocet) values (11, 'Yogurt - Assorted Pack', 79);
insert into zbozi (id_zbozi, nazev, pocet) values (12, 'Tandoori Curry Paste', 83);
insert into zbozi (id_zbozi, nazev, pocet) values (13, 'Lemonade - Pineapple Passion', 76);
insert into zbozi (id_zbozi, nazev, pocet) values (14, 'Red Currant Jelly', 47);
insert into zbozi (id_zbozi, nazev, pocet) values (15, 'Sprouts - Baby Pea Tendrils', 80);
insert into zbozi (id_zbozi, nazev, pocet) values (16, 'Pepper - Black, Whole', 37);
insert into zbozi (id_zbozi, nazev, pocet) values (17, 'Bacardi Limon', 98);
insert into zbozi (id_zbozi, nazev, pocet) values (18, 'Wine - Malbec Trapiche Reserve', 66);
insert into zbozi (id_zbozi, nazev, pocet) values (19, 'Cheese', 63);
insert into zbozi (id_zbozi, nazev, pocet) values (20, 'Rabbit - Saddles', 35);
insert into zbozi (id_zbozi, nazev, pocet) values (21, 'Appetizer - Assorted Box', 24);
insert into zbozi (id_zbozi, nazev, pocet) values (22, 'Doilies - 10, Paper', 15);
insert into zbozi (id_zbozi, nazev, pocet) values (23, 'Cheese - Roquefort Pappillon', 25);
insert into zbozi (id_zbozi, nazev, pocet) values (24, 'Remy Red', 75);
insert into zbozi (id_zbozi, nazev, pocet) values (25, 'Gin - Gilbeys London, Dry', 84);
insert into zbozi (id_zbozi, nazev, pocet) values (26, 'Flower - Potmums', 79);
insert into zbozi (id_zbozi, nazev, pocet) values (27, 'Browning Caramel Glace', 23);
insert into zbozi (id_zbozi, nazev, pocet) values (28, 'Sauce Bbq Smokey', 39);
insert into zbozi (id_zbozi, nazev, pocet) values (29, 'Vacuum Bags 12x16', 44);
insert into zbozi (id_zbozi, nazev, pocet) values (30, 'Wine - Rosso Toscano Igt', 39);
insert into zbozi (id_zbozi, nazev, pocet) values (31, 'Kokos', 39);

select setval(pg_get_serial_sequence('zbozi','id_zbozi'),31);

insert into pokoj (id_pokoj, pocet_postel) values (1, 5);
insert into pokoj (id_pokoj, pocet_postel) values (2, 10);
insert into pokoj (id_pokoj, pocet_postel) values (3, 3);
insert into pokoj (id_pokoj, pocet_postel) values (4, 1);
insert into pokoj (id_pokoj, pocet_postel) values (5, 9);
insert into pokoj (id_pokoj, pocet_postel) values (6, 10);
insert into pokoj (id_pokoj, pocet_postel) values (7, 7);
insert into pokoj (id_pokoj, pocet_postel) values (8, 10);
insert into pokoj (id_pokoj, pocet_postel) values (9, 1);
insert into pokoj (id_pokoj, pocet_postel) values (10, 7);
insert into pokoj (id_pokoj, pocet_postel) values (11, 2);
insert into pokoj (id_pokoj, pocet_postel) values (12, 10);
insert into pokoj (id_pokoj, pocet_postel) values (13, 6);
insert into pokoj (id_pokoj, pocet_postel) values (14, 10);
insert into pokoj (id_pokoj, pocet_postel) values (15, 5);
insert into pokoj (id_pokoj, pocet_postel) values (16, 3);
insert into pokoj (id_pokoj, pocet_postel) values (17, 1);
insert into pokoj (id_pokoj, pocet_postel) values (18, 8);
insert into pokoj (id_pokoj, pocet_postel) values (19, 9);
insert into pokoj (id_pokoj, pocet_postel) values (20, 9);
insert into pokoj (id_pokoj, pocet_postel) values (21, 9);

select setval(pg_get_serial_sequence('pokoj','id_pokoj'),21);

insert into osoba (id_osoba, jmeno) values (1, 'Dewain McCuish');
insert into osoba (id_osoba, jmeno) values (2, 'Murielle Croughan');
insert into osoba (id_osoba, jmeno) values (3, 'Sindee Emanson');
insert into osoba (id_osoba, jmeno) values (4, 'Celestia Ruggen');
insert into osoba (id_osoba, jmeno) values (5, 'Gilda Tilson');
insert into osoba (id_osoba, jmeno) values (6, 'Clerissa Stenners');
insert into osoba (id_osoba, jmeno) values (7, 'Rockey Marchelli');
insert into osoba (id_osoba, jmeno) values (8, 'Carlina Popov');
insert into osoba (id_osoba, jmeno) values (9, 'Schuyler Flippini');
insert into osoba (id_osoba, jmeno) values (10, 'Helene Tennison');
insert into osoba (id_osoba, jmeno) values (11, 'Gale Jarry');
insert into osoba (id_osoba, jmeno) values (12, 'Stacee Strang');
insert into osoba (id_osoba, jmeno) values (13, 'Junette Litterick');
insert into osoba (id_osoba, jmeno) values (14, 'Querida Itskovitz');
insert into osoba (id_osoba, jmeno) values (15, 'Kaleena Stoltz');
insert into osoba (id_osoba, jmeno) values (16, 'Clovis Webburn');
insert into osoba (id_osoba, jmeno) values (17, 'Gibbie Loache');
insert into osoba (id_osoba, jmeno) values (18, 'Kathy Sherratt');
insert into osoba (id_osoba, jmeno) values (19, 'Stormi Alten');
insert into osoba (id_osoba, jmeno) values (20, 'Toddie Harbar');
insert into osoba (id_osoba, jmeno) values (21, 'Vojtech');

select setval(pg_get_serial_sequence('osoba','id_osoba'),21);
insert into osoba (id_osoba, jmeno) values (default, 'Vuk');
insert into osoba (id_osoba, jmeno) values (default, 'Meraj');
insert into osoba (id_osoba, jmeno) values (default, 'Martin');


insert into zamestnanec (id_osoba, pocet_splnenych_kontraktu, vek, popis) values (1, 91, 50, 'Self-enabling solution-oriented Graphic Interface');
insert into zamestnanec (id_osoba, pocet_splnenych_kontraktu, vek, popis) values (2, 13, 16, 'Quality-focused scalable archive');
insert into zamestnanec (id_osoba, pocet_splnenych_kontraktu, vek, popis) values (3, 94, 77, 'Universal coherent orchestration');
insert into zamestnanec (id_osoba, pocet_splnenych_kontraktu, vek, popis) values (4, 17, 46, 'Re-contextualized full-range Graphical User Interface');
insert into zamestnanec (id_osoba, pocet_splnenych_kontraktu, vek, popis) values (5, 97, 15, 'Fully-configurable methodical secured line');
insert into zamestnanec (id_osoba, pocet_splnenych_kontraktu, vek, popis) values (6, 52, 14, 'Cross-group demand-driven success');
insert into zamestnanec (id_osoba, pocet_splnenych_kontraktu, vek, popis) values (7, 73, 45, 'Face to face explicit methodology');
insert into zamestnanec (id_osoba, pocet_splnenych_kontraktu, vek, popis) values (8, 8, 23, 'Pre-emptive foreground hardware');
insert into zamestnanec (id_osoba, pocet_splnenych_kontraktu, vek, popis) values (9, 61, 73, 'Visionary coherent product');
insert into zamestnanec (id_osoba, pocet_splnenych_kontraktu, vek, popis) values (10, 63, 50, 'Operative even-keeled middleware');
insert into zamestnanec (id_osoba, pocet_splnenych_kontraktu, vek, popis) values (11, 60, 30, 'Centralized global architecture');
insert into zamestnanec (id_osoba, pocet_splnenych_kontraktu, vek, popis) values (12, 71, 34, 'Balanced content-based synergy');
insert into zamestnanec (id_osoba, pocet_splnenych_kontraktu, vek, popis) values (13, 85, 51, 'Cloned contextually-based software');
insert into zamestnanec (id_osoba, pocet_splnenych_kontraktu, vek, popis) values (21, 85, 51, 'Cloned software');

insert into zakaznik (id_osoba, id_pokoj, vernostni_bonus) values (1, 10, 9);
insert into zakaznik (id_osoba, id_pokoj, vernostni_bonus) values (2, null, 4);
insert into zakaznik (id_osoba, id_pokoj, vernostni_bonus) values (3, 12, 8);
insert into zakaznik (id_osoba, id_pokoj, vernostni_bonus) values (4, null, 10);
insert into zakaznik (id_osoba, id_pokoj, vernostni_bonus) values (5, 13, 10);
insert into zakaznik (id_osoba, id_pokoj, vernostni_bonus) values (6, 4, 3);
insert into zakaznik (id_osoba, id_pokoj, vernostni_bonus) values (7, 18, 8);
insert into zakaznik (id_osoba, id_pokoj, vernostni_bonus) values (8, 17, 8);
insert into zakaznik (id_osoba, id_pokoj, vernostni_bonus) values (9, 4, 6);
insert into zakaznik (id_osoba, id_pokoj, vernostni_bonus) values (10, 20, 2);
insert into zakaznik (id_osoba, id_pokoj, vernostni_bonus) values (14, null, 0);
insert into zakaznik (id_osoba, id_pokoj, vernostni_bonus) values (15, 11, 0);
insert into zakaznik (id_osoba, id_pokoj, vernostni_bonus) values (16, 17, 0);
insert into zakaznik (id_osoba, id_pokoj, vernostni_bonus) values (18, 21, 2);
insert into zakaznik (id_osoba, id_pokoj, vernostni_bonus) values (19, null, 1);
insert into zakaznik (id_osoba, id_pokoj, vernostni_bonus) values (20, null, 3);
insert into zakaznik (id_osoba, id_pokoj, vernostni_bonus) values (21, null, 3);


insert into prodej (datum, id_osoba, id_zbozi, pocet) values ('2060-07-27', 1, 2, 2);
insert into prodej (datum, id_osoba, id_zbozi, pocet) values ('2060-07-27', 2, 2, 4);
insert into prodej (datum, id_osoba, id_zbozi, pocet) values ('2060-07-29', 3, 2, 8);
insert into prodej (datum, id_osoba, id_zbozi, pocet) values ('2060-07-27', 4, 2, 2);
insert into prodej (datum, id_osoba, id_zbozi, pocet) values ('2060-07-27', 5, 2, 2);
insert into prodej (datum, id_osoba, id_zbozi, pocet) values ('2060-07-27', 6, 2, 2);
insert into prodej (datum, id_osoba, id_zbozi, pocet) values ('2060-07-27', 7, 2, 2);
insert into prodej (datum, id_osoba, id_zbozi, pocet) values ('2060-07-27', 8, 2, 2);
insert into prodej (datum, id_osoba, id_zbozi, pocet) values ('2079-10-14', 9, 2, 8);
insert into prodej (datum, id_osoba, id_zbozi, pocet) values ('2060-07-27', 10, 2, 2);
insert into prodej (datum, id_osoba, id_zbozi, pocet) values ('2060-07-27', 14, 2, 2);
insert into prodej (datum, id_osoba, id_zbozi, pocet) values ('2060-07-27', 15, 2, 2);
insert into prodej (datum, id_osoba, id_zbozi, pocet) values ('2078-08-31', 16, 2, 3);
insert into prodej (datum, id_osoba, id_zbozi, pocet) values ('2060-07-27', 18, 2, 2);
insert into prodej (datum, id_osoba, id_zbozi, pocet) values ('2060-07-27', 19, 2, 2);
insert into prodej (datum, id_osoba, id_zbozi, pocet) values ('2071-12-14', 20, 2, 4);
insert into prodej (datum, id_osoba, id_zbozi, pocet) values ('2071-12-14', 21, 2, 4);

insert into prodej (datum, id_osoba, id_zbozi, pocet) values ('2086-06-25', 1, 5, 1);
insert into prodej (datum, id_osoba, id_zbozi, pocet) values ('2062-11-23', 2, 18, 2);
insert into prodej (datum, id_osoba, id_zbozi, pocet) values ('2062-02-13', 10, 24, 4);
insert into prodej (datum, id_osoba, id_zbozi, pocet) values ('2080-10-05', 2, 23, 6);
insert into prodej (datum, id_osoba, id_zbozi, pocet) values ('2087-08-09', 7, 13, 2);
insert into prodej (datum, id_osoba, id_zbozi, pocet) values ('2076-09-11', 3, 17, 3);
insert into prodej (datum, id_osoba, id_zbozi, pocet) values ('2058-05-26', 5, 9, 3);
insert into prodej (datum, id_osoba, id_zbozi, pocet) values ('2084-04-20', 4, 5, 3);
insert into prodej (datum, id_osoba, id_zbozi, pocet) values ('2066-03-03', 5, 17, 8);
insert into prodej (datum, id_osoba, id_zbozi, pocet) values ('2080-07-06', 9, 24, 9);
insert into prodej (datum, id_osoba, id_zbozi, pocet) values ('2062-11-04', 6, 11, 10);
insert into prodej (datum, id_osoba, id_zbozi, pocet) values ('2087-07-02', 7, 4, 8);
insert into prodej (datum, id_osoba, id_zbozi, pocet) values ('2077-09-12', 9, 13, 5);
insert into prodej (datum, id_osoba, id_zbozi, pocet) values ('2068-01-06', 7, 27, 3);
insert into prodej (datum, id_osoba, id_zbozi, pocet) values ('2077-06-17', 5, 1, 1);
insert into prodej (datum, id_osoba, id_zbozi, pocet) values ('2081-03-08', 6, 29, 6);
insert into prodej (datum, id_osoba, id_zbozi, pocet) values ('2066-01-12', 4, 3, 6);
insert into prodej (datum, id_osoba, id_zbozi, pocet) values ('2068-11-29', 10, 23, 7);
insert into prodej (datum, id_osoba, id_zbozi, pocet) values ('2069-10-04', 16, 26, 3);
insert into prodej (datum, id_osoba, id_zbozi, pocet) values ('2067-03-23', 15, 7, 9);
insert into prodej (datum, id_osoba, id_zbozi, pocet) values ('2060-07-02', 16, 14, 4);
insert into prodej (datum, id_osoba, id_zbozi, pocet) values ('2068-11-20', 14, 10, 8);
insert into prodej (datum, id_osoba, id_zbozi, pocet) values ('2076-12-07', 16, 13, 6);
insert into prodej (datum, id_osoba, id_zbozi, pocet) values ('2073-04-04', 15, 7, 9);
insert into prodej (datum, id_osoba, id_zbozi, pocet) values ('2060-09-19', 15, 4, 7);
insert into prodej (datum, id_osoba, id_zbozi, pocet) values ('2058-04-22', 14, 28, 6);
insert into prodej (datum, id_osoba, id_zbozi, pocet) values ('2057-12-03', 16, 17, 1);
insert into prodej (datum, id_osoba, id_zbozi, pocet) values ('2062-12-21', 19, 5, 6);
insert into prodej (datum, id_osoba, id_zbozi, pocet) values ('2064-09-17', 20, 5, 6);
insert into prodej (datum, id_osoba, id_zbozi, pocet) values ('2086-08-18', 19, 26, 5);
insert into prodej (datum, id_osoba, id_zbozi, pocet) values ('2067-08-10', 20, 14, 1);
insert into prodej (datum, id_osoba, id_zbozi, pocet) values ('2085-10-30', 18, 5, 6);
insert into prodej (datum, id_osoba, id_zbozi, pocet) values ('2078-07-03', 19, 19, 9);
insert into prodej (datum, id_osoba, id_zbozi, pocet) values ('2087-03-31', 18, 26, 2);
insert into prodej (datum, id_osoba, id_zbozi, pocet) values ('2082-05-24', 19, 26, 3);
insert into prodej (datum, id_osoba, id_zbozi, pocet) values ('2070-11-16', 20, 3, 1);
insert into prodej (datum, id_osoba, id_zbozi, pocet) values ('2070-11-16', 21, 31, 1);
insert into prodej (datum, id_osoba, id_zbozi, pocet) values ('2070-11-16', 1, 31, 1);


insert into najd_a_zabij (id_ukol, cil, popis) values (1, 'Pattin Utting', 'Persevering local data-warehouse');
insert into najd_a_zabij (id_ukol, cil, popis) values (2, 'Bria Stanger', 'Vision-oriented homogeneous toolset');
insert into najd_a_zabij (id_ukol, cil, popis) values (3, 'Kendre Rizzo', 'Persevering radical moderator');
insert into najd_a_zabij (id_ukol, cil, popis) values (4, 'Pincus Jarrel', 'Front-line reciprocal data-warehouse');
insert into najd_a_zabij (id_ukol, cil, popis) values (5, 'Giorgi Karpman', 'Face to face composite functionalities');
insert into najd_a_zabij (id_ukol, cil, popis) values (6, 'Stacie De Francisci', 'Ameliorated didactic system engine');
insert into najd_a_zabij (id_ukol, cil, popis) values (7, 'Trix Burchmore', 'Ameliorated systematic encoding');
insert into najd_a_zabij (id_ukol, cil, popis) values (8, 'Scott Reiach', 'Object-based 5th generation productivity');
insert into najd_a_zabij (id_ukol, cil, popis) values (9, 'Mae Montague', 'Object-based bifurcated functionalities');
insert into najd_a_zabij (id_ukol, cil, popis) values (10, 'Bili Stowell', 'Total 5th generation ability');

select setval(pg_get_serial_sequence('najd_a_zabij','id_ukol'),10);

insert into prevoz_zbozi (id_ukol, typ_naklad, hmotnost_naklad, odkud, kam) values (1, 'Parts', 2948, 'Pechenga', 'Bantar');
insert into prevoz_zbozi (id_ukol, typ_naklad, hmotnost_naklad, odkud, kam) values (2, 'Combined', 1900, 'Bajiao', 'Mateus Leme');
insert into prevoz_zbozi (id_ukol, typ_naklad, hmotnost_naklad, odkud, kam) values (3, 'Secret', 1603, 'Yŏnggwang-ŭp', 'Charneca');
insert into prevoz_zbozi (id_ukol, typ_naklad, hmotnost_naklad, odkud, kam) values (4, 'Parts', 1623, 'Ambositra', 'Botshabelo');
insert into prevoz_zbozi (id_ukol, typ_naklad, hmotnost_naklad, odkud, kam) values (5, 'Parts', 2428, 'Chŏngju', 'Caikouji');
insert into prevoz_zbozi (id_ukol, typ_naklad, hmotnost_naklad, odkud, kam) values (6, 'Money', 630, 'Mmathubudukwane', 'Srbica');
insert into prevoz_zbozi (id_ukol, typ_naklad, hmotnost_naklad, odkud, kam) values (7, 'Parts', 561, 'Bayeux', 'Yanjiang');
insert into prevoz_zbozi (id_ukol, typ_naklad, hmotnost_naklad, odkud, kam) values (8, 'Weapons', 2992, 'Novospasskoye', 'Sundbyberg');
insert into prevoz_zbozi (id_ukol, typ_naklad, hmotnost_naklad, odkud, kam) values (9, 'Food', 2229, 'Xibali', 'Gobernador Ingeniero Valentín Virasoro');
insert into prevoz_zbozi (id_ukol, typ_naklad, hmotnost_naklad, odkud, kam) values (10, 'Secret', 2888, 'Nanfeng', 'Tatariv');
insert into prevoz_zbozi (id_ukol, typ_naklad, hmotnost_naklad, odkud, kam) values (11, 'Parts', 2071, 'Langpas', 'Lennec');
insert into prevoz_zbozi (id_ukol, typ_naklad, hmotnost_naklad, odkud, kam) values (12, 'Secret', 1903, 'Haiyangsuo', 'Reston');
insert into prevoz_zbozi (id_ukol, typ_naklad, hmotnost_naklad, odkud, kam) values (13, 'Combined', 749, 'Bitanjuan', 'Cimanggu');
insert into prevoz_zbozi (id_ukol, typ_naklad, hmotnost_naklad, odkud, kam) values (14, 'Food', 1912, 'Yelizovo', 'Järfälla');
insert into prevoz_zbozi (id_ukol, typ_naklad, hmotnost_naklad, odkud, kam) values (15, 'Weapons', 1382, 'Rufino', 'Miliangju');
insert into prevoz_zbozi (id_ukol, typ_naklad, hmotnost_naklad, odkud, kam) values (16, 'Weapons', 2500, 'Bajiao', 'Järfälla');
insert into prevoz_zbozi (id_ukol, typ_naklad, hmotnost_naklad, odkud, kam) values (17, 'Combined', 250, 'Bajiao', 'Caikouji');


select setval(pg_get_serial_sequence('prevoz_zbozi','id_ukol'),17);

insert into ostatni (id_ukol, popis) values (1, 'Total solution-oriented support');
insert into ostatni (id_ukol, popis) values (2, 'Grass-roots methodical firmware');
insert into ostatni (id_ukol, popis) values (3, 'Re-engineered actuating hardware');
insert into ostatni (id_ukol, popis) values (4, 'Public-key user-facing groupware');
insert into ostatni (id_ukol, popis) values (5, 'User-friendly non-volatile matrices');
insert into ostatni (id_ukol, popis) values (6, 'Quality-focused global installation');
insert into ostatni (id_ukol, popis) values (7, 'Self-enabling grid-enabled approach');
insert into ostatni (id_ukol, popis) values (8, 'Synergistic grid-enabled capability');
insert into ostatni (id_ukol, popis) values (9, 'Proactive national budgetary management');
insert into ostatni (id_ukol, popis) values (10, 'Cloned explicit projection');
insert into ostatni (id_ukol, popis) values (11, 'Cloned projection');

select setval(pg_get_serial_sequence('ostatni','id_ukol'),11);

insert into kontrakt (id_kontrakt, id_ukol, ostatni_id_ukol, prevoz_zbozi_id_ukol, id_osoba, odmena, uspesne_splneno) values (1, null, 1, null, 8, 72955, true);
insert into kontrakt (id_kontrakt, id_ukol, ostatni_id_ukol, prevoz_zbozi_id_ukol, id_osoba, odmena, uspesne_splneno) values (2, 2, null, null, 7, 81472, false);
insert into kontrakt (id_kontrakt, id_ukol, ostatni_id_ukol, prevoz_zbozi_id_ukol, id_osoba, odmena, uspesne_splneno) values (3, null, 9, null, 9, 14655, true);
insert into kontrakt (id_kontrakt, id_ukol, ostatni_id_ukol, prevoz_zbozi_id_ukol, id_osoba, odmena, uspesne_splneno) values (4, null, 7, null, 9, 11604, true);
insert into kontrakt (id_kontrakt, id_ukol, ostatni_id_ukol, prevoz_zbozi_id_ukol, id_osoba, odmena, uspesne_splneno) values (5, null, null, 7, 9, 80260, false);
insert into kontrakt (id_kontrakt, id_ukol, ostatni_id_ukol, prevoz_zbozi_id_ukol, id_osoba, odmena, uspesne_splneno) values (6, 5, null, null, 12, 26190, false);
insert into kontrakt (id_kontrakt, id_ukol, ostatni_id_ukol, prevoz_zbozi_id_ukol, id_osoba, odmena, uspesne_splneno) values (7, null, 4, null, 13, 79966, false);
insert into kontrakt (id_kontrakt, id_ukol, ostatni_id_ukol, prevoz_zbozi_id_ukol, id_osoba, odmena, uspesne_splneno) values (8, 6, null, null, 1, 48785, true);
insert into kontrakt (id_kontrakt, id_ukol, ostatni_id_ukol, prevoz_zbozi_id_ukol, id_osoba, odmena, uspesne_splneno) values (9, 4, null, null, 1, 43266, true);
insert into kontrakt (id_kontrakt, id_ukol, ostatni_id_ukol, prevoz_zbozi_id_ukol, id_osoba, odmena, uspesne_splneno) values (10, null, 5, null, 13, 98482, false);
insert into kontrakt (id_kontrakt, id_ukol, ostatni_id_ukol, prevoz_zbozi_id_ukol, id_osoba, odmena, uspesne_splneno) values (11, null, 3, null, 5, 64007, false);
insert into kontrakt (id_kontrakt, id_ukol, ostatni_id_ukol, prevoz_zbozi_id_ukol, id_osoba, odmena, uspesne_splneno) values (12, 10, null, null, 9, 33003, false);
insert into kontrakt (id_kontrakt, id_ukol, ostatni_id_ukol, prevoz_zbozi_id_ukol, id_osoba, odmena, uspesne_splneno) values (13, 4, null, null, 6, 63885, true);
insert into kontrakt (id_kontrakt, id_ukol, ostatni_id_ukol, prevoz_zbozi_id_ukol, id_osoba, odmena, uspesne_splneno) values (14, 3, null, null, 12, 97553, false);
insert into kontrakt (id_kontrakt, id_ukol, ostatni_id_ukol, prevoz_zbozi_id_ukol, id_osoba, odmena, uspesne_splneno) values (15, 8, null, null, 12, 71605, false);
insert into kontrakt (id_kontrakt, id_ukol, ostatni_id_ukol, prevoz_zbozi_id_ukol, id_osoba, odmena, uspesne_splneno) values (16, null, 4, null, 5, 27121, false);
insert into kontrakt (id_kontrakt, id_ukol, ostatni_id_ukol, prevoz_zbozi_id_ukol, id_osoba, odmena, uspesne_splneno) values (17, 6, null, null, 5, 63260, false);
insert into kontrakt (id_kontrakt, id_ukol, ostatni_id_ukol, prevoz_zbozi_id_ukol, id_osoba, odmena, uspesne_splneno) values (18, 8, null, null, 10, 41878, null);
insert into kontrakt (id_kontrakt, id_ukol, ostatni_id_ukol, prevoz_zbozi_id_ukol, id_osoba, odmena, uspesne_splneno) values (19, null, 7, null, 3, 71123, true);
insert into kontrakt (id_kontrakt, id_ukol, ostatni_id_ukol, prevoz_zbozi_id_ukol, id_osoba, odmena, uspesne_splneno) values (20, 4, null, null, 3, 54056, false);
insert into kontrakt (id_kontrakt, id_ukol, ostatni_id_ukol, prevoz_zbozi_id_ukol, id_osoba, odmena, uspesne_splneno) values (21, null, null, 14, 6, 53636, false);
insert into kontrakt (id_kontrakt, id_ukol, ostatni_id_ukol, prevoz_zbozi_id_ukol, id_osoba, odmena, uspesne_splneno) values (22, null, null, 3, 7, 21787, false);
insert into kontrakt (id_kontrakt, id_ukol, ostatni_id_ukol, prevoz_zbozi_id_ukol, id_osoba, odmena, uspesne_splneno) values (23, 4, null, null, 3, 18918, true);
insert into kontrakt (id_kontrakt, id_ukol, ostatni_id_ukol, prevoz_zbozi_id_ukol, id_osoba, odmena, uspesne_splneno) values (24, null, null, 13, 11, 95375, false);
insert into kontrakt (id_kontrakt, id_ukol, ostatni_id_ukol, prevoz_zbozi_id_ukol, id_osoba, odmena, uspesne_splneno) values (25, 8, null, null, 3, 38310, true);
insert into kontrakt (id_kontrakt, id_ukol, ostatni_id_ukol, prevoz_zbozi_id_ukol, id_osoba, odmena, uspesne_splneno) values (26, null, 6, null, 6, 75855, false);
insert into kontrakt (id_kontrakt, id_ukol, ostatni_id_ukol, prevoz_zbozi_id_ukol, id_osoba, odmena, uspesne_splneno) values (27, null, 1, null, 10, 68836, false);
insert into kontrakt (id_kontrakt, id_ukol, ostatni_id_ukol, prevoz_zbozi_id_ukol, id_osoba, odmena, uspesne_splneno) values (28, null, null, 14, 10, 31854, false);
insert into kontrakt (id_kontrakt, id_ukol, ostatni_id_ukol, prevoz_zbozi_id_ukol, id_osoba, odmena, uspesne_splneno) values (29, 9, null, null, 3, 28253, null);
insert into kontrakt (id_kontrakt, id_ukol, ostatni_id_ukol, prevoz_zbozi_id_ukol, id_osoba, odmena, uspesne_splneno) values (30, 7, null, null, 13, 29075, false);
insert into kontrakt (id_kontrakt, id_ukol, ostatni_id_ukol, prevoz_zbozi_id_ukol, id_osoba, odmena, uspesne_splneno) values (31, null, null, 11, 1, 91270, null);
insert into kontrakt (id_kontrakt, id_ukol, ostatni_id_ukol, prevoz_zbozi_id_ukol, id_osoba, odmena, uspesne_splneno) values (32, 7, null, null, 6, 48848, false);
insert into kontrakt (id_kontrakt, id_ukol, ostatni_id_ukol, prevoz_zbozi_id_ukol, id_osoba, odmena, uspesne_splneno) values (33, null, 8, null, 13, 22419, false);
insert into kontrakt (id_kontrakt, id_ukol, ostatni_id_ukol, prevoz_zbozi_id_ukol, id_osoba, odmena, uspesne_splneno) values (34, null, null, 6, 13, 79950, true);
insert into kontrakt (id_kontrakt, id_ukol, ostatni_id_ukol, prevoz_zbozi_id_ukol, id_osoba, odmena, uspesne_splneno) values (35, null, 7, null, 5, 72887, true);
insert into kontrakt (id_kontrakt, id_ukol, ostatni_id_ukol, prevoz_zbozi_id_ukol, id_osoba, odmena, uspesne_splneno) values (36, null, 1, null, 13, 62094, true);
insert into kontrakt (id_kontrakt, id_ukol, ostatni_id_ukol, prevoz_zbozi_id_ukol, id_osoba, odmena, uspesne_splneno) values (37, null, 6, null, 3, 51939, true);
insert into kontrakt (id_kontrakt, id_ukol, ostatni_id_ukol, prevoz_zbozi_id_ukol, id_osoba, odmena, uspesne_splneno) values (38, 1, null, null, 12, 14408, true);
insert into kontrakt (id_kontrakt, id_ukol, ostatni_id_ukol, prevoz_zbozi_id_ukol, id_osoba, odmena, uspesne_splneno) values (39, null, null, 9, 8, 67127, false);
insert into kontrakt (id_kontrakt, id_ukol, ostatni_id_ukol, prevoz_zbozi_id_ukol, id_osoba, odmena, uspesne_splneno) values (40, 2, null, null, 7, 63396, false);

select setval(pg_get_serial_sequence('kontrakt','id_kontrakt'),40);
