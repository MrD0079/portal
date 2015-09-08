<?php

InitRequestVar("event",0);

$sql=rtrim(file_get_contents('sql/ocenka_events.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('events', $data);

foreach ($data as $k=>$v)
{
	if ($_REQUEST["event"]==$v["year"]&&$v["disabled"]==1)
	{
		$smarty->assign('disabled', 'disabled');
	}
}

?>