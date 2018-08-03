<?php
if (isset($_REQUEST["save"]))
{
    
    include 'PHPExcel/Classes/PHPExcel/IOFactory.php';
	if (isset($_FILES['fn']))
	{
		if ($_FILES['fn']["error"]==0)
		{
			//$params = array(OraDate2MDBDate($_REQUEST["month_list"]));
			//$res = $db->extended->execParam("begin pr_merch_spec_head_ins_new(?,?,?,?,?); end;", $params);
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
                        $p = array("dt"=>OraDate2MDBDate($_REQUEST["month_list"]));
                        Table_Update("spec", $p, null);
			$j=1;
			foreach ($sheetData as $k1=>$v1)
			{
				if ($j>1)
				{
					$p = array(
						"dt"=>OraDate2MDBDate($_REQUEST["month_list"]),
						"id"=>$v1["A"],
						"price"=>$v1["B"]
					);
					Table_Update("spec", $p, $p);
				}
				$j++;
			}
		}
	}
}
$sql = rtrim(file_get_contents('sql/month_list.sql'));
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('month_list', $res);

$sql="  SELECT c.mt || ' ' || c.y period, COUNT (*) cnt, to_char(max(s.lu),'dd.mm.yyyy hh24:mi:ss') lu
    FROM spec s, calendar c
   WHERE s.dt = c.data AND c.data = TRUNC (c.data, 'mm')
GROUP BY c.y,
         c.my,
         dt,
         c.mt
ORDER BY c.y, c.my DESC";
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('spec_list', $res);



$smarty->display('spec.html');
