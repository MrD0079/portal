<?php

//audit("вошел в загрузку спецификаций","merch_spec");

InitRequestVar("routes_agents",0);
InitRequestVar("merch_spec_nets",0);
InitRequestVar("merch_spec_oblast","0");
InitRequestVar("spec_join","0");
InitRequestVar("merch_spec_sd",$now);
InitRequestVar("merch_spec_tz","0");

//ses_req();

include 'PHPExcel/Classes/PHPExcel/IOFactory.php';

if (isset($_REQUEST["save"]))
{
	audit("сохранил спецификации","merch_spec");
	if (isset($_REQUEST["selected_changed"]))
	{
		foreach ($_REQUEST["selected_changed"] as $k=>$v)
		{
			$table_name = "MERCH_SPEC_FLD_AG";
			$keys = array('ag_id'=>$_REQUEST["routes_agents"],'field_id'=>$k);
			if ($v=='on')
			{
	        		Table_Update ($table_name, $keys, $keys);
			}
			if ($v=='off')
			{
	        		Table_Update ($table_name, $keys, null);
			}
		}
	}
	if (isset($_FILES['fn']))
	{
		if ($_FILES['fn']["error"]==0)
		{
			audit("add spec head, fn: ".$_FILES['fn']["name"],"merch_spec");
			$params = array(
				$_REQUEST["routes_agents"],
				$_REQUEST["merch_spec_nets"],
				$_REQUEST["merch_spec_oblast"],
				$_REQUEST["merch_spec_tz"],
				OraDate2MDBDate($_REQUEST["merch_spec_sd"])
			);
			$res = $db->extended->execParam("begin pr_merch_spec_head_ins_new(?,?,?,?,?); end;", $params);
			audit("add spec head, params: ".serialize($params),"merch_spec");
			$inputFileName = $_FILES['fn']["tmp_name"];
			$inputFileType = PHPExcel_IOFactory::identify($inputFileName);
			//echo 'Файл ',pathinfo($inputFileName,PATHINFO_BASENAME),' определен как ',$inputFileType,'<br>';
			$objReader = PHPExcel_IOFactory::createReader($inputFileType);
			$objPHPExcel = $objReader->load($inputFileName);
			//var_dump($objPHPExcel);
			$sheetData = $objPHPExcel->getActiveSheet()->toArray(null,true,true,true);
			$sheetData = recursive_iconv ('UTF-8', 'Windows-1251', $sheetData);
			//var_dump($sheetData);
			//print_r($sheetData);
			$j=1;
			foreach ($sheetData as $k1=>$v1)
			{
				if ($j>1/*&&$j==2*/)
				{
					$p = array(
						$_REQUEST["routes_agents"],
						$_REQUEST["merch_spec_nets"],
						$_REQUEST["merch_spec_oblast"],
						$_REQUEST["merch_spec_tz"],
						OraDate2MDBDate($_REQUEST["merch_spec_sd"]),
						$v1["A"],
						$v1["B"],
						$v1["C"],
						$v1["D"],
						$v1["E"],
						$v1["F"],
						$v1["G"]
					);
					$res = $db->extended->execParam("begin pr_merch_spec_body_ins_new(?,?,?,?,?,?,?,?,?,?,?,?); end;", $p);
					audit("add spec body, params: ".serialize($p),"merch_spec");
				}
				$j++;
			}
		}
	}
	if (isset($_REQUEST["del"]))
	{
		foreach ($_REQUEST["del"] as $k=>$v)
		{
			$params = array(
				$_REQUEST["routes_agents"],
				$_REQUEST["merch_spec_nets"],
				$_REQUEST["merch_spec_oblast"],
				$k,
				OraDate2MDBDate($_REQUEST["merch_spec_sd"])
			);
			$res = $db->extended->execParam("begin pr_merch_spec_head_ins_new(?,?,?,?,?); end;", $params);
			audit("del spec, params: ".serialize($params),"merch_spec");
		}
	}
}

$sql = rtrim(file_get_contents('sql/merch_spec_fld_ag.sql'));
$p=array(":ag"=>$_REQUEST["routes_agents"]);
$sql=stritr($sql,$p);
//echo $sql;
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('merch_spec_fld_ag', $res);
//print_r($res);

$sql=rtrim(file_get_contents('sql/routes_agents.sql'));
$routes_agents = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('routes_agents', $routes_agents);

$sql=rtrim(file_get_contents('sql/merch_spec_nets.sql'));
$merch_spec_nets = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('merch_spec_nets', $merch_spec_nets);

$sql=rtrim(file_get_contents('sql/merch_spec_oblast.sql'));
$merch_spec_oblast = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('merch_spec_oblast', $merch_spec_oblast);

$smarty->display('merch_spec.html');
?>