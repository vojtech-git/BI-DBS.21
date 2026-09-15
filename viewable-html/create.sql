-- odeberu pokud existuje funkce na oodebrání tabulek a sekvencí
DROP FUNCTION IF EXISTS remove_all();

-- vytvořím funkci která odebere tabulky a sekvence
-- chcete také umět psát PLSQL? Zapište si předmět BI-SQL ;-)
CREATE or replace FUNCTION remove_all() RETURNS void AS $$
DECLARE
    rec RECORD;
    cmd text;
BEGIN
    cmd := '';

    FOR rec IN SELECT
            'DROP SEQUENCE ' || quote_ident(n.nspname) || '.'
                || quote_ident(c.relname) || ' CASCADE;' AS name
        FROM
            pg_catalog.pg_class AS c
        LEFT JOIN
            pg_catalog.pg_namespace AS n
        ON
            n.oid = c.relnamespace
        WHERE
            relkind = 'S' AND
            n.nspname NOT IN ('pg_catalog', 'pg_toast') AND
            pg_catalog.pg_table_is_visible(c.oid)
    LOOP
        cmd := cmd || rec.name;
    END LOOP;

    FOR rec IN SELECT
            'DROP TABLE ' || quote_ident(n.nspname) || '.'
                || quote_ident(c.relname) || ' CASCADE;' AS name
        FROM
            pg_catalog.pg_class AS c
        LEFT JOIN
            pg_catalog.pg_namespace AS n
        ON
            n.oid = c.relnamespace WHERE relkind = 'r' AND
            n.nspname NOT IN ('pg_catalog', 'pg_toast') AND
            pg_catalog.pg_table_is_visible(c.oid)
    LOOP
        cmd := cmd || rec.name;
    END LOOP;

    EXECUTE cmd;
    RETURN;
END;
$$ LANGUAGE plpgsql;
-- zavolám funkci co odebere tabulky a sekvence - Mohl bych dropnout celé schéma a znovu jej vytvořit, použíjeme však PLSQL
select remove_all();


CREATE TABLE kontrakt (
    id_kontrakt SERIAL NOT NULL,
    id_ukol INTEGER,
    ostatni_id_ukol INTEGER,
    prevoz_zbozi_id_ukol INTEGER,
    id_osoba INTEGER NOT NULL,
    odmena INTEGER NOT NULL,
    uspesne_splneno BOOLEAN
);
ALTER TABLE kontrakt ADD CONSTRAINT pk_kontrakt PRIMARY KEY (id_kontrakt);

CREATE TABLE najd_a_zabij (
    id_ukol SERIAL NOT NULL,
    cil VARCHAR(80) NOT NULL,
    popis VARCHAR(256) NOT NULL
);
ALTER TABLE najd_a_zabij ADD CONSTRAINT pk_najd_a_zabij PRIMARY KEY (id_ukol);

CREATE TABLE osoba (
    id_osoba SERIAL NOT NULL,
    jmeno VARCHAR(80) NOT NULL
);
ALTER TABLE osoba ADD CONSTRAINT pk_osoba PRIMARY KEY (id_osoba);

CREATE TABLE ostatni (
    id_ukol SERIAL NOT NULL,
    popis VARCHAR(256) NOT NULL
);
ALTER TABLE ostatni ADD CONSTRAINT pk_ostatni PRIMARY KEY (id_ukol);

CREATE TABLE pokoj (
    id_pokoj SERIAL NOT NULL,
    pocet_postel INTEGER NOT NULL
);
ALTER TABLE pokoj ADD CONSTRAINT pk_pokoj PRIMARY KEY (id_pokoj);

CREATE TABLE prevoz_zbozi (
    id_ukol SERIAL NOT NULL,
    typ_naklad VARCHAR(30) NOT NULL,
    hmotnost_naklad INTEGER NOT NULL,
    odkud VARCHAR(80) NOT NULL,
    kam VARCHAR(80) NOT NULL
);
ALTER TABLE prevoz_zbozi ADD CONSTRAINT pk_prevoz_zbozi PRIMARY KEY (id_ukol);

CREATE TABLE prodej (
    datum DATE NOT NULL,
    id_osoba INTEGER NOT NULL,
    id_zbozi INTEGER NOT NULL,
    pocet INTEGER NOT NULL
);
ALTER TABLE prodej ADD CONSTRAINT pk_prodej PRIMARY KEY (datum, id_osoba, id_zbozi);

CREATE TABLE zakaznik (
    id_osoba INTEGER NOT NULL,
    id_pokoj INTEGER,
    vernostni_bonus INTEGER NOT NULL
);
ALTER TABLE zakaznik ADD CONSTRAINT pk_zakaznik PRIMARY KEY (id_osoba);

CREATE TABLE zamestnanec (
    id_osoba INTEGER NOT NULL,
    pocet_splnenych_kontraktu INTEGER NOT NULL,
    vek INTEGER NOT NULL,
    popis VARCHAR(256) NOT NULL
);
ALTER TABLE zamestnanec ADD CONSTRAINT pk_zamestnanec PRIMARY KEY (id_osoba);

CREATE TABLE zbozi (
    id_zbozi SERIAL NOT NULL,
    nazev VARCHAR(40) NOT NULL,
    pocet INTEGER NOT NULL
);
ALTER TABLE zbozi ADD CONSTRAINT pk_zbozi PRIMARY KEY (id_zbozi);

ALTER TABLE kontrakt ADD CONSTRAINT fk_kontrakt_najd_a_zabij FOREIGN KEY (id_ukol) REFERENCES najd_a_zabij (id_ukol) ON DELETE CASCADE;
ALTER TABLE kontrakt ADD CONSTRAINT fk_kontrakt_ostatni FOREIGN KEY (ostatni_id_ukol) REFERENCES ostatni (id_ukol) ON DELETE CASCADE;
ALTER TABLE kontrakt ADD CONSTRAINT fk_kontrakt_prevoz_zbozi FOREIGN KEY (prevoz_zbozi_id_ukol) REFERENCES prevoz_zbozi (id_ukol) ON DELETE CASCADE;
ALTER TABLE kontrakt ADD CONSTRAINT fk_kontrakt_zamestnanec FOREIGN KEY (id_osoba) REFERENCES zamestnanec (id_osoba) ON DELETE CASCADE;

ALTER TABLE prodej ADD CONSTRAINT fk_prodej_zakaznik FOREIGN KEY (id_osoba) REFERENCES zakaznik (id_osoba) ON DELETE CASCADE;
ALTER TABLE prodej ADD CONSTRAINT fk_prodej_zbozi FOREIGN KEY (id_zbozi) REFERENCES zbozi (id_zbozi) ON DELETE CASCADE;

ALTER TABLE zakaznik ADD CONSTRAINT fk_zakaznik_osoba FOREIGN KEY (id_osoba) REFERENCES osoba (id_osoba) ON DELETE CASCADE;
ALTER TABLE zakaznik ADD CONSTRAINT fk_zakaznik_pokoj FOREIGN KEY (id_pokoj) REFERENCES pokoj (id_pokoj) ON DELETE CASCADE;

ALTER TABLE zamestnanec ADD CONSTRAINT fk_zamestnanec_osoba FOREIGN KEY (id_osoba) REFERENCES osoba (id_osoba) ON DELETE CASCADE;

ALTER TABLE kontrakt ADD CONSTRAINT xc_kontrakt_id_ukol_ostatni_id_ CHECK ((id_ukol IS NOT NULL AND ostatni_id_ukol IS NULL AND prevoz_zbozi_id_ukol IS NULL) OR (id_ukol IS NULL AND ostatni_id_ukol IS NOT NULL AND prevoz_zbozi_id_ukol IS NULL) OR (id_ukol IS NULL AND ostatni_id_ukol IS NULL AND prevoz_zbozi_id_ukol IS NOT NULL));
