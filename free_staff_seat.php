<?


if (isset($_REQUEST["save"])&&isset($_REQUEST["data"]))
{
	foreach ($_REQUEST["data"] as $k=>$v)
	{
		Table_Update("free_staff_seat", array("id"=>$k),$v);
	}
}



if (isset($_REQUEST["del"]))
{
	foreach ($_REQUEST["del"] as $k=>$v)
	{
                Table_Update("free_staff_seat", array('id'=>$k),null);
	}
}

if (isset($_REQUEST["new"]))
{
	Table_Update("free_staff_seat", array("name"=>$_REQUEST["new_seat_name"]), array("name"=>$_REQUEST["new_seat_name"]));
}

$sql=rtrim(file_get_contents('sql/free_staff_seat.sql'));
$free_staff_seat = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('free_staff_seat', $free_staff_seat);
$smarty->display('free_staff_seat.html');

?>