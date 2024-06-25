# apparently docker doesnt support setfacl command so gotta get the acl thingy
#installing nano also to edit code
FROM ubuntu
WORKDIR /usr/src/app
COPY . .
RUN apt-get update && apt-get install -y apache2 && apt-get install -y acl && apt-get install -y apache2-utils
EXPOSE 80
ENTRYPOINT [ "apache2ctl" ]
CMD ["-DFOREGROUND"]