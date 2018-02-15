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

$amort         = $db->getOne("select amort from user_list where tn = ".$emp_tn."");
$pos           = $db->getOne("select pos_name from user_list where tn = ".$emp_tn."");
$department    = $db->getOne("select department_name from user_list where tn = ".$emp_tn."");

$smarty->assign('amort', $amort);
$smarty->assign('pos', $pos);
$smarty->assign('department', $department);

$emp_fio = $db->getOne("select fn_getname(" . $emp_tn . ") from dual");
$smarty->assign('emp_fio', $emp_fio);
$exp_fio = $db->getOne("select fn_getname(" . $exp_tn . ") from dual");
$smarty->assign('exp_fio', $exp_fio);

$sql = rtrim(file_get_contents('sql/month_list.sql'));
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('month_list', $res);

//audit("открыл затраты ".$emp_tn." за ".$_REQUEST["month_list"],"zat");

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
	audit("отправил сообщение по затратам ".$emp_tn." за ".$_REQUEST["month_list"],"zat");
	if ($exp_tn==$emp_tn)
	{
		$email=$db->getOne("select e_mail from user_list where tn=(select parent from parents where tn=".$emp_tn.")");
		$subj="Комментарии по отчету о затратах за ".$period.", сотрудник ".$emp_fio;
	}
	else
	{
		$email=$db->getOne("select e_mail from user_list where tn=".$emp_tn);
		$subj="Комментарии по отчету о затратах за ".$period;
	}
	$text=nl2br($_REQUEST["msg"]);
	send_mail($email,$subj,$text,null);
	$keys = array(
		"tn"=>$emp_tn,
		"m"=>$m,
		"y"=>$y
	);
	$vals=array("msg"=>$_REQUEST["msg"]);
	Table_Update("zat_monthly",$keys,$vals);
	$keys = array(
		"tn"=>$emp_tn,
		"m"=>$m,
		"y"=>$y,
		"lu"=>null
	);
	$vals=array("msg"=>$_REQUEST["msg"],"lu_tn"=>$tn,"lu_fio"=>$fio);
	Table_Update("zat_monthly_chat",$keys,$vals);
}





if (isset($_REQUEST["save"])||isset($_REQUEST["copy_city"]))
{
	audit("сохранил затраты ".$emp_tn." за ".$_REQUEST["month_list"],"zat");
	if (isset($_REQUEST["zat_daily_car"]))
	{
		//$sum_pet=0;
		foreach ($_REQUEST["zat_daily_car"] as $key=>$val)
		{
			$keys = array(
			"tn"=>$emp_tn,
			"data"=>OraDate2MDBDate($key)
			);
			foreach($val as $k=>$v)
			{
				$val[$k]=str_replace(",", ".", $v);
			}
			Table_Update ("zat_daily_car", $keys, $val);
			//$sum_pet=$sum_pet+$val["pet_sum"];
		}
		$keys = array(
			"tn"=>$emp_tn,
			"m"=>$m,
			"y"=>$y
		);
		if ($amort!=0)
		{
			//$v=str_replace(",", ".", $sum_pet*$amort);
			$v = $amort*$db->getOne("select sum(pet_sum) from zat_daily_car where tn=".$emp_tn." and trunc(data,'mm')=to_date('".$_REQUEST["month_list"]."','dd.mm.yyyy')");
			//echo $v;
		}
		else
		{
			$v=0;
		}
		Table_Update ("zat_monthly", $keys, array("amort"=>$v));
	}
	if (isset($_REQUEST["zat_daily_trip"]))
	{
		foreach ($_REQUEST["zat_daily_trip"] as $key=>$val)
		{
			$keys = array(
			"tn"=>$emp_tn,
			"data"=>OraDate2MDBDate($key)
			);
			foreach($val as $k=>$v)
			{
				$val[$k]=str_replace(",", ".", $v);
			}
			Table_Update ("zat_daily_trip", $keys, $val);
		}
	}
	if (isset($_REQUEST["zat_monthly"]))
	{
		$keys = array(
			"tn"=>$emp_tn,
			"m"=>$m,
			"y"=>$y
		);
		foreach($_REQUEST["zat_monthly"] as $k=>$v)
		{
			$_REQUEST["zat_monthly"][$k]=str_replace(",", ".", $v);
		}
		$table_name = 'zat_monthly';
		$where="tn=".$emp_tn." and m=".$m." and y=".$y;
		$is_accepted="select is_accepted from ".$table_name." where ".$where;	
		$is_processed="select is_processed from ".$table_name." where ".$where;	
		$is_accepted = $db->getOne($is_accepted);
		$is_processed = $db->getOne($is_processed);
		if (!isset($is_accepted)) {$is_accepted=0;}
		if (!isset($is_processed)) {$is_processed=0;}
		Table_Update ("zat_monthly", $keys, $_REQUEST["zat_monthly"]);
		if (isset($_REQUEST["zat_monthly"]["is_accepted"]))
		{
			$is_accepted!=$_REQUEST["zat_monthly"]["is_accepted"] ? $accepted_changed=1: $accepted_changed=0;
			if ($accepted_changed==1)
			{
				$who="руководителем";
				$status="принят";
				$email=$db->getOne("select e_mail from user_list where tn=".$emp_tn);
				setlocale(LC_TIME, "rus_RUS");
				$subj="Изменение статуса отчета о затратах на ".$period;
				$text="Здравствуйте.<br>";
				$text.="Статус вашего отчета о затратах на ".$period." изменен ".$who." с '".$status."'-'".Int2Text($is_accepted)."' на '".$status."'-'".Int2Text($_REQUEST["zat_monthly"]["is_accepted"])."'.<br>";
				$text.="Время изменения: ".$now_date_time.".";
				send_mail($email,$subj,$text,null);
				audit("статус отчета о затратах ".$emp_tn." за ".$_REQUEST["month_list"]." изменен ".$who." с '".$status."'-'".Int2Text($is_accepted)."' на '".$status."'-'".Int2Text($_REQUEST["zat_monthly"]["is_accepted"]),"zat");
                        }
		}
		if (isset($_REQUEST["zat_monthly"]["is_processed"]))
		{
			$is_processed!=$_REQUEST["zat_monthly"]["is_processed"] ? $processed_changed=1: $processed_changed=0;
			if ($processed_changed==1)
			{
				$who="сотрудником департамента оплаты и стимулирования персонала";
				$status="обработан";
				$email=$db->getOne("select e_mail from user_list where tn=".$emp_tn);
				setlocale(LC_TIME, "rus_RUS");
				$subj="Изменение статуса отчета о затратах на ".$period;
				$text="Здравствуйте.<br>";
				$text.="Статус вашего отчета о затратах на ".$period." изменен ".$who." с '".$status."'-'".Int2Text($is_processed)."' на '".$status."'-'".Int2Text($_REQUEST["zat_monthly"]["is_processed"])."'.<br>";
				$text.="Время изменения: ".$now_date_time.".";
				send_mail($email,$subj,$text,null);
				audit("статус отчета о затратах ".$emp_tn." за ".$_REQUEST["month_list"]." изменен ".$who." с '".$status."'-'".Int2Text($is_processed)."' на '".$status."'-'".Int2Text($_REQUEST["zat_monthly"]["is_processed"]),"zat");
			}
		}
	}
}

if (isset($_REQUEST["copy_city"]))
{
	audit("скопировал города ".$emp_tn." за ".$_REQUEST["month_list"],"zat");
	if (isset($_REQUEST["zat_daily_car"]))
	{
		foreach ($_REQUEST["zat_daily_car"] as $key=>$val)
		{
			$keys = array(
			"tn"=>$emp_tn,
			"data"=>OraDate2MDBDate($key)
			);
			foreach($val as $k=>$v)
			{
				$val[$k]=str_replace(",", ".", $v);
			}
			Table_Update ("zat_daily_trip", $keys, array("city"=>$val["city"]));
		}
	}
}



if (isset($_REQUEST["error"])||isset($_REQUEST["error_stat"]))
{
	audit("отправил сообщение об ошибке  затратах ".$emp_tn." за ".$_REQUEST["month_list"],"zat");
	if (isset($_REQUEST["error_stat"]))
	{
		$keys = array(
			"tn"=>$emp_tn,
			"m"=>$m,
			"y"=>$y
		);
		$vals = array("is_accepted"=>0);
		Table_Update ("zat_monthly", $keys, $vals);
	}
	$sql = rtrim(file_get_contents('sql/get_emails.sql'));
	$p=array(":tn"=>$emp_tn);
	$sql=stritr($sql,$p);
	$emails = $db->getCol($sql);
	$subj = "Ошибка в отчете о затратах";
	$text =
	"В отчете о затратах сотрудника - <b>".$emp_fio."</b> - специалистом департамента оплаты и стимулирования персонала обнаружена ошибка:".
	"<p style=\"color: red;\">".$_REQUEST["txt"]."</p>";
	if (isset($_REQUEST["error"]))
	{
		$text.= "Просьба учесть информацию в дальнейшем при заполнении отчета о затратах.<br>";
	}
	if (isset($_REQUEST["error_stat"]))
	{
		$text.= "Просим в кратчайшие сроки: исправить ошибку, руководителю выставить статус 'Отчет принят' на значение 'ДА'.<br>";
	}
	$text.= "В противном случае дальнейшие выплаты по сотруднику - <b>".$emp_fio."</b> - будут приостановлены.";
	foreach ($emails as $val)
	{
		send_mail($val,$subj,$text,null);
	}
	/*
	Сообщения сотрудников оплаты добавлять в переписку.
	Сейчас они только рассылаются по почте, в переписке не остаются.
	Оставлять только текст, написанный сотрудником оплаты.
	Префикс типа "....Оплаты будут приостановлены" - в переписку НЕ ДОБАВЛЯТЬ.
	*/


	$keys = array(
		"tn"=>$emp_tn,
		"m"=>$m,
		"y"=>$y,
		"lu"=>null
	);
	$vals=array("msg"=>$_REQUEST["txt"],"lu_tn"=>$tn,"lu_fio"=>$fio);
	Table_Update("zat_monthly_chat",$keys,$vals);
}




$sql = rtrim(file_get_contents('sql/zat.sql'));
$p=array(':sd'=>"'".$_REQUEST["month_list"]."'",":tn"=>$emp_tn);
$sql=stritr($sql,$p);
$zat = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('zat', $zat);


$sql = rtrim(file_get_contents('sql/zat_daily.sql'));
$p=array(':sd'=>"'".$_REQUEST["month_list"]."'",":tn"=>$emp_tn);
$sql=stritr($sql,$p);
$zat_daily = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('zat_daily', $zat_daily);


$sql = rtrim(file_get_contents('sql/zat_daily_total.sql'));
$p=array(':sd'=>"'".$_REQUEST["month_list"]."'",":tn"=>$emp_tn);
$sql=stritr($sql,$p);
$zat_daily_total = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('zat_daily_total', $zat_daily_total);



$sql = rtrim(file_get_contents('sql/zat_monthly.sql'));
$p=array(":tn"=>$emp_tn,":month_list"=>"'".$_REQUEST["month_list"]."'");
$sql=stritr($sql,$p);
$zat_monthly = $db->getRow($sql,null,null,null,MDB2_FETCHMODE_ASSOC);
$smarty->assign('zat_monthly', $zat_monthly);
//print_r($zat_monthly);

$sql = rtrim(file_get_contents('sql/zat_monthly_chat.sql'));
$p=array(":tn"=>$emp_tn,":month_list"=>"'".$_REQUEST["month_list"]."'");
$sql=stritr($sql,$p);
$zat_monthly_chat = $db->getAll($sql,null,null,null,MDB2_FETCHMODE_ASSOC);
$smarty->assign('zat_monthly_chat', $zat_monthly_chat);
//print_r($zat_monthly_chat);


$smarty->assign('emp_tn', $emp_tn);
$smarty->assign('exp_tn', $exp_tn);



if (isset($_REQUEST["del_file"]))
{
	foreach ($_REQUEST["del_file"] as $k=>$v)
	{
		unlink($v);
		audit("удалил файл ".$v." из затрат ".$emp_tn." за ".$_REQUEST["month_list"],"zat");
	}
}

$d1="zat_files";
$d2=$d1."/".$y;
$d3=$d2."/".$m;
$d5=$d3."/".$emp_tn;

if (!file_exists($d1)) {mkdir($d1);}
if (!file_exists($d2)) {mkdir($d2);}
if (!file_exists($d3)) {mkdir($d3);}
if (!file_exists($d5)) {mkdir($d5);}

foreach ($_FILES as $k=>$v)
{
	foreach ($v["name"] as $k1=>$v1)
	{
		if (!file_exists($d5."/".$k)) {mkdir($d5."/".$k);}
		if (is_uploaded_file($v['tmp_name'][$k1])){
			move_uploaded_file($v["tmp_name"][$k1], $d5."/".$k."/".translit($v["name"][$k1]));
			audit("успешно сохранен файл ".translit($v["name"][$k1])." в затратах ".$emp_tn." за ".$_REQUEST["month_list"],"zat");
		}
	}
}

function fl_func($prefix)
{
	global $smarty;
	global $d5;
	$d3=$d5."/".$prefix."/";
	if (!file_exists($d3)) {mkdir($d3);}
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
fl_func("car");
fl_func("trip");
fl_func("other");


if (isset($_REQUEST["save_car"]))
{
	audit("сохранил авто ".$_REQUEST["car"]." в затратах ".$emp_tn." за ".$_REQUEST["month_list"],"zat");
	$keys = array(
		"svideninn"=>$emp_tn,
	);
	$vals = $_REQUEST["car"];
	Table_Update ("spdtree", $keys, $vals);
}

$car_brand     = $db->getOne("select car_brand from spdtree where svideninn = ".$emp_tn."");
$car_rashod    = $db->getOne("select car_rashod from spdtree where svideninn = ".$emp_tn."");

$smarty->assign('car_brand', $car_brand);
$smarty->assign('car_rashod', $car_rashod);

if (isset($_REQUEST["save_limits"]))
{
	audit("сохранил лимиты в затратах ".$emp_tn." за ".$_REQUEST["month_list"],"zat");
	$keys = array(
		"tn"=>$emp_tn,
		"lu"=>null
	);
	$vals = $_REQUEST["limits"];
	if ($_REQUEST["limits"]["sz_id"]!=null)
        {
            $sz_kat=$db->getOne('select cat from sz where id='.$_REQUEST["limits"]["sz_id"]);
            if ($sz_kat==15534784)
            {
                    Table_Update ("limits", $keys, $vals);
            }
            else
            {
                    $smarty->assign('error', 1);
                    $smarty->assign('error_text', "Указанная СЗ не относится к категории 'Оплата: установка / корректировка лимитов'");
            }
        }
	if ($_REQUEST["limits"]["zay_id"]!=null)
        {
            $zay_st=$db->getOne('select st from bud_ru_zay where id='.$_REQUEST["limits"]["zay_id"]);
            if ($zay_st==73133433)
            {
                Table_Update ("limits", $keys, $vals);
            }
            else
            {
                $smarty->assign('error', 1);
                $smarty->assign('error_text', "Указанная заявка на активность не относится к категории 'Ст. 10 Установка ГБО'");
            }
        }
}


$sql = rtrim(file_get_contents('sql/zat_limits_current.sql'));
$p=array(":tn"=>$emp_tn);
$sql=stritr($sql,$p);
$res = $db->getRow($sql,null,null,null,MDB2_FETCHMODE_ASSOC);
$smarty->assign('limits_current', $res);

$sql = rtrim(file_get_contents('sql/zat_limits.sql'));
$p=array(":tn"=>$emp_tn);
$sql=stritr($sql,$p);
$res = $db->getAll($sql,null,null,null,MDB2_FETCHMODE_ASSOC);
$smarty->assign('limits', $res);

$smarty->display('zat.html');

//ses_req();

?>