<?php

isset($_REQUEST["exp_tn"]) ? $exp_tn=$_REQUEST["exp_tn"]: $exp_tn=$tn;
isset($_REQUEST["emp_tn"]) ? $emp_tn=$_REQUEST["emp_tn"]: $emp_tn=$exp_tn;
!isset($_REQUEST["readonly"]) ? $_REQUEST["readonly"]=0: null;
if ($exp_tn==$emp_tn)
{
$smarty->assign('self', 1);
}
else
{
$smarty->assign('self', 0);
}
$res = $db->getOne("select fn_getname(" . $emp_tn . ") from dual");
$smarty->assign('emp_fio', $res);
$res = $db->getOne("select fn_getname(" . $exp_tn . ") from dual");
$smarty->assign('exp_fio', $res);

$sql = rtrim(file_get_contents('sql/month_list.sql'));
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('month_list', $res);

//audit("открыл план ".$emp_tn." за ".$_REQUEST["month_list"],"activ");

foreach($res as $k=>$v)
{
if ($v["sd_c"]==$_REQUEST["month_list"])
{
$period=$v["my"];
}
}

$m=substr($_REQUEST["month_list"], 3, 2);
$y=substr($_REQUEST["month_list"], 6, 4);

if (isset($_REQUEST["send_msg"])&&isset($_REQUEST["msg"]))
{
	if ($exp_tn==$emp_tn)
	{
		$email=$db->getOne("select e_mail from user_list where tn=(select parent from parents where tn=".$emp_tn.")");
		$subj="Комментарии к плану активности за ".$period.", сотрудник ".$emp_fio;
	}
	else
	{
		$email=$db->getOne("select e_mail from user_list where tn=".$emp_tn);
		$subj="Комментарии к плану активности за ".$period;
	}
	$text=nl2br($_REQUEST["msg"]);
	send_mail($email,$subj,$text,null);
	$keys = array(
		"tn"=>$emp_tn,
		"m"=>$m,
		"y"=>$y
	);
	$vals=array("msg"=>$_REQUEST["msg"]);
	Table_Update("p_activ_plan_monthly",$keys,$vals);
	$keys = array(
		"tn"=>$emp_tn,
		"m"=>$m,
		"y"=>$y,
		"lu"=>null
	);
	$vals=array("msg"=>$_REQUEST["msg"],"lu_tn"=>$tn,"lu_fio"=>$fio);
	Table_Update("p_activ_plan_monthly_chat",$keys,$vals);
}

$sql = rtrim(file_get_contents('sql/dates_list.sql'));
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('dates_list', $res);

$sql = rtrim(file_get_contents('sql/month_plan_weeks.sql'));
$p=array(':sd'=>"'".$_REQUEST["month_list"]."'");
$sql=stritr($sql,$p);
$month_plan_weeks = $db->getAssoc($sql, false, array(), MDB2_FETCHMODE_ASSOC);

foreach ($month_plan_weeks as $val)
{
	$sql = rtrim(file_get_contents('sql/month_plan_week_days.sql'));
	$p=array(':sd'=>"'".$_REQUEST["month_list"]."'",':week'=>$val);
	$sql=stritr($sql,$p);
	//$month_plan_week_days = $db->getAll($sql, MDB2_FETCHMODE_ASSOC);
	$month_plan_week_days = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	//print_r($month_plan_week_days);
	for ($i=1;$i<=6;$i++)
	{
		$calendar[$val][$i]='';
	}
	foreach ($month_plan_week_days as $val1)
	{
		$calendar[$val][$val1["dw"]]=$val1;
	}
	$smarty->assign('calendar', $calendar);
//	print_r($calendar);
}

$sql = rtrim(file_get_contents('sql/week_days_list.sql'));
$week_days_list = $db->getAssoc($sql, false, array(), MDB2_FETCHMODE_ASSOC);
$smarty->assign('week_days_list', $week_days_list);
//print_r($week_days_list);

$sql = rtrim(file_get_contents('sql/activ_types.sql'));
$activ_types = $db->getAssoc($sql, false, array(), MDB2_FETCHMODE_ASSOC);
$smarty->assign('activ_types', $activ_types);

if (isset($_REQUEST["save"]))
{
	audit("сохранил план ".$emp_tn." за ".$_REQUEST["month_list"],"activ");
	if (isset($_REQUEST["plan_daily"]))
	{
	foreach ($_REQUEST["plan_daily"] as $key=>$val)
	{
		$table_name = 'p_activ_plan_daily';
		$keys = array(
			"tn"=>$emp_tn,
			"data"=>OraDate2MDBDate($key),
		);
		$vals = array(
			"city"=>$val["city"],
			"plan"=>$val["plan"]
		);
		Table_Update ($table_name, $keys, $vals);
	}
	}
	if (isset($_REQUEST["plan_weekly"]))
	{
	foreach ($_REQUEST["plan_weekly"] as $key=>$val)
	{
		foreach ($val as $key1=>$val1)
		{
			$table_name = 'p_activ_plan_weekly';
			$keys = array(
				"tn"=>$emp_tn,
				"w"=>$key,
				"p_activ_type_id"=>$key1,
				"m"=>$m,
				"y"=>$y
			);
			if (isset($val1["fakt"]))
			{
				$values = array("fakt"=>$val1["fakt"]);
				Table_Update ($table_name, $keys, $values);
			}
			if (isset($val1["plan"]))
			{
				$values = array("plan"=>$val1["plan"]);
				Table_Update ($table_name, $keys, $values);
			}
		}
	}
	}
	if (isset($_REQUEST["plan_monthly"]))
	{
		$table_name = 'p_activ_plan_monthly';
		$where="tn=".$emp_tn." and m=".$m." and y=".$y;
		$sql="select plan_ok from ".$table_name." where ".$where;	
		$plan_ok_old = $db->getOne($sql);
		if (!isset($plan_ok_old)) {$plan_ok_old=0;}
		if ($plan_ok_old!=$_REQUEST["plan_monthly"]["plan_ok"])
		{
			//echo "old ".$plan_ok_old." new ".$_REQUEST["plan_monthly"]["plan_ok"]."<br>";
			$email=$db->getOne("select e_mail from user_list where tn=".$emp_tn);
			setlocale(LC_TIME, "rus_RUS");
			$subj="Изменение статуса плана активности на ".$period;
			$text="Здравствуйте.<br>";
			$text.="Статус вашего плана активности на ".$period." изменен руководителем с '".Int2Text($plan_ok_old)."' на '".Int2Text($_REQUEST["plan_monthly"]["plan_ok"])."'.<br>";
			$text.="Время изменения: ".$now_date_time.".";
			send_mail($email,$subj,$text,null);
		}
		$table_name = 'p_activ_plan_monthly';
		$keys = array(
			"tn"=>$emp_tn,
			"m"=>$m,
			"y"=>$y
		);
		$vals = array("plan_ok"=>$_REQUEST["plan_monthly"]["plan_ok"]);
		Table_Update ($table_name, $keys, $vals);
	}
	if (isset($_FILES['doc']))
	{
		foreach ($_FILES['doc']['error'] as $k=>$v)
		{
			if ($v==0)
			{
				$d1="files/plan_actfiles/iv_files";
				if (!file_exists($d1)) {mkdir($d1,0777,true);}
				$fn=get_new_file_id().'_'.translit($_FILES['doc']['name'][$k]);
				//echo $fn."<br>";
				move_uploaded_file($_FILES['doc']['tmp_name'][$k],"files/plan_actfiles/iv_files/".$fn);
				$table_name = 'p_activ_plan_daily';
				$keys = array(
					"tn"=>$emp_tn,
					"data"=>OraDate2MDBDate($k),
				);
				$vals = array("doc"=>$fn);
				Table_Update ($table_name, $keys, $vals);
			}
		}
	}

}



$sql = rtrim(file_get_contents('sql/activ_plan_daily.sql'));
$p=array(":tn"=>$emp_tn,":month_list"=>"'".$_REQUEST["month_list"]."'",":dpt_id"=>$_SESSION['dpt_id']);
$sql=stritr($sql,$p);
//echo $sql;
$activ_plan_daily = $db->getAssoc($sql, false, array(), MDB2_FETCHMODE_ASSOC);
//$activ_plan_daily = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

foreach ($activ_plan_daily as $key=>$val)
{
$activ_plan_daily[$key]['city']=$val[0];
$activ_plan_daily[$key]['plan']=$val[1];
$activ_plan_daily[$key]['doc']=$val[2];
$sql = rtrim(file_get_contents('sql/activ_plan_daily_fakt_aktiv.sql'));
$p=array(":tn"=>$emp_tn,":dt"=>"'".$key."'",":dpt_id"=>$_SESSION['dpt_id']);
$sql=stritr($sql,$p);
//echo $sql;
$d = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$activ_plan_daily[$key]['fakt']=$d;
}
$smarty->assign('plan_daily', $activ_plan_daily);
//print_r($activ_plan_daily);



$sql = rtrim(file_get_contents('sql/activ_plan_weekly.sql'));
$p=array(":tn"=>$emp_tn,":month_list"=>"'".$_REQUEST["month_list"]."'");
$sql=stritr($sql,$p);
//echo $sql;
//$activ_plan_weekly = $db->getAssoc($sql, false, array(), MDB2_FETCHMODE_ASSOC);
$activ_plan_weekly = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

//print_r($activ_plan_weekly);

$a=array();
foreach ($activ_plan_weekly as $key=>$val)
{
//$a[$val["W"]]=array();
$a[$val["w"]][$val["p_activ_type_id"]]["plan"]=$val["plan"];
$a[$val["w"]][$val["p_activ_type_id"]]["fakt"]=$val["fakt"];
}

$activ_plan_weekly=$a;

//print_r($activ_plan_weekly);

$smarty->assign('plan_weekly', $activ_plan_weekly);





$sql = rtrim(file_get_contents('sql/activ_plan_weekly_total.sql'));
$p=array(":tn"=>$emp_tn,":month_list"=>"'".$_REQUEST["month_list"]."'");
$sql=stritr($sql,$p);
//echo $sql;
$activ_plan_weekly_total = $db->getAssoc($sql, false, array(), MDB2_FETCHMODE_ASSOC);
//$activ_plan_weekly_total = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

foreach ($activ_plan_weekly_total as $key=>$val)
{
$activ_plan_weekly_total[$key]['plan']=$val[0];
$activ_plan_weekly_total[$key]['fakt']=$val[1];
}



//print_r($activ_plan_weekly_total);

$smarty->assign('plan_weekly_total', $activ_plan_weekly_total);






$sql = rtrim(file_get_contents('sql/activ_plan_monthly.sql'));
$p=array(":tn"=>$emp_tn,":month_list"=>"'".$_REQUEST["month_list"]."'");
$sql=stritr($sql,$p);
//echo $sql;
$activ_plan_monthly = $db->getAssoc($sql, false, array(), MDB2_FETCHMODE_ASSOC);
//print_r($activ_plan_monthly);
$smarty->assign('plan_monthly', $activ_plan_monthly);


$sql = rtrim(file_get_contents('sql/activ_plan_monthly_chat.sql'));
$p=array(":tn"=>$emp_tn,":month_list"=>"'".$_REQUEST["month_list"]."'");
$sql=stritr($sql,$p);
$activ_plan_monthly_chat = $db->getAll($sql,null,null,null,MDB2_FETCHMODE_ASSOC);
$smarty->assign('activ_plan_monthly_chat', $activ_plan_monthly_chat);
//print_r($zat_monthly_chat);



$smarty->assign('emp_tn', $emp_tn);
$smarty->assign('exp_tn', $exp_tn);

$smarty->display('plan_activ.html');

?>