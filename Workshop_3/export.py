import cx_Oracle
import csv

username = 'WORKSHOP_3'
password = '123'
database = '127.0.0.1/xe'
connection = cx_Oracle.connect(username, password, database)
table_list = ['ANIMAL_TYPES', 'APPROXIMATE_BREEDS', 'ANIMALS', 'COUNTRIES', 'CITY', 'STREET', 'SHELTER_ADDRESS', 'SHELTERS', 'INTAKE']

for table in table_list:
    with open(table + ".csv", "w", newline="") as file:
        writer = csv.writer(file)
        table_name = table
        cursor = connection.cursor()
        query_row = """SELECT *
        FROM """ + table_name

        cursor.execute(query_row)
        column_names = [row[0] for row in cursor.description]
        writer.writerow(column_names)
        cursor_table = cursor.fetchall()
        for row in cursor_table:
            writer.writerow(row)

        cursor.close()
