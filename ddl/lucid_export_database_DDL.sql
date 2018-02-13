CREATE TABLE "Trasy" (
  "id" serial,
  "poczatek" integer,
  "koniec" integer,
  "via" integer,
  "km" integer
);

CREATE TABLE "Opetatorzy_kursy" (
  "id" serial,
  "operatorID" integer,
  "kursID" integer
);

CREATE TABLE "Operatorzy" (
  "id" serial,
  "kod" varchar(10),
  "nazwa" text,
  "dzial_prawny_tel" varchar(20),
  "adres" text,
  "email" varchar(255),
  "strona_www" varchar(255),
  "tryb_id" integer,
  "wymagania_id" integer
);

CREATE TABLE "Szczegoly_kursu" (
  "id (key)" Serial,
  "przystanek" varchar(255),
  "plan_przyjazd" timestamp,
  "real_przyjazd" timestamp,
  "km_narastająco" integer,
  "km_od_poprzed" integer,
  "kursID" integer,
  "max_ilosc_pas" integer,
  "realna_ilosc" integer,
  "wojewodztwo" varchar(50),
  "rekompensata" numeric,
  "pogoda" boolean,
  "marka_pociagu" varchar(55),
  "rodzaj_pociągu" varchar(55),
  "status_do_przystanku" integer,
  "powod_opoznienia" integer
);

CREATE TABLE "Tryb_wysylki" (
  "id" serial,
  "email" bool,
  "www" bool,
  "poczta" bool,
  "info" text
);

CREATE TABLE "Osoba_kontaktowa" (
  "id" serial,
  "imie" varchar(50),
  "nazwisko" varchar(255),
  "operatorID" integer,
  "email" varchar(255),
  "telefon" varchar(20),
  "dzial" varchar(50)
);

CREATE TABLE "Wymagania_operatorow" (
  "id" serial,
  "skan_biletu" bool,
  "skan_dowodu" bool
);

CREATE TABLE "Powod_opoznienia" (
  "id" serial,
  "powod" varchar(55)
);

CREATE TABLE "Kursy" (
  "id (key)" serial,
  "kod_polaczenia" varchar(16),
  "plan_km" integer,
  "plan_odjazd" timestamp,
  "plan_przyjazd" timestamp,
  "real_km" integer,
  "real_odjazd" timestamp,
  "real_przyjazd" timestamp,
  "status_id" integer,
  "trasa_id" integer
);