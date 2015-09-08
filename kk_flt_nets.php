<?

//ses_req();

audit ("открыл форму фильтры сетей","kk");

InitRequestVar("id",0);



if (isset($_REQUEST["add"]))
{
	Table_update("kk_flt_nets",array("tn"=>$tn,"id"=>0),array("name"=>addslashes($_REQUEST["name"])));
	audit ("добавил фильтр по сетям","kk");
	$new_id=$db->getOne("select max(id) from kk_flt_nets where tn=".$tn);
	if (isset($_REQUEST["detail"]))
	{
		$keys = array("id_flt"=>$new_id);
		Table_update("kk_flt_nets_detail",$keys,null);
		foreach ($_REQUEST["detail"] as $k=>$v)
		{
			$keys = array("id_net"=>$k,"id_flt"=>$new_id);
			Table_update("kk_flt_nets_detail",$keys,$keys);
		}
	}
}

if (isset($_REQUEST["save"]))
{
	Table_update("kk_flt_nets",array("tn"=>$tn,"id"=>$_REQUEST["id"]),array("name"=>addslashes($_REQUEST["name"])));
	audit ("сохранил фильтр по сетям","kk");
	if (isset($_REQUEST["detail"]))
	{
		$keys = array("id_flt"=>$_REQUEST["id"]);
		Table_update("kk_flt_nets_detail",$keys,null);
		foreach ($_REQUEST["detail"] as $k=>$v)
		{
			$keys = array("id_net"=>$k,"id_flt"=>$_REQUEST["id"]);
			Table_update("kk_flt_nets_detail",$keys,$keys);
		}
	}
}


if (isset($_REQUEST["del"]))
{
	Table_update("kk_flt_nets",array("tn"=>$tn,"id"=>$_REQUEST["id"]),null);
	audit ("удалил фильтр по сетям","kk");
}




$sql=rtrim(file_get_contents('sql/kk_flt_nets.sql'));
$params=array(':tn' => $tn);
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('kk_flt_nets', $data);


$sql=rtrim(file_get_contents('sql/kk_flt_nets_detail.sql'));
$params=array(':tn' => $tn,':id_flt' => $_REQUEST["id"]);
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('kk_flt_nets_detail', $data);





$smarty->display('kk_start.html');
$smarty->display('kk_flt_nets.html');
$smarty->display('kk_end.html');

?>