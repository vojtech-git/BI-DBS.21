# Semestrální práce z předmětu Databázové systémy: Lazarova hospoda

## Popis

V dobrodružném vesmíru počítačové hry Lazarovi Parťáci žije Lazar princ J-Manovy říše. Po životě plném hrdinských činů se rozhodl že svá zlatá léta hodlá dožít v klidu. Proto si ve vysokém věku 31 let otevřel svou vesmírnou hospůdku. Pro spravný chod bude potřebovat vymakanou databazi.

Jelikož se hodlá věnovat i prodeji a směně unikátního Zboží a vzácnosti bude muset zaznamenávat co vlastni a chce prodat. Bude pro něj duležité hlavně za kolik, komu a kdy předmět prodal.

Lazar se ve svém volném čase také rád zabýva organizovaním vesmírných kontraktů proto je potřeba zaznamenávat kontrakty které mužou plnit pracovnici na volne noze. Jednotlivé vesmírné kontrakty budou detailně rezepsany do nejmenších podrobností aby se pracovníci mohli informovaně rozhodnout zda ukol přijmou, jestli je k splnění potřeba vybavení případně zda ukol vyzaduje tým pracovníků. Kontrakt bude obsahovat informaci o výši odměny a bude označený podle stavu. V kontraktu bude zaznamenáno zda byl úspěšně dokončen.

Vesmírný kontrakt bude vždy mezi Lazarem a jednotlivými zaměstnanci a musí se týkat právě jednoho úkolu na kterém může zaměstnanec pracovat sám a nebo může spolupracovat s dalšími zaměstnanci. Lazarova hospoda nabízí dva standardní typy úkolu najdi a zneškodno nebo převoz zboží. Pokud úkol nelze zařadit do standardní kategorie je zařazen do kategorie ostatní. Jednotlivé úkoly budou obsahovat již zmíněné specifikace a budou vystaveny na tabuli úkolů v hospodě tak aby každý mohl zvážit zda jej chce plnit.

K vesmírným kontraktům se budou moci přihlašovat Zaměstnanci. U zaměstnance budou podstatné jeho osobní informace (jméno, příjmení, osobní identifikator obcana J-Manovy Říše (OIOJR) a počet splněných úkolů) a podle jejich počtu splněných prací se bude rozhodovat o bonusech.

Zákazník bude kdokoliv kdo si koupí nějaké zboží nebo pronajme pokoj.

V hospodě je možné si rezervovat pokoj. O pokoji bude v databázi zaznamenána jeho velikost, počet postelí a zda je v ceně zahrnuta údrzba. Pokoj si může rezervovat jednotlvý zakazník.

## Diagram

![Diagram](diagram_white_background.png)

## Relační schéma

![Relational Schema](relational_schema.png)

## Create script

```sql
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

```

## Insert script

![Insert Script](insert.sql)

## Dotazy

### Vsechny osoby, ktere jsou zakaznici a jejich vernostni bonus.

Kategorie:
A F2

#### RA

```
{osoba[osoba.id_osoba = zakaznik.id_osoba]zakaznik}
[id_osoba, jmeno, vernostni_bonus]
```

#### SQL

```
SELECT osoba.*, zakaznik.vernostni_bonus
FROM osoba
JOIN zakaznik USING (id_osoba)
;
```

### Vypis vsechny atributy osob, ktere nejsou zamestnanci. 

Kategorie:
B G1

#### RA

```
osoba!<*zamestnanec
```

#### SQL

```
select osoba.*
from osoba
where id_osoba not in (
    select id_osoba
    from zamestnanec
)
;
```

### Pokoj na kterem spi pouze zakaznik "Kathy Sherratt". 

Kategorie:
C F1 F2 G2 H2

#### RA

```
{pokoj<*{zakaznik[zakaznik.id_osoba = osoba.id_osoba]osoba(jmeno='Kathy Sherratt')}}
\
{pokoj<*{zakaznik[zakaznik.id_osoba = osoba.id_osoba]osoba(jmeno!='Kathy Sherratt')}}
```

#### SQL

```
select distinct id_pokoj, pocet_postel
from pokoj
natural join (
    select distinct zakaznik.id_osoba, zakaznik.id_pokoj, zakaznik.vernostni_bonus, r1.id_osoba as id_osoba_1, r1.jmeno
    from zakaznik
    join (
        select distinct *
        from osoba
        where jmeno = 'Kathy Sherratt'
    ) r1 on zakaznik.id_osoba = r1.id_osoba
) r2
except
select distinct id_pokoj, pocet_postel
from pokoj pokoj1
natural join (
    select distinct zakaznik1.id_osoba, zakaznik1.id_pokoj, zakaznik1.vernostni_bonus, r3.id_osoba as id_osoba_1, r3.jmeno
    from zakaznik zakaznik1
    join (
        select distinct *
        from osoba osoba1
        where jmeno != 'Kathy Sherratt'
    ) r3 on zakaznik1.id_osoba = r3.id_osoba
) r4;
```

### Zbozi, ktere si koupili vsichni zakaznici.

Kategorie:
D1 G1 G4

#### RA

```
zbozi_vsechno:=zbozi[id_zbozi]
zakaznici:=zakaznik[id_osoba]
vsechny_kombinace:=zbozi_vsechno×zakaznici
realne_kombinace:=prodej[id_zbozi, id_osoba]
nenastale_kombinace:=vsechny_kombinace\realne_kombinace
zbozi_ktere_neprodalo_vsem:=nenastale_kombinace[id_zbozi]
zbozi_ktere_prodalo_vsem:=zbozi[id_zbozi]\zbozi_ktere_neprodalo_vsem
zbozi_ktere_prodalo_vsem*zbozi
```

#### SQL

```
select *
from zbozi z where not exists(
    select *
    from zakaznik o
    where not exists(
        select z
        from prodej p
        where o.id_osoba = p.id_osoba and z.id_zbozi = p.id_zbozi
    )
)
```

### Kontrola dotazu: Zbozi, ktere si koupili vsichni zakaznici.

Kategorie:
D2 F2 G1 G4 H2

#### SQL

```
select *
from zakaznik

except

select o.*
from zakaznik o
join prodej p using(id_osoba)
where id_zbozi = (
    select id_zbozi
    from zbozi z where not exists(
        select *
        from zakaznik o
        where not exists(
            select z
            from prodej p
            where o.id_osoba = p.id_osoba and z.id_zbozi = p.id_zbozi
        )
    )
)
;
```

### Vytvor pohled obsazenych pokoju na kterych bydli verni zakaznici. 

Kategorie:
G1 G4 L

#### SQL

```
create or replace view pokoje as
select * from pokoj p
where p.pocet_postel > 2
and exists (
  select * from zakaznik z
  where z.id_pokoj = p.id_pokoj and z.vernostni_bonus > 3
);

select * from pokoje;
```

### Vytvor pohled obsazenych pokoju na kterych bydli verni zakaznici a z nich vyber pokoje ktere maji pocet posteli vetsi jak 9.

Kategorie:
G1 G4 L M

#### SQL

```
create or replace view pokoje as
select * from pokoj p
where p.pocet_postel > 2
and exists (
  select * from zakaznik z
  where z.id_pokoj = p.id_pokoj and z.vernostni_bonus > 3
);

select * from pokoje
where pocet_postel > 9;
```

### Smaz osoby ktere nejsou zakaznici ani zamestnanci. 

Kategorie:
G1 H1 P

#### SQL

```
begin;

select * from osoba;

delete from osoba where id_osoba not in (
  select a.id_osoba from zakaznik a
  union
  select z.id_osoba from zamestnanec z
);

select * from osoba;

rollback;
```

### Pro kazdy typ nakladu spocitej kolik se odvezlo kg. Zajima nas pouze naklad odvezeny z mesta Bajiao a jen ty typy kterych se dohromady odvezlo vice jak 2000kg. Vysledek serad podle velikosti celkoveho odvezeneho nakladu. 

Kategorie:
I1 I2 K

#### SQL

```
select typ_naklad, sum(hmotnost_naklad) as celkove_odvezeno_kg
from prevoz_zbozi
where odkud='Bajiao'
group by typ_naklad
having sum(hmotnost_naklad)>2000
order by celkove_odvezeno_kg desc
```

### Najdi vsechny zamestnance, kteri jsou zaroven zakaznici a vypis i ty co nejsou zakaznici. 

Kategorie:
A F2 F4

#### SQL

```
select *
from zamestnanec
left join zakaznik using(id_osoba)
```

### Vsichni zakaznici, kteri jsou zaroven zamestnanci. 

Kategorie:
A F2 F5

#### SQL

```
select *
from zakaznik
full join zamestnanec using(id_osoba)
```

### Spocitej kolik kontraktu plni nebo splnil kazdy zamestnanec.

Kategorie:
A F2 G3 I1

#### SQL

```
select o.jmeno, (select count(*) from kontrakt k where k.id_osoba = z.id_osoba) as pocet_kontraktu
from zamestnanec z
join osoba o using(id_osoba);
```

### Najdi osoby ktere jsou zamestnanci a vypis ktere plni kontrakty a jakou odmenu dostanou.

Kategorie:
A F2 G2

#### SQL

```
select o.jmeno, g.id_kontrakt, g.odmena
from (
    select k.id_kontrakt, k.odmena, z.id_osoba from kontrakt k
    join zamestnanec z using(id_osoba)
) as g
join osoba o using(id_osoba)
```

### Kolik by probehlo nakupu pokud by si kazdy zamestnanec koupil od kazdeho druhu zbozi alespon 1 kus.

Kategorie:
F3 I1

#### SQL

```
select count(*) as pocet_nakupu
from zbozi
cross join zakaznik;
```

### Osoby co nemaji zadny kontrakt a nebydli na zadnem pokoji.

Kategorie:
G1 H3

#### SQL

```
select id_osoba
from zamestnanec
where id_osoba not in(
    select id_osoba
    from kontrakt
)
intersect
select id_osoba
from zakaznik
where id_pokoj is null
```

### Zamestnanci kteri nemaji zadne kontrakty

Kategorie:
A F2 G1 G4 H2 J

#### SQL

```
select id_osoba
from zamestnanec
where id_osoba not in(
    select id_osoba
    from kontrakt
);

select id_osoba
from zamestnanec z
where not exists(
    select 3
    from kontrakt k
    where k.id_osoba = z.id_osoba
);

select id_osoba
from zamestnanec
except
select id_osoba from zamestnanec join kontrakt using(id_osoba);
```

### Zmen popis zamestnance s popisem 'Pre-emptive foreground hardware' na popis 'neco' pokud ma tento zamestnanec alespon jeden uspesne splneny kontrakt.

Kategorie:
G1 O

#### SQL

```
begin;

select *
from zamestnanec
where popis='Pre-emptive foreground hardware';

update zamestnanec
set popis = 'neco'
where popis = 'Pre-emptive foreground hardware'
and id_osoba in (
select id_osoba
from kontrakt
where uspesne_splneno = 'true'
);
```

### Vyber osoby ktere nejsou ani zakaznik ani zamestnanec a pridej je do zakazniku.

Kategorie:
G1 H1 I1 N

#### SQL

```
begin;

select count(*)
from osoba
where id_osoba not in(
    select id_osoba
    from zamestnanec
    union
    select id_osoba
    from zakaznik
);

insert into zakaznik(id_osoba, id_pokoj, vernostni_bonus)
select id_osoba, null as id_pokoj, 0 as vernostni_bonus
from osoba
where id_osoba not in(
    select id_osoba
    from zamestnanec
    union
    select id_osoba
    from zakaznik
);

select count(*)
from osoba
where id_osoba not in(
    select id_osoba
    from zamestnanec
    union
    select id_osoba
    from zakaznik
);

rollback;
```

### Vypis vsechny kontrakty ktere se vazou na typ ukolu prevoz_zbozi a plni je nebo je splnil zamestnanec ktery je starsi nez 20 let.

Kategorie:
G1

#### SQL

```
select *
from kontrakt
where prevoz_zbozi_id_ukol is not null and id_osoba in(
    select id_osoba
    from zamestnanec z
    where z.vek > 20
)
;
```

### Vypis vsechny nakupy ktere probehly pred 18.3.2035 a zaroven vypis jmeno toho kdo nakupoval.

Kategorie:
A F1

#### RA
```
prodej(datum>'18.3.2077')[prodej.id_osoba = osoba.id_osoba]osoba
```

#### SQL

```
SELECT *
FROM prodej
JOIN osoba ON prodej.id_osoba = osoba.id_osoba
WHERE datum > '2077-03-18';
```

### Ukol typu ostatni ktery nikdo neplni.

Kategorie:
G1 G4

#### RA
```
ostatni!<ostatni.id_ukol=kontrakt.ostatni_id_ukol]kontrakt
```

#### SQL

```
select distinct *
from ostatni o
where not exists(
    select *
    from kontrakt
    where o.id_ukol = kontrakt.ostatni_id_ukol
)
```

### Zbozi ktere si koupil osoba "Vojtech".

Kategorie:
A F2

#### RA

```
osoba(jmeno='Vojtech')[osoba.id_osoba=prodej.id_osoba]prodej[prodej.id_zbozi = zbozi.id_zbozi>zbozi```
```

#### SQL

```sql
select z.*
from zbozi z
join prodej using(id_zbozi)
join osoba using(id_osoba)
where jmeno='Vojtech'
```

### Vsichni zakaznici kteri si rezervuji pokoj. 

Kategorie:
A F2

#### RA

```
{zakaznik[zakaznik.id_pokoj = pokoj.id_pokoj]pokoj}[zakaznik.id_pokoj ,zakaznik.id_osoba, zakaznik.vernostni_bonus, pokoj.pocet_postel]
```

#### SQL

```sql
select *
from zakaznik
join pokoj using(id_pokoj)
```

### Vsechny osoby ktere jsou zakaznici a zamestnanci zaroven.

Kategorie:
A F1

#### RA

```
{zakaznik[zakaznik.id_osoba = zamestnanec.id_osoba]zamestnanec}[zakaznik.id_osoba, zakaznik.vernostni_bonus, zamestnanec.vek, zamestnanec.popis]
```

#### SQL

```sql
select z.id_osoba,
        z.vernostni_bonus,
        zm.vek,
        zm.popis
from zakaznik z
join zamestnanec zm on zm.id_osoba = z.id_osoba
```

### Vyber vsechny kontrakty ktere jsou spojene s ukolem typu prevoz zbozi a vyber jenom typ nakladu, hmotnost nakladu, odkud a kam. 

Kategorie:
A F1

#### RA

```
{zakaznik[zakaznik.id_osoba = zamestnanec.id_osoba]zamestnanec}[zakaznik.id_osoba, zakaznik.vernostni_bonus, zamestnanec.vek, zamestnanec.popis]
```

#### SQL

```sql
select distinct typ_naklad, hmotnost_naklad, odkud, kam
from kontrakt k
join prevoz_zbozi pz on k.prevoz_zbozi_id_ukol = pz.id_ukol
```

## Kategorie dotazů
```
A 	A - Positive query on at least two joined tables 	D1 D10 D11 D12 D13 D16 D20 D22 D23 D24 D25
AR 	A (RA) - Positive query on at least two joined tables 	D1 D20 D22 D23 D24 D25
B 	B - Negative query on at least two joined tables 	D2
C 	C - Select only those related to... 	D3
D1 	D1 - Select all related to - universal quantification query 	D4
D2 	D2 - Result check of D1 query 	D5
F1 	F1 - JOIN ON 	D3 D20 D24 D25
F2  F2 - NATURAL JOIN|JOIN USING 	D1 D3 D5 D10 D11 D12 D13 D16 D22 D23
F2_R  F2 (RA) - NATURAL JOIN|JOIN USING 	D1 D3 D22 D23
F3 	F3 - CROSS JOIN 	D14
F4 	F4 - LEFT|RIGHT OUTER JOIN 	D10
F5 	F5 - FULL (OUTER) JOIN 	D11
G1 	G1 - Nested query in WHERE clause 	D2 D4 D5 D6 D7 D8 D15 D16 D17 D18 D19 D21
G1_R  G1 (RA) - Nested query in WHERE clause 	D2 D4 D21
G2 	G2 - Nested query in FROM clause 	D3 D13
G2R  G2 (RA) - Nested query in FROM clause 	D3
G3 	G3 - Nested query in SELECT clause 	D12
G4 	G4 - Correlated nested query (EXISTS|NOT EXISTS) 	D4 D5 D6 D7 D16 D21
G4R  G4 (RA) - Correlated nested query (EXISTS|NOT EXISTS) 	D4 D21
H1 	H1 - Set unification - UNION 	D8 D18
H2 	H2 - Set difference - MINUS or EXCEPT 	D3 D5 D16
H2R  H2 (RA) - Set difference - MINUS or EXCEPT 	D3
H3  H3 - Set intersection - INTERSECT 	D15
I1 	I1 - Aggregate functions (count|sum|min|max|avg) 	D9 D12 D14 D18
I2 	I2 - Aggregate function over grouped rows - GROUP BY (HAVING) 	D9
J 	J - Same query in 3 different sql statements 	D16
K 	K - All clauses in one query - SELECT FROM WHERE GROUP BY HAVING ORDER BY 	D9
L 	L - View 	D6 D7
M 	M - Query over a view 	D7
N 	N - INSERT, which insert a set of rows, which are the result of another subquery (an INSERT command which has VALUES clause replaced by a nested query. 	D18
O 	O - UPDATE with nested SELECT statement 	D17
P 	P - DELETE with nested SELECT statement 
```

### Zdroje

[1] Stránky předmětu DBS.BI-DBS FIT ČVUT Course Pages [online]. FIT ČVUT, 2023, [cit.16.5.2023]. Dostupné z: https://courses.fit.cvut.cz

[2] QUAST, Karel: .Vzorová semestrální práce [online]. FIT ČVUT, 2023, [cit.16.5.2023]. Dostupné z: https://users.fit.cvut.cz/~hunkajir/dbs/main.xml

[3] Mockaroo Random Data Generator and API Mocking Tool. | JSON / CSV / SQL / Excel [online]. Mockaroo, 2023, [cit. 16.5.2023]. Dostupné z: https://www.mockaroo.com/
