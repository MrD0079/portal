<?php



audit("открыл закрепление маршрута за сотрудниками","merch_routes");







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

	if (isset($_REQUEST["gps"]))
	{
		foreach ($_REQUEST["gps"] as $k=>$v)
		{
			Table_Update("routes_head",array("id"=>$k),array("gps"=>$v));
		}
	}

}

$sql = rtrim(file_get_contents('sql/merch_routes.sql'));
$p=array(":month_list"=>"'".$_REQUEST["month_list"]."'");
$sql=stritr($sql,$p);
$r1 = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

$sql = rtrim(file_get_contents('sql/merch_routes_total.sql'));
$p=array(":month_list"=>"'".$_REQUEST["month_list"]."'");
$sql=stritr($sql,$p);
$r2 = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

foreach ($r2 as $k=>$v){$d[$v["tn"]]["head"]=$v;}
foreach ($r1 as $k=>$v){$d[$v["tn"]]["data"][$v["login"]]=$v;}
isset($d) ? $smarty->assign('d', $d) : null;

if (isset($_REQUEST["save"]))
{
	if (isset($_REQUEST["mail"]))
	{
		foreach ($_REQUEST["mail"] as $k=>$v)
		{
			$email=$db->getOne("select e_mail from user_list where tn=".$k);
			$text="<table border=1 cellspacing=0 cellpadding=3>";
			$text.="<tr>";
			$text.="<td>Маршрут</td>";
			$text.="<td>Логин</td>";
			$text.="<td>Пароль</td>";
			$text.="</tr>";
			$t1="маршрут / логин / пароль<br>";
			foreach ($r1 as $k1=>$v1)
			{
				if ($v1["tn"]==$k)
				{
					$text.="<tr>";
					$text.="<td>".$v1["num"]."</td>";
					$text.="<td>".$v1["login"]."</td>";
					$text.="<td>".$v1["password"]."</td>";
					$text.="</tr>";
					$t1.=$v1["num"]." / ".$v1["login"]." / ".$v1["password"]."<br>";
				}
			}
			$text.="</table>";
			send_mail($email,"Закрепление маршрута за сотрудниками",$t1,null);
		}
	}
}


$sql = rtrim(file_get_contents('sql/month_list.sql'));
//echo $sql;
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('month_list', $res);



$smarty->display('merch_routes.html');
?>