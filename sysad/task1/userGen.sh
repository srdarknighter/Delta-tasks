useradd -m clubadmin

#creating directories for mentors and mentees under clubadmin user
mkdir /home/clubadmin/mentors
mkdir /home/clubadmin/mentees


#creating home directories and accounts for each and every mentee in the menteeDetails.txt
while IFS=' ' read -r name rollno; do
	userid=$name$rollno
	useradd -m -d /home/clubadmin/mentees/$userid $userid

	#creating domainpref, task completed, task submitted files under home directory of every mentee account
	touch /home/clubadmin/mentees/$userid/domain_pref.txt
	touch /home/clubadmin/mentees/$userid/task_completed.txt
	touch /home/clubadmin/mentees/$userid/task_submitted.txt
	
	#perms 
	chmod 740 /home/clubadmin/mentees/$userid
done <./menteeDetails.txt

#made accounts and home directories for the respective mentors under the respective domains along with the flies allocatedMentees and submitted tasks with the sub
#directories of task 1,2 and 3
while IFS=' ' read -r mentor domain capacity; do
	useradd -m -d /home/clubadmin/mentors/$domain/$mentor $mentor
	touch /home/clubadmin/mentors/$domain/$mentor/allocatedMentees.txt
	mkdir -p /home/clubadmin/mentors/$domain/$mentor/submittedTasks/task1
	mkdir -p /home/clubadmin/mentors/$domain/$mentor/submittedTasks/task2
	mkdir -p /home/clubadmin/mentors/$domain/$mentor/submittedTasks/task3
	
 	#perms
	chmod 740 /home/clubadmin/mentors/$domain/$mentor
done <./mentorDetails.txt

#creating mentees_domain and setting perms
touch /home/clubadmin/mentees_domain.txt
chmod 622 /home/clubadmin/mentees_domain.txt


setfacl -m u:clubadmin:rwx /home/*


#setting specific mentor perms
while IFS=' ' read -r mentor domain capaciy; do
	setfacl -m u:$mentor:rwx /home/clubadmin/mentors/$domain/$mentor
	setfacl -m u:$mentor:--- /home/*
	setfacl -x u:$mentor /home/clubadmin/mentees_domain.txt
done < ./mentorDetails.txt


#setting specific mentee perms

while IFS=' ' read -r name roll; do
	setfacl -m u:$name$roll:rwx /home/clubadmin/mentees/$name$roll
	setfacl -m u:$name$roll:--- /home/*
	setfacl -x u:$name$roll: /home/clubadmin/mentees_domain.txt
done < ./menteeDetails.txt
