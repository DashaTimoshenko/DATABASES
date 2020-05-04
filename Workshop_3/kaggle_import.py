import csv
import cx_Oracle
import random

username = 'WORKSHOP_3'
password = '123'
database = '127.0.0.1/xe'
connection = cx_Oracle.connect(username, password, database)

filename = "aac_intakes.csv"

with open(filename, newline='') as file:
    reader = csv.reader(file)



    for row in reader:
        if row[1] == 'animal_id':
            continue
        animal_id = row[1]
        animal_type = row[2]
        breed = row[3]
        intake_datetime = row[5]
        intake_condition = row[8]
        shelter_id = random.randint(100, 104)

        insert_query_animal_type = """insert into ANIMAL_TYPES (animal_type_id, animal_type)
                        SELECT ANIMAL_TYPE_ID_GEN.NEXTVAL, :animal_type
                        FROM DUAL WHERE NOT EXISTS (SELECT ANIMAL_TYPE FROM ANIMAL_TYPES WHERE ANIMAL_TYPE = :animal_type)"""
        cursor_type = connection.cursor()
        cursor_type.execute(insert_query_animal_type, animal_type=animal_type)
        cursor_type.close()
#######################################

        insert_query_animal_breed = """insert into APPROXIMATE_BREEDS (approximate_breed_id, approximate_breed)
                SELECT ANIMAL_BREED_ID_GEN.NEXTVAL, :breed
                FROM DUAL WHERE NOT EXISTS (SELECT approximate_breed FROM APPROXIMATE_BREEDS WHERE approximate_breed = :breed)"""
        cursor_breed = connection.cursor()
        cursor_breed.execute(insert_query_animal_breed, breed=breed)
        cursor_breed.close()
        connection.commit()  # save changes in db
#######################################
        insert_query_animals = """INSERT INTO ANIMALS ( animal_id, animal_type_id, approximate_breed_id)
        SELECT :animal_id ,
        (SELECT animal_type_id FROM ANIMAL_TYPES WHERE animal_type = :animal_type),
        (SELECT APPROXIMATE_BREED_ID FROM APPROXIMATE_BREEDS WHERE APPROXIMATE_BREED = :breed)
        FROM DUAL
          WHERE NOT EXISTS (SELECT animal_id FROM ANIMALS WHERE animal_id = :animal_id)"""
        cursor_animals = connection.cursor()
        cursor_animals.execute(insert_query_animals, animal_id=animal_id, animal_type=animal_type, breed=breed)
        cursor_animals.close()
        connection.commit() #save changes in db


        #######################################
        insert_query_intake = """insert into INTAKE(animal_id, shelter_id, intake_datetime, intake_condition)
        SELECT :animal_id, :shelter_id, to_timestamp(:intake_datetime, 'YYYY-MM-DD"T"HH24:MI:SS.ff4'), :intake_condition
        FROM DUAL
          WHERE NOT EXISTS (SELECT animal_id, intake_datetime 
          FROM INTAKE 
          WHERE animal_id = :animal_id AND intake_datetime = to_timestamp(:intake_datetime, 'YYYY-MM-DD"T"HH24:MI:SS.ff4'))
        """
        cursor_intake = connection.cursor()
        cursor_intake.execute(insert_query_intake, animal_id=animal_id, shelter_id=shelter_id, intake_datetime=intake_datetime, intake_condition=intake_condition)
        cursor_intake.close()
        connection.commit()  # save changes in db
