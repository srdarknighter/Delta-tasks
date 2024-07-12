import socket
import hashlib
import psycopg2
# we shall have 5 rounds of mcq after which winnner will be announced or we can choose between 5 10 or 20 questions mode wise
conn = psycopg2.connect("host=postgres user=postgres dbname=CLI_GAME")
cursor = conn.cursor()
PORT = 9999
HOST = socket.gethostbyname(socket.gethostname())
HEADER = 64
FORMAT = "utf-8"
DISCONNECT_MESSAGE = "DISCONNECTING!"
client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
client.connect((HOST,PORT))


def send(msg):
    message = msg.encode(FORMAT)
    msg_length = len(message)
    sent_length = str(msg_length).encode(FORMAT)
    sent_length += b" " * (HEADER - len(sent_length))
    client.send(sent_length)
    client.send(message)

def receive():
    msg_length = client.recv(HEADER).decode(FORMAT)
    if msg_length:
        msg_length = int(msg_length)
        message = conn.recv(msg_length).decode(FORMAT)
        return message
    return None

user_status = input("Enter if you are 'NEW USER' or 'EXISTING USER'")
send(user_status)

if user_status=='EXISTING USER':
    while True:
        username = input("Enter the username")
        password = input("Enter your password")
        h = hashlib.new("SHA256")
        h.update(password.encode())
        hashed_password = h.hexdigest()
        send(username)
        send(hashed_password)

        message_autentication = receive()
        print(message_autentication)
        if message_autentication == "USER AUTENTICATION IS SUCCESSFUL":
            break
        else:
            continue

elif user_status=='NEW USER':
    username = input("Enter the username")
    password = input("Enter your password")
    h = hashlib.new("SHA256")
    h.update(password.encode())
    hashed_password = h.hexdigest()
    send(username)
    send(hashed_password)
else:
    exit

for i in range(5):
    question = input("Enter the question")
    answer = input("Enter the correct option for the question")

    send((question,answer))
    #receive it in a list and store from there send question make them answer it then show leader board 

    question_answer = receive()
    print(question_answer)  
    answer_question = input("Enter the correct option for the question ")
    send(answer_question)

    answer_response = receive()
    print(answer_response)

    leaderboard_table = receive()
    for i in leaderboard_table:
        print(i)

final_leaderboard_table = receive()
for i in final_leaderboard_table:
    print(i)

exit