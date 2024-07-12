FROM ubuntu
WORKDIR /usr/src/app
COPY . .
RUN apt-get update && apt-get install python3 && apt-get install pip && apt-get install psycopg2-binary
EXPOSE 9999
CMD ["python3","server.py"]