#!/usr/bin/bash

#DIDNT WORK PYTHON CODE WORKS
#run it in the app environemnt and then send request to the postgres container
#idea is that we will take user input for username and password and cross verufy with the database
#since we dont have one jsut gonna take the password as lol
#use python + mysql connector to do this revamp the whole thing

task_web() {
    read -p "completed task 1? " wt1
    read -p "completed task 2? " wt2
    read -p "completed task 3? " wt3
    command1 = "INSERT INTO taskdetails_web(username,task1,task2,task3) VALUES("$username","$wt1","$wt2","$wt3");"
    psql -h postgres -U postgres -d records -c "$command1"
}

task_app(){
    read -p "completed task 1? " at1
    read -p "completed task 2? " at2
    read -p "completed task 3? " at3
    command2 = "INSERT INTO taskdetails_app(username,task1,task2,task3) VALUES("$username","$at1","$at2","$at3");"
    psql -h postgres -U postgres -d records -c "$command2"
}

task_sysad(){
    read -p "completed task 1? " st1
    read -p "completed task 2? " st2
    read -p "completed task 3? " st3
    command3 = "INSERT INTO taskdetails_sysad(username,task1,task2,task3) VALUES("$username","$st1","$st2","$st3");"
    psql -h postgres -U postgres -d records -c "$command3"
}


read -p "Enter the userid: " username
read -p "Enter the password: " password
flag=False

#checking if mentor or mentee has logged in
while IFS=' ' read -r mentee rollnumber;do
    if [ "$username" = "$mentee$rollnumber" ] && [ "$password" = "lol" ]; then
        flag=true
        break
    fi
done < ./menteeDetails.txt

#if mentee has logged in we update task completion details and append it to task_submitted.txt
if [ $flag = "true" ]; then
    #mentee confirmation
    #getting domains of  mentee and then asking the questions
    #the psql thingy adds the values to the sql table regarding task submission details.
    while IFS=' ' read -r domains; do
        if echo "$domains" | grep -q "web" ;then 
            task_web 
        fi

        if echo "$domains" | grep -q "app" ;then 
            task_app
        fi


        if echo "$domains" | grep -q "sysad" ;then
            task_sysad  
        fi
    done < ./mentees_Domain.txt
fi


# install psql in script_runner container and then connect to the postgres container by the command
# psql -h postgres -U postgres -d records , here records has the 