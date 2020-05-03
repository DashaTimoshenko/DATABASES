CREATE VIEW intake_shelter AS
    SELECT
        intake.animal_id,
        shelters.shelter_title,
        intake.intake_datetime
    FROM
             intake
        JOIN shelters ON intake.shelter_id = shelters.shelter_id;



