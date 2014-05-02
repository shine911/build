echo -e "${bldblu}Uploading to FTP sever for $DEVICE ${txtrst}"

# Call 1. Uses the ftp command with the -inv switches.  -i turns off interactive     prompting. -n Restrains FTP from attempting the auto-login feature. -v enables verbose and progress. 

ftp -inv $HOST << EOF

# Call 2. Here the login credentials are supplied by calling the variables.

user $USER $PASS

# Call 3. Here you will change to the directory where you want to put or get
cd /download/rom/mokee

tick

# Call4.  Here you will tell FTP to put or get the file.
put pa-$DEVICE_*

# End FTP Connection
bye