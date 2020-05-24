BEGIN
    add_animal_to_shelter('A700000', 105, 'Normal');
END;
/
/* Правильна відповідь:
Error starting at line : 1 in command -
BEGIN
  add_animal_to_shelter('A700000', 105, 'Normal');
END;
Error report -
ORA-20001: Тваринку чи притулок не знайдено.
ORA-06512: at "<USER>.ADD_ANIMAL_TO_SHELTER", line 24
ORA-06512: at line 2*/

BEGIN
    add_animal_to_shelter('A700000', 100, 'Normal');
END;
/
/*Правильна відповідь:
PL/SQL procedure successfully completed.*/

SELECT
    *
FROM
    TABLE ( intake_shelters('A700002', '2013') );
/*Правильна відповідь:
INTAKE_ANIMAL_ID               INTAKE_TIME                   S_TITLE                                                                                             
------------------------------ ----------------------------- ----------
A700002                        05.10.2015 17:55:00,000000000 Bim                                                                                                 
A700002                        29.10.2017 08:44:00,000000000 In good hands 
*/