<?

//ses_req();

audit("открыл fin_plan","fin_plan");


InitRequestVar("nets");
InitRequestVar("calendar_years");
InitRequestVar("plan_month");
InitRequestVar("plan_type");



if (isset($_REQUEST["plan_type"]))
{
	$res = &$db->getOne('select name from nets_plan_type where id='.$_REQUEST["plan_type"]);
	$smarty->assign('plan_type_name', $res);
}



if ($_REQUEST["plan_type"]==4&&isset($_REQUEST["plan_month"])&&isset($_REQUEST["save"]))
{
	!isset($_REQUEST["db_sum"]) ? $_REQUEST["db_sum"]=0: null;
	$keys=array();
	$vals=array();
	$keys["year"]=$_REQUEST["calendar_years"];
	$keys["plan_type"]=$_REQUEST["plan_type"];
	$keys["id_net"]=$_REQUEST["nets"];
	$keys["month"]=$_REQUEST["plan_month"];
	$vals["bonus_base"]=$_REQUEST["db_type"];
	$vals["bonus_sum"]=str_replace(",", ".", $_REQUEST["db_sum"]);
	Table_Update ("nets_plan_month_ok", $keys, $vals);
	$db->query("BEGIN nets_plan_month_ok_update(".$_REQUEST["plan_type"].",".$_REQUEST["nets"].",".$_REQUEST["calendar_years"].",".$_REQUEST["plan_month"]."); END;");
}





if (isset($_REQUEST["fin_plan_month_ok"]))
{
	$table_name = 'nets_plan_month_ok';
	if (isset($_REQUEST["plan_month_ok"]))
	{
		foreach($_REQUEST["plan_month_ok"] as $k=>$v)
		{
			foreach($v as $k1=>$v1)
			{
				if ($v1!="")
				{
					$keys = array(
						"id_net" => $_REQUEST["nets"],
						"plan_type" => $_REQUEST["plan_type"],
						"year" => $_REQUEST["calendar_years"],
						'month'=>$k1
					);
					$vals = array($k=>$v1);
					Table_Update ($table_name, $keys, $vals);
				}
			}
		}
	}
}

if (isset($_REQUEST["save_year"])||isset($_REQUEST["nets_plan_year"]))
{
	$params=array(
		":net" => $_REQUEST["nets"],
		":plan_type" => $_REQUEST["plan_type"],
		":y" => $_REQUEST["calendar_years"]
	);
	audit("сохранил годовой фин. план сети","fin_plan");
	if (
		isset($_REQUEST['nets_plan_year']["sales"])||
		isset($_REQUEST['nets_plan_year']["sales_prev"])||
		isset($_REQUEST['nets_plan_year']["sales_ng"])||
		isset($_REQUEST['nets_plan_year']["sales_prev_ng"])
	)
	{
		$sql="update nets_plan_month set payment_format = 1 where plan_type=:plan_type and payment_format = 1 and id_net = :net and year = :y";
		$sql=stritr($sql,$params);
		$db->query($sql);
	}
	$keys=array(
		"id_net" => $_REQUEST["nets"],
		"plan_type" => $_REQUEST["plan_type"],
		"year" => $_REQUEST["calendar_years"]
	);
	Table_Update ("nets_plan_year", $keys, $_REQUEST['nets_plan_year']);
}



if (isset($_REQUEST["fin2dog"]))
{
	$sql=rtrim(file_get_contents('sql/copy_nets_plan_month_fin2dog.sql'));
	$params=array(':year'=>$_REQUEST["calendar_years"],':id_net'=>$_REQUEST["nets"]);
	$sql=stritr($sql,$params);
	$data = $db->query($sql);
	//print_r($data);
}

if (isset($_REQUEST["senddog2fm"]))
{
	$fm_email=$db->getOne("select e_mail from user_list where is_fin_man=1");
	$sql="select n.net_name,fn_getname (tn_rmkk) rmkk,fn_getname (tn_mkk) mkk from nets n where id_net=".$_REQUEST["nets"];
	$data = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$net_name=$data["net_name"];
	$rmkk=$data["rmkk"];
	$mkk=$data["mkk"];
	$subj="Подтверждение корректности финансового планирования по сети \"".$net_name."\"";
	$text="Здравствуйте,<br>";
	$text.="Прошу просмотреть и подтвердить корректность договорного планирования по сети \"".$net_name."\" на ".$_REQUEST["calendar_years"]." год.<br>";
	$text.="Ответственные: РМКК - ".$rmkk.", МКК - ".$mkk.".<br>";
	//$text.="<a href=https://ps.avk.ua:8080/?action=fin_plan&nets=".$_REQUEST["nets"]."&calendar_years=".$_REQUEST["calendar_years"]."&plan_type=".$_REQUEST["plan_type"].">Договорное планирование</a>";
	send_mail($fm_email,$subj,$text,null);
}



if (isset($_REQUEST["save_month"]))
{
	audit("сохранил статью в месячный фин. план сети","fin_plan");

	foreach ($_REQUEST["statya_enabled"] as $key=>$val)
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
			"payment_format" => $_REQUEST["payment_format"],
			"cnt" => str_replace(",", ".", $_REQUEST["cnt"][$key]),
			"payer" => $_REQUEST["payer"][$key],
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
	$_REQUEST["edit"] = null;
}

if (isset($_REQUEST["cancel_month"]))
{
	$_REQUEST["month"] = null;
	$_REQUEST["edit"] = null;
}


if (isset($_REQUEST["add_month"]))
{
	audit("добавил статьи в месячный фин. план сети","fin_plan");
	if (isset($_REQUEST["statya_enabled"]))
	{
		foreach ($_REQUEST["statya_enabled"] as $key=>$val)
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
				"payment_format" => $_REQUEST["payment_format"],
				"cnt" => str_replace(",", ".", $_REQUEST["cnt"][$key]),
				"payer" => $_REQUEST["payer"][$key],
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
			if ($_REQUEST["statya_on_year"]==1)
			{
				$sql=rtrim(file_get_contents('sql/fin_plan_month_ok_assoc.sql'));
				$p1=array(':y'=>$_REQUEST["calendar_years"],":plan_type" => $_REQUEST["plan_type"],':net'=>$_REQUEST["nets"]);
				$sql=stritr($sql,$p1);
				$d1 = $db->getAssoc($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
        
				for ($i=1;$i<=12;$i++)
				{
					$values["month"] = $i;
					if ($d1[$i]!=1)
					{
						Table_Update ("nets_plan_month", $keys, $values);
					}
				}
			}
			else
			{
				Table_Update ("nets_plan_month", $keys, $values);
			}
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








if (isset($_REQUEST["add_st"])&&isset($_REQUEST["st"]))
{
	foreach ($_REQUEST["st"] as $k=>$v)
	{
		$sql=rtrim(file_get_contents('sql/copy_nets_plan_month_dog2oper.sql'));
		$params=array(':id'=>$v,":plan_type" => $_REQUEST["plan_type"],":tn_confirmed"=>$tn);
		$sql=stritr($sql,$params);
		$data = $db->query($sql);
/*
		$keys=array();
		$vals=array();
		$keys["id"]=$v;
		$vals["tn_confirmed"]=$tn;
		Table_Update ("nets_plan_month", $keys, $vals);*/
	}
}



$sql=rtrim(file_get_contents('sql/list_mkk_all.sql'));
$params=array(':tn'=>$tn,':dpt_id' => $_SESSION["dpt_id"]);
$sql=stritr($sql,$params);
$list_mkk_all = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('list_mkk_all', $list_mkk_all);


if ($_REQUEST["plan_type"]==4)
{
$sql=rtrim(file_get_contents('sql/nets_ter.sql'));
}
else
{
$sql=rtrim(file_get_contents('sql/nets.sql'));
}
$params=array(':tn'=>$tn,':dpt_id' => $_SESSION["dpt_id"]);
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
		$sql=rtrim(file_get_contents('sql/nets_plan_year.sql'));
		$params=array(':year'=>$_REQUEST["calendar_years"],":plan_type" => $_REQUEST["plan_type"],':net'=>$_REQUEST["nets"]);
		$sql=stritr($sql,$params);
		$data = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
		$smarty->assign('nets_plan_year', $data);

		$sql=rtrim(file_get_contents('sql/sales_cur_year.sql'));
		$params=array(':year'=>$_REQUEST["calendar_years"],":plan_type" => $_REQUEST["plan_type"],':net'=>$_REQUEST["nets"]);
		$sql=stritr($sql,$params);
		$data = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
		$smarty->assign('sales', $data);

		for($i=1;$i<=3;$i++)
		{
		$sql=rtrim(file_get_contents('sql/sales_cur_year.sql'));
		$params=array(':year'=>$_REQUEST["calendar_years"],":plan_type" => $i,':net'=>$_REQUEST["nets"]);
		$sql=stritr($sql,$params);
		$data = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
		$smarty->assign('plan_year_type_'.$i, $data);
		}

		$sql=rtrim(file_get_contents('sql/sales_koeff.sql'));
		$params=array(':year'=>$_REQUEST["calendar_years"],":plan_type" => $_REQUEST["plan_type"],':net'=>$_REQUEST["nets"]);
		$sql=stritr($sql,$params);
		$data = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
		$smarty->assign('percent', $data);

		$sql=rtrim(file_get_contents('sql/month_prognoz.sql'));
		$params=array(':year'=>$_REQUEST["calendar_years"],":plan_type" => $_REQUEST["plan_type"],':net'=>$_REQUEST["nets"]);
		$sql=stritr($sql,$params);
		$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
		$smarty->assign('month_prognoz',$data);

		if ($_REQUEST["plan_type"]==4)
		{
		$sql=rtrim(file_get_contents('sql/nets_plan_month_4.sql'));
		}
		else
		{
		$sql=rtrim(file_get_contents('sql/nets_plan_month.sql'));
		}

		$params=array(':y'=>$_REQUEST["calendar_years"],":plan_type" => $_REQUEST["plan_type"],":plan_month" => 0,':net'=>$_REQUEST["nets"],':tn'=>$tn);
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
				$params=array(
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

		if ($_REQUEST["plan_type"]==3&&isset($_REQUEST["plan_month"]))
		{
			$sql=rtrim(file_get_contents('sql/nets_plan_month.sql'));
			$params=array(':y'=>$_REQUEST["calendar_years"],":plan_type" => 2,":plan_month" => $_REQUEST["plan_month"],':net'=>$_REQUEST["nets"],':tn'=>$tn);
			$sql=stritr($sql,$params);
			$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
			$smarty->assign("nets_dog_plan_one_month", $data);
			//echo $sql;

			for($i=1;$i<=3;$i++)
			{
			$sql=rtrim(file_get_contents("sql/fin_plan_one_month_".$i.".sql"));
			$params=array(':y'=>$_REQUEST["calendar_years"],":plan_type" => $i,":plan_month" => $_REQUEST["plan_month"],':net'=>$_REQUEST["nets"]);
			$sql=stritr($sql,$params);
			$data = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
			$smarty->assign("fin_plan_one_month_".$i, $data);
			//echo $sql;
			}
		}
		if ((($_REQUEST["plan_type"]==3)||($_REQUEST["plan_type"]==4))&&(isset($_REQUEST["plan_month"])))
		{
			$sql=rtrim(file_get_contents('sql/fin_plan_month_ok.sql'));
			$params=array(':y'=>$_REQUEST["calendar_years"],":plan_type" => $_REQUEST["plan_type"],':net'=>$_REQUEST["nets"]);
			$sql=stritr($sql,$params);
			$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
			$smarty->assign("fin_plan_month_ok", $data);
		}
		if (isset($_REQUEST["month"]))
		{
			$sql=rtrim(file_get_contents('sql/fil_list.sql'));
			$params=array(':y'=>$_REQUEST["calendar_years"],":m" => $_REQUEST["plan_month"],':tn'=>$tn);
			$sql=stritr($sql,$params);
			$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
			$smarty->assign("fil_list", $data);
		}
		if ($_REQUEST["plan_type"]==4&&isset($_REQUEST["plan_month"]))
		{
			!isset($_REQUEST["db_sum"]) ? $_REQUEST["db_sum"]=0: null;

			$sql=rtrim(file_get_contents('sql/nets_plan_month_4.sql'));
			$params=array(':y'=>$_REQUEST["calendar_years"],":plan_type" => 3,":plan_month" => $_REQUEST["plan_month"],':net'=>$_REQUEST["nets"],':tn'=>$tn);
			$sql=stritr($sql,$params);
			$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
			$smarty->assign("nets_dog_plan_one_month", $data);
			//echo $sql;

			$params=array(
				':y'=>$_REQUEST["calendar_years"],
				':m'=>$_REQUEST["plan_month"],
				':plan_type'=>4,
				':net'=>$_REQUEST["nets"]
			);

			$sql=rtrim(file_get_contents('sql/fakt_uslug_npf.sql'));
			$sqlt=rtrim(file_get_contents('sql/fakt_uslug_npf_total.sql'));
			$sql=stritr($sql,$params);
			$sqlt=stritr($sqlt,$params);
//echo $sql;
			$data = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
			$datat = $db->getRow($sqlt, null, null, null, MDB2_FETCHMODE_ASSOC);
			$smarty->assign('npf', $data);
			$smarty->assign('npft', $datat);

			$sql=rtrim(file_get_contents('sql/fakt_uslug_bonus_db.sql'));
			$sql=stritr($sql,$params);
			$data = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
			$smarty->assign('db', $data);

			$params=array(
				':y'=>$_REQUEST["calendar_years"],
				':m'=>$_REQUEST["plan_month"],
				':plan_type'=>3,
				':net'=>$_REQUEST["nets"]
			);

			$sql=rtrim(file_get_contents('sql/fakt_uslug_ok.sql'));
			$sql=stritr($sql,$params);
			$data = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
			$smarty->assign('fakt_uslug_ok', $data);

		}

	}
}

$sql=rtrim(file_get_contents('sql/calendar_months.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('calendar_months', $data);

$sql=rtrim(file_get_contents('sql/groups.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('groups', $data);

$sql=rtrim(file_get_contents('sql/payment_type.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('payment_type', $data);

$sql=rtrim(file_get_contents('sql/payment_format.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('payment_format', $data);

$smarty->display('kk_start.html');
$smarty->display('fin_plan.html');
$smarty->display('kk_end.html');

?>