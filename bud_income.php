<?
if (isset($_REQUEST['save']))
{
	$_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);
	$keys = array(
		'year'=>$_REQUEST['y'],
		'month'=>$_REQUEST['m'],
		'fil_id'=>$_REQUEST['fil_id']);
	$vals = array($_REQUEST['field']=>$_REQUEST['val']);
	Table_Update('bud_income', $keys,$vals);
}
else
{
	if (isset($_FILES['fn']))
	{
		if ($_FILES['fn']["error"]==0)
		{
			audit("load xls in bud_income, fn: ".$_FILES['fn']["name"],"bud_income");
			include 'PHPExcel/Classes/PHPExcel/IOFactory.php';
			/*$params = array(
				$_REQUEST["routes_agents"],
				$_REQUEST["merch_spec_nets"],
				$_REQUEST["merch_spec_oblast"],
				$_REQUEST["merch_spec_tz"],
				OraDate2MDBDate($_REQUEST["merch_spec_sd"])
			);
			$params=array(
				'y'=>$_REQUEST["y"],
				'm'=>$_REQUEST["m"],
				'tn'=>$tn,
			);*/
			//$res = $db->extended->execParam("begin pr_merch_spec_head_ins_new(?,?,?,?,?); end;", $params);
			//audit("load xls in bud_income, params: ".serialize($params),"bud_income");
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
				if ($j>1)
				{
					//print_r($v1);
					$fil_id = $db->getOne("select id from bud_fil where name = '".$v1["A"]."'");
					$keys = array(
						'year'=>$v1['B'],
						'month'=>$v1['C'],
						'fil_id'=>$fil_id
					);
					$vals = array(
						'fund_other'=>$v1['D'],
						'kk_income'=>$v1['E'],
						'compensation'=>$v1['F']
					);
					Table_Update('bud_income', $keys,$vals);
					/*$res = $db->extended->execParam("begin pr_merch_spec_body_ins_new(?,?,?,?,?,?,?,?,?,?,?,?); end;", $p);
					audit("load xls line in bud_income, params: ".serialize($p),"bud_income");*/
				}
				$j++;
			}
		}
	}
	audit("открыл bud_income","fin_plan");
	InitRequestVar("y");
	InitRequestVar("m",0);
	InitRequestVar("reptype",1);
	if (isset($_REQUEST["y"])&&isset($_REQUEST["generate"]))
	{
		$params=array(
			':dpt_id' => $_SESSION["dpt_id"],
			':y'=>$_REQUEST["y"],
			':m'=>$_REQUEST["m"],
			':tn'=>$tn,
		);
		if ($_REQUEST["reptype"]==1)
		{
			$sql=rtrim(file_get_contents('sql/bud_income1.sql'));
			$sql=stritr($sql,$params);
			$data1 = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
			foreach ($data1 as $k=>$v)
			{
				$d[$v["my"]]["head"]=$v;
				$d[$v["my"]]["data"][$v["fil_id"]]=$v;
			}
		}
		if ($_REQUEST["reptype"]==2)
		{
			$sql=rtrim(file_get_contents('sql/bud_income1.sql'));
			$sql=stritr($sql,$params);
			$data1 = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
			foreach ($data1 as $k=>$v)
			{
				$d[$v["my"]]["head"]=$v;
				$d[$v["my"]]["data"][$v["fil_id"]]["head"]=$v;
			}
			$sql=rtrim(file_get_contents('sql/bud_income2.sql'));
			$sql=stritr($sql,$params);
			$data2 = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
			foreach ($data2 as $k=>$v)
			{
				//$d[$v["my"]]["head"]=$v;
				//$d[$v["my"]]["data"][$v["fil_id"]]=$v;
				//$d[$v["my"]]["data"][$v["fil_id"]]["head"]=$v;
				$d[$v["my"]]["data"][$v["fil_id"]]["data"][$v["id_net"]]=$v;
			}
		}
		//print_r($data);
		//print_r($d);
		isset($d)?$smarty->assign('finreport', $d) : null;
	}
	$sql=rtrim(file_get_contents('sql/payment_type.sql'));
	$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('payment_type', $data);
	$sql=rtrim(file_get_contents('sql/distr_prot_di_kk.sql'));
	$sql=stritr($sql,$params);
	$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('payer', $data);
	$sql=rtrim(file_get_contents('sql/calendar_years.sql'));
	$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('y', $data);
	$sql=rtrim(file_get_contents('sql/calendar_months.sql'));
	$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('m', $data);
	$sql=rtrim(file_get_contents('sql/nets.sql'));
	$sql=stritr($sql,$params);
	$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('nets', $data);
	$sql=rtrim(file_get_contents('sql/list_rmkk.sql'));
	$sql=stritr($sql,$params);
	$list_rmkk = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('list_rmkk', $list_rmkk);
	$sql=rtrim(file_get_contents('sql/list_mkk.sql'));
	$sql=stritr($sql,$params);
	$list_mkk = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('list_mkk', $list_mkk);
	$smarty->display('bud_income.html');
}
?>