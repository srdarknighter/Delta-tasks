#!usr/bin/bash
#core user is clubadmin
#core password is set as joemama"
#going to authenticate login details
declare -A mentor_capacity

#creating capacity variables for all the mentors and initialising to zero, instead storing capacity as variable values
#and subtracting one from it every time a mentee is added to the list. When the variable becomes zero it goes to the next mentor
#using an associative array for this task

while IFS=' ' read -r mentor domain cap;do
    mentor_capacity["$mentor"] = "$cap"
done </home/anirudh-s-space/sysad/sysad_exercises/task1/mentorDetails.txt

read -p "Enter userid: " userid
read -p "Enter password: " password

if [ "$userid" = clubadmin ] && [ "$password" = joemama ]; then

    #starting with webdev
    #using mentees_domain.txt file
    
    for i in /home/clubadmin/mentors/web/*; do
        while IFS=' ' read -r userid domains;do
            if echo "$domains" | grep -q "web" ;then
                if [ ${mentor_capacity["$i"]} -ne 0 ];then
                    echo "$userid" | sudo tee -a /home/clubadmin/mentors/web/$i/allocatedMentees.txt
                    oldcap = "${mentor_capacity["$i"]}"
                    newcap = $((oldcap - 1))
                    mentor_capacity["$i"] = "$newcap"
                fi
            fi
        done </home/clubadmin/mentees_domain.txt
    done


    for i in /home/clubadmin/mentors/app/*; do
        while IFS=' ' read -r userid domains;do
            if echo "$domains" | grep -q "app" ;then
                if [ ${mentor_capacity["$i"]} -ne 0 ];then
                    echo "$userid" | sudo tee -a /home/clubadmin/mentors/app/$i/allocatedMentees.txt
                    oldcap = "${mentor_capacity["$i"]}"
                    newcap = $((oldcap - 1))
                    mentor_capacity["$i"] = "$newcap"
                fi
            fi
        done </home/clubadmin/mentees_domain.txt
    done

    for i in /home/clubadmin/mentors/sysad/*; do
        while IFS=' ' read -r userid domains;do
            if echo "$domains" | grep -q "sysad" ;then
                if [ ${mentor_capacity["$i"]} -ne 0 ];then
                    echo "$userid" | sudo tee -a /home/clubadmin/mentors/sysad/$i/allocatedMentees.txt
                    oldcap = "${mentor_capacity["$i"]}"
                    newcap = $((oldcap - 1))
                    mentor_capacity["$i"] = "$newcap"
                fi
            fi
        done </home/clubadmin/mentees_domain.txt
    done
fi