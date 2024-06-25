cd /home/$USER/sysad/task1
sudo docker build -t sysad-server .
#make the mentees_domain.txt executable
#starting an interactive env in the docker container
sudo docker run -itd -p 82:80 sysad-server:latest
#go to gemini.club:82 to access the file
# use sudo docker cp SRC DEST to copy script files into docker container script_runner.