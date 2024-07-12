import socket

HEADER = 64
PORT = 5050
FORMAT = 'utf-8'
DISCONNECT_MESSAGE = "DISCONNECT!"
HOST = socket.gethostbyname(socket.gethostname())

client = socket.socket(socket.AF_INET,socket.SOCK_STREAM)
client.connect((HOST,PORT))

def send(msg):
    message = msg.encode(FORMAT)
    msg_length = len(message)
    sent_length = str(msg_length).encode(FORMAT)
    sent_length += b" " * (HEADER - len(sent_length))
    client.send(sent_length)
    client.send(message)


send("Hello World")
send("Hello World!!")
send("Hello chennai")
