<?


//ses_req();

audit("открыл zakaz_nal","zakaz_nal");


if (isset($_REQUEST["nets"])){$_SESSION["nets"]=$_REQUEST["nets"];}else{if (isset($_SESSION["nets"])){$_REQUEST["nets"]=$_SESSION["nets"];}}
if (isset($_REQUEST["calendar_years"])){$_SESSION["calendar_years"]=$_REQUEST["calendar_years"];}else{if (isset($_SESSION["calendar_years"])){$_REQUEST["calendar_years"]=$_SESSION["calendar_years"];}}
if (isset($_REQUEST["plan_month"])){$_SESSION["plan_month"]=$_REQUEST["plan_month"];}else{if (isset($_SESSION["plan_month"])){$_REQUEST["plan_month"]=$_SESSION["plan_month"];}}



if (isset($_REQUEST["save_month"]))
{
	audit("сохранил статью в мес€чный фин. план сети","zakaz_nal");

	foreach ($_REQUEST["statya_enabled"] as $key=>$val)
	{
if ($_REQUEST["mkk_ter"][$key]==0)
{
echo "не заполнено поле ћ   территории, запись не сохранена<br>";
}
else
{
		$keys=array("id" => $_REQUEST["edit"]);
		$values=array(
			"id_net" => $_REQUEST["nets"],
			"year" => $_REQUEST["calendar_years"],
			"month" => $_REQUEST["month"],
			"plan_type" => $_REQUEST["plan_type"],
			"statya" => $key,
			"descript" => $_REQUEST["descript"],
			"payment_type" => $_REQUEST["payment_type"],
			"payment_format" => 2,
			"cnt" => str_replace(",", ".", $_REQUEST["cnt"][$key]),
			"payer" => $_REQUEST["payer"][$key],
			"is_zakaz_nal" => 1,
			"mkk_ter" => $_REQUEST["mkk_ter"][$key]
		);
		if (isset($_REQUEST["bonus"]))
		{
			$values["bonus"] = str_replace(",", ".", $_REQUEST["bonus"][$key]);
		}
		if (isset($_REQUEST["price"]))
		{
			$values["price"] = str_replace(",", ".", $_REQUEST["price"][$key]);
		}
		Table_Update ("nets_plan_month", $keys, $values);
}
	}
	$_REQUEST["edit"] = null;
}

if (isset($_REQUEST["cancel_month"]))
{
	$_REQUEST["month"] = null;
	$_REQUEST["edit"] = null;
}

if (isset($_REQUEST["add_month"]))
{
	audit("добавил статьи в мес€чный фин. план сети","zakaz_nal");

	foreach ($_REQUEST["statya_enabled"] as $key=>$val)
	{
if ($_REQUEST["mkk_ter"][$key]==0)
{
echo "не заполнено поле ћ   территории, запись не добавлена<br>";
}
else
{
		$keys=array("id" => 0);
		$values=array(
			"id_net" => $_REQUEST["nets"],
			"year" => $_REQUEST["calendar_years"],
			"month" => $_REQUEST["month"],
			"plan_type" => $_REQUEST["plan_type"],
			"statya" => $key,
			"descript" => $_REQUEST["descript"],
			"payment_type" => $_REQUEST["payment_type"],
			"payment_format" => 2,
			"cnt" => str_replace(",", ".", $_REQUEST["cnt"][$key]),
			"payer" => $_REQUEST["payer"][$key],
			"is_zakaz_nal" => 1,
			"mkk_ter" => $_REQUEST["mkk_ter"][$key]
		);
		if (isset($_REQUEST["bonus"]))
		{
			$values["bonus"] = str_replace(",", ".", $_REQUEST["bonus"][$key]);
		}
		if (isset($_REQUEST["price"]))
		{
			$values["price"] = str_replace(",", ".", $_REQUEST["price"][$key]);
		}
		/*if ($_REQUEST["statya_on_year"]==1)
		{
			for ($i=1;$i<=12;$i++)
			{
				$values["month"] = $i;
				Table_Update ("nets_plan_month", $keys, $values);
			}
		}
		else
		{
			Table_Update ("nets_plan_month", $keys, $values);
		}*/
		Table_Update ("nets_plan_month", $keys, $values);
}
	}
}

if (isset($_REQUEST["del"]))
{
	foreach ($_REQUEST["del"] as $k=>$v)
	{
		$db->extended->autoExecute("nets_plan_month", null, MDB2_AUTOQUERY_DELETE, "id=".$v);
	}
}





$sql=rtrim(file_get_contents('sql/list_mkk_all.sql'));
$params=array(':dpt_id' => $_SESSION["dpt_id"],':tn'=>$tn);
$sql=stritr($sql,$params);
$list_mkk_all = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('list_mkk_all', $list_mkk_all);


$sql=rtrim(file_get_contents('sql/zakaz_nal_nets.sql'));
//$sql=rtrim(file_get_contents('sql/nets.sql'));


$params=array(':dpt_id' => $_SESSION["dpt_id"],':tn'=>$tn,':dpt_id' => $_SESSION["dpt_id"]);
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('nets', $data);

$sql=rtrim(file_get_contents('sql/calendar_years.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('calendar_years', $data);

if (isset($_REQUEST["calendar_years"])&&isset($_REQUEST["nets"]))
{
	if (($_REQUEST["calendar_years"]>0)&&($_REQUEST["nets"]>0))
	{

		//$sql=rtrim(file_get_contents('sql/nets_plan_month_4.sql'));
		$sql=rtrim(file_get_contents('sql/zakaz_nal_nets_plan_month.sql'));

		$params=array(':dpt_id' => $_SESSION["dpt_id"],':y'=>$_REQUEST["calendar_years"],":plan_type" => $_REQUEST["plan_type"],":plan_month" => 0,':net'=>$_REQUEST["nets"],':tn'=>$tn);
		$sql=stritr($sql,$params);
		$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
		$smarty->assign("nets_plan_month", $data);
		//print_r($data);


		if (isset($_REQUEST["edit"]))
		{
			foreach ($data as $key=>$val)
			{
				if ($val["rid"]==$_REQUEST["edit"])
				{
					$_REQUEST["month"]=$val["month"];
					$_REQUEST["payment_format"]=$val["pf_id"];
					$_REQUEST["groupp"]=$val["group_id"];
					$_REQUEST["descript"]=$val["descript"];
					$_REQUEST["payment_type"]=$val["pt_id"];
				}
			}
		}

		if (isset($_REQUEST["groupp"]))
		{
			if ($_REQUEST["groupp"]>0)
			{
				$sql=rtrim(file_get_contents('sql/statya.sql'));
				$params=array(':dpt_id' => $_SESSION["dpt_id"],
					":plan_type" => $_REQUEST["plan_type"],
					':groupp'=>$_REQUEST['groupp']
				);
				if (isset($_REQUEST["edit"]))
				{
					$params[":edit_statya"] = $_REQUEST["edit"];
				}
				else
				{
					$params[":edit_statya"] = 0;
				}
				$sql=stritr($sql,$params);
				$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
				$smarty->assign('statya', $data);
			}
		}

			$sql=rtrim(file_get_contents('sql/fin_plan_month_ok.sql'));
			$params=array(':dpt_id' => $_SESSION["dpt_id"],':y'=>$_REQUEST["calendar_years"],":plan_type" => $_REQUEST["plan_type"],':net'=>$_REQUEST["nets"]);
			$sql=stritr($sql,$params);
			$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
			$smarty->assign("fin_plan_month_ok", $data);

		if (isset($_REQUEST["plan_month"]))
		{
			$sql=rtrim(file_get_contents('sql/fil_list.sql'));
			$params=array(':y'=>$_REQUEST["calendar_years"],":m" => $_REQUEST["plan_month"],':tn'=>$tn);
			$sql=stritr($sql,$params);
			$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
			$smarty->assign("fil_list", $data);
		}

	}
}

$sql=rtrim(file_get_contents('sql/calendar_months.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('calendar_months', $data);

$sql=rtrim(file_get_contents('sql/groups.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('groups', $data);

$sql=rtrim(file_get_contents('sql/payment_type_zakaz_nal.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('payment_type', $data);

$sql=rtrim(file_get_contents('sql/payment_format.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('payment_format', $data);

$smarty->display('kk_start.html');
$smarty->display('zakaz_nal.html');
$smarty->display('kk_end.html');

?>