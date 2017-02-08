date >> /home/httpd/server2/uprasoft/jopa.log
#Новый сервер:
#212.26.135.70
#avk@uprasoft.com
#001923
#Старый сервер:
#91.205.16.67
#avk@uprasoft.com.ua
#001923
cd /home/httpd/server2/uprasoft/output/
#ftp -i 212.26.135.70<<_EOF_
ftp -v -i 212.26.135.70 >> /home/httpd/server2/uprasoft/jopa.log<<_EOF_
mget 20*.xml
mdel 20*.xml
quit
_EOF_
cd /home/httpd/server2/uprasoft/
#rm routes.xml
/usr/bin/php /home/httpd/server2/uprasoft/jopa.php >> /home/httpd/server2/uprasoft/jopa.log
# > /home/httpd/server2/uprasoft/jopa.log
#chmod 666 /home/httpd/server2/uprasoft/jopa.log
#rm -rf /home/httpd/server2/uprasoft/*.xml
#mv /home/httpd/server2/uprasoft/*.xml /home/httpd/server2/uprasoft/Loaded/