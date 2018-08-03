<?php



audit("открыл Пароли заказчиков","routes_agents_pwd");





if (isset($_REQUEST["new"]))
{
	foreach ($_REQUEST["new"] as $k=>$v)
	{
		$id=get_new_id();
		Table_Update("routes_agents_pwd",array("ag_id"=>$k,"id"=>$id),array("ag_id"=>$k,"id"=>$id));
	}
}


if (isset($_REQUEST["save"]))
{
	if (isset($_REQUEST["pwd"]))
	{
		foreach ($_REQUEST["pwd"] as $k=>$v)
		{
			$new_pwd=$db->getOne("select DBMS_RANDOM.STRING ('A', 4) from dual");
			Table_Update("spr_users",array("login"=>$k),array("password"=>$new_pwd));
		}
	}
}

if (isset($_REQUEST["save_data"]))
{
	if (isset($_REQUEST["comm"]))
	{
		foreach ($_REQUEST["comm"] as $k=>$v)
		{
			Table_Update("routes_agents_pwd",array("login"=>$k),array("comm"=>$v));
		}
	}
	if (isset($_REQUEST["email"]))
	{
		foreach ($_REQUEST["email"] as $k=>$v)
		{
			Table_Update("routes_agents_pwd",array("login"=>$k),array("email"=>$v));
		}
	}
	if (isset($_REQUEST["is_super"]))
	{
		foreach ($_REQUEST["is_super"] as $k=>$v)
		{
			Table_Update("routes_agents_pwd",array("login"=>$k),array("is_super"=>$v));
		}
	}
	if (isset($_REQUEST["is_vf"]))
	{
		foreach ($_REQUEST["is_vf"] as $k=>$v)
		{
			Table_Update("routes_agents_pwd",array("login"=>$k),array("is_vf"=>$v));
		}
	}
	if (isset($_REQUEST["is_so"]))
	{
		foreach ($_REQUEST["is_so"] as $k=>$v)
		{
			Table_Update("routes_agents_pwd",array("login"=>$k),array("is_so"=>$v));
		}
	}
	if (isset($_REQUEST["stat"]))
	{
		foreach ($_REQUEST["stat"] as $k=>$v)
		{
			Table_Update("routes_agents_pwd",array("login"=>$k),array("stat"=>$v));
		}
	}
	if (isset($_REQUEST["del"]))
	{
		foreach ($_REQUEST["del"] as $k=>$v)
		{
			Table_Update("routes_agents_pwd",array("login"=>$k),null);
		}
	}
}

$sql = rtrim(file_get_contents('sql/routes_agents_pwd.sql'));
$p=array(":month_list"=>"'".$_REQUEST["month_list"]."'");
$sql=stritr($sql,$p);
$r1 = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

$sql = rtrim(file_get_contents('sql/routes_agents_pwd_total.sql'));
$p=array(":month_list"=>"'".$_REQUEST["month_list"]."'");
$sql=stritr($sql,$p);
$r2 = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

foreach ($r2 as $k=>$v){$d[$v["id"]]["head"]=$v;}
foreach ($r1 as $k=>$v){$d[$v["id"]]["data"][$v["login"]]=$v;}
isset($d) ? $smarty->assign('d', $d) : null;

//print_r($d);

$smarty->display('routes_agents_pwd.html');
?>