<?php

//ses_req();


audit("открыл счет для перечисления СПД","perech");


$sql = rtrim(file_get_contents('sql/perech_schet.sql'));
$p = array(':id' => $_REQUEST["id"]);
$sql=stritr($sql,$p);
$data = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);


//print_r($data);

$smarty->assign('s', $data);



$smarty->display('perech_schet.html');

?>