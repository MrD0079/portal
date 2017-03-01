<?

audit("МР открыл отчет","merch_report_new");

$sql=rtrim(file_get_contents('sql/routes_text.sql'));
$routes_text = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('routes_text', $routes_text);

$sql = rtrim(file_get_contents('sql/merch_report_dates_list.sql'));
$dates_list = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('dates_list', $dates_list);

InitRequestVar("dates_list",$now);

$x = $db->getOne("select case when to_date('".$_REQUEST["dates_list"]."','dd.mm.yyyy') > trunc(sysdate) then 1 end from dual");
$smarty->assign('readonly', $x);

foreach ($dates_list as $k=>$v){if ($v["data_c"]==$_REQUEST["dates_list"]){$day=$v["dm"];}}

$sql = rtrim(file_get_contents('sql/merch_report_head.sql'));
$p=array(":data"=>"'".$_REQUEST["dates_list"]."'",":login"=>"'".$login."'");
$sql=stritr($sql,$p);
$r=$db->GetRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('route', $r);

function Time2Int($v)
{
	$h=substr($v,0,2);
	$m=substr($v,3,2);
	//echo $h."-".$m."<br>";
	return $h*60+$m;
}


if (isset($_REQUEST["save_zp"])&&isset($_REQUEST["data"]))
{
	foreach ($_REQUEST["data"] as $k => $v)
	{
		$keys = array('head_id'=>$v["head_id"],'h_fio_otv'=>$v["h_fio_otv"]);
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
			foreach ($v as $k1 => $v1)
			{
				$keys = array('rb_id'=>$k1,'dt'=>OraDate2MDBDate($_REQUEST["dates_list"]));
				$values = array($k=>$v1);
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
				$p=array(
					":head_id"=>$r["id"],
					":kod_tp"=>$v["tp"],
					":dt"=>"'".$_REQUEST["dates_list"]."'"
				);
				foreach ($v["ag"] as $k1 => $v1)
				{
					$sql = rtrim(file_get_contents('sql/merch_report_new_vv_ins.sql'));
					$p[":ag_id"]=$v1;
					$sql=stritr($sql,$p);
					$res = $db->query($sql);
				}
			}
		}

		$sql = rtrim(file_get_contents('sql/merch_report_new_vv_tp.sql'));
		$p=array(":route"=>$r["id"]);
		$sql=stritr($sql,$p);
		$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
		$smarty->assign('vv_tp', $res);

		$sql=rtrim(file_get_contents('sql/routes_agents.sql'));
		$routes_agents = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
		$smarty->assign('routes_agents', $routes_agents);

		$sql = rtrim(file_get_contents('sql/merch_report_new_routes_body.sql'));
		$p=array(":route"=>$r["id"],":day"=>$day,":dates_list"=>"'".$_REQUEST["dates_list"]."'");
		$sql=stritr($sql,$p);
		$rb = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

		$sql = rtrim(file_get_contents('sql/merch_report_new_routes_body1.sql'));
		$p=array(":route"=>$r["id"],":day"=>$day,":dates_list"=>"'".$_REQUEST["dates_list"]."'");
		$sql=stritr($sql,$p);
		$rb1 = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

		foreach ($rb as $k=>$v)
		{
			$d[$v["kodtp"]]["head"]=$v;
			$d[$v["kodtp"]]["data"][$v["ag_id"].".".$v["vv"]]=$v;

			$sqlr = rtrim(file_get_contents('sql/merch_report_new_routes_body_reminders.sql'));
			$p=array(":route"=>$r["id"],":ag_id"=>$v["ag_id"],":kodtp"=>$v["kodtp"],":dates_list"=>"'".$_REQUEST["dates_list"]."'");

			$sqlr=stritr($sqlr,$p);
			$rb1r = $db->getAll($sqlr, null, null, null, MDB2_FETCHMODE_ASSOC);

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

		isset($d) ? $smarty->assign('d', $d) : null;
		$sql = rtrim(file_get_contents('sql/merch_report_new_routes_body_total.sql'));
		$p=array(":route"=>$r["id"],":day"=>$day,":dates_list"=>"'".$_REQUEST["dates_list"]."'");
		$sql=stritr($sql,$p);
		$res = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
		$smarty->assign('rb_total', $res);

		/*$sql = rtrim(file_get_contents('sql/merch_report_new_zpm.sql'));
		$p=array(":head_id"=>$r["id"],":month_list"=>"'".$_REQUEST["dates_list"]."'");
		$sql=stritr($sql,$p);
		$zpm = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
		$smarty->assign('zpm', $zpm);
$_REQUEST["zpm"]=$sql;
$_REQUEST["zpm_res"]=$zpm;*/
		$sql = rtrim(file_get_contents('sql/merch_report_new_zp.sql'));
		$p=array(":head_id"=>$r["id"]);
		$sql=stritr($sql,$p);
		$zp = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
		$smarty->assign('zp', $zp);
$_REQUEST["zp"]=$sql;
$_REQUEST["zp_res"]=$zp;

		$sql="select path from ms_faq";
		$f = $db->getOne($sql);
		$smarty->assign('ms_faq', $f);
	}
}

$smarty->display('merch_report_new.html');

?>