/*DROP TYPE TBL_INTAKE_SHELTERS;
DROP TYPE ROW_INTAKE_SHELTERS;
*/
CREATE TYPE row_intake_shelters AS OBJECT (
    intake_animal_id  VARCHAR2(30 BYTE),
    intake_time       TIMESTAMP(6),
    s_title           VARCHAR2(100 BYTE)
);
/

CREATE TYPE tbl_intake_shelters IS
    TABLE OF row_intake_shelters;
/

CREATE OR REPLACE FUNCTION intake_shelters (
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