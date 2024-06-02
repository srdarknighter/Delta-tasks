sudo useradd -m clubadmin

#creating directories for mentors and mentees under clubadmin user
sudo mkdir /home/clubadmin/mentors
sudo mkdir /home/clubadmin/mentees


#creating home directories and accounts for each and every mentee in the menteeDetails.txt
while IFS=' ' read -r name rollno; do
	userid=$name$rollno
	sudo useradd -m -d /home/clubadmin/mentees/$userid $userid

	#creating domainpref, task completed, task submitted files under home directory of every mentee account
	sudo touch /home/clubadmin/mentees/$userid/domain_pref.txt
	sudo touch /home/clubadmin/mentees/$userid/task_completed.txt
	sudo touch /home/clubadmin/mentees/$userid/task_submitted.txt
	
	#perms 
	sudo chmod 740 /home/clubadmin/mentees/$userid
done </home/anirudh-s-space/sysad/sysad_exercises/task1/menteeDetails.txt

#made accounts and home directories for the respective mentors under the respective domains along with the flies allocatedMentees and submitted tasks with the sub
#directories of task 1,2 and 3
while IFS=' ' read -r mentor domain capacity; do
	sudo useradd -m -d /home/clubadmin/mentors/$domain/$mentor $mentor
	sudo touch /home/clubadmin/mentors/$domain/$mentor/allocatedMentees.txt
	sudo mkdir -p /home/clubadmin/mentors/$domain/$mentor/submittedTasks/task1
	sudo mkdir -p /home/clubadmin/mentors/$domain/$mentor/submittedTasks/task2
	sudo mkdir -p /home/clubadmin/mentors/$domain/$mentor/submittedTasks/task3
	
 	#perms
	sudo chmod 740 /home/clubadmin/mentors/$domain/$mentor
done </home/anirudh-s-space/sysad/sysad_exercises/task1/mentorDetails.txt

#creating mentees_domain and setting perms
sudo touch /home/clubadmin/mentees_domain.txt
sudo chmod 622 /home/clubadmin/mentees_domain.txt


sudo setfacl -m u:clubadmin:rwx /home/*


#setting specific mentor perms
while IFS=' ' read -r mentor domain capaciy; do
	sudo setfacl -m u:$mentor:rwx /home/clubadmin/mentors/$domain/$mentor
	sudo setfacl -m u:$mentor:--- /home/*
	sudo setfacl -x u:$mentor /home/clubadmin/mentees_domain.txt
done < /home/anirudh-s-space/sysad/sysad_exercises/task1/mentorDetails.txt


#setting specific mentee perms

while IFS=' ' read -r name roll; do
	sudo setfacl -m u:$name$roll:rwx /home/clubadmin/mentees/$name$roll
	sudo setfacl -m u:$name$roll:--- /home/*
	sudo setfacl -x u:$name$roll: /home/clubadmin/mentees_domain.txt
done < /home/anirudh-s-space/sysad/sysad_exercises/task1/menteeDetails.txt
