<?

//ses_req();

if (isset($_REQUEST["save"])&&isset($_REQUEST["data"]))
{
	foreach ($_REQUEST["data"] as $k=>$v)
	{
		Table_Update("merch_report_cal_rep", array("id"=>$k),$v);
	}
	if (isset($_FILES["files"]))
	{
		$z = $_FILES["files"];
		foreach ($z['tmp_name'] as $k=>$v)
		{
			if (is_uploaded_file($z["tmp_name"][$k]))
			{
				$a=pathinfo($z["name"][$k]);
				$fn="pict".get_new_file_id().".".$a["extension"];
				move_uploaded_file($z["tmp_name"][$k], "files/".$fn);
				$vals = array("pict"=>$fn);
				Table_Update ("merch_report_cal_rep", array("id"=>$k), $vals);
			}
		}
	}
}

$sql=rtrim(file_get_contents('sql/merch_report_cal_rep.sql'));
$merch_report_cal_rep = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('d', $merch_report_cal_rep);
$smarty->display('merch_report_cal_rep.html');

?>