<?

audit("открыл sdu","sdu");

//ses_req();

if (isset($_REQUEST["nets"])){$_SESSION["nets"]=$_REQUEST["nets"];}else{if (isset($_SESSION["nets"])){$_REQUEST["nets"]=$_SESSION["nets"];}}
if (isset($_REQUEST["calendar_years"])){$_SESSION["calendar_years"]=$_REQUEST["calendar_years"];}else{if (isset($_SESSION["calendar_years"])){$_REQUEST["calendar_years"]=$_SESSION["calendar_years"];}}

if (isset($_REQUEST["ok_sdu"]))
{
	$this_email=$db->getOne("select e_mail from user_list where tn=".$tn);
	$parent_email=$db->getOne("SELECT e_mail FROM user_list WHERE tn = (SELECT parent FROM parents WHERE tn = ".$tn.")");
	$sql="select n.net_name,fn_getname (tn_rmkk) rmkk,fn_getname (tn_mkk) mkk from nets n where id_net=".$_REQUEST["nets"];
	$data = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$net_name=$data["net_name"];
	$rmkk=$data["rmkk"];
	$mkk=$data["mkk"];
	$subj="Подтверждение СДУ по сети \"".$net_name."\"";
	$text="Здравствуйте,<br>";
	$text.="Прошу просмотреть и принять СДУ по сети \"".$net_name."\" на ".$_REQUEST["calendar_years"]." год.<br>";
	$text.="Ответственные: РМКК - ".$rmkk.", МКК - ".$mkk.".<br>";
	send_mail($parent_email,$subj,$text,null);
	send_mail($this_email,$subj,$text,null);
}

if (isset($_REQUEST["save"]))
{
	if (isset($_REQUEST["nets_props_year"]))
	{
		$keys=array(
			"id_net" => $_REQUEST["nets"],
			"year" => $_REQUEST["calendar_years"]
		);
		foreach ($_REQUEST["nets_props_year"] as $k=>$v) {
		foreach ($v as $k1=>$v1) {
			$values=$v1;
			$keys["shop_format"]=$k;
			$keys["prop_id"]=$k1;
			Table_Update ("nets_props_year", $keys, $values);
		}
		}
	}

	audit("сохранил годовой фин. план сети","sdu");

	if (isset($_REQUEST["pay_days"]))
	{
		$keys=array(
			"id_net" => $_REQUEST["nets"],
			"plan_type" => $_REQUEST["plan_type"],
			"year" => $_REQUEST["calendar_years"]
		);
		$values=array(
			"pay_days" => $_REQUEST["pay_days"]
		);
		Table_Update ("nets_plan_year", $keys, $values);
	}
	if (isset($_REQUEST["pay_type"]))
	{
		$keys=array(
			"id_net" => $_REQUEST["nets"],
			"plan_type" => $_REQUEST["plan_type"],
			"year" => $_REQUEST["calendar_years"]
		);
		$values=array(
			"pay_type" => $_REQUEST["pay_type"]
		);
		Table_Update ("nets_plan_year", $keys, $values);
	}
	if (isset($_REQUEST["pay_detail"]))
	{
		$keys=array(
			"id_net" => $_REQUEST["nets"],
			"plan_type" => $_REQUEST["plan_type"],
			"year" => $_REQUEST["calendar_years"]
		);
		$values=array(
			"pay_detail" => $_REQUEST["pay_detail"]
		);
		Table_Update ("nets_plan_year", $keys, $values);
	}
	if (isset($_REQUEST["specified_period"]))
	{
		$keys=array(
			"id_net" => $_REQUEST["nets"],
			"plan_type" => $_REQUEST["plan_type"],
			"year" => $_REQUEST["calendar_years"]
		);
		$values=array(
			"specified_period" => $_REQUEST["specified_period"]
		);
		Table_Update ("nets_plan_year", $keys, $values);
	}
	if (isset($_REQUEST["condition"]))
	{
		$keys=array(
			"id_net" => $_REQUEST["nets"],
			"plan_type" => $_REQUEST["plan_type"],
			"year" => $_REQUEST["calendar_years"]
		);
		$values=array(
			"condition" => $_REQUEST["condition"]
		);
		Table_Update ("nets_plan_year", $keys, $values);
	}




	if (isset($_REQUEST["ok"]))
	{
		foreach ($_REQUEST["ok"] as $k=>$v)
		{
			$keys=array(
				"id_net" => $_REQUEST["nets"],
				"year" => $_REQUEST["calendar_years"],
				"ver" => $k
			);
			foreach ($v as $k1=>$v1)
			{
				$values=array($k1 => $v1);
				Table_Update ("sdu", $keys, $values);
			}
		}
	}

	if (isset($_REQUEST["terms"]))
	{
		foreach ($_REQUEST["terms"] as $k=>$v)
		{
			$keys=array(
				"id_net" => $_REQUEST["nets"],
				"year" => $_REQUEST["calendar_years"],
				"ver" => $k
			);
			foreach ($v as $k1=>$v1)
			{
				$keys["term_id"]=$k1;
				$values = array();
				isset($v1["pay_format"]) ? $values["pay_format"] = $v1["pay_format"] : null;
				$values["summa"] = str_replace(",", ".", $v1["summa"]);
				$values["txt"] = addslashes($v1["txt"]);
				Table_Update ("sdu_terms_year", $keys, $values);
			}
		}
	}


}

if (isset($_REQUEST["calendar_years"])&&isset($_REQUEST["nets"]))
{
	if (($_REQUEST["calendar_years"]>0)&&($_REQUEST["nets"]>0))
	{
		if (isset($_REQUEST["add_ver"]))
		{
			$new_ver=$db->getOne("select nvl(max(ver),0)+1 from sdu where id_net=".$_REQUEST["nets"]." and year=".$_REQUEST["calendar_years"]);
			$keys=array("id_net" => $_REQUEST["nets"],"year" => $_REQUEST["calendar_years"],"ver" => $new_ver);
			$values=array("ver" => $new_ver);
			//Table_Update ("sdu", $keys, $values);
			Table_Update ("sdu", $keys, $values);
		}

		if (isset($_REQUEST["del_ver"]))
		{
			$db->query("delete from sdu where id_net=".$_REQUEST["nets"]." and year=".$_REQUEST["calendar_years"]." and ver=".$_REQUEST["del_ver"]);
			$db->query("delete from sdu_terms_year where id_net=".$_REQUEST["nets"]." and year=".$_REQUEST["calendar_years"]." and ver=".$_REQUEST["del_ver"]);
		}

		$sql=rtrim(file_get_contents('sql/sdu.sql'));
		$params=array(':year'=>$_REQUEST["calendar_years"],':plan_type'=>$_REQUEST["plan_type"],':net'=>$_REQUEST["nets"]);
		$sql=stritr($sql,$params);
		$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
		//print_r($data);
		$smarty->assign('sdu', $data);


		$sql=rtrim(file_get_contents('sql/nets_plan_year.sql'));
		$params=array(':year'=>$_REQUEST["calendar_years"],':plan_type'=>$_REQUEST["plan_type"],':net'=>$_REQUEST["nets"]);
		$sql=stritr($sql,$params);
		$data = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
		//print_r($data);
		$smarty->assign('nets_plan_year', $data);

		for ($i=1;$i<=2;$i++)
		{
		$sql=rtrim(file_get_contents('sql/nets_plan_year.sql'));
		$params=array(':year'=>$_REQUEST["calendar_years"]-$i,':plan_type'=>$_REQUEST["plan_type"],':net'=>$_REQUEST["nets"]);
		$sql=stritr($sql,$params);
		$data = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
		//print_r($data);
		$smarty->assign('nets_plan_year'.$i, $data);
		}

		$sql=rtrim(file_get_contents('sql/sdu_terms_list.sql'));
		$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
		$smarty->assign('sdu_terms_list', $data);

		$sql=rtrim(file_get_contents('sql/sdu_terms_year.sql'));
		$params=array(':year'=>$_REQUEST["calendar_years"],':plan_type'=>$_REQUEST["plan_type"],':net'=>$_REQUEST["nets"]);
		$sql=stritr($sql,$params);
		$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
		$data1=array();
		foreach($data as $k=>$v)
		{
			$data1[$v["ver"]][$v["term_id"]]=$v;
		}
		isset($data1) ? $smarty->assign('sdu_terms_year', $data1) : null;


		for ($i=1;$i<=2;$i++)
		{
			$sql=rtrim(file_get_contents('sql/sdu_terms_year_last_ver.sql'));
			$params=array(':year'=>$_REQUEST["calendar_years"]-$i,':plan_type'=>$_REQUEST["plan_type"],':net'=>$_REQUEST["nets"]);
			$sql=stritr($sql,$params);
			$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
			$data1=array();
			foreach($data as $k=>$v)
			{
				$data1[$v["term_id"]]=$v;
			}
			//print_r($data1);
			$smarty->assign("sdu_terms_year_last_ver".$i, $data1);
		}








		$sql=rtrim(file_get_contents('sql/nets_proportions_perc.sql'));
		$params=array(':year'=>$_REQUEST["calendar_years"],':plan_type'=>$_REQUEST["plan_type"],':net'=>$_REQUEST["nets"]);
		$sql=stritr($sql,$params);
		$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
		$smarty->assign('nets_proportions_perc', $data);

		$sql=rtrim(file_get_contents('sql/nets_proportions_face.sql'));
		$params=array(':year'=>$_REQUEST["calendar_years"],':plan_type'=>$_REQUEST["plan_type"],':net'=>$_REQUEST["nets"]);
		$sql=stritr($sql,$params);
		$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
		$smarty->assign('nets_proportions_face', $data);

                
                
                
                
                $sql=rtrim(file_get_contents('sql/sdu_props.sql'));
		$params=array(':year'=>$_REQUEST["calendar_years"],':net'=>$_REQUEST["nets"]);
		$sql=stritr($sql,$params);
		$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
                $props=array();
                foreach ($data as $k=>$v){
                    $props[$v["y"]][$v["format_id"]]["h"]["format_name"]=$v["format_name"];
                    $props[$v["y"]][$v["format_id"]]["h"]["readonly"]=$v["readonly"];
                    //$props[$v["y"]][$v["format_id"]]["d"][$v["prop_id"]]["h"]["proportion_name"]=$v["proportion_name"];
                    $props[$v["y"]][$v["format_id"]]["d"][$v["prop_id"]]["d"]["face"]=$v["face"];
                    $props[$v["y"]][$v["format_id"]]["d"][$v["prop_id"]]["d"]["perc"]=$v["perc"];
                }
                $smarty->assign('props', $props);
                foreach ($data as $k=>$v){
                    $propnames[$v["prop_id"]]=$v["proportion_name"];
                }
                $smarty->assign('propnames', $propnames);
                
                
               
                
                
                
                
                
                
                
                
                
		for ($i=0;$i<=2;$i++)
		{
		$sql=rtrim(file_get_contents('sql/sdu_budjet_last_ver.sql'));
		$params=array(':year'=>$_REQUEST["calendar_years"]-$i,':plan_type'=>$_REQUEST["plan_type"],':net'=>$_REQUEST["nets"]);
		$sql=stritr($sql,$params);
		$data = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
		$smarty->assign("sdu_budjet_last_ver".$i, $data);

		//print_r($data);

		}

 
                
                
                


		$sql=rtrim(file_get_contents('sql/sdu.sql'));
		$params=array(':year'=>$_REQUEST["calendar_years"],':plan_type'=>$_REQUEST["plan_type"],':net'=>$_REQUEST["nets"]);
		$sql=stritr($sql,$params);
		$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
		foreach($data as $k=>$v)
		{
		$sql=rtrim(file_get_contents('sql/sdu_budjet.sql'));
		$params=array(':year'=>$_REQUEST["calendar_years"],':plan_type'=>$_REQUEST["plan_type"],':net'=>$_REQUEST["nets"],':ver'=>$v["ver"]);
		$sql=stritr($sql,$params);
		$data11 = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
		$data1[$v["ver"]]=$data11;
		}
		isset($data1) ? $smarty->assign('sdu_budjet', $data1) : null;



		if (isset($_REQUEST["del_file"]))
		{
			unlink($_REQUEST["del_file"]);
		}

		function fl_func($prefix)
		{
			global $smarty;
			$d1="nets_files/".$_REQUEST["calendar_years"]."/";
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

		fl_func("psus");
		fl_func("dmp");
		fl_func("mm");
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

$sql=rtrim(file_get_contents('sql/conditions.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('conditions', $data);

$sql=rtrim(file_get_contents('sql/nets_pay_types.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('nets_pay_types', $data);

$sql=rtrim(file_get_contents('sql/payment_format.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('payment_format', $data);



$smarty->display('kk_start.html');

isset($_REQUEST['print'])?$smarty->display('sdu_terms_detail.html'):$smarty->display('sdu.html');

$smarty->display('kk_end.html');


?>