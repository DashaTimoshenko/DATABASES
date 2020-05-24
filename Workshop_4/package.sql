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

    FUNCTION intake_shelters (
        an_id    IN  VARCHAR2,
        in_year  IN  VARCHAR2
    ) RETURN tbl_intake_shelters
        PIPELINED
    IS

        CURSOR my_cursor IS
        SELECT
            intake.animal_id,
            intake.intake_datetime,
            shelters.shelter_title
        FROM
            intake,
            shelters
        WHERE
                intake.shelter_id = shelters.shelter_id
            AND EXTRACT(YEAR FROM intake_datetime) >= in_year
            AND an_id = intake.animal_id;

    BEGIN
        FOR rec IN my_cursor LOOP
            PIPE ROW ( row_intake_shelters(rec.animal_id, rec.intake_datetime, rec.shelter_title) );
        END LOOP;
    END intake_shelters;

    PROCEDURE add_animal_to_shelter (
        animal_id_in         IN  VARCHAR2,
        shelter_id_in        IN  NUMBER,
        intake_condition_in  IN  VARCHAR2
    ) IS
        no_animal_or_shelter EXCEPTION;
        v_is_exist INTEGER;
    BEGIN
        v_is_exist := 0;
        SELECT
            COUNT(1)
        INTO v_is_exist
        FROM
            dual
        WHERE
            NOT EXISTS (
                SELECT
                    animals.animal_id,
                    shelters.shelter_id
                FROM
                    animals,
                    shelters
                WHERE
                        animals.animal_id = animal_id_in
                    AND shelters.shelter_id = shelter_id_in
            );

        IF v_is_exist = 1 THEN
            RAISE no_animal_or_shelter;
        ELSE
            INSERT INTO intake (
                animal_id,
                shelter_id,
                intake_datetime,
                intake_condition
            ) VALUES (
                animal_id_in,
                shelter_id_in,
                systimestamp,
                intake_condition_in
            );

        END IF;

    EXCEPTION
        WHEN no_animal_or_shelter THEN
            raise_application_error(-20001, 'Тваринку чи притулок не знайдено.');
        WHEN OTHERS THEN
            raise_application_error(-20002, 'Помилка при доданні тваринки.');
    END;

END my_package;
/