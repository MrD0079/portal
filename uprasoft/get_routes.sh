date >> /home/httpd/server2/uprasoft/get_routes.log
#Новый сервер:
#212.26.135.70
#avk@uprasoft.com
#001923
#Старый сервер:
#91.205.16.67
#avk@uprasoft.com.ua
#001923
cd /home/httpd/server2/uprasoft/
/usr/bin/php /home/httpd/server2/uprasoft/get_routes.php >> /home/httpd/server2/uprasoft/get_routes.log
cd /home/httpd/server2/uprasoft/output/
#ftp -v -n -i 212.26.135.70<<_EOF_
ftp -v -i 212.26.135.70 >> /home/httpd/server2/uprasoft/get_routes.log<<_EOF_
put routes.xml
quit
_EOF_
#rm routes.xml