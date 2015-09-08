<?

//audit("открыл merch_report_sb","merch_report_sb");

$sql = rtrim(file_get_contents('sql/merch_report_dates_list.sql'));
$dates_list = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('dates_list', $dates_list);
InitRequestVar("dates_list",$now);
foreach ($dates_list as $k=>$v){if ($v["data_c"]==$_REQUEST["dates_list"]){$day=$v["dm"];}}
//echo $day;

$sql = rtrim(file_get_contents('sql/merch_report_head.sql'));
$p=array(":data"=>"'".$_REQUEST["dates_list"]."'",":login"=>"'".$login."'");
$sql=stritr($sql,$p);
$r=$db->GetRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('route', $r);

if (isset($r["id"]))
{
	if ($r["id"]!="")
	{
		$sql = rtrim(file_get_contents('sql/merch_report_sb.sql'));
		$p=array(":data"=>"'".$_REQUEST["dates_list"]."'",":route"=>$r["id"]);
		$sql=stritr($sql,$p);
		$rb = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
		//echo $sql;
		//print_r($p);
		foreach ($rb as $k=>$v)
		{
			$sql = rtrim(file_get_contents('sql/merch_report_sb_products.sql'));
			$p=array(":data"=>"'".$_REQUEST["dates_list"]."'",":route"=>$r["id"],":kodtp"=>$v["kodtp"]);
			$sql=stritr($sql,$p);
			$rb1 = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
			//print_r($rb1);
			//$rb1?$rb[$k]["products"]=$rb1:$rb[$k]["products"]=null;
			$rb[$k]["products"]=$rb1;
		}
		$smarty->assign('d', $rb);
		//print_r($rb);
	}
}

$smarty->display('merch_report_sb.html');

?>