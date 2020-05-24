CREATE OR REPLACE PACKAGE my_package IS
    TYPE rowgetticket IS RECORD (
        intake_animal_id  VARCHAR2(30 BYTE),
        intake_time       TIMESTAMP(6),
        s_title           VARCHAR2(100 BYTE)
    );
    TYPE tbl_intake_shelters IS
        TABLE OF row_intake_shelters;
    FUNCTION intake_shelters (
        an_id    IN  VARCHAR2,
        in_year  IN  VARCHAR2
    ) RETURN tbl_intake_shelters
        PIPELINED;

    PROCEDURE add_animal_to_shelter (
        animal_id_in         IN  VARCHAR2,
        shelter_id_in        IN  NUMBER,
        intake_condition_in  IN  VARCHAR2
    );

END my_package;
/

CREATE OR REPLACE PACKAGE BODY my_package IS
    FUNCTION INTAKE_SHELTERS(AN_ID IN VARCHAR2, IN_YEAR IN VARCHAR2)
        RETURN TBL_INTAKE_SHELTERS
        PIPELINED
        IS
          CURSOR MY_CURSOR IS
            SELECT INTAKE.ANIMAL_ID, INTAKE.INTAKE_DATETIME, SHELTERS.SHELTER_TITLE
            FROM INTAKE, shelters
            WHERE intake.shelter_id = shelters.shelter_id AND
            EXTRACT(YEAR FROM intake_datetime) >= IN_YEAR AND
            AN_ID = INTAKE.ANIMAL_ID;
        BEGIN
        FOR rec in MY_CURSOR
          LOOP
            PIPE ROW(ROW_INTAKE_SHELTERS(rec.ANIMAL_ID, rec.INTAKE_DATETIME, rec.SHELTER_TITLE));
          END LOOP;
        END INTAKE_SHELTERS;
   
   
    PROCEDURE add_animal_to_shelter(animal_id_in IN VARCHAR2, shelter_id_in IN NUMBER, intake_condition_in IN VARCHAR2)
        IS
           no_animal_or_shelter EXCEPTION;
           v_is_exist INTEGER;
        BEGIN
            v_is_exist := 0;
            SELECT COUNT(1)
            INTO v_is_exist
            FROM DUAL
            WHERE NOT EXISTS (SELECT ANIMALS.animal_id, SHELTERS.shelter_id  
            FROM ANIMALS, SHELTERS
                WHERE ANIMALS.animal_id = animal_id_in AND
                SHELTERS.shelter_id = shelter_id_in );
                
            IF v_is_exist = 1 THEN 
              RAISE no_animal_or_shelter;        
            ELSE
              INSERT INTO INTAKE (ANIMAL_ID,SHELTER_ID,INTAKE_DATETIME,INTAKE_CONDITION)
              VALUES (animal_id_in, shelter_id_in, SYSTIMESTAMP, intake_condition_in);
            END IF;
        EXCEPTION
           WHEN no_animal_or_shelter THEN
              raise_application_error (-20001,'Тваринку чи притулок не знайдено.');
        
           WHEN OTHERS THEN
              raise_application_error (-20002,'Помилка при доданні тваринки.');
        END;     
END my_package;
/