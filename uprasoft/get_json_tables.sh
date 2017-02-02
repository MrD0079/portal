cd /home/httpd/server2/uprasoft/
/usr/bin/php /home/httpd/server2/uprasoft/get_json_tables.php
ftp -i 77.88.208.51<<_EOF_
cd mservice
mput output/*.json
quit
_EOF_
