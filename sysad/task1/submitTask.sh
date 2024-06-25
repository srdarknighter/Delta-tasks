#!/usr/bin/bash
#idea is that we will take user input for username and password and cross verufy with the database
#since we dont have one jsut gonna take the password as lol
read -p "Enter the userid: " username
read -p "Enter the password: " password
flag=False
flag1=False

#checking if mentor or mentee has logged in
while IFS=' ' read -r mentee rollnumber;do
    if [ "$username" = "$mentee$rollnumber" ] && [ "$password" = "lol" ]; then
        flag=true
    fi
done <./menteeDetails.txt   

while IFS=' ' read -r mentor domain cap; do
    if [ "$username" = "$mentor" ] && [ "$password" = "lol" ]; then
        flag1=true
        name="$mentor"
        pref="$domain"
    fi
done <./mentorDetails.txt

#if mentee has logged in we update task completion details and append it to task_completed.txt
if [ $flag = "true" ]; then
    #mentee confirmation
    #getting domains of  mentee and then asking the questions
    while IFS=' ' read -r domains; do
        if echo "$domains" | grep -q "web" ;then 
            mkdir -p /home/clubadmin/mentees/$username/web/Task1
            mkdir -p /home/clubadmin/mentees/$username/web/Task2
            mkdir -p /home/clubadmin/mentees/$username/web/Task3

            read -p "completed task 1? " wt1
            read -p "completed task 2? " wt2
            read -p "completed task 3? " wt3
        echo " Web: 
                Task 1: "$wt1"
                Task 2: "$wt2"
                Task 3: "$wt3" " | tee -a /home/clubadmin/mentees/$username/task_submitted.txt

        fi


        if echo "$domains" | grep -q "app" ;then 
            mkdir -p /home/clubadmin/mentees/$username/app/Task1
            mkdir -p /home/clubadmin/mentees/$username/app/Task2
            mkdir -p /home/clubadmin/mentees/$username/app/Task3

            read -p "completed task 1? " at1
            read -p "completed task 2? " at2
            read -p "completed task 3? " at3
        echo " App: 
                Task 1: "$at1"
                Task 2: "$at2"
                Task 3: "$at3" " | tee -a /home/clubadmin/mentees/$username/task_submitted.txt

        fi


        if echo "$domains" | grep -q "sysad" ;then
            mkdir -p /home/clubadmin/mentees/$username/sysad/Task1
            mkdir -p /home/clubadmin/mentees/$username/sysad/Task2
            mkdir -p /home/clubadmin/mentees/$username/sysad/Task3
            read -p "completed task 1? " st1
            read -p "completed task 2? " st2
            read -p "completed task 3? " st3
        echo " Sysad: 
                Task 1: "$st1"
                Task 2: "$st2"
                Task 3: "$st3" " | tee -a /home/clubadmin/mentees/$username/task_submitted.txt

        fi
    done <./menteeDetails.txt
fi

#if mentor logs in we need mentors domain+ userid of mentee which is in allocatedMentees.txt and then we check in mentees directory
#if the domain, task folders have been uploaded and then proceed to create the symlink
#(under task folders in mentor we create induvidual mentee folders and put the sym link in it)

if [ $flag1 = "true" ]; then
    while IFS=' ' read -r userid; do
        if [[ -d "/home/clubadmin/mentees/$userid/$pref/Task1" &&  -d "/home/clubadmin/mentees/$userid/$pref/Task2" && -d "/home/clubadmin/mentees/$userid/$pref/Task3" ]]; then

            if [ "$(find /home/clubadmin/mentees/$userid/$pref/Task1 | wc -l)" -ne 0 ]; then
                ln -s /home/clubadmin/mentees/$userid/$pref/Task1 /home/clubadmin/mentors/$pref/$name/submittedTasks/task1/$userid
                
                echo "$pref Task1 completed" | tee -a /home/clubadmin/mentees/$userid/task_completed.txt
            fi

            if [ "$(find /home/clubadmin/mentees/$userid/$pref/Task2 | wc -l)" -ne 0 ]; then
                ln -s /home/clubadmin/mentees/$userid/$pref/Task2 /home/clubadmin/mentors/$pref/$name/submittedTasks/task2/$userid
                echo "$pref Task2 completed" | tee -a /home/clubadmin/mentees/$userid/task_completed.txt
            fi

            if [ "$(find /home/clubadmin/mentees/$userid/$pref/Task3 | wc -l)" -ne 0 ]; then
                ln -s /home/clubadmin/mentees/$userid/$pref/Task3 /home/clubadmin/mentors/$pref/$name/submittedTasks/task3/$userid
                echo "$pref Task3 completed" | tee -a /home/clubadmin/mentees/$userid/task_completed.txt
            fi

        fi
    done </home/clubadmin/mentors/$pref/$name/allocatedMentees.txt
fi