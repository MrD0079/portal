<?
InitRequestVar("exp_list_without_ts",0);
InitRequestVar("dates_list1");
InitRequestVar("dates_list2");
InitRequestVar("zname",'');
InitRequestVar("status",-1);
InitRequestVar("tptype",0);
InitRequestVar("db",0);
$params=array(
	':exp_list_without_ts' => $_REQUEST["exp_list_without_ts"],
	':tn' => $tn,
	':dpt_id' => $_SESSION["dpt_id"],
	":dates_list1"=>"'".$_REQUEST["dates_list1"]."'",
	":dates_list2"=>"'".$_REQUEST["dates_list2"]."'",
	":zname"=>"'".$_REQUEST["zname"]."'",
	':db' => $_REQUEST["db"],
	":status"=>$_REQUEST["status"],
	":tptype"=>$_REQUEST["tptype"],
);
if (isset($_REQUEST["del"]))
{
	Table_Update("scmovezay",array("id"=>$_REQUEST["del"]),null);
}
else if (isset($_REQUEST["save"]))
{
	$_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);
	Table_Update("scmovezay",
		array("id"=>$_REQUEST["id"]),
		array($_REQUEST['field']=>$_REQUEST['val'])
	);
	$creator_mail = $db->getOne("SELECT e_mail FROM user_list WHERE tn = (SELECT tn FROM scmovezay WHERE id = ".$_REQUEST["id"].")");
	$z = $db->getRow("select z.*, to_char(z.created,'dd.mm.yyyy') created from scmovezay z where id=".$_REQUEST["id"], null, null, null, MDB2_FETCHMODE_ASSOC);
	if ($_REQUEST['field']=='status'&&$_REQUEST['val']==2) //rejected
	{
		$subj = 'Отклонена заявка на перенос торговых условий, клиент '.$z["tpnamefrom"].$z["netnamefrom"].', '.$z["created"];
		$text = 'Ваша заявка на перенос торговых условий ОТКЛОНЕНА ВСТМ. Причина отклонения: '.$z["failure"];
		send_mail($creator_mail,$subj,$text);
	}
	if ($_REQUEST['field']=='status'&&$_REQUEST['val']==1) //accepted
	{
		$subj = 'Подтверждена заявка на перенос торговых условий, клиент '.$z["tpnamefrom"].$z["netnamefrom"].', '.$z["created"];
		$text = 'Ваша заявка на перенос торговых условий подтверждена ВСТМ.';
		send_mail($creator_mail,$subj,$text);
		$zold=$db->getOne('SELECT getZayIdFromSCMoveZay ('.$_REQUEST["id"].') FROM DUAL');
		if ($zold>0)
		{
			$znew=get_new_id();
			$db->query("BEGIN createZayCopy (".$zold.",".$znew."); END;");
			$db->query("DECLARE
						v_tpto    INTEGER;
						v_netto   INTEGER;
						BEGIN
						SELECT tpto, netto INTO v_tpto, v_netto FROM scmovezay WHERE id = ".$_REQUEST["id"].";
						setZayFieldVal (".$znew.",'admin_id',14,v_netto);
						setZayFieldVal (".$znew.",'admin_id',4,v_tpto);
						END;");
			$sql="SELECT zff.ff_id, zff.val_file, zff.rep_val_file FROM bud_ru_zay_ff zff, bud_ru_ff ff WHERE zff.z_id = ".$zold." AND zff.ff_id = ff.id AND ff.TYPE = 'file'";
			$x = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
			foreach ($x as $k1=>$v1)
			{
				$a=explode("\n",$v1["val_file"]);
				foreach ($a as $v)
				{
					$pathFrom="files/bud_ru_zay_files/".$zold."/".$v1['ff_id'];
					$pathTo="files/bud_ru_zay_files/".$znew."/".$v1['ff_id'];
					if (!file_exists($pathTo)) {mkdir($pathTo,0777,true);}
					copy($pathFrom."/".$v, $pathTo."/".$v);
				}
				$a=explode("\n",$v1["rep_val_file"]);
				foreach ($a as $v)
				{
					$pathFrom="files/bud_ru_zay_files/".$zold."/".$v1['ff_id']."/report";
					$pathTo="files/bud_ru_zay_files/".$znew."/".$v1['ff_id']."/report";
					if (!file_exists($pathTo)) {mkdir($pathTo,0777,true);}
					copy($pathFrom."/".$v, $pathTo."/".$v);
				}
			}
		}
		$sql="SELECT tpfrom, tpto, tpnamefrom FROM scmovezay WHERE id = ".$_REQUEST["id"]." AND tpfrom IS NOT NULL AND tpto IS NOT NULL";
		$x = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
		if ($x)
		{
			//print_r($x);
			$db->query("DELETE FROM SC_TP WHERE tp_kod = ".$x["tpto"]);
			$db->query("INSERT INTO SC_TP
			                   (BONUS,DELAY,DISCOUNT,DPT_ID,FIXED,FIXED_LU,JUSTIFICATION,JUSTIFICATION_LU,LU,MARGIN,TP_KOD)
                        SELECT BONUS,DELAY,DISCOUNT,DPT_ID,FIXED,FIXED_LU,
						       'Торговые условия были скопированы заменой с ТП ".$x["tpnamefrom"].", ".$now."',
							   JUSTIFICATION_LU,LU,MARGIN,".$x["tpto"]."
                               FROM SC_TP
                               WHERE tp_kod = ".$x["tpfrom"]);
			$db->query("DELETE FROM SC_FILES WHERE tp_kod = ".$x["tpto"]);
			$sql="SELECT z.fn, z.dpt_id, TO_CHAR (z.dt, 'dd.mm.yyyy') dt FROM sc_files z WHERE tp_kod = ".$x["tpfrom"];
			$x1 = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
			foreach ($x1 as $k=>$v)
			{
				$fnnew=get_new_file_id()."_".$v["fn"];
				copy("files/".$v["fn"], "files/".$fnnew);
				$db->query("INSERT INTO SC_FILES (DPT_ID, DT, FN, TP_KOD) VALUES (".$v["dpt_id"].", TO_DATE('".$v["dt"]."','dd.mm.yyyy'), '".$fnnew."', ".$x["tpto"].")");
			}
		}
	}
}
else
{
	if (isset($_REQUEST["select"]))
	{
		$sql=rtrim(file_get_contents('sql/scmovehistory.sql'));
		$sql=stritr($sql,$params);
		$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
		$smarty->assign('d', $data);
	}
	$sql=rtrim(file_get_contents('sql/scmovehistoryt.sql'));
	$sql=stritr($sql,$params);
	$t = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('t', $t);
	$sql = rtrim(file_get_contents('sql/exp_list_from_parent_without_ts.sql'));
	$sql=stritr($sql,$params);
	$exp_list_without_ts = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('exp_list_without_ts', $exp_list_without_ts);
	$sql = rtrim(file_get_contents('sql/bud_db_list.sql'));
	$sql=stritr($sql,$params);
	$x = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('db', $x);
	$sql = rtrim(file_get_contents('sql/accept_types.sql'));
	$x = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('accept_types', $x);
	$smarty->display('scmovehistory.html');
}
?>