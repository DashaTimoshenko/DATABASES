CREATE SEQUENCE an_type_id MINVALUE 1 START WITH 1 INCREMENT BY 1 CACHE 20;

DELETE FROM animal_types;

INSERT INTO animal_types (
    animal_type_id,
    animal_type
)
    SELECT
        an_type_id.NEXTVAL,
        animal_type
    FROM
        (
            SELECT DISTINCT
                animal_type
            FROM
                animal_dataset
        );

-------------------------------------------

INSERT INTO approximate_breeds (
    breed_id,
    approximate_breed
)
    SELECT
        ROWNUM,
        breed
    FROM
        (
            SELECT DISTINCT
                breed
            FROM
                animal_dataset
        );

---------------------------------------------

ALTER TABLE approximate_breeds ADD CONSTRAINT uc_approximate_breed UNIQUE ( approximate_breed );

ALTER TABLE animal_types ADD CONSTRAINT uc_animal_type UNIQUE ( animal_type );

ALTER TABLE animal_dataset
    ADD CONSTRAINT dataset_breed_fk FOREIGN KEY ( breed )
        REFERENCES approximate_breeds ( approximate_breed );

ALTER TABLE animal_dataset
    ADD CONSTRAINT dataset_type_fk FOREIGN KEY ( animal_type )
        REFERENCES animal_types ( animal_type );
  
----------------------------------------------

DELETE FROM animals;

INSERT INTO animals (
    animal_id,
    animal_type_id,
    breed_id,
    color
)
    SELECT
        animal_id,
        animal_type_id,
        breed_id,
        color
    FROM
        (
            SELECT DISTINCT
                animal_id,
                animal_type_id,
                breed_id,
                color,
                ROW_NUMBER() OVER(PARTITION BY animal_dataset.animal_id
                    ORDER BY
                        animal_dataset.animal_id
                ) rn
            FROM
                     animal_dataset
                JOIN animal_types ON animal_dataset.animal_type = animal_types.animal_type
                JOIN approximate_breeds ON animal_dataset.breed = approximate_breeds.approximate_breed
        )
    WHERE
        rn = 1;

--------------------------------------------------

INSERT INTO intake (
    intake_id,
    animal_id,
    shelter_id,
    intake_datetime,
    intake_condition
)
    SELECT
        ROWNUM,
        animal_id,
        sel_id,
        intake_time,
        intake_condition
    FROM
        (
            SELECT
                animal_id,
                floor(dbms_random.value(100, 105))                                                                                                                            AS sel_id,
                to_timestamp(animal_dataset.datetime, 'YYYY-MM-DD"T"HH24:MI:SS.ff4')                                                                                         AS intake_time,
                intake_condition,
                ROW_NUMBER() OVER(PARTITION BY animal_dataset.animal_id, animal_dataset.datetime
                    ORDER BY
                        animal_dataset.animal_id, animal_dataset.datetime
                )                 rn
            FROM
                animal_dataset
        )
    WHERE
        rn = 1;

        

---------------------------------------------------
Insert into SHELTER_ZIP (SHELTER_ADDRESS_ID,SHELTER_ZIP) values ('1','15895     ');
Insert into SHELTER_ZIP (SHELTER_ADDRESS_ID,SHELTER_ZIP) values ('2','13024     ');
Insert into SHELTER_ZIP (SHELTER_ADDRESS_ID,SHELTER_ZIP) values ('3','10087     ');
Insert into SHELTER_ZIP (SHELTER_ADDRESS_ID,SHELTER_ZIP) values ('4','75656     ');
Insert into SHELTER_ZIP (SHELTER_ADDRESS_ID,SHELTER_ZIP) values ('5','35541     '); 

---------------------------------------------------
Insert into SHELTER_ADDRESS (SHELTER_ADDRESS_ID,SHELTER_COUNTRY,SHELTER_CITY,SHELTER_STREET) values ('5','France','Fizhak','Bayar');
Insert into SHELTER_ADDRESS (SHELTER_ADDRESS_ID,SHELTER_COUNTRY,SHELTER_CITY,SHELTER_STREET) values ('2','Poland','Krakow','Kalwaryjska');
Insert into SHELTER_ADDRESS (SHELTER_ADDRESS_ID,SHELTER_COUNTRY,SHELTER_CITY,SHELTER_STREET) values ('3','USA','New York','Beaver St');
Insert into SHELTER_ADDRESS (SHELTER_ADDRESS_ID,SHELTER_COUNTRY,SHELTER_CITY,SHELTER_STREET) values ('4','Ukraine','Kiev','Libidan St');
Insert into SHELTER_ADDRESS (SHELTER_ADDRESS_ID,SHELTER_COUNTRY,SHELTER_CITY,SHELTER_STREET) values ('1','Ukraine','Lviv','Antonovich St');
---------------------------------------------------
Insert into SHELTERS (SHELTER_ID,SHELTER_TITLE,SHELTER_ADDRESS_ID,BUILD_NUM,RATING) values ('100','Republic friend','1','56','4');
Insert into SHELTERS (SHELTER_ID,SHELTER_TITLE,SHELTER_ADDRESS_ID,BUILD_NUM,RATING) values ('101','Happy pets','2','35','5');
Insert into SHELTERS (SHELTER_ID,SHELTER_TITLE,SHELTER_ADDRESS_ID,BUILD_NUM,RATING) values ('102','In good hands','3','15','5');
Insert into SHELTERS (SHELTER_ID,SHELTER_TITLE,SHELTER_ADDRESS_ID,BUILD_NUM,RATING) values ('103','Friend','4','27','4');
Insert into SHELTERS (SHELTER_ID,SHELTER_TITLE,SHELTER_ADDRESS_ID,BUILD_NUM,RATING) values ('104','Bim','5','9','3');
---------------------------------------------------
  
