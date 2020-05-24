CREATE OR REPLACE PROCEDURE add_animal_to_shelter
   (animal_id_in IN VARCHAR2, shelter_id_in IN NUMBER, intake_condition_in IN VARCHAR2)
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