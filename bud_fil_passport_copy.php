<?

$db->query("BEGIN bud_fil_passport_copy (".$_REQUEST['from'].", ".$_REQUEST['to']."); END;");

?>