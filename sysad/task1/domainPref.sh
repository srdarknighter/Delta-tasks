#!/usr/bin/bash
#idea is that we will take user input for username and password and cross verufy with the database
#since we dont have one jsut gonna take the password as lol
read -p "Enter the userid: " username
read -p "Enter the password: " password
flag=False
while IFS=' ' read -r mentee rollnumber;do
    if [ "$username" = "$mentee$rollnumber" ] && [ "$password" = "lol" ]; then
        flag=True
    fi
done </home/anirudh-s-space/sysad/sysad_exercises/task1/menteeDetails.txt   

if echo $flag; then
    # Getting domain prefs
    read -p "First preference: " n1
    read -p "Second preference (press Enter to skip): " n2
    read -p "Third preference (press Enter to skip): " n3

    #appending domain prefs
    echo "$n1 $n2 $n3" | sudo tee -a /home/clubadmin/mentees/$username/domain_Pref.txt

    #creating dir for every domain pref under the mentee's dir
    sudo mkdir -p /home/clubadmin/mentees/$username/$n1
    if [ -n "$n2" ]; then
        sudo mkdir -p /home/clubadmin/mentees/$username/$n2
    fi
    if [ -n "$n3" ]; then
        sudo mkdir -p /home/clubadmin/mentees/$username/$n3
    fi

    #appending the details to mentees_domain.txt
    echo "$username $n1->$n2->$n3" | sudo tee -a /home/clubadmin/mentees_domain.txt
fi