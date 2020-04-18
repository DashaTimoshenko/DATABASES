CREATE TABLE Animals(
  animal_id VARCHAR2(30) PRIMARY KEY,
  animal_type_id INTEGER NOT NULL,
  breed_id INTEGER NOT NULL,
  color VARCHAR2(50)
);

CREATE TABLE Animal_types(
  animal_type_id INTEGER PRIMARY KEY,
  animal_type VARCHAR2(50) NOT NULL
);

CREATE TABLE Approximate_breeds(
  breed_id INTEGER PRIMARY KEY,
  approximate_breed VARCHAR2(150) NOT NULL
);
---------------------------------------------
CREATE TABLE Intake(
  intake_id INTEGER PRIMARY KEY,
  animal_id VARCHAR2(30) NOT NULL,
  shelter_id INTEGER NOT NULL,
  intake_datetime TIMESTAMP NOT NULL,
  intake_condition VARCHAR2(30),
  UNIQUE (animal_id, shelter_id, intake_datetime)
);


---------------------------------------------
CREATE TABLE Shelters(
  shelter_id INTEGER PRIMARY KEY,
  shelter_title VARCHAR2(100) NOT NULL,
  shelter_address_id INTEGER NOT NULL,
  build_num VARCHAR2(10) NOT NULL,
  rating INTEGER
);
---------------------------------------------
CREATE TABLE Shelter_address(
  shelter_address_id INTEGER PRIMARY KEY,
  shelter_country VARCHAR2(50) NOT NULL,
  shelter_city VARCHAR2(50) NOT NULL,
  shelter_street VARCHAR2(150) NOT NULL,

  UNIQUE (shelter_country, shelter_city, shelter_street)
);

CREATE TABLE Shelter_zip(
  shelter_address_id INTEGER NOT NULL,
  shelter_zip char(10) NOT NULL,
  UNIQUE (shelter_address_id, shelter_zip)
);
---------------------------------------------

ALTER TABLE   Animals
  ADD CONSTRAINT breed_fk FOREIGN KEY (breed_id) REFERENCES Approximate_breeds (breed_id);
  
ALTER TABLE  Animals
  ADD CONSTRAINT type_fk FOREIGN KEY (animal_type_id) REFERENCES Animal_types (animal_type_id);
--------------------------------
ALTER TABLE  Intake
  ADD CONSTRAINT animal_id_fk FOREIGN KEY (animal_id) REFERENCES Animals (animal_id);
--------------------------------
ALTER TABLE  Shelters
  ADD CONSTRAINT shelter_address_id_fk FOREIGN KEY (shelter_address_id) REFERENCES Shelter_address (shelter_address_id);
  

ALTER TABLE  Shelter_zip
  ADD CONSTRAINT shelter_zip_fk FOREIGN KEY (shelter_address_id) REFERENCES Shelter_address (shelter_address_id);
--------------------------------
ALTER TABLE  Intake
  ADD CONSTRAINT shelter_id_fk FOREIGN KEY (shelter_id) REFERENCES Shelters (shelter_id);

