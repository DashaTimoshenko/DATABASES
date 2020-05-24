CREATE OR REPLACE TRIGGER animals_names BEFORE
    INSERT OR UPDATE ON animals
    FOR EACH ROW
BEGIN
    IF ( :new.animal_name IS NULL ) THEN
        :new.animal_name := 'NO_NAME';
    END IF;
END;
/

INSERT INTO animals (
    animal_id,
    animal_type,
    approximate_breed,
    animal_name
) VALUES (
    'A7122222211',
    'Cat',
    'Мейн кун',
    NULL
);