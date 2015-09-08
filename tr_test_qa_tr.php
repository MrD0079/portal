<?php

InitRequestVar("tr",0);

$sql=rtrim(file_get_contents('sql/tr_test_qa_tr.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('tr', $data);

?>