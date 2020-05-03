import cx_Oracle


connection = cx_Oracle.connect('Dasha_T', '040801', '127.0.0.1/xe')

# -------------------------------------
#               Query 1
# -------------------------------------

cursor1 = connection.cursor()

query1 = """SELECT  recent_data.shelter_title,
        COUNT(recent_data.animal_id)
    from (SELECT animal_id, shelter_title, max(intake_datetime) 
            FROM intake_shelter
            group by intake_shelter.animal_id, intake_shelter.shelter_title) recent_data
    JOIN Animals ON recent_data.animal_id = Animals.animal_id
    JOIN Animal_types ON Animals.animal_type_id = Animal_types.animal_type_id
        WHERE Animal_types.animal_type = 'Dog'
        GROUP BY recent_data.shelter_title """

cursor1.execute(query1)

print('''
 -------------------------------------
               Query 1
 -------------------------------------''')
print("(shelter_title, animals_count)")
for record in cursor1.fetchall():
    print(record)



# -------------------------------------
#               Query 2
# -------------------------------------

cursor2 = connection.cursor()

query2 = """SELECT  
         COUNT(*)/(SELECT COUNT(*) FROM intake)*100 AS Sick_animals

    FROM
        intake
    WHERE
        intake.intake_condition = 'Sick'
    group by intake.intake_condition"""

cursor2.execute(query2)

title = ['Sick_animals', 'All_animals']
sick_animals_count = cursor2.fetchone()[0]
print('''
 -------------------------------------
               Query 2
 -------------------------------------
 ''')
print(sick_animals_count)



# -------------------------------------
#               Query 3
# -------------------------------------

cursor3 = connection.cursor()

query3 = """ SELECT
    EXTRACT(YEAR FROM intake_datetime) AS YEAR,
    COUNT(DISTINCT animal_id) AS COUNT
FROM
         intake_shelter
WHERE
    intake_shelter.shelter_title = 'Bim'
GROUP BY
    EXTRACT(YEAR FROM intake_datetime)
HAVING
    COUNT(DISTINCT animal_id) > 800
ORDER BY
    EXTRACT(YEAR FROM intake_datetime)"""

cursor3.execute(query3)
print('''
 -------------------------------------
               Query 3
 -------------------------------------
 ''')
print("(year, animals_count)")
for record in cursor3.fetchall():
    print(record)


cursor1.close()
cursor2.close()
cursor3.close()
connection.close()