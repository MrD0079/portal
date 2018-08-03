<?

audit("открыл meetings","meetings");



if (isset($_REQUEST["nets"])){$_SESSION["nets"]=$_REQUEST["nets"];}else{if (isset($_SESSION["nets"])){$_REQUEST["nets"]=$_SESSION["nets"];}}
if (isset($_REQUEST["calendar_years"])){$_SESSION["calendar_years"]=$_REQUEST["calendar_years"];}else{if (isset($_SESSION["calendar_years"])){$_REQUEST["calendar_years"]=$_SESSION["calendar_years"];}}




foreach ($_FILES as $k=>$v)
{
	echo "<p style=\"color: red;\">";
	if ($v['error'] !== 0)
	{
		switch ($v['error'])
		{
			case 1: echo "Загруженный файл превысил значение upload_max_filesize (10мб) в php.ini."; break;
			case 2: echo "Загруженный файл превысил значение MAX_FILE_SIZE (" . $_REQUEST["MAX_FILE_SIZE"] . "), заданное в HTML форме."; break;
			case 3: echo "Файл загружен не полностью."; break;
			//case 4: echo "Файл не загружен."; break;
		}
	}
	echo "</p>";
}

if (isset($_REQUEST["save_new"]))
{
	$keys=array(
		"id_net" => $_REQUEST["nets"],
		"year" => $_REQUEST["calendar_years"],
		"id" => 0
	);
	$prefix="meetings";
	$d1="files/nets_files/".$_REQUEST["calendar_years"]."/";
	$d2=$d1.$_REQUEST["nets"]."/";
	$d3=$d2.$prefix."/";
	if (!file_exists($d1)) {mkdir($d1);}
	if (!file_exists($d2)) {mkdir($d2);}
	if (!file_exists($d3)) {mkdir($d3);}
	if (isset($_FILES["meet_file"]))
	{
		$v1 = get_new_file_id()."_".translit($_FILES["meet_file"]["name"]);
		move_uploaded_file($_FILES["meet_file"]["tmp_name"], $d3.$v1);
		$mf=$d3.$v1;
		$mfn=$v1;
	}
	else
	{
		$mf="";
		$mfn="";
	}
	$values=array(
		"meet_date" => OraDate2MDBDate($_REQUEST["meet_date"]),
		"meet_file" => $mf,
		"meet_file_name" => $mfn,
		"meet_date_next" => OraDate2MDBDate($_REQUEST["meet_date_next"]),
		"manager" => $tn
	);
	Table_Update ("nets_meetings_year", $keys, $values);
}

if (isset($_REQUEST["save"]))
{
	audit("сохранил встречи с клиентом сети","meetings");
	if (isset($_REQUEST["dus_type"]))
	{
		$keys=array(
			"id_net" => $_REQUEST["nets"],
			"plan_type" => $_REQUEST["plan_type"],
			"year" => $_REQUEST["calendar_years"]
		);
		$values=array(
			"dus_type" => $_REQUEST["dus_type"]
		);
		Table_Update ("nets_plan_year", $keys, $values);
	}
	if (isset($_REQUEST["du_complete"]))
	{
		if ($_REQUEST["du_complete"]!="")
		{
			$keys=array(
				"id_net" => $_REQUEST["nets"],
				"plan_type" => $_REQUEST["plan_type"],
				"year" => $_REQUEST["calendar_years"]
			);
			$values=array(
				"du_complete" => $_REQUEST["du_complete"]
			);
			Table_Update ("nets_plan_year", $keys, $values);
		}
	}
	if (isset($_REQUEST["du_complete_date"]))
	{
		$keys=array(
			"id_net" => $_REQUEST["nets"],
			"plan_type" => $_REQUEST["plan_type"],
			"year" => $_REQUEST["calendar_years"]
		);
		$values=array(
			"du_complete_date" => OraDate2MDBDate($_REQUEST["du_complete_date"])

		);
		Table_Update ("nets_plan_year", $keys, $values);
	}
}

if (isset($_REQUEST["calendar_years"])&&isset($_REQUEST["nets"]))
{
	if (($_REQUEST["calendar_years"]>0)&&($_REQUEST["nets"]>0))
	{
		$sql=rtrim(file_get_contents('sql/nets_plan_year.sql'));
		$params=array(':year'=>$_REQUEST["calendar_years"],':plan_type'=>$_REQUEST["plan_type"],':net'=>$_REQUEST["nets"]);
		$sql=stritr($sql,$params);
		$data = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
		//print_r($data);
		$smarty->assign('nets_plan_year', $data);

		$sql=rtrim(file_get_contents('sql/sdu_budjet_last_ver.sql'));
		$params=array(':year'=>$_REQUEST["calendar_years"],':plan_type'=>$_REQUEST["plan_type"],':net'=>$_REQUEST["nets"]);
		$sql=stritr($sql,$params);
		$data = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
		$smarty->assign("sdu_budjet_last_ver", $data);

		if (isset($_REQUEST["del_meeting"]))
		{
			$db->query("delete from nets_meetings_year where id=".$_REQUEST["del_meeting"]);
		}

		$sql=rtrim(file_get_contents('sql/nets_meetings_year.sql'));
		$params=array(':year'=>$_REQUEST["calendar_years"],':plan_type'=>$_REQUEST["plan_type"],':net'=>$_REQUEST["nets"]);
		$sql=stritr($sql,$params);
		$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
		$smarty->assign('nets_meetings_year', $data);

		if (isset($_REQUEST["del_file"]))
		{
			unlink($_REQUEST["del_file"]);
		}

		function fl_func($prefix)
		{
			global $smarty;
			$d1="files/nets_files/".$_REQUEST["calendar_years"]."/";
			$d2=$d1.$_REQUEST["nets"]."/";
			$d3=$d2.$prefix."/";
			if (!file_exists($d1)) {mkdir($d1);}
			if (!file_exists($d2)) {mkdir($d2);}
			if (!file_exists($d3)) {mkdir($d3);}
			if (isset($_FILES["file_".$prefix])) {move_uploaded_file($_FILES["file_".$prefix]["tmp_name"], $d3.translit($_FILES["file_".$prefix]["name"]));}
			$file_list=array();
			if ($handle = opendir($d3)) {
				while (false !== ($file = readdir($handle)))
				{
					if ($file != "." && $file != "..") {$file_list[] = array("path"=>$d3,"file"=>$file);}
				}
				closedir($handle);
			}
			$smarty->assign("file_list_".$prefix, $file_list);
		}
		fl_func("dus");
	}
}

$sql=rtrim(file_get_contents('sql/nets.sql'));
$params=array(':tn'=>$tn,':dpt_id' => $_SESSION["dpt_id"]);
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('nets', $data);

$sql=rtrim(file_get_contents('sql/calendar_years.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('calendar_years', $data);

$sql=rtrim(file_get_contents('sql/nets_dus_types.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('nets_dus_types', $data);


$smarty->display('kk_start.html');
$smarty->display('meetings.html');
$smarty->display('kk_end.html');


?>