cd /home/httpd/server2/uprasoft/output/
ftp -i 91.205.16.67<<_EOF_
mget *.xml
mdel *.xml
quit
_EOF_
cd /home/httpd/server2/uprasoft/
#rm routes.xml
/usr/bin/php /home/httpd/server2/uprasoft/jopa.php
# > /home/httpd/server2/uprasoft/jopa.log
#chmod 666 /home/httpd/server2/uprasoft/jopa.log
#rm -rf /home/httpd/server2/uprasoft/*.xml
#mv /home/httpd/server2/uprasoft/*.xml /home/httpd/server2/uprasoft/Loaded/
