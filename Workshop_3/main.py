import chart_studio
chart_studio.tools.set_credentials_file(username='dasha_timoshenko', api_key='Sz62LgZzhmiNHj2fBBU5')
import plotly.graph_objs as go
import chart_studio.plotly as py
import cx_Oracle

username = 'WORKSHOP_3'
password = '123'
database = '127.0.0.1/xe'
connection = cx_Oracle.connect(username, password, database)

#-------------------------------------
#               Query 1
#-------------------------------------
cursor1 = connection.cursor()

query1 = """SELECT  recent_data.shelter_title,
        COUNT(recent_data.animal_id)
    from (SELECT animal_id, shelter_title, max(intake_datetime) 
            FROM intake_shelter
            group by intake_shelter.animal_id, intake_shelter.shelter_title) recent_data
    JOIN Animals ON recent_data.animal_id = Animals.animal_id
    JOIN Animal_types ON Animals.animal_type_id = Animal_types.animal_type_id
        WHERE Animal_types.animal_type = 'Dog'
        GROUP BY recent_data.shelter_title"""

cursor1.execute(query1)

shelter_title = []
dog_count = []
for record in cursor1.fetchall():
    shelter_title.append(record[0])
    dog_count.append(record[1])

bar = go.Bar(
    x = shelter_title,
    y = dog_count
)

py.plot([bar], auto_open=True, filename='test')

#-------------------------------------
#               Query 2
#-------------------------------------
cursor2 = connection.cursor()

query2 = """SELECT 
         intake_shelter.shelter_title, 
         COUNT(animal_id)/(SELECT COUNT(*) FROM intake_shelter)*100 AS animals_count       
    FROM
        intake_shelter
    group by intake_shelter.shelter_title"""

cursor2.execute(query2)

shelter = []
animal_count = []
for record in cursor2.fetchall():
    shelter.append(record[0])
    animal_count.append(record[1])


pie = go.Pie(labels = shelter, values = animal_count)

py.plot([pie], auto_open=True, filename='lab_3.2')

#-------------------------------------
#               Query 3
#-------------------------------------
cursor3 = connection.cursor()

query3 = """SELECT
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

years = []
animal_count = []
for record in cursor3.fetchall():
    years.append(record[0])
    animal_count.append(record[1])

data = go.Scatter(
    x = years,
    y = animal_count
)
layout3 = go.Layout(xaxis = {'title':'years'}, yaxis = {'title':'animal_count'})
py.plot([data], layout = layout3,  auto_open=True, filename='test')

cursor1.close()
cursor2.close()
cursor3.close()
connection.close()
