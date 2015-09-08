<?php

$sql=rtrim(file_get_contents('sql/val_bumvesna_cu.sql'));
$d = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('d', $d);


$smarty->display('val_bumvesna_cu.html');

?>