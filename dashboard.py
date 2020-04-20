import chart_studio
chart_studio.tools.set_credentials_file(username='dasha_timoshenko', api_key='Sz62LgZzhmiNHj2fBBU5')
import plotly.graph_objs as go
import chart_studio.plotly as py
import cx_Oracle
import re
import chart_studio.dashboard_objs as dashboard

def fileId_from_url(url):
    """Return fileId from a url."""
    raw_fileId = re.findall("~[A-z.]+/[0-9]+", url)[0][1: ]
    return raw_fileId.replace('/', ':')

username = 'Dasha_T'
password = '040801'
database = '127.0.0.1/xe'
connection = cx_Oracle.connect(username, password, database)

""" create plot 1   Вивести притулок та загальну кількість собак, які  бували в ньому
за останній час."""
cursor1 = connection.cursor()

query1 = """SELECT  Shelters.shelter_title,
        COUNT(Animals.animal_id)
    from Shelters
    JOIN (SELECT intake.animal_id, max(intake.intake_datetime), intake.shelter_id
            FROM intake
            group by intake.animal_id, intake.shelter_id) recent_data ON Shelters.shelter_id = recent_data.shelter_id
    JOIN Animals ON recent_data.animal_id = Animals.animal_id
    JOIN Animal_types ON Animals.animal_type_id = Animal_types.animal_type_id
        WHERE Animal_types.animal_type = 'Dog'
        GROUP BY Shelters.shelter_title"""

cursor1.execute(query1)

shelter_title = []
dog_count = []
for record in cursor1.fetchall():
    print("Shelter: ", record[0], " and count of dogs: ", record[1])
    shelter_title.append(record[0])
    dog_count.append(record[1])

data = [go.Bar(
    x=shelter_title,
    y=dog_count
)]

layout = go.Layout(
    title='Shelters and count of dogs',
    xaxis=dict(
        title='Shelters',
        titlefont=dict(
            family='Courier New, monospace',
            size=18,
            color='#7f7f7f'
        )
    ),
    yaxis=dict(
        title='Count of dogs',
        rangemode='nonnegative',
        autorange=True,
        titlefont=dict(
            family='Courier New, monospace',
            size=18,
            color='#7f7f7f'
        )
    )
)
fig = go.Figure(data=data, layout=layout)

shelters_dog_count = py.plot(fig, filename='shelters_dog_count')


""" create plot 2   Вивести відсоток хворих тварин, що потрапляють до притулків."""

cursor2 = connection.cursor()

query2 = """SELECT  
         ROUND(COUNT(*)/(SELECT COUNT(*) FROM intake)*100, 4) AS Sick_animals

    FROM
        intake
    WHERE
        intake.intake_condition = 'Sick'
    group by intake.intake_condition"""

cursor2.execute(query2)
title = ['Other_animals', 'Sick_animals']
sick_animals_count = cursor2.fetchone()[0]
other = 100 - sick_animals_count
value = [other, sick_animals_count]
pie = go.Pie(labels = title, values = value)
sick_animals_percent = py.plot([pie], filename='sick_animals_percent')

""" create plot 3   Вивести динаміку скільки тварин потрапило до притулку "Bim" за різні роки, враховувати лише ті роки де кількість тварин перевищила 800."""
cursor3 = connection.cursor()

query3 = """ SELECT EXTRACT(year FROM intake_datetime), COUNT(DISTINCT animal_id)
  FROM intake
  JOIN shelters ON intake.shelter_id = shelters.shelter_id
  WHERE
        shelters.shelter_title = 'Bim'
  GROUP BY EXTRACT(year FROM intake_datetime)
  HAVING COUNT(DISTINCT animal_id)>800 
  ORDER by EXTRACT(year FROM intake_datetime)"""

cursor3.execute(query3)

years = []
animal_count = []
for record in cursor3.fetchall():
    years.append(record[0])
    animal_count.append(record[1])

data = go.Scatter(
    x = years,
    y = animal_count,
    mode='lines+markers'
)
quantity_per_year=py.plot([data], filename='Count of animals by year')

"""--------CREATE DASHBOARD------------------ """
new_dboard = dashboard.Dashboard()

shelters_dog_count_id = fileId_from_url(shelters_dog_count)
sick_animals_percent_id = fileId_from_url(sick_animals_percent)
quantity_per_year_id = fileId_from_url(quantity_per_year)

box_1 = {
    'type': 'box',
    'boxType': 'plot',
    'fileId': shelters_dog_count_id,
    'title': 'Shelter and count of dogs'
}

box_2 = {
    'type': 'box',
    'boxType': 'plot',
    'fileId': sick_animals_percent_id,
    'title': 'Sick animals percent'
}

box_3 = {
    'type': 'box',
    'boxType': 'plot',
    'fileId': quantity_per_year_id,
    'title': 'Count of animals by year'
}

new_dboard.insert(box_1)
new_dboard.insert(box_2, 'below', 1)
new_dboard.insert(box_3, 'left', 2)

py.dashboard_ops.upload(new_dboard, 'My Second Dashboard with Python')