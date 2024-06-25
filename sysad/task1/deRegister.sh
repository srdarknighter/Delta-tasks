read -p "Enter the userid: " username
read -p "Enter the password: " password
flag=False
while IFS=' ' read -r mentee rollnumber;do
    if [ "$username" = "$mentee$rollnumber" ] && [ "$password" = "lol" ]; then
        flag=true
    fi
done <./menteeDetails.txt

if [ $flag = "true" ]; then
    read -p "Enter the domain u want to exit" dom1

    sed -i "s/$dom1//g" /home/clubadmin/mentees/$username/domain_pref.txt
    rm -r /home/clubadmin/mentees/$username/$dom1

    read -p "Enter the domain u want to exit(press enter to skip)" dom2
    sed -i "s/$dom2//g" /home/clubadmin/mentees/$username/domain_pref.txt
    rm -r /home/clubadmin/mentees/$username/$dom2

    read -p "Enter the domain u want to exit(press enter to skip)" dom3
    sed -i "s/$dom3//g" /home/clubadmin/mentees/$username/domain_pref.txt
    rm -r /home/clubadmin/mentees/$username/$dom3
fi