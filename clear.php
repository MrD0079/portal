<?php
$output = `find /home/httpd/server2/uprasoft/Loaded/                   -mtime +3 -delete`;
$output = `find /home/httpd/server2/merch_chat_files                   -mtime +124 -delete`;
$output = `find /home/httpd/server2/merch_photo_report_new_archives    -mtime +124 -delete`;
$output = `find /home/httpd/server2/merch_spec_report_archives         -mtime +124 -delete`;
$output = `find /home/httpd/server2/merch_spec_report_files            -mtime +124 -delete`;
$output = `find /home/httpd/server2/merch_spec_report_files_chat_files -mtime +124 -delete`;
$output = `find /home/httpd/server2/merch_chat_files                   -type d -empty -delete`;
$output = `find /home/httpd/server2/merch_photo_report_new_archives    -type d -empty -delete`;
$output = `find /home/httpd/server2/merch_spec_report_archives         -type d -empty -delete`;
$output = `find /home/httpd/server2/merch_spec_report_files            -type d -empty -delete`;
$output = `find /home/httpd/server2/merch_spec_report_files_chat_files -type d -empty -delete`;
#/usr/bin/php /home/httpd/server2/clear.php
#$output = `du -d1 -c -BM /srv/www/htdocs/ms/`;
?>