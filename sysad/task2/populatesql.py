import psycopg2
def task_web(cursor,username):
    task1 = input("Completed task 1? ")
    task2 = input("Completed task 2? ")
    task3 = input("Completed task 3? ")
    command = f"INSERT INTO taskdetails_web(username,task1,task2,task3) VALUES(%s,%s,%s,%s)"
    cursor.execute(command,(username,task1,task2,task3))
    con.commit()

def task_app(cursor,username):
    task1 = input("Completed task 1? ")
    task2 = input("Completed task 2? ")
    task3 = input("Completed task 3? ")
    command = f"INSERT INTO taskdetails_app(username,task1,task2,task3) VALUES(%s,%s,%s,%s)"
    cursor.execute(command,(username,task1,task2,task3))
    con.commit()

def task_sysad(cursor,username):
    task1 = input("Completed task 1? ")
    task2 = input("Completed task 2? ")
    task3 = input("Completed task 3? ")
    command = f"INSERT INTO taskdetails_sysad(username,task1,task2,task3) VALUES(%s,%s,%s,%s)"
    cursor.execute(command,(username,task1,task2,task3))
    con.commit()

username = input("Enter the username")
password = input("Enter the password")

con = psycopg2.connect("host=postgres user=postgres dbname=records")
cursor=con.cursor()
cursor.execute("CREATE TABLE taskdetails_web(
    username VARCHAR PRIMARY KEY,
    task1 VARCHAR NOT NULL,
    task2 VARCHAR NOT NULL,
    task3 VARCHAR NOT NULL
)")
cursor.execute("CREATE TABLE taskdetails_app(
    username VARCHAR PRIMARY KEY,
    task1 VARCHAR NOT NULL,
    task2 VARCHAR NOT NULL,
    task3 VARCHAR NOT NULL
)")

cursor.execute("CREATE TABLE taskdetails_sysad(
    username VARCHAR PRIMARY KEY,
    task1 VARCHAR,
    task2 VARCHAR,
    task3 VARCHAR
)")

con.commit()


flag = False

with open('menteeDetails.txt', 'r') as file:
    mentee_details = file.readlines()
    for line in mentee_details:
        mentee, rollnumber = line.strip().split()
        if username == mentee + rollnumber and password == "lol":
            flag = True
            break

if flag:
    with open('mentees_Domain.txt', 'r') as file:
        mentees_domains = file.readlines()
        for line in mentees_domains:
            try:
                mentee, domains = line.split()
                if username==mentee:
                    if "web" in domains:
                        task_web(cursor, username)
                    if "app" in domains:
                        task_app(cursor, username)
                    if "sysad" in domains:
                        task_sysad(cursor, username)
            except ValueError:
                break
    con.commit()
else:
    print("Invalid username or password.")

cursor.close()
con.close()
