<?

audit ("открыл форму редактирования заявки на тренинг","tr");



$p = array();
$p[':id'] = $_REQUEST["id"];
$p[':dpt_id'] = $_SESSION["dpt_id"];

if (isset($_REQUEST["SendNBT"])&&isset($_REQUEST["table"]))
{
	$order = $_REQUEST["id"];
	if (isset($_REQUEST["tr_loc"]))
	{
		$dt = $db->getOne("select TO_CHAR (dt_start, 'dd.mm.yyyy') from tr_order_head where id=".$_REQUEST["id"]);
		$p[':loc'] = $_REQUEST["tr_loc"];
		$p[':dt_start'] = "'".$dt."'";
		$sql=rtrim(file_get_contents('sql/tr_order_exist.sql'));
		$sql=stritr($sql,$p);
		$d = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
		$r = $db->query($sql);
		if ($r->numRows()==0)
		{
			$keys = array("id" => $order);
			$vals = array(
				"loc" => $_REQUEST["tr_loc"]
			);
			Table_Update("tr_order_head",$keys,$vals);
		}
		else
		{
			echo "<h3 style='color:red'>На указанную дату проведение тренинга на выбранной локации невозможно,<br>так как запланировано проведение тренинга - ".$d["name"].",<br>тренер - ".$d["fio"]."</h3>";
		}
	}
	if (isset($_REQUEST["text"]))
	{
		$keys = array("id" => $order);
		$vals = array(
			"text" => $_REQUEST["text"]
		);
		Table_Update("tr_order_head",$keys,$vals);
	}
	foreach ($_REQUEST["table"] as $k => $v)
	{
	$keys = array(
		"head" => $order,
		"tn" => $v["tn"]
	);
	$vals = array(
		"manual" => $v["manual"]
	);
	Table_Update("tr_order_body",$keys,$vals);
	}
}

$smarty->assign('text', $db->getOne("select text from tr_order_head where id=".$_REQUEST["id"]));
$smarty->assign('loc', $db->getOne("select loc from tr_order_head where id=".$_REQUEST["id"]));

$sql=rtrim(file_get_contents('sql/tr_order_edit_users.sql'));
$sql=stritr($sql,$p);
//echo $sql;
$tru = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('tru', $tru);

$sql = rtrim(file_get_contents('sql/tr_order_edit_users_add.sql'));
$sql=stritr($sql,$p);
//echo $sql;
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('trua', $data);

//print_r($data);

$sql=rtrim(file_get_contents('sql/tr_loc.sql'));
$sql=stritr($sql,$p);
$tr_loc = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('tr_loc', $tr_loc);

$smarty->display('tr_order_edit.html');

?>