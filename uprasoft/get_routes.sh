cd /home/httpd/server2/uprasoft/
/usr/bin/php /home/httpd/server2/uprasoft/get_routes.php
ftp -i 91.205.16.67<<_EOF_
put output/routes.xml
quit
_EOF_
#rm routes.xml
