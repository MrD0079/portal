<?php


//print_r($_SERVER);

//ses_req();

InitRequestVar("selected_tp",0);
InitRequestVar("exp_list_without_ts",0);
InitRequestVar("exp_list_only_ts",0);
InitRequestVar("eta_list",$_SESSION["h_eta"]);
InitRequestVar("ok_traid",1);
InitRequestVar("ok_chief",1);

$params=array(
	':tn' => $tn,
	':dpt_id' => $_SESSION["dpt_id"],
	':eta_list' => "'".$_REQUEST["eta_list"]."'",
	':ok_traid' => $_REQUEST["ok_traid"],
	':ok_chief' => $_REQUEST["ok_chief"],
	':exp_list_without_ts' => $_REQUEST["exp_list_without_ts"],
	':exp_list_only_ts' => $_REQUEST["exp_list_only_ts"],
	':tp' => "'".$_REQUEST["selected_tp"]."'"
);

$sql = rtrim(file_get_contents('sql/exp_list_from_parent_only_ts.sql'));
$sql=stritr($sql,$params);
$exp_list_only_ts = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('exp_list_only_ts', $exp_list_only_ts);

$sql = rtrim(file_get_contents('sql/exp_list_from_parent_without_ts.sql'));
$sql=stritr($sql,$params);
$exp_list_without_ts = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('exp_list_without_ts', $exp_list_without_ts);

$sql = rtrim(file_get_contents('sql/a13_oy_report_eta_list.sql'));
$sql=stritr($sql,$params);
$eta_list = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('eta_list', $eta_list);

if (isset($_REQUEST["add"]))
{
	if (isset($_REQUEST["keys"]))
	{
		foreach ($_REQUEST["keys"] as $key => $val)
		{
			$keys = array('h_tp_kod_data_nakl'=>$key);
			isset($_REQUEST["data_s"][$key]) ? $vals = $_REQUEST["data_s"][$key] : $vals = null;
			isset($vals["bonus_dt1"]) ? $vals["bonus_dt1"]=OraDate2MDBDate($vals["bonus_dt1"]) : null;
			if ($vals["if1"]!=0)
			{
				Table_Update ("a13_oy_action_nakl", $keys, $vals);
				/*$sql="
                                      SELECT COUNT (*)
                                        FROM a13_oy_action_nakl
                                       WHERE h_tp_kod_data_nakl IN (SELECT h_tp_kod_data_nakl
                                                                      FROM a13_oy
                                                                     WHERE tp_kod = (SELECT tp_kod
                                                                                       FROM a13_oy
                                                                                      WHERE h_tp_kod_data_nakl = '".$key."')
                                                                           AND data = (SELECT data
                                                                                         FROM a13_oy
                                                                                        WHERE h_tp_kod_data_nakl = '".$key."'))
                                         AND h_tp_kod_data_nakl <> '".$key."'
                                      ";
				$c=$db->getOne($sql);
				if ($c==0)
				{
					Table_Update ("a13_oy_action_nakl", $keys, $vals);
				}
				else
				{
					echo "<p>По одному клиенту за один визит в период акции может быть только одна акционная накладная!!!</p>";
				}*/
			}
			else
			{
				Table_Update ("a13_oy_action_nakl", $keys, null);
			}
		}
	}
}

if (isset($_REQUEST["del_file"]))
{
foreach ($_REQUEST["del_file"] as $k=>$v)
{
$fn=$db->getOne("select fn from a13_oy_files where id=".$k);
unlink("a13_oy_files/".$tn."/".$fn);
$fn=$db->query("delete from a13_oy_files where id=".$k);
}
}

if (isset($_FILES["new_fn"]))
{
	if ($_FILES["new_fn"]["name"]!="")
	{
		$_REQUEST["new"]["tn"]=$tn;
		$d1="a13_oy_files";
		if (!file_exists($d1)) {mkdir($d1);}
		$d1="a13_oy_files/".$tn;
		if (!file_exists($d1)) {mkdir($d1);}
		if (is_uploaded_file($_FILES["new_fn"]['tmp_name'])){move_uploaded_file($_FILES["new_fn"]["tmp_name"], $d1."/".translit($_FILES["new_fn"]["name"]));}
		$_REQUEST["new"]["fn"]=translit($_FILES["new_fn"]["name"]);
		if ($_FILES["new_fn"]['error']==0){
			Table_Update("a13_oy_files",$_REQUEST["new"],$_REQUEST["new"]);
		}
	}
}




if (isset($_REQUEST["save"]))
{
	if (isset($_REQUEST["data"]))
	{
		foreach($_REQUEST["data"] as $k=>$v)
		{
			$keys = array('id'=>$k);
//			print_r($keys);
//			print_r($v);
			isset($v["bonus_dt1"]) ? $v["bonus_dt1"]=OraDate2MDBDate($v["bonus_dt1"]) : null;
			Table_Update ('a13_oy_action_nakl', $keys, $v);
			/*$sql="
				SELECT SUM (bonus_sum1)
				  FROM a13_oy_action_nakl
				 WHERE     h_tp_kod_data_nakl IN
				              (SELECT h_tp_kod_data_nakl
				                 FROM a13_oy
				                WHERE tp_kod =
				                         (SELECT tp_kod
				                            FROM a13_oy
				                           WHERE h_tp_kod_data_nakl =
				                                    (SELECT h_tp_kod_data_nakl
				                                       FROM a13_oy_action_nakl
				                                      WHERE id = '".$k."')))
				       AND h_tp_kod_data_nakl <> (SELECT h_tp_kod_data_nakl
				                                    FROM a13_oy_action_nakl
				                                   WHERE id = '".$k."')
                              ";
			$c=$db->getOne($sql);
			//echo $sql;
			//echo $c." ".$v["bonus_sum1"]."<br>";
			if (($c+$v["bonus_sum1"])<=345)
			{
				Table_Update ("a13_oy_action_nakl", $keys, $v);
			}
			else
			{
				$sql="
				SELECT nakl
				  FROM a13_oy
				 WHERE h_tp_kod_data_nakl = (SELECT h_tp_kod_data_nakl
				                               FROM a13_oy_action_nakl
				                              WHERE id = '".$k."')
				";
				$c=$db->getOne($sql);
				echo "<p style='color:red'>По одному клиенту за период акции суммарный бонус может быть не более 345 грн! Бонус по накладной ".$c." не сохранен!</p>";
			}*/
		}
	}
	if (isset($_REQUEST["data_files"]))
	{
		foreach($_REQUEST["data_files"] as $k=>$v)
		{
			$keys = array('id'=>$k);
			Table_Update ('a13_oy_files', $keys, $v);
		}
	}
	if (isset($_REQUEST["del"]))
	{
		foreach ($_REQUEST["del"] as $key => $val)
		{
			$keys = array('id'=>$key);
			Table_Update ('a13_oy_action_nakl', $keys, null);
		}
	}
}

$sql=rtrim(file_get_contents('sql/a13_oy_report_tp.sql'));
$sql=stritr($sql,$params);
$tp = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
//print_r($tp);
$smarty->assign('tp', $tp);

if ($_REQUEST["selected_tp"]!=0)
{
//$params=array(':dpt_id' => $_SESSION["dpt_id"],':tn'=>$tn,':tp'=>"'".$_REQUEST["selected_tp"]."'",':eta_list' => "'".$_REQUEST["eta_list"]."'");
$sql = rtrim(file_get_contents('sql/a13_oy_report_nakl.sql'));
$sql=stritr($sql,$params);
//echo $sql;
$nakl_list = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('nakl_list', $nakl_list);
}

if (isset($_REQUEST["generate"]))
{

$sql=rtrim(file_get_contents("sql/a13_oy_report.sql"));
$sql=stritr($sql,$params);
$list = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign("list", $list);

$sql=rtrim(file_get_contents("sql/a13_oy_report_itogi.sql"));
$sql=stritr($sql,$params);
$list = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign("itogi", $list);

//echo $sql;



$sql=rtrim(file_get_contents("sql/a13_oy_report_itogi_files.sql"));
$sql=stritr($sql,$params);
$list = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign("itogi_files", $list);

$d1=array();

$sql=rtrim(file_get_contents('sql/a13_oy_files.sql'));
$sql=stritr($sql,$params);
$d = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

if (isset($d))
{
foreach ($d as $k=>$v)
{
$d1[$v["tn"]]["data"][$v["id"]]=$v;
}
}

$sql=rtrim(file_get_contents('sql/a13_oy_files_total.sql'));
$sql=stritr($sql,$params);
$d = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);


//echo $sql;

if (isset($d))
{
foreach ($d as $k=>$v)
{
$d1[$v["tn"]]["data_total"]=$v;
}
}

if (isset($d1))
{
$smarty->assign('file_list', $d1);
}

$sql=rtrim(file_get_contents('sql/a13_oy_files_total_total.sql'));
$sql=stritr($sql,$params);
$d = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('file_list_total', $d);



}

$smarty->display('a13_oy_report.html');

?>