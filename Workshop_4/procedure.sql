CREATE OR REPLACE PROCEDURE add_animal_to_shelter (
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
        raise_application_error(-20001, 'No animal or shelter found.');
    WHEN OTHERS THEN
        raise_application_error(-20002, 'Error adding animal.');
END;
