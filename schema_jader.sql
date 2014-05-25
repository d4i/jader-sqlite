-- JADER
-- sql script to create tables and indexes

CREATE TABLE demo (
  case_id text not null unique,
  freq integer not null,
  sex text,
  age text,
  weight text,
  height text,
  quarter text,
  scene text,
  report text,
  reporter text
);
CREATE INDEX demo01 on demo (case_id);
CREATE INDEX demo02 on demo (quarter);
CREATE TABLE drug (
  case_id text not null,
  freq integer not null,
  sn integer,
  relation text,
  generic_name text,
  brand_name text,
  process text,
  start_date text,
  end_date text,
  dosage text,
  unit text,
  fraction text,
  reason text,
  fix text,
  relapse text
);
CREATE INDEX drug01 on drug (case_id);
CREATE INDEX drug02 on drug (generic_name);
CREATE TABLE reac (
  case_id text not null,
  freq integer not null,
  sn integer,
  event text,
  outcome text,
  date text
);
CREATE INDEX reac01 on reac (case_id);
CREATE INDEX reac02 on reac (event);
CREATE TABLE hist (
  case_id text not null,
  freq integer not null,
  sn integer,
  disease text
);
CREATE INDEX hist01 on hist (case_id);
CREATE INDEX hist02 on hist (disease);
