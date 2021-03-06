
CREATE TABLE animal_types (
    animal_type_id  INTEGER NOT NULL,
    animal_type     VARCHAR2(30) NOT NULL
);

ALTER TABLE animal_types ADD CONSTRAINT animal_types_pk PRIMARY KEY ( animal_type_id );

ALTER TABLE animal_types ADD CONSTRAINT animal_types__un UNIQUE ( animal_type );

CREATE TABLE animals (
    animal_id             VARCHAR2(30) NOT NULL,
    animal_type_id        INTEGER NOT NULL,
    approximate_breed_id  INTEGER NOT NULL
);

ALTER TABLE animals ADD CONSTRAINT animals_pk PRIMARY KEY ( animal_id );

CREATE TABLE approximate_breeds (
    approximate_breed_id  INTEGER NOT NULL,
    approximate_breed     VARCHAR2(150) NOT NULL
);

ALTER TABLE approximate_breeds ADD CONSTRAINT approximate_breeds_pk PRIMARY KEY ( approximate_breed_id );

ALTER TABLE approximate_breeds ADD CONSTRAINT approximate_breeds__un UNIQUE ( approximate_breed );

CREATE TABLE city (
    city_id       INTEGER NOT NULL,
    city          VARCHAR2(50) NOT NULL,
    country_code  VARCHAR2(3) NOT NULL
);

ALTER TABLE city ADD CONSTRAINT city_pk PRIMARY KEY ( city_id );

ALTER TABLE city ADD CONSTRAINT city__un UNIQUE ( city,
                                                  country_code );

CREATE TABLE countries (
    country_code  VARCHAR2(3) NOT NULL,
    country       VARCHAR2(50) NOT NULL
);

ALTER TABLE countries ADD CONSTRAINT countries_pk PRIMARY KEY ( country_code );

ALTER TABLE countries ADD CONSTRAINT countries__un UNIQUE ( country );

CREATE TABLE intake (
    animal_id         VARCHAR2(30) NOT NULL,
    shelter_id        INTEGER NOT NULL,
    intake_datetime   TIMESTAMP NOT NULL,
    intake_condition  VARCHAR2(30) NOT NULL
);

ALTER TABLE intake ADD CONSTRAINT relation_3_pk PRIMARY KEY ( animal_id,
                                                              intake_datetime );



CREATE TABLE shelter_address (
    shelter_address_id  INTEGER NOT NULL,
    build_num           VARCHAR2(7) NOT NULL,
    street_id           INTEGER NOT NULL
);

ALTER TABLE shelter_address ADD CONSTRAINT shelter_address_pk PRIMARY KEY ( shelter_address_id );

ALTER TABLE shelter_address ADD CONSTRAINT shelter_address__un UNIQUE ( build_num,
                                                                        street_id );

CREATE TABLE shelters (
    shelter_id          INTEGER NOT NULL,
    shelter_title       VARCHAR2(100) NOT NULL,
    shelter_address_id  INTEGER NOT NULL
);

ALTER TABLE shelters ADD CONSTRAINT shelters_pk PRIMARY KEY ( shelter_id );

CREATE TABLE street (
    street_id  INTEGER NOT NULL,
    street     VARCHAR2(50) NOT NULL,
    city_id    INTEGER NOT NULL
);

ALTER TABLE street ADD CONSTRAINT street_pk PRIMARY KEY ( street_id );

ALTER TABLE street ADD CONSTRAINT street__un UNIQUE ( street,
                                                      city_id );

ALTER TABLE animals
    ADD CONSTRAINT animals_breeds_fk FOREIGN KEY ( approximate_breed_id )
        REFERENCES approximate_breeds ( approximate_breed_id );

ALTER TABLE animals
    ADD CONSTRAINT animals_types_fk FOREIGN KEY ( animal_type_id )
        REFERENCES animal_types ( animal_type_id );

ALTER TABLE city
    ADD CONSTRAINT city_countries_fk FOREIGN KEY ( country_code )
        REFERENCES countries ( country_code );

ALTER TABLE intake
    ADD CONSTRAINT relation_3_animals_fk FOREIGN KEY ( animal_id )
        REFERENCES animals ( animal_id );

ALTER TABLE intake
    ADD CONSTRAINT relation_3_shelters_fk FOREIGN KEY ( shelter_id )
        REFERENCES shelters ( shelter_id );

ALTER TABLE shelter_address
    ADD CONSTRAINT shelter_address_fk FOREIGN KEY ( street_id )
        REFERENCES street ( street_id );

ALTER TABLE shelters
    ADD CONSTRAINT shelter_address_un UNIQUE( shelter_address_id );

ALTER TABLE shelters
    ADD CONSTRAINT shelter_address_fk1 FOREIGN KEY ( shelter_address_id )
        REFERENCES shelter_address ( shelter_address_id );

ALTER TABLE street
    ADD CONSTRAINT street_city_fk FOREIGN KEY ( city_id )
        REFERENCES city ( city_id );