read -p "Enter userid: " userid
read -p "Enter password: " password
#checking if core user has logged in
#using an associative array we can keep a count of total task submission per domain
domains_count=3
#to get total people who have registered for each and every domain we can access it from mentees_domain.txt
count_web=$(grep -c "web" /home/clubadmin/mentees_domain.txt)
count_app=$(grep -c "app" /home/clubadmin/mentees_domain.txt)
count_sysad=$(grep -c "sysad" /home/clubadmin/mentees_domain.txt)

web_task1=0
web_task2=0
web_task3=0
app_task1=0
app_task2=0
app_task3=0
sysad_task1=0
sysad_task2=0
sysad_task3=0

#next we have to retrieve number of people who submitted the each of the tasks under each domain
#go to each domain task folder check if empty or not and occrodingly increment it

if [ "$userid" = clubadmin ] && [ "$password" = joemama ]; then
    for i in /home/clubadmin/mentees/*; then
        if [ "$(find /home/clubadmin/mentees/$i/web/Task1 | wc -l)" -ne 0 ]; then
            web_task1=$((web_task1+1))
        fi

        if [ "$(find /home/clubadmin/mentees/$i/web/Task2 | wc -l)" -ne 0 ]; then
            web_task2=$((web_task2+1))
        fi

        if [ "$(find /home/clubadmin/mentees/$i/web/Task3 | wc -l)" -ne 0 ]; then
            web_task3=$((web_task3+1))
        fi

        if [ "$(find /home/clubadmin/mentees/$i/app/Task1 | wc -l)" -ne 0 ]; then
            app_task1=$((app_task1+1))
        fi

        if [ "$(find /home/clubadmin/mentees/$i/app/Task2 | wc -l)" -ne 0 ]; then
            app_task2=$((app_task2+1))
        fi

        if [ "$(find /home/clubadmin/mentees/$i/app/Task3 | wc -l)" -ne 0 ]; then
            app_task3=$((app_task3+1))
        fi

        if [ "$(find /home/clubadmin/mentees/$i/sysad/Task1 | wc -l)" -ne 0 ]; then
            sysad_task1=$((sysad_task1+1))
        fi

        if [ "$(find /home/clubadmin/mentees/$i/sysad/Task2 | wc -l)" -ne 0 ]; then
            sysad_task2=$((sysad_task2+1))
        fi

        if [ "$(find /home/clubadmin/mentees/$i/sysad/Task3 | wc -l)" -ne 0 ]; then
            sysad_task3=$((sysad_task3+1))
        fi
fi

percentage_web=$(echo "scale=2; (($web_task1 + $web_task2 + $web_task3) / $count_web) * 100" | bc)
percentage_app=$(echo "scale=2; (($app_task1 + $app_task2 + $app_task3) / $count_app) * 100" | bc)
percentage_sysad=$(echo "scale=2; (($sysad_task1 + $sysad_task2 + $sysad_task3) / $count_sysad) * 100" | bc)

echo "Web: $percentage_web App: $percentage_app Sysad: $percentage_sysad"