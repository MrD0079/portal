<?php

audit("открыл сводный отчет М-Сервис","merch_report_4sv_by_spec_new1");

InitRequestVar("dates_list1",$_REQUEST["dates_list"]);
InitRequestVar("dates_list2",$_REQUEST["dates_list"]);
InitRequestVar("select_route_numb",0);
InitRequestVar("select_route_fio_otv",0);
InitRequestVar("svms_list",0);
InitRequestVar("oblast","0");
InitRequestVar("nets",0);
InitRequestVar("agent",0);
InitRequestVar("city","0");
InitRequestVar("tp",0);

$p = array(
	':dpt_id' => $_SESSION["dpt_id"],
	":sd"=>"'".$_REQUEST["dates_list1"]."'",
	":ed"=>"'".$_REQUEST["dates_list2"]."'",
	":tn"=>$tn,":login"=>"'".$login."'",":login"=>"'".$login."'"
);

$sql = rtrim(file_get_contents('sql/dates_list.sql'));
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('dates_list', $res);

$sql=rtrim(file_get_contents('sql/merch_report_4sv_by_spec_new1_oblast.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('oblast', $data);

$sql=rtrim(file_get_contents('sql/merch_report_4sv_by_spec_new1_nets.sql'));
$sql=stritr($sql,$p);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('nets', $data);

$sql=rtrim(file_get_contents('sql/svms_list.sql'));
$sql=stritr($sql,$p);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('svms_list', $data);

$sql = rtrim(file_get_contents('sql/merch_report_4sv_by_spec_new1_routes_head.sql'));
$sql=stritr($sql,$p);
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('routes_head', $res);

$sql = rtrim(file_get_contents('sql/merch_report_4sv_by_spec_new1_routes_head_fio_otv.sql'));
$sql=stritr($sql,$p);
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('routes_head_fio_otv', $res);

$sql = rtrim(file_get_contents('sql/routes_agents.sql'));
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('routes_head_agents', $res);

$sql = rtrim(file_get_contents('sql/merch_report_4admin_by_spec_new_city.sql'));
$sql=stritr($sql,$p);
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('city', $res);

if (isset($_REQUEST["select"]))
{
	$p=array(
		":agent"=>$_REQUEST["agent"],
		":nets"=>$_REQUEST["nets"],
		":tn"=>$tn,
		":select_route_numb"=>$_REQUEST["select_route_numb"],
		":select_route_fio_otv"=>$_REQUEST["select_route_fio_otv"],
		":svms_list"=>$_REQUEST["svms_list"],
		":sd"=>"'".$_REQUEST["dates_list1"]."'",
		":ed"=>"'".$_REQUEST["dates_list2"]."'",
		":city"=>"'".$_REQUEST["city"]."'",
		":oblast"=>"'".$_REQUEST["oblast"]."'",
		":tp"=>$_REQUEST["tp"],":login"=>"'".$login."'"
	);
	$sql = rtrim(file_get_contents('sql/merch_report_4sv_by_spec_new1.sql'));
	$sql=stritr($sql,$p);
	$rb = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$sql = rtrim(file_get_contents('sql/merch_report_4sv_by_spec_new1_files.sql'));
	$sql=stritr($sql,$p);
	$rbf = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	foreach ($rb as $k=>$v)
	{
		$d[$v["dt"].$v["svms_name"].$v["num"].$v["fio_otv"]]["head"]=$v;
		$d[$v["dt"].$v["svms_name"].$v["num"].$v["fio_otv"]]["data"][$v["tz_oblast"].$v["city"].$v["net_name"].$v["ur_tz_name"].$v["tz_address"]]["head"]=$v;
		$d[$v["dt"].$v["svms_name"].$v["num"].$v["fio_otv"]]["data"][$v["tz_oblast"].$v["city"].$v["net_name"].$v["ur_tz_name"].$v["tz_address"]]["data"][$v["ag_id"]]["head"]=$v;
		$d[$v["dt"].$v["svms_name"].$v["num"].$v["fio_otv"]]["data"][$v["tz_oblast"].$v["city"].$v["net_name"].$v["ur_tz_name"].$v["tz_address"]]["data"][$v["ag_id"]]["data"][$v["msr_id"]]=$v;
	}
	if
		(!isset($_REQUEST["nophoto"]))
	{
		foreach ($rbf as $k=>$v)
		{
			$d[$v["dt"].$v["svms_name"].$v["num"].$v["fio_otv"]]["data"][$v["tz_oblast"].$v["city"].$v["net_name"].$v["ur_tz_name"].$v["tz_address"]]["data"][$v["ag_id"]]["head"]["file_list"][$v["msr_file_id"]]=$v;
		}
		$zip = new ZipArchive();
		recursive_remove_directory("merch_spec_report_archives/".$tn,true);
		foreach ($rb as $k=>$v)
		{
			$d1="merch_spec_report_archives";
			$d2=$d1."/".$tn;
			$d3=$d2."/".translit($v["ag_name"]);
			$d4=$d3."/".translit($v["tz_oblast"]);
			$d5=$d4."/".translit($v["net_name"]);
			$d6=$d5."/".translit($v["dt"]);
			if (!file_exists($d6)) {mkdir($d6,0777,true);}
			$p1=translit($v["ag_name"])."/".translit($v["tz_oblast"])."/".translit($v["net_name"])."/".translit($v["dt"]);
			$archive=$d2."/".$_REQUEST["dates_list2"]."_".translit($v["tz_address"])."."."zip";
			$d1="merch_spec_report_files";
			$d2=$d1."/".$v["dt"];
			$d3=$d2."/".$v["ag_id"];
			$d4=$d3."/".$v["kodtp"];
			if (!file_exists($d4)) {mkdir($d4,0777,true);}
			$zip->open($archive, ZIPARCHIVE::CREATE);
			$file_list=array();
			if ($handle = opendir($d4))
			{
				while (false !== ($file = readdir($handle)))
				{
					if ($file != "." && $file != "..")
					{
						$file_list[] = array("path"=>$d4,"file"=>$file);
						copy ($d4."/".$file,$d6."/".$file);
						$zip->addFile($d6."/".$file, $p1."/".$file);
					}
				}
				closedir($handle);
			}
			$zip->close();
			$d[$v["dt"].$v["svms_name"].$v["num"].$v["fio_otv"]]["data"][$v["tz_oblast"].$v["city"].$v["net_name"].$v["ur_tz_name"].$v["tz_address"]]["head"]["archive"]=$archive;
		}
	}
	isset($d) ? $smarty->assign('d', $d) : null;
	$sql = rtrim(file_get_contents('sql/merch_report_4sv_by_spec_new14.sql'));
	$sql=stritr($sql,$p);
	$res = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('rb_total', $res);
	$sql = rtrim(file_get_contents('sql/merch_report_4sv_by_spec_new1_fields.sql'));
	$sql = strtr(strtolower($sql), $p);
	$fields = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('merch_spec_report_fields', $fields);
}

$smarty->display('merch_report_4sv_by_spec_new1.html');

?>