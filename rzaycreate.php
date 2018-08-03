<?



//audit("открыл rzay_reestr","rzay_reestr");
/*
InitRequestVar("nets",0);
InitRequestVar("calendar_years",0);
InitRequestVar("tn_rmkk",0);
InitRequestVar("tn_mkk",0);
InitRequestVar("calendar_months",0);
InitRequestVar("format",0);
InitRequestVar("payer",0);
InitRequestVar("urlic",0);
InitRequestVar("num",'');
InitRequestVar("okfm","all");
InitRequestVar("rzay_sended","all");
*/

if (isset($_REQUEST["gettplist"]))
{
	$sql=rtrim(file_get_contents('sql/rzaycreate_gettplist.sql'));
	$p = array(':id_net' => $_REQUEST["id_net"]);
	$sql=stritr($sql,$p);
	$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	echo "<option></option>";
	foreach ($data as $k=>$v)
	{
		echo "<option value=".$v["id"].">".$v["name"]."</option>";
	}
}
else
{
	if (isset($_REQUEST["add"]))
	{
		
		$id=get_new_id();
		$v=$_REQUEST["new"];
		$v["dt"]=OraDate2MDBDate($v["dt"]);
		$v["id"]=$id;
		Table_Update("rzay",$v,$v);
		if (isset($_FILES['new_files']))
		{
			foreach($_FILES['new_files']['name'] as $k=>$v)
			{
				if
				(
					is_uploaded_file($_FILES['new_files']['tmp_name'][$k])
				)
				{
					$a=pathinfo($_FILES['new_files']['name'][$k]);
					$fn=get_new_file_id().'_'.translit($_FILES['new_files']['name'][$k]);
					$vals=array(
						'rzay'=>$id,
						'fn'=>$fn
					);
					Table_Update('rzayfiles', $vals,$vals);
					move_uploaded_file($_FILES['new_files']['tmp_name'][$k], 'files/'.$fn);
				}
			}
		}
		echo '<p style="color:red">заявка '.$id.' отправлена на согласование</p>';
	}
	$sql=rtrim(file_get_contents('sql/distr_prot_di_kk.sql'));
	$p = array(":dpt_id" => $_SESSION["dpt_id"],':tn'=>$tn);
	$sql=stritr($sql,$p);
	$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('payer', $data);
	$sql = rtrim(file_get_contents('sql/month_list.sql'));
	$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('month_list', $res);
	$sql=rtrim(file_get_contents('sql/bud_ru_zay_create_nets.sql'));
	$params=array(':tn'=>$tn,':dpt_id' => $_SESSION["dpt_id"]);
	$sql=stritr($sql,$params);
	$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('nets', $data);
	$smarty->display('rzaycreate.html');
}
?>