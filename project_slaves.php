<?

InitRequestVar("prj_id",0);

//ses_req();

$table="project_report";

if ((isset($_REQUEST["z"]))&&(isset($_REQUEST["save"])))
{
	foreach ($_REQUEST["z"] as $k=>$v)
	{
		foreach ($v as $k1=>$v1)
		{
			$keys=array("prj_node_id"=>$k1,"tn"=>$k);
			$values=$v1;
			//print_r($keys);
			//print_r($values);
			Table_Update($table,$keys,$values);
		}
	}
}


$params=array(":dpt_id"=>$_SESSION["dpt_id"],":tn"=>$tn);
$sql=rtrim(file_get_contents('sql/project_slaves_heads.sql'));
$sql=stritr($sql,$params);
$project_slaves_heads = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('project_slaves_heads', $project_slaves_heads);


$prg=null;

foreach($project_slaves_heads as $k=>$v)
{
	if ($_REQUEST["prj_id"]==$v["id"])
	{
		$prg=$v;
	}
}

if (($_REQUEST["prj_id"]!=0)&&$prg)
{
	$params=array(':prj_id' => $_REQUEST["prj_id"],":dpt_id"=>$_SESSION["dpt_id"],":tn"=>$tn);
	$sql="SELECT distinct f.slave, fn_getname (f.slave) fio FROM full f WHERE f.dpt_id = :dpt_id AND f.master = :tn AND f.full = 1 AND fn_get_prj_grant (:prj_id, f.slave) = 1 /*and f.slave in (2372112532,2396911573,2967710205)*/";
	$sql=stritr($sql,$params);
	$r = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	foreach($r as $k=>$v)
	{
		$params=array(':prj_id' => $_REQUEST["prj_id"],":dpt_id"=>$_SESSION["dpt_id"],":tn"=>$v["slave"]);
		$sql=rtrim(file_get_contents('sql/project_slaves.sql'));
		$sql=stritr($sql,$params);
		$project_slaves = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
		$d[$v["slave"]]["head"]["fio"]=$v["fio"];
		$d[$v["slave"]]["head"]["tn"]=$v["slave"];
		$d[$v["slave"]]["data"]=$project_slaves;

		$params=array(':prj_id' => $_REQUEST["prj_id"],":dpt_id"=>$_SESSION["dpt_id"],":tn"=>$v["slave"]);
		$sql=rtrim(file_get_contents('sql/project_slaves_total.sql'));
		$sql=stritr($sql,$params);
		$project_slaves_total = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
		$dt[$v["slave"]]["head"]["fio"]=$v["fio"];
		$dt[$v["slave"]]["head"]["tn"]=$v["slave"];
		$dt[$v["slave"]]["data"]=$project_slaves_total;


	}
	$smarty->assign('project_slaves', $d);
	$smarty->assign('project_slaves_total', $dt);


}

$smarty->display('project_slaves.html');

?>