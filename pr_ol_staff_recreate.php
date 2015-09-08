<?

$db->query('begin pr_ol_staff_recreate('.$_REQUEST['dpt_id'].'); end;');

//echo 'begin pr_ol_staff_recreate('.$_REQUEST['dpt_id'].'); end;';

echo 'ОЛ данной страны обновлены '.$now_date_time;


?>