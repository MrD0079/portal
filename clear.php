<?php
$output = `find /srv/www/files/ -type f -exec chmod 0777 {} \;`;
exit;
#$output = `chmod -R 777 /srv/www/merch_photo_report_new_archives/*`;
#$output = `chmod -R 777 /srv/www/merch_spec_report_archives/*`;
$output = `find /srv/www/files/uprasoft/Loaded/                   -mtime +3 -delete`;
$output = `find /srv/www/files/merch_chat_files                   -mtime +124 -delete`;
$output = `find /srv/www/files/merch_photo_report_new_archives    -mtime +124 -delete`;
$output = `find /srv/www/files/merch_spec_report_archives         -mtime +124 -delete`;
$output = `find /srv/www/files/merch_spec_report_files            -mtime +124 -delete`;
$output = `find /srv/www/files/merch_spec_report_files_chat_files -mtime +124 -delete`;
$output = `find /srv/www/files/merch_chat_files                   -type d -empty -delete`;
$output = `find /srv/www/files/merch_photo_report_new_archives    -type d -empty -delete`;
$output = `find /srv/www/files/merch_spec_report_archives         -type d -empty -delete`;
$output = `find /srv/www/files/merch_spec_report_files            -type d -empty -delete`;
$output = `find /srv/www/files/merch_spec_report_files_chat_files -type d -empty -delete`;
#/usr/bin/php /srv/www/files/clear.php
#$output = `du -d1 -c -BM /srv/www/htdocs/ms/`;
?>