import random
import socket
import threading
import hashlib
import psycopg2
# we shall have 5 rounds of mcq after which winnner will be announced or we can choose between 5 10 or 20 questions mode wise
con = psycopg2.connect("host=postgres user=postgres dbname=CLI_GAME")
cursor = con.cursor()
PORT = 9999
HOST = socket.gethostbyname(socket.gethostname())
HEADER = 64
FORMAT = "utf-8"
DISCONNECT_MESSAGE = "DISCONNECTING!"
server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
server.bind((HOST,PORT))

def send(conn,msg):
    message = msg.encode(FORMAT)
    msg_length = len(message)
    sent_length = str(msg_length).encode(FORMAT)
    sent_length += b" " * (HEADER - len(sent_length))
    conn.send(sent_length)
    conn.send(message)

def receive(conn,addr):
    msg_length = conn.recv(HEADER).decode(FORMAT)
    if msg_length:
        msg_length = int(msg_length)
        message = conn.recv(msg_length).decode(FORMAT)
        return message
    return None

welcome_message = """
**************************************************
*                                                *
*           Welcome to the CLI                   *
*                  QUIZ Game!                    *
*                                                *
**************************************************

ENTER YOUR QUESTION WITH OPTIONS AND THE CORRECT ANSWER 
          AFTER EVERY ROUND
    LEADERBOARD WILL BE DISPLAYED AT THE END OF THE ROUND

**************************************************
"""

def adduser(conn,addr):
    username = receive(conn,addr)
    password = receive(conn,addr)
    h = hashlib.new("SHA256")
    h.update(password.encode())
    hashed_password = h.hexdigest()
    command = f"INSERT INTO users(username,password) VALUES(%s,%s)"
    cursor.execute(command,(username,hashed_password))
    con.commit()
    return username

def leaderboard(conn):
    cursor.execute("select * from leaderboard order by points")
    data = cursor.fetchall()
    send(conn,data)

def question_collection(conn,addr):
    question = receive(conn,addr)
    answer = receive(conn,addr)
    answer_tuple = (question,answer)
    return answer_tuple


def authenticate_user(conn,addr):
    username = receive(conn,addr)
    hashed_password = receive(conn,addr) #hashed

    cursor.execute("SELECT username from users")
    data = cursor.fetchall()
    if username in data:
        cursor.execute(f"SELECT password from users where username = %s",(username))
        data1 = cursor.fetchall()
        if data1 == hashed_password:
            send(conn, "USER AUTENTICATION IS SUCCESSFUL")
        else:
            send(conn, "WRONG CREDENTIALS")
    else:
        send(conn, "USER NOT FOUND")
    return username

def handle_client(conn, addr):
    try:
        user_status = receive(conn,addr)
        if user_status.lower() == "existing user":
            username = authenticate_user(conn, addr)
        elif user_status.lower() == "new user":
            username = adduser(conn, addr)
        else:
            send(conn, "Error: Retry")
            return

        send(conn, welcome_message)
        cursor.execute(f"insert into leaderboard(username,points) values(%s,%s)",(username,0))
        question_list = []
        for i in range(5):
            question = question_collection(conn,addr)
            question_list.append(question)
            unique_question = random.choice(question_list)
            if unique_question == question:
                question_list.remove(unique_question)
            unique_question = random.choice(question_list)
            send(conn,unique_question[0])
            answer = receive(conn,addr)
            if answer.lower() == unique_question[1].lower():
                send(conn, "ANSWER IS CORRECT +10 POINTS")
                cursor.execute(f"update leaderboard set points = points + 10 where username = %s",(username))
                con.commit()
            else:
                send(conn,"ANSWER IS INCORRECT 0 POINTS")
            leaderboard(conn)

            question_list.clear()
        
        leaderboard(conn)

    except Exception as e:
        print(f"Exception: {e}")
    finally:
        conn.close()

def start():
    server.listen()
    while True:
        conn, addr = server.accept()
        print(f"New connection from {addr}")
        thread = threading.Thread(target=handle_client, args=(conn, addr))
        thread.start()
        print(f"Active connections: {threading.active_count() - 1}")
start()