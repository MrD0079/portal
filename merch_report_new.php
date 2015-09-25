<?

//audit("открыл merch_report_new","merch_report_new");




$sql=rtrim(file_get_contents('sql/routes_text.sql'));
$routes_text = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('routes_text', $routes_text);

$sql = rtrim(file_get_contents('sql/merch_report_dates_list.sql'));
$dates_list = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('dates_list', $dates_list);

InitRequestVar("dates_list",$now);

foreach ($dates_list as $k=>$v){if ($v["data_c"]==$_REQUEST["dates_list"]){$day=$v["dm"];}}

//echo $day;

$sql = rtrim(file_get_contents('sql/merch_report_head.sql'));
$p=array(":data"=>"'".$_REQUEST["dates_list"]."'",":login"=>"'".$login."'");
$sql=stritr($sql,$p);
//$sql = "select * from routes_head where login='".$login."' and data=trunc(to_date('".$_REQUEST["dates_list"]."','dd/mm/yyyy'),'mm')";
$r=$db->GetRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('route', $r);

//echo $sql;

//echo $r["id"];







function Time2Int($v)
{
	$h=substr($v,0,2);
	$m=substr($v,3,2);
	//echo $h."-".$m."<br>";
	return $h*60+$m;
}


if (isset($_REQUEST["save_zp"]))
{
	foreach ($_REQUEST["data"] as $k => $v)
	{
		$keys = array('head_id'=>$r["id"],'h_fio_otv'=>$k);
		isset($v['part1_dt'])?$v['part1_dt']=OraDate2MDBDate($v['part1_dt']):null;
		isset($v['part2_dt'])?$v['part2_dt']=OraDate2MDBDate($v['part2_dt']):null;
		Table_Update ('mr_zp', $keys, $v);
	}
}

if (isset($_REQUEST["save"]))
{
	if (isset($_REQUEST["rb"]))
	{
		$table_name = "merch_report";
		foreach ($_REQUEST["rb"] as $k => $v)
		{
			//echo $k."<br>";
			foreach ($v as $k1 => $v1)
			{
				/*if (($k=="tz_start") or ($k=="tz_end"))
				{
					$v1=Time2Int($v1);
					//echo $v1;
				}*/
				//echo $k1."<br>";
				$keys = array('rb_id'=>$k1,'dt'=>OraDate2MDBDate($_REQUEST["dates_list"]));
				$values = array($k=>$v1);
				//print_r($keys);
				//print_r($values);
				Table_Update ($table_name, $keys, $values);
			}
		}
	}
}

if (isset($r["id"]))
{
	if ($r["id"]!="")
	{
		if (isset($_REQUEST["add_vv"])&&isset($_REQUEST["vv_new"]))
		{
			foreach ($_REQUEST['vv_new'] as $k => $v)
			{
				$sql = rtrim(file_get_contents('sql/merch_report_new_vv_ins.sql'));
				$p=array(
					":head_id"=>$r["id"],
					":kod_tp"=>$v["tp"],
					":ag_id"=>$v["ag"],
					//":dt"=>"'".OraDate2MDBDate($_REQUEST["dates_list"])."'"
					":dt"=>"'".$_REQUEST["dates_list"]."'"
				);
				$sql=stritr($sql,$p);
				$res = $db->query($sql);
				//echo $sql;
			}
		}

		$sql = rtrim(file_get_contents('sql/merch_report_new_vv_tp.sql'));
		$p=array(":route"=>$r["id"]);
		$sql=stritr($sql,$p);
		//echo $sql;
		$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
		$smarty->assign('vv_tp', $res);

		$sql=rtrim(file_get_contents('sql/routes_agents.sql'));
		$routes_agents = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
		$smarty->assign('routes_agents', $routes_agents);

		$sql = rtrim(file_get_contents('sql/merch_report_new_routes_body.sql'));
		$p=array(":route"=>$r["id"],":day"=>$day,":dates_list"=>"'".$_REQUEST["dates_list"]."'");
		$sql=stritr($sql,$p);
		$rb = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
		//echo $sql;

		$sql = rtrim(file_get_contents('sql/merch_report_new_routes_body1.sql'));
		$p=array(":route"=>$r["id"],":day"=>$day,":dates_list"=>"'".$_REQUEST["dates_list"]."'");
		$sql=stritr($sql,$p);
		$rb1 = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
		//echo $sql;

		foreach ($rb as $k=>$v)
		{
			$d[$v["kodtp"]]["head"]=$v;
			$d[$v["kodtp"]]["data"][$v["ag_id"].".".$v["vv"]]=$v;

			$sqlr = rtrim(file_get_contents('sql/merch_report_new_routes_body_reminders.sql'));
			$p=array(":route"=>$r["id"],":ag_id"=>$v["ag_id"],":kodtp"=>$v["kodtp"],":dates_list"=>"'".$_REQUEST["dates_list"]."'");
//print_r($p);
			$sqlr=stritr($sqlr,$p);
			$rb1r = $db->getAll($sqlr, null, null, null, MDB2_FETCHMODE_ASSOC);
			//echo $sql;
			$d[$v["kodtp"]]["data"][$v["ag_id"].".".$v["vv"]]['reminders']=null;
			foreach ($rb1r as $kr=>$vr)
			{
				$d[$v["kodtp"]]["data"][$v["ag_id"].".".$v["vv"]]['reminders']["rep".$vr['rep_id']]=$vr;
			}
		}
		foreach ($rb1 as $k=>$v)
		{
			$d[$v["kodtp"]]["total"]=$v;
		}
		//print_r($d);
		isset($d) ? $smarty->assign('d', $d) : null;
		$sql = rtrim(file_get_contents('sql/merch_report_new_routes_body_total.sql'));
		$p=array(":route"=>$r["id"],":day"=>$day,":dates_list"=>"'".$_REQUEST["dates_list"]."'");
		$sql=stritr($sql,$p);
		$res = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
		$smarty->assign('rb_total', $res);

$sql = rtrim(file_get_contents('sql/merch_report_new_zpm.sql'));
$p=array(":head_id"=>$r["id"],":month_list"=>"'".$_REQUEST["dates_list"]."'");
$sql=stritr($sql,$p);
$zpm = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('zpm', $zpm);

$sql = rtrim(file_get_contents('sql/merch_report_new_zp.sql'));
$p=array(":head_id"=>$r["id"],":month_list"=>"'".$_REQUEST["dates_list"]."'");
$sql=stritr($sql,$p);
$zp = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('zp', $zp);

/*
print_r($zpm);
echo "zzz";
print_r($zp);
*/

	}
}

$smarty->display('merch_report_new.html');

?>