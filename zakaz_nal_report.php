<?
if (isset($_REQUEST["save"]))
{
	$_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);
	$keys = array(
		'tn'=>$_REQUEST['tn'],
		'year'=>$_REQUEST['year'],
		'month'=>$_REQUEST['month']
	);
	//$_REQUEST['field'] == "oknm_nm" && $_REQUEST['val'] == "" && $_REQUEST["table"] == "nm" ? $vals = null : $vals = array($_REQUEST['field'] => $_REQUEST['val']);
        $vals = array($_REQUEST['field'] => $_REQUEST['val']);
	Table_Update('promo_'.$_REQUEST["table"], $keys,$vals);
	if ($_REQUEST['field'] == "oknm_nm" && $_REQUEST['val'] == 1 && $_REQUEST["table"] == "nm")
	{
		$url="https://localhost:8080/?username=".$_SESSION["_authsession"]["username"]."&password=".$password."&auto=1&action=zakaz_nal_report&generate=1&print=1&calendar_years=".$_REQUEST['year']."&plan_month=".$_REQUEST['month']."&nets=0&tn_rmkk=".$_REQUEST['tn']."&tn_mkk=0&table=4send&nohead=1";
		$r = file_get_contents($url);
                $r = trim(preg_replace('/\s+/', ' ', $r));
		$fn="zakaz_nal_".get_new_file_id().".xls";
		$fnWithPath="sz_files/".$fn;
		$fp = fopen($fnWithPath, "w");
		fwrite($fp, $r);
		fclose($fp);
		chmod($fnWithPath,0777);
		$attaches[]=$fnWithPath;
		$subj="Заказ промо по форме 2, команда КК, ".$_REQUEST['month'].".".$_REQUEST['year'];
		$text="НМ КК согласовал заказ промобюджета по форме 2 на ".$_REQUEST['month'].".".$_REQUEST['year'];
                $text.=$r;
		//$mails = $db->getOne("SELECT wm_concat(val_string) FROM parameters WHERE dpt_id = 1 AND param_name IN ('accept1', 'accept2')");
		$mails = $db->getOne("SELECT wm_concat (e_mail) FROM user_list WHERE tn IN (2741600286, 2970)");
                Table_Update(
                        'promo_'.$_REQUEST["table"],
                        $keys,
                        array('text'=>$r,
                            'fn'=>$fn
                            )
                        );
		$db->query("BEGIN PR_PROMO_OK_SZ_CREATE (".$_REQUEST['tn'].", ".$_REQUEST['year'].", ".$_REQUEST['month']."); END;");
		send_mail($mails,$subj,$text,$fn);
		//send_mail("denis.yakovenko@avk.ua",$mails." *** ".$subj,$text,$attaches);
	}
}
else
{
audit("открыл zakaz_nal_report","zakaz_nal_report");
//InitRequestVar("nets");
InitRequestVar("calendar_years");
InitRequestVar("plan_month");
InitRequestVar("tn_rmkk");
InitRequestVar("tn_mkk");
if (isset($_REQUEST["generate"])&&($_REQUEST["calendar_years"]>0))
{
	$sql=rtrim(file_get_contents('sql/zakaz_nal_report_table.sql'));
	$sql1=rtrim(file_get_contents('sql/zakaz_nal_report_table1.sql'));
	$sql2=rtrim(file_get_contents('sql/zakaz_nal_report_table2.sql'));
	$params=array(
		':y'=>$_REQUEST["calendar_years"],
		":plan_month" => $_REQUEST["plan_month"],
		//':nets'=>$_REQUEST["nets"],
		':tn_rmkk'=>$_REQUEST["tn_rmkk"],
		':tn_mkk'=>$_REQUEST["tn_mkk"],
		':tn'=>$tn
	);
	$sql=stritr($sql,$params);
	$sql1=stritr($sql1,$params);
	$sql2=stritr($sql2,$params);
	$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$data1 = $db->getAll($sql1, null, null, null, MDB2_FETCHMODE_ASSOC);
	$data2 = $db->getAll($sql2, null, null, null, MDB2_FETCHMODE_ASSOC);
	//echo $sql;
		foreach ($data2 as $k=>$v)
		{
			$d[$v["rmkk"]]["head"]=$v;
		}
		foreach ($data1 as $k=>$v)
		{
			$d[$v["rmkk"]]["data"][$v["mkk_ter"]]["head"]=$v;
		}
		foreach ($data as $k=>$v)
		{
			$d[$v["rmkk"]]["data"][$v["mkk_ter"]]["data"][$v["id_net"]]["head"]=$v;
		}
		$smarty->assign("data_table", $d);
                //print_r($d);
}
$params=array(':tn'=>$tn,':dpt_id' => $_SESSION["dpt_id"]);
$sql=rtrim(file_get_contents('sql/list_mkk_all.sql'));
$sql=stritr($sql,$params);
$list_mkk_all = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('list_mkk_all', $list_mkk_all);
$sql=rtrim(file_get_contents('sql/calendar_years.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('calendar_years', $data);
$sql=rtrim(file_get_contents('sql/calendar_months.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('calendar_months', $data);
$sql=rtrim(file_get_contents('sql/list_rmkk.sql'));
$sql=stritr($sql,$params);
$list_rmkk = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('list_rmkk', $list_rmkk);
$sql=rtrim(file_get_contents('sql/list_mkk.sql'));
$sql=stritr($sql,$params);
$list_mkk = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('list_mkk', $list_mkk);
$sql = rtrim(file_get_contents('sql/emp_exp_spd_list.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('spd_list', $data);
$smarty->display('kk_start.html');
$smarty->display('zakaz_nal_report.html');
$smarty->display('kk_end.html');
}