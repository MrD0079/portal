<?php
if (isset($_REQUEST['nohead']))
{
	if (isset($_REQUEST["save"]))
	{
		$_REQUEST['field']=='reserv_dt'?$_REQUEST['val']=OraDate2MDBDate($_REQUEST['val']):null;
		Table_Update("spr_users_eta",array("login"=>$_REQUEST["login"]),array($_REQUEST["field"]=>$_REQUEST["val"]));
	}
	if (isset($_REQUEST["updatePwd"]))
	{
		$new_pwd=$db->getOne("select DBMS_RANDOM.STRING ('A', 4) from dual");
		Table_Update("spr_users",array("login"=>$_REQUEST["login"]),array("password"=>$new_pwd));
		echo $new_pwd;
	}
	if (isset($_REQUEST["sendPwds"]))
	{
		$email=$db->getOne("select e_mail from user_list where tn=".$_REQUEST['tn']);
		$text="<table border=1 cellspacing=0 cellpadding=3>";
		$text.="<tr>";
		$text.="<td>ЭТА</td>";
		$text.="<td>Логин</td>";
		$text.="<td>Пароль</td>";
		$text.="</tr>";
		$t1="ЭТА / логин / пароль<br>";
		$params=array(':dpt_id' => $_SESSION["dpt_id"],
			':tn'=>$tn,
			':exp_list_without_ts' => 0,
			':exp_list_only_ts' => 0
		);
		$sql = rtrim(file_get_contents('sql/spr_users_eta.sql'));
		$sql=stritr($sql,$params);
		$r1 = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
		foreach ($r1 as $k1=>$v1)
		{
			if ($v1["tn"]==$_REQUEST['tn'])
			{
				$text.="<tr>";
				$text.="<td>".$v1["eta"]."</td>";
				$text.="<td>".$v1["login"]."</td>";
				$text.="<td>".$v1["password"]."</td>";
				$text.="</tr>";
				$t1.=$v1["eta"]." / ".$v1["login"]." / ".$v1["password"]."<br>";
			}
		}
		$text.="</table>";
		send_mail($email,"Торговые агенты",$text,null);
	}
}
else
{
	audit("открыл список торговых агентов","spr_users_eta");
	InitRequestVar("exp_list_without_ts",0);
	InitRequestVar("exp_list_only_ts",0);
	InitRequestVar("reserv",1);
	$params=array(':dpt_id' => $_SESSION["dpt_id"],
		':tn'=>$tn,
		':exp_list_without_ts' => $_REQUEST["exp_list_without_ts"],
		':exp_list_only_ts' => $_REQUEST["exp_list_only_ts"],
		':reserv' => $_REQUEST["reserv"],
	);
	$sql = rtrim(file_get_contents('sql/spr_users_eta_childs_list.sql'));
	$sql=stritr($sql,$params);
	$exp_list_only_ts = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('exp_list_only_ts', $exp_list_only_ts);
	$sql = rtrim(file_get_contents('sql/spr_users_eta_chief_list.sql'));
	$sql=stritr($sql,$params);
	$exp_list_without_ts = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('exp_list_without_ts', $exp_list_without_ts);
	if (isset($_REQUEST["show"]))
	{
		$sql = rtrim(file_get_contents('sql/spr_users_eta.sql'));
		$sql=stritr($sql,$params);
		$r1 = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
		$sql = rtrim(file_get_contents('sql/spr_users_eta_total.sql'));
		$sql=stritr($sql,$params);
		$r2 = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
		foreach ($r2 as $k=>$v){$d[$v["tn"]]["head"]=$v;}
		foreach ($r1 as $k=>$v){$d[$v["tn"]]["data"][$v["login"]]=$v;}
		isset($d) ? $smarty->assign('d', $d) : null;
	}
	$smarty->display('spr_users_eta.html');
}
?>