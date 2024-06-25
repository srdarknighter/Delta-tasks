#going to /etc/hosts and changing the url for localhost to gemini.club for the corresopnding ip address
mkdir /var/www/gemini.club
ln -s /home/clubadmin/mentees_domain.txt /var/www/gemini.club
#create .conf file after the above step
nano /etc/apache2/sites-available/gemini.club.conf
#refer .conf file
echo "these are the file contents" | tee -a /var/www/gemini.club/mentees_domain.txt
systemctl restart apache2
a2ensite gemini.club
#figure how to host it on the new thing
#now access gemini.club/mentees_domain.txt url the data will be displayed