<?


//ses_req();

if (!isset($_REQUEST["tn"]))
{
	$self=1;
	$razv_tn=$tn;
}
else
{
	$self = 0;
	$razv_tn=$_REQUEST["tn"];
	$params=array(':exp_tn'=>$tn,':emp_tn'=>$razv_tn);

	$sql=rtrim(file_get_contents('sql/razv_get_teacher.sql'));
	$sql=stritr($sql,$params);
	$teacher=$db->getOne($sql);
	$smarty->assign('teacher', $teacher);

	$sql=rtrim(file_get_contents('sql/razv_get_chief.sql'));
	$sql=stritr($sql,$params);
	$chief=$db->getOne($sql);
	$smarty->assign('chief', $chief);

}
$smarty->assign('self', $self);

$razv_fio = $db->getOne("select fio from user_list where tn=".$razv_tn);
$smarty->assign('razv_fio', $razv_fio);

InitRequestVar("razv_event",0);

if ($_REQUEST["razv_event"]>0)
{

if (isset($_REQUEST['save']))
{
	if (isset($_REQUEST['r_plan']))
	{
		$table_name="r_plan";
		$keys=array("tn"=>$razv_tn,"event"=>$_REQUEST["razv_event"]);
		$vals=$_REQUEST["r_plan"];
		Table_Update ($table_name, $keys, $vals);
	}
	if (isset($_REQUEST['r_purpose']))
	{
		$table_name="r_purpose";
		foreach ($_REQUEST["r_purpose"] as $key=>$val)
		{
			$keys=array("tn"=>$razv_tn,"event"=>$_REQUEST["razv_event"],"purpose_id"=>$key);
			$vals=$val;
			Table_Update ($table_name, $keys, $vals);
		}
	}
	if (isset($_REQUEST['r_dev_movement']))
	{
		$table_name="r_dev_movement";
		foreach ($_REQUEST["r_dev_movement"] as $key=>$val)
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
	if (isset($_REQUEST['r_os']))
	{
		$table_name="r_os";
		foreach ($_REQUEST["r_os"] as $key=>$val)
		{
			$keys=array("tn"=>$razv_tn,"event"=>$_REQUEST["razv_event"],"os_id"=>$key);
			$vals=$val;
			Table_Update ($table_name, $keys, $vals);
		}
	}
	if (isset($_REQUEST['r_os_movement']))
	{
		$table_name="r_os_movement";
		foreach ($_REQUEST["r_os_movement"] as $key=>$val)
		{
			foreach ($val as $key1=>$val1)
			{
				$keys=array("os_id"=>$key,"movement_id"=>$key1);
				$vals=$val1;
				isset($vals["period"])?$vals["period"]=OraDate2MDBDate($vals["period"]):null;
				Table_Update ($table_name, $keys, $vals);
			}
		}
	}
	if (isset($_REQUEST['r_probation']))
	{
		$table_name="r_probation";
		foreach ($_REQUEST["r_probation"] as $key=>$val)
		{
			$keys=array("tn"=>$razv_tn,"event"=>$_REQUEST["razv_event"],"probation_id"=>$key);
			$vals=$val;
			isset($vals["period"])?$vals["period"]=OraDate2MDBDate($vals["period"]):null;
			Table_Update ($table_name, $keys, $vals);
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
					$keys=array($key1=>$key2);
					$vals=null;
					Table_Update ($table_name, $keys, $vals);
				}
			}
		}
	}
}
else
{
	if (isset($_REQUEST['new_purpose'])) {$db->query("insert into r_purpose (tn,event) values (".$razv_tn.",".$_REQUEST["razv_event"].")");}
	if (isset($_REQUEST['new_dev_movement'])){$db->query("insert into r_dev_movement (purpose_id) values (".$_REQUEST['r'].")");}
	if (isset($_REQUEST['new_os'])) {$db->query("insert into r_os (tn,event) values (".$razv_tn.",".$_REQUEST["razv_event"].")");}
	if (isset($_REQUEST['new_os_movement'])){$db->query("insert into r_os_movement (os_id) values (".$_REQUEST['r'].")");}
	if (isset($_REQUEST['new_probation'])) {$db->query("insert into r_probation (tn,event) values (".$razv_tn.",".$_REQUEST["razv_event"].")");}
}


	// get plan
	$data = $db->getRow("select rownum, p.* from (select * from r_plan p where tn=".$razv_tn." and event=".$_REQUEST["razv_event"]." order by event) p", null, null, null, MDB2_FETCHMODE_ASSOC);
	if ($data)
	{
		foreach ($data as $key=>$val)
		{
			$smarty->assign($key,$val);
		}
	}

	// get purposes
	$data = $db->getAll("select rownum, p.* from (select * from r_purpose p where tn=".$razv_tn." and event=".$_REQUEST["razv_event"]." order by purpose_id) p", null, null, null, MDB2_FETCHMODE_ASSOC);
	foreach ($data as $key=>$val)
	{
		// get dev_movements
		$dev_movements = $db->getAll("select rownum, p.*,to_char(p.period,'dd.mm.yyyy') period from (select * from r_dev_movement p where purpose_id=".$val["purpose_id"]." order by movement_id) p", null, null, null, MDB2_FETCHMODE_ASSOC);
		$data[$key]["dev_movements"]=$dev_movements;
	}
	$smarty->assign('purposes',$data);

	// get oss
	$data = $db->getAll("select rownum, p.* from (select * from r_os p where tn=".$razv_tn." and event=".$_REQUEST["razv_event"]." order by os_id) p", null, null, null, MDB2_FETCHMODE_ASSOC);
	foreach ($data as $key=>$val)
	{
		// get os_movements
		$os_movements = $db->getAll("select rownum, p.*,to_char(p.period,'dd.mm.yyyy') period from (select * from r_os_movement p where os_id=".$val["os_id"]." order by movement_id) p", null, null, null, MDB2_FETCHMODE_ASSOC);
		$data[$key]["os_movements"]=$os_movements;
	}
	$smarty->assign('oss',$data);

	$data = $db->getAll("select rownum, p.*,to_char(p.period,'dd.mm.yyyy') period from (select * from r_probation p where tn=".$razv_tn." and event=".$_REQUEST["razv_event"]." order by probation_id) p", null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('probations',$data);
}

$sql=rtrim(file_get_contents('sql/razv_events.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('razv_event', $data);

$sql=rtrim(file_get_contents('sql/razv_plan_status.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('razv_plan_status',$data);

$smarty->display('razv_plan.html');


?>