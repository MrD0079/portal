<?
$_REQUEST["tu"]==1?$doc_str="торговые условия":$doc_str="заявка на проведение активности";
$dyn_flt='';
if (isset($_REQUEST["dyn_flt"]))
{
	$a1=array();
	foreach ($_REQUEST["dyn_flt"] as $k=>$v)
	{
		($v["subtype"]!=null)&&($v["item"]!=null)?$a1[]=$v["item"]:null;
	}
	(count($a1)>0)?$dyn_flt='AND z.id IN (SELECT z_id FROM bud_ru_zay_ff WHERE val_list IN ('.join($a1,',').') HAVING COUNT (*) = '.count($a1).' GROUP BY z_id)':$dyn_flt='';
}

InitRequestVar("exp_list_without_ts",0);
InitRequestVar("dates_list1",$_SESSION["month_list"]);
InitRequestVar("dates_list2",$now);
InitRequestVar("who",0);
InitRequestVar("status",0);
InitRequestVar("srok_ok",0);
InitRequestVar("report_done_flt",0);
InitRequestVar("report_zero_cost_flt",0);
InitRequestVar("st",0);
InitRequestVar("kat",0);
InitRequestVar("creator",0);
InitRequestVar("country",$_SESSION["cnt_kod"]);
InitRequestVar("bud_ru_zay_pos_id",0);
InitRequestVar("fil",0);
InitRequestVar("funds",0);
InitRequestVar("id_net",0);
InitRequestVar("region_name","0");
InitRequestVar("department_name","0");
InitRequestVar("z_id",0);
InitRequestVar("wait4myaccept",1);
InitRequestVar("date_between_brzr","dt12");

$params=array(':tn'=>$tn,':dpt_id' => $_SESSION["dpt_id"]);

$sql = rtrim(file_get_contents('sql/month_list.sql'));
$sql=stritr($sql,$params);
$dt = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('dt', $dt);

$sql = rtrim(file_get_contents('sql/exp_list_from_parent_without_ts.sql'));
$sql=stritr($sql,$params);
$exp_list_without_ts = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('exp_list_without_ts', $exp_list_without_ts);

$sql=rtrim(file_get_contents('sql/bud_ru_st_ras.sql'));
$sql=stritr($sql,$params);
$st = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('st', $st);

$sql = rtrim(file_get_contents('sql/bud_ru_zay_report_creators_list.sql'));
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('creators_list', $data);

$sql = rtrim(file_get_contents('sql/bud_ru_zay_report_pos_list.sql'));
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('pos_list', $data);

$sql = rtrim(file_get_contents('sql/bud_ru_zay_report_region_list.sql'));
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('region_list', $data);

$sql = rtrim(file_get_contents('sql/bud_ru_zay_report_fil_list.sql'));
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('fil_list', $data);

$sql = rtrim(file_get_contents('sql/bud_ru_zay_report_funds_list.sql'));
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('funds_list', $data);

$sql=rtrim(file_get_contents('sql/nets.sql'));
$sql=stritr($sql,$params);
$nets = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('nets', $nets);

$sql = rtrim(file_get_contents('sql/bud_ru_zay_report_department_list.sql'));
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('department_list', $data);

if (isset($_REQUEST["reset"])&&isset($_REQUEST["reset_z_id"]))
{
	
	$_REQUEST["select"]=1;
	$keys = array("id"=>$_REQUEST["reset_z_id"]);
	$vals = array("report_done"=>null,"report_zero_cost"=>null,"report_fakt_equal_plan"=>null);
	Table_Update("bud_ru_zay",$keys,$vals);
	$keys = array("z_id"=>$_REQUEST["reset_z_id"]);
	$vals = array("rep_accepted"=>0);
	Table_Update("bud_ru_zay_accept",$keys,$vals);
	$keys = array("bud_z_id"=>$_REQUEST["reset_z_id"],"plan_type"=>4);
	Table_Update("nets_plan_month",$keys,null);
	$keys = array("bud_z_id"=>$_REQUEST["reset_z_id"]);
	Table_Update("invoice",$keys,null);
}

if (
        isset($_REQUEST["save_cost_assign_month"])
        &&isset($_REQUEST["reset_z_id"])
        &&isset($_REQUEST["cost_assign_month"])
        )
{
	
	$_REQUEST["select"]=1;
        if ($_REQUEST["cost_assign_month"]!=""){
            $keys = array("id"=>$_REQUEST["reset_z_id"]);
            $vals = array("cost_assign_month"=>OraDate2MDBDate($_REQUEST["cost_assign_month"]));
            Table_Update("bud_ru_zay",$keys,$vals);
        }
}

if (isset($_REQUEST["save"]))
{
	
	$_REQUEST["select"]=1;
	if (isset($_REQUEST["report_done"]))
	{
		foreach ($_REQUEST["report_done"] as $k=>$v)
		{
			$keys = array("id"=>$k);
			$vals = array("report_done"=>$v);
			Table_Update("bud_ru_zay",$keys,$vals);
		}
	}
	if (isset($_REQUEST["report_zero_cost"]))
	{
		
		foreach ($_REQUEST["report_zero_cost"] as $k=>$v)
		{
			$keys = array("id"=>$k);
			$vals = array("report_zero_cost"=>$v);
			Table_Update("bud_ru_zay",$keys,$vals);
			if ($v==1)
			{
				$keys = array("id"=>$k);
				$vals = array("report_done"=>1);
				Table_Update("bud_ru_zay",$keys,$vals);
				$keys = array("z_id"=>$k);
				$vals = array("rep_accepted"=>1);
				Table_Update("bud_ru_zay_accept",$keys,$vals);
				$keys = array("z_id"=>$k,"tn"=>$tn);
				$vals = array("text"=>"Данный отчет по активности был подтвержден автоматически, так как отображает нулевые затраты");
				Table_Update("bud_ru_zay_rep_chat",$keys,$vals);
                                
                                // Связь с бюджетами КК
                                // продублировано в bud_ru_zay_report_accept.php
                                // После завершения согласования отчета по заявке добавляется запись в факт оказанных услуг соответствующей сети. 
                                $db->query("BEGIN BUD_ZAY_REP2FINPLAN (".$k."); END;");
                                // поле "месяц отнесения затрат" заполняется когда отчет по активности согласован всеми "согласователями" отчета. 
                                $db->query("BEGIN set_cost_assign_month (".$k."); END;");

			}
		}
	}
	if (isset($_REQUEST["report_fakt_equal_plan"]))
	{
		foreach ($_REQUEST["report_fakt_equal_plan"] as $k=>$v)
		{
			$keys = array("id"=>$k);
			$vals = array("report_fakt_equal_plan"=>$v);
			Table_Update("bud_ru_zay",$keys,$vals);
			if ($v==1)
			{
				//$keys = array("id"=>$k);
				//$vals = array("report_done"=>1);
				Table_Update("bud_ru_zay",$keys,$vals);
				$keys = array("z_id"=>$k);
				$vals = array("rep_accepted"=>1);
				Table_Update("bud_ru_zay_accept",$keys,$vals);
				$keys = array("z_id"=>$k,"tn"=>$tn);
				$vals = array("text"=>"Результаты переговоров были подтверждены автоматически, так как полностью соответствуют целям на переговоры");
				Table_Update("bud_ru_zay_rep_chat",$keys,$vals);
				$sql=rtrim(file_get_contents('sql/bud_ru_zay_report_copy_plan2fakt.sql'));
				$params=array(':z_id' => $k);
				$sql=stritr($sql,$params);
				$data = $db->query($sql);
				$sql=rtrim(file_get_contents('sql/bud_ru_zay_report_copy_plan2fakt_files.sql'));
				$p=array(':z_id' => $k);
				$sql=stritr($sql,$p);
				$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
				foreach ($data as $k1=>$v1)
				{
					$a=explode("\n",$v1["val_file"]);
					foreach ($a as $v)
					{
						$pathFrom="files/bud_ru_zay_files/".$k."/".$v1['ff_id'];
						$pathTo="files/bud_ru_zay_files/".$k."/".$v1['ff_id']."/report";
						if (!file_exists($pathTo)) {mkdir($pathTo,0777,true);}
						copy($pathFrom."/".$v, $pathTo."/".$v);
					}
				}
			}
		}
	}
	if (isset($_REQUEST["new_st"]))
	{
		foreach ($_REQUEST["new_st"] as $k=>$v)
		{
			$var_type = $db->getOne("SELECT TYPE FROM bud_ru_ff WHERE id = (SELECT ff_id FROM bud_ru_zay_ff WHERE id = ".$k.")");
			$var_type=="datepicker"&&isset($v) ? $v=OraDate2MDBDate($_REQUEST["new_st"][$k]) : null;
			$var_type=="file"&&isset($v) ? $v=implode($v,"\n") : null;
			$keys = array("id"=>$k);
			$vals = array("rep_val_".$var_type=>$v);
			Table_Update("bud_ru_zay_ff",$keys,$vals);
		}
	}

	if (isset($_REQUEST["bud_ru_zay_files_del"]))
	{
		foreach ($_REQUEST["bud_ru_zay_files_del"] as $k=>$v)
		{
			$id=$db->getOne("select z_id from bud_ru_zay_ff where id=".$k);
			$old_val=$db->getOne("select rep_val_file from bud_ru_zay_ff where id=".$k);
			$ov=explode("\n",$old_val);
			$keys = array("id"=>$k);
			$del_array=array();
			foreach ($v as $k1=>$v1)
			{
				unlink($v1);
				$del_array[]=$k1;
			}
			$vals = array("rep_val_file"=>implode(array_diff($ov,$del_array),"\n"));
			Table_Update("bud_ru_zay_ff",$keys,$vals);
		}
	}

	if (isset($_FILES["new_st"]))
	{
		foreach ($_FILES["new_st"]["tmp_name"] as $k=>$v)
		{
			$id=$db->getOne("select z_id from bud_ru_zay_ff where id=".$k);
			$ff_id=$db->getOne("select ff_id from bud_ru_zay_ff where id=".$k);
			$old_val=$db->getOne("select rep_val_file from bud_ru_zay_ff where id=".$k);
			isset($old_val)?$old_val="\n".$old_val:null;
			$s=array();
			foreach ($v as $k1=>$v1)
			{
			if (is_uploaded_file($v1))
			{
				$a=pathinfo($_FILES["new_st"]["name"][$k][$k1]);
				$fn=translit($_FILES["new_st"]["name"][$k][$k1]);
				$path="files/bud_ru_zay_files/".$id."/".$ff_id."/report";
				if (!file_exists($path)) {mkdir($path,0777,true);}
				move_uploaded_file($v1, $path."/".$fn);
				$s[]=$fn;
				$ss=implode($s,"\n");
				$keys = array("id"=>$k);
				$vals = array("rep_val_file"=>$ss.$old_val);
				Table_Update("bud_ru_zay_ff",$keys,$vals);
			}
			}
		}
	}


	if (isset($_REQUEST["sup_doc_del"]))
	{
		foreach ($_REQUEST["sup_doc_del"] as $k=>$v)
		{
			$old_val=$db->getOne("select sup_doc from bud_ru_zay where id=".$k);
			$ov=explode("\n",$old_val);
			$keys = array("id"=>$k);
			$del_array=array();
			foreach ($v as $k1=>$v1)
			{
				unlink($v1);
				$del_array[]=$k1;
			}
			$vals = array("sup_doc"=>implode(array_diff($ov,$del_array),"\n"));
			Table_Update("bud_ru_zay",$keys,$vals);
		}
	}

	if (isset($_FILES["sup_doc"]))
	{
		foreach ($_FILES["sup_doc"]["tmp_name"] as $k=>$v)
		{
			$old_val=$db->getOne("select sup_doc from bud_ru_zay where id=".$k);
			isset($old_val)?$old_val="\n".$old_val:null;
			$s=array();
			foreach ($v as $k1=>$v1)
			{
			if (is_uploaded_file($v1))
			{
				$a=pathinfo($_FILES["sup_doc"]["name"][$k][$k1]);
				$fn=translit($_FILES["sup_doc"]["name"][$k][$k1]);
				$path="files/bud_ru_zay_files/".$k."/sup_doc";
				if (!file_exists($path)) {mkdir($path,0777,true);}
				move_uploaded_file($v1, $path."/".$fn);
				$s[]=$fn;
				$ss=implode($s,"\n");
				$keys = array("id"=>$k);
				$vals = array("sup_doc"=>$ss.$old_val);
				Table_Update("bud_ru_zay",$keys,$vals);
			}
			}
		}
	}
}


if (isset($_REQUEST["add_chat"]))
{
	
	$_REQUEST["select"]=1;
	if (isset($_REQUEST["bud_ru_zay_accept_chat"]))
	{
		foreach ($_REQUEST["bud_ru_zay_accept_chat"] as $k=>$v)
		{
			if ($v!="")
			{
				Table_Update("bud_ru_zay_rep_chat",array("tn"=>$tn,"z_id"=>$k,"text"=>$v),array("tn"=>$tn,"z_id"=>$k,"text"=>$v));
				$sql=rtrim(file_get_contents('sql/bud_ru_zay_accept_chat.sql'));
				$params=array(':z_id' => $k,':tn' => $tn);
				$sql=stritr($sql,$params);
				$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
				foreach ($data as $k1=>$v1)
				{
					$subj=$doc_str." №".$v1["z_id"]." от ".$v1["created"].". Уточнение";
					$text="Здравствуйте ".$v1["fio"]."<br>";
					$text.=$doc_str." №".$v1["z_id"]." от ".$v1["created"]."<br>";
					$text.=$fio." оставил(а) комментарий/уточнение: ".$v."<br>";
					$text.="Просьба ответить на комментарий/уточнение <a href=\"https://ps.avk.ua/?action=bud_ru_zay_report&tu=".$_REQUEST["tu"]."\">Здесь</a>";
					$email=$v1["email"];
					send_mail($email,$subj,$text);
				}
			}
		}
	}
}


$params=array(
':exp_list_without_ts' => $_REQUEST["exp_list_without_ts"],
':tn' => $tn,
':dpt_id' => $_SESSION["dpt_id"],
":dates_list1"=>"'".$_REQUEST["dates_list1"]."'",
":dates_list2"=>"'".$_REQUEST["dates_list2"]."'",
":status"=>$_REQUEST["status"],
":srok_ok"=>$_REQUEST["srok_ok"],
":report_done_flt"=>$_REQUEST["report_done_flt"],
":report_zero_cost"=>$_REQUEST["report_zero_cost_flt"],
":st"=>$_REQUEST["st"],
":kat"=>$_REQUEST["kat"],
":creator"=>$_REQUEST["creator"],
":who"=>$_REQUEST["who"],
":fil"=>$_REQUEST["fil"],
":funds"=>$_REQUEST["funds"],
":id_net"=>$_REQUEST["id_net"],
":country"=>"'".$_REQUEST["country"]."'",
":bud_ru_zay_pos_id"=>$_REQUEST["bud_ru_zay_pos_id"],
":region_name"=>"'".$_REQUEST["region_name"]."'",
":department_name"=>"'".$_REQUEST["department_name"]."'",
':wait4myaccept'=>$_REQUEST['wait4myaccept'],
"/*dyn_flt*/"=>$dyn_flt,
":z_id"=>$_REQUEST["z_id"],
':date_between_brzr' => "'".$_REQUEST["date_between_brzr"]."'",
':tu'=>$_REQUEST['tu']
);

//print_r($params);

if ($_REQUEST["z_id"]!=0)
{
	$params[":z_id"]=$_REQUEST["z_id"];
	$sql=rtrim(file_get_contents('sql/bud_ru_zay_report_find_z.sql'));
	$sql=stritr($sql,$params);
	$data = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	if (isset($data))
	{
		$smarty->assign('find_bud_ru_zay', $data);
		$params[":dates_list1"]="'01.01.2000'";
		$params[":dates_list2"]="'31.12.2050'";
		$params[":who"]=0;
		$params[":status"]=0;
		$params[":srok_ok"]=0;
		$params[":report_done_flt"]=0;
		$params[":report_zero_cost"]=0;
		$params[":st"]=0;
		$params[":kat"]=0;
		$params[":creator"]=0;
		$params[":country"]="0"/*"'".$_SESSION["cnt_kod"]."'"*/;
		$params[":bud_ru_zay_pos_id"]=0;
		$params[":fil"]=0;
		$params[":funds"]=0;
		$params[":id_net"]=0;
		$params[":region_name"]="0";
		$params[":department_name"]="0";
		$params[":wait4myaccept"]=1;
		$params[":tu"]=$_REQUEST["tu"];
	}
}

if (isset($_REQUEST["select"])&&(!isset($_REQUEST["showonlysvod"])))
{

$sql=rtrim(file_get_contents('sql/bud_ru_zay_report.sql'));
$sql=stritr($sql,$params);
//echo $sql;
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

foreach ($data as $k=>$v)
{
$d[$v["id"]]["head"]=$v;
$d[$v["id"]]["executors"][$v["executor_tn"]]=$v;
$d[$v["id"]]["data"][$v["acceptor_tn"]]=$v;
if ($v["chat_id"]!="")
{
$d[$v["id"]]["chat"][$v["chat_id"]]=$v;
}
if ($v["zchat_id"]!="")
{
$d[$v["id"]]["zchat"][$v["zchat_id"]]=$v;
}
}

if (isset($d))
{

foreach ($d as $k=>$v)
{
	$sql=rtrim(file_get_contents('sql/bud_ru_zay_get_ff.sql'));
	$p=array(':z_id' => $k);
	$sql=stritr($sql,$p);
	$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	foreach ($data as $k1=>$v1)
	{
		if ($v1["type"]=="file")
		{
			$v1["val_file"]!=null?$data[$k1]["val_file"]=explode("\n",$v1["val_file"]):null;
			$v1["rep_val_file"]!=null?$data[$k1]["rep_val_file"]=explode("\n",$v1["rep_val_file"]):null;
		}
		/*if ($v1['type']=='list')
		{
			if ($v1['val_list'])
			{
			$sql=$db->getOne('SELECT get_item FROM bud_ru_ff_subtypes WHERE id = (SELECT subtype FROM bud_ru_ff WHERE id = '.$v1['ff_id'].')');
			$params[':id'] = $v1['val_list'];
			$sql=stritr($sql,$params);
			$list = $db->getOne($sql);
			$data[$k1]['val_list_name'] = $list;
			}

			if ($v1['rep_val_list'])
			{
			$sql=$db->getOne('SELECT get_item FROM bud_ru_ff_subtypes WHERE id = (SELECT subtype FROM bud_ru_ff WHERE id = '.$v1['ff_id'].')');
			$params[':id'] = $v1['rep_val_list'];
			$sql=stritr($sql,$params);
			$list = $db->getOne($sql);
			$data[$k1]['rep_val_list_name'] = $list;
			}

		}*/
		if (($v1['type']=='list')&&($v1['autocomplete']!=1))
		{
			$sql=$db->getOne('select get_list from bud_ru_ff_subtypes where id = (SELECT subtype FROM bud_ru_ff WHERE id = '.$v1['ff_id'].')');
			$sql=stritr($sql,$params);
			$list = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
			$data[$k1]['list'] = $list;
		}

	}
	include "bud_ru_zay_formula.php";
	$d[$k]["ff"]=$data;
	$v["head"]["sup_doc"]!=null?$d[$k]["head"]["sup_doc"]=explode("\n",$v["head"]["sup_doc"]):null;
}
}

//print_r($d);

//$_REQUEST["d"]=$d;


//print_r($params);


isset($d) ? $smarty->assign('d', $d) : null;

$sql=rtrim(file_get_contents('sql/bud_ru_zay_report_total.sql'));
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('d1', $data);

}

if (isset($_REQUEST["select"])&&$_REQUEST["z_id"]==0)
{

//$params[":status"]=1;

$sql=rtrim(file_get_contents('sql/bud_ru_zay_report_ff.sql'));
$sql=stritr($sql,$params);
$bud_ru_ff = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('bud_ru_ff', $bud_ru_ff);

//echo $sql;


$sql=rtrim(file_get_contents('sql/bud_ru_zay_report_ff_st_ras.sql'));
$sql=stritr($sql,$params);
$bud_ru_ff_st_ras = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('bud_ru_ff_st_ras', $bud_ru_ff_st_ras);

//echo $sql;



$sql=rtrim(file_get_contents('sql/bud_ru_zay_report_ff_st.sql'));
$sql=stritr($sql,$params);
$bud_ru_ff_st = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('bud_ru_ff_st', $bud_ru_ff_st);

//echo $sql;




}




$smarty->display('bud_ru_zay_report.html');

?>