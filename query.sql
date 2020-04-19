/*--------------------------------------
               Query 1
--------------------------------------*/
SELECT
    shelters.shelter_title,
    COUNT(animals.animal_id)
FROM
         shelters
    JOIN (
        SELECT
            intake.animal_id,
            MAX(intake.intake_datetime),
            intake.shelter_id
        FROM
            intake
        GROUP BY
            intake.animal_id,
            intake.shelter_id
    ) recent_data ON shelters.shelter_id = recent_data.shelter_id
    JOIN animals ON recent_data.animal_id = animals.animal_id
    JOIN animal_types ON animals.animal_type_id = animal_types.animal_type_id
WHERE
    animal_types.animal_type = 'Dog'
GROUP BY
    shelters.shelter_title;

/*--------------------------------------
               Query 2
--------------------------------------*/

SELECT
    round(COUNT(*) /(
        SELECT
            COUNT(*)
        FROM
            intake
    ) * 100, 4) AS sick_animals
FROM
    intake
WHERE
    intake.intake_condition = 'Sick'
GROUP BY
    intake.intake_condition; 
/*-------------Query 2 second version----------------------------*/

SELECT
    round(SUM(
        CASE
            WHEN i.intake_condition = 'Sick' THEN
                1
            ELSE
                0
        END
    ) / COUNT(i.intake_id) * 100, 4) AS sick_animals
FROM
    intake i;
    
    

/*--------------------------------------
               Query 3
--------------------------------------*/

SELECT
    EXTRACT(YEAR FROM intake_datetime),
    COUNT(DISTINCT animal_id)
FROM
         intake
    JOIN shelters ON intake.shelter_id = shelters.shelter_id
WHERE
    shelters.shelter_title = 'Bim'
GROUP BY
    EXTRACT(YEAR FROM intake_datetime)
HAVING
    COUNT(DISTINCT animal_id) > 800
ORDER BY
    EXTRACT(YEAR FROM intake_datetime);
-------------------------   