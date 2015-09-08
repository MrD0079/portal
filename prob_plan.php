<?

if (!isset($_REQUEST["tn"]))
{
	$self=1;
	$prob_tn=$tn;
}
else
{
	$self = 0;
	$prob_tn=$_REQUEST["tn"];
}

audit("открыл план адаптации ".$prob_tn,"prob_plan");

if (isset($_REQUEST["replace_data"]))
{
	audit("заменил даты ".$prob_tn,"prob_plan");
	foreach ($_REQUEST["replace_data"] as $k=>$v)
	{
		if ($v!="")
		{
			//echo $k." changed to ".$v."<br>";
			$table_name="p_prob_inst";
			$keys=array("prob_tn"=>$prob_tn);
			$vals=array($k=>OraDate2MDBDate($v));
			Table_Update ($table_name, $keys, $vals);
		}
	}
}

if (isset($_REQUEST["replace_exp"]))
{
	audit("заменил ответственных ".$prob_tn,"prob_plan");
	foreach ($_REQUEST["replace_exp"] as $k=>$v)
	{
		if ($v!="")
		{
			//echo $k." changed<br>";
			$table_name="p_prob_inst";
			$keys=array("prob_tn"=>$prob_tn);
			$vals=array($k=>$v);
			Table_Update ($table_name, $keys, $vals);
		}
	}
}

$params=array(":tn"=>$prob_tn);
$sql=rtrim(file_get_contents('sql/prob_plan.sql'));
$sql=stritr($sql,$params);
$data = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

if ($data["prob_tn"]==$tn) {$smarty->assign("self",1);}
if ($data["inst_tn"]==$tn) {$smarty->assign("inst",1);}
if ($data["chief_tn"]==$tn) {$smarty->assign("chief",1);}
if ($data["dir_tn"]==$tn) {$smarty->assign("dir",1);}

$smarty->assign('plan', $data);

$prob_fio = &$db->getOne("select fio from user_list where tn=".$prob_tn);
$smarty->assign('prob_fio', $prob_fio);

if (isset($_REQUEST['clear_checkboxes']))
{
	audit("сбросил подтверждения p_plan ".$prob_tn,"prob_plan");
	$table_name="p_plan";
	$keys=array("tn"=>$prob_tn);
	$vals=$_REQUEST["clear_plan"];
	Table_Update ($table_name, $keys, $vals);
}

if (isset($_REQUEST['p_plan']))
{
	audit("сохранил p_plan ".$prob_tn,"prob_plan");
	$table_name="p_plan";
	$keys=array("tn"=>$prob_tn);
	$vals=$_REQUEST["p_plan"];
	Table_Update ($table_name, $keys, $vals);
}

if (isset($_REQUEST['p_purpose']))
{
	audit("сохранил p_purpose ".$prob_tn,"prob_plan");
	$table_name="p_purpose";
	foreach ($_REQUEST["p_purpose"] as $key=>$val)
	{
		$keys=array("tn"=>$prob_tn,"purpose_id"=>$key);
		$vals=$val;
		Table_Update ($table_name, $keys, $vals);
	}
}

if (isset($_REQUEST['p_dev_movement']))
{
	audit("сохранил p_dev_movement ".$prob_tn,"prob_plan");
	$table_name="p_dev_movement";
	foreach ($_REQUEST["p_dev_movement"] as $key=>$val)
	{
		foreach ($val as $key1=>$val1)
		{
			$keys=array("purpose_id"=>$key,"movement_id"=>$key1);
			$vals=$val1;
			isset($vals["period"])?$vals["period"]=OraDate2MDBDate($vals["period"]):null;
			Table_Update ($table_name, $keys, $vals);
		}
	}
}

if (isset($_REQUEST['del']))
{
	foreach ($_REQUEST["del"] as $key=>$val)
	{
		$table_name=$key;
		foreach ($val as $key1=>$val1)
		{
			foreach ($val1 as $key2=>$val2)
			{
				audit("удалил запись ".$key1."=>".$key2." из таблицы ".$key." ".$prob_tn,"prob_plan");
				$keys=array($key1=>$key2);
				$vals=null;
				Table_Update ($table_name, $keys, $vals);
			}
		}
	}
}

if (isset($_REQUEST['new_purpose']))
{
	audit("добавил p_purpose ".$prob_tn,"prob_plan");
	$db->query("insert into p_purpose (tn) values (".$prob_tn.")");
}

if (isset($_REQUEST['new_dev_movement']))
{
	audit("добавил p_dev_movement ".$prob_tn,"prob_plan");
	$db->query("insert into p_dev_movement (purpose_id) values (".$_REQUEST['r'].")");
}

if (isset($_REQUEST['new_probation']))
{
	audit("добавил p_probation ".$prob_tn,"prob_plan");
	$db->query("insert into p_probation (tn) values (".$prob_tn.")");
}

$sql=rtrim(file_get_contents('sql/prob_plan_status.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('prob_plan_status',$data);

$sql=rtrim(file_get_contents('sql/prob_plan_test.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('prob_plan_test',$data);

// get plan
$sql="
select
rownum,
p.*,
TO_CHAR (stamp_employee, 'dd/mm/yyyy hh24:mi:ss') stamp_employee_t,
TO_CHAR (stamp_teacher, 'dd/mm/yyyy hh24:mi:ss') stamp_teacher_t,
TO_CHAR (stamp_chief, 'dd/mm/yyyy hh24:mi:ss') stamp_chief_t
from (select * from p_plan p where tn=".$prob_tn.") p";
//echo $sql;
$data = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
//print_r($data);
if ($data)
{
	foreach ($data as $key=>$val)
	{
		$smarty->assign($key,$val);
	}
}
// get purposes
$data = $db->getAll("select rownum, p.* from (select * from p_purpose p where tn=".$prob_tn." order by purpose_id) p", null, null, null, MDB2_FETCHMODE_ASSOC);
foreach ($data as $key=>$val)
{
	// get dev_movements
	$dev_movements = $db->getAll("select rownum, p.*,to_char(p.period,'dd.mm.yyyy') period from (select * from p_dev_movement p where purpose_id=".$val["purpose_id"]." order by movement_id) p", null, null, null, MDB2_FETCHMODE_ASSOC);
	$data[$key]["dev_movements"]=$dev_movements;
}
$smarty->assign('purposes',$data);

$sql = rtrim(file_get_contents('sql/spd_list.sql'));
$p = array(':dpt_id' => $_SESSION["dpt_id"]);
$sql=stritr($sql,$p);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('spd_list', $data);

$sql = rtrim(file_get_contents('sql/prob_plan_test_result.sql'));
$p = array(':tn' => $prob_tn);
$sql=stritr($sql,$p);
$data = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('test_result', $data);

$smarty->display('prob_plan.html');

?>