-- JADER
-- sql script to create tables and indices

CREATE TABLE demo (
  case_id CHAR(10) NOT NULL unique,
  freq SMALLINT NOT NULL,
  sex VARCHAR(10),
  age VARCHAR(20),
  weight VARCHAR(20),
  height VARCHAR(20),
  quarter VARCHAR(10),
  status VARCHAR(10),
  report VARCHAR(10),
  reporter VARCHAR(30)
);
CREATE INDEX demo01 ON demo (case_id);
CREATE INDEX demo02 ON demo (quarter);
CREATE TABLE drug (
  case_id CHAR(10) NOT NULL,
  freq SMALLINT NOT NULL,
  sn SMALLINT,
  association VARCHAR(10),
  name VARCHAR(120),
  brand VARCHAR(50),
  route VARCHAR(30),
  start_date VARCHAR(20),
  end_date VARCHAR(20),
  dosage VARCHAR(20),
  unit VARCHAR(10),
  fraction VARCHAR(10),
  reason VARCHAR(50),
  fix VARCHAR(20),
  relapse VARCHAR(10)
);
CREATE INDEX drug01 ON drug (case_id);
CREATE INDEX drug02 ON drug (name);
CREATE TABLE reac (
  case_id CHAR(10) NOT NULL,
  freq SMALLINT NOT NULL,
  sn SMALLINT,
  event VARCHAR(120),
  outcome VARCHAR(10),
  onset_date VARCHAR(20)
);
CREATE INDEX reac01 ON reac (case_id);
CREATE INDEX reac02 ON reac (event);
CREATE TABLE hist (
  case_id CHAR(10) NOT NULL,
  freq SMALLINT NOT NULL,
  sn SMALLINT,
  disease VARCHAR(120)
);
CREATE INDEX hist01 ON hist (case_id);
CREATE INDEX hist02 ON hist (disease);
