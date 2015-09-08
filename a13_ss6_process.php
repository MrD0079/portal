<?php
//audit("вошел в список сетей");
//ses_req();


InitRequestVar("selected_tp",0);
InitRequestVar("eta_list","");
//!isset($_REQUEST["selected_tp"]) ? $_REQUEST["selected_tp"]=0: null;

$table_name = "a13_ss6_action_nakl";


if (isset($_REQUEST["add"]))
{
	if (isset($_REQUEST["keys"]))
	{
		foreach ($_REQUEST["keys"] as $key => $val)
		{
			$keys = array('h_tp_kod_data_nakl'=>$key);
			isset($_REQUEST["data"][$key]) ? $vals = $_REQUEST["data"][$key] : $vals = null;
			/*isset($vals["bonus_dt1"]) ? $vals["bonus_dt1"]=OraDate2MDBDate($vals["bonus_dt1"]) : null;
			isset($vals["bonus_dt2"]) ? $vals["bonus_dt2"]=OraDate2MDBDate($vals["bonus_dt2"]) : null;
			Table_Update ($table_name, $keys, $vals);*/
			isset($vals['if1']) ? $if1=$vals['if1'] : $if1 = null;
			isset($vals['if2']) ? $if2=$vals['if2'] : $if2 = null;
			if (($if1==1)||($if2==1))
			{

				$sql="
SELECT COUNT (*)
  FROM a13_ss6_action_nakl
 WHERE h_tp_kod_data_nakl IN (SELECT h_tp_kod_data_nakl
                                FROM a13_ss6
                               WHERE tp_kod = (SELECT tp_kod
                                                 FROM a13_ss6
                                                WHERE h_tp_kod_data_nakl = '".$key."')
                                     AND data = (SELECT data
                                                   FROM a13_ss6
                                                  WHERE h_tp_kod_data_nakl = '".$key."'))
";
				//echo $sql;
				$c=$db->getOne($sql);
				//echo $c;
				if ($c<2)
				{
					Table_Update ($table_name, $keys, $vals);
				}
				else
				{
					echo "<p>ѕо одному клиенту за один визит в период акции может быть не более двух акционных накладных!!!</p>";
				}
			}
			else
			{
				Table_Update ($table_name, $keys, null);
			}
		}
	}
}

if (isset($_REQUEST["del"]))
{
	foreach ($_REQUEST["del"] as $key => $val)
	{
		$keys = array('h_tp_kod_data_nakl'=>$key);
		Table_Update ($table_name, $keys, null);
	}
}



if (isset($_REQUEST["del_file"]))
{
foreach ($_REQUEST["del_file"] as $k=>$v)
{
$fn=$db->getOne("select fn from a13_ss6_files where id=".$k);
unlink("a13_ss6_files/".$tn."/".$fn);
$fn=$db->query("delete from a13_ss6_files where id=".$k);
}
}

if (isset($_FILES["new_fn"]))
{
	if ($_FILES["new_fn"]["name"]!="")
	{
		//ses_req();
		$_REQUEST["new"]["tn"]=$tn;
		$d1="a13_ss6_files/".$tn;
		if (!file_exists($d1)) {mkdir($d1);}
		//$d1=$d1."/1";
		if (!file_exists($d1)) {mkdir($d1);}
		if (is_uploaded_file($_FILES["new_fn"]['tmp_name'])){move_uploaded_file($_FILES["new_fn"]["tmp_name"], $d1."/".translit($_FILES["new_fn"]["name"]));}
		$_REQUEST["new"]["fn"]=translit($_FILES["new_fn"]["name"]);
		if ($_FILES["new_fn"]['error']==0){
			Table_Update("a13_ss6_files",$_REQUEST["new"],$_REQUEST["new"]);
		}
	}
}

$params=array(':dpt_id' => $_SESSION["dpt_id"],':tn'=>$tn,':tp_kat'=>1,':exp_list_without_ts' => 0,':exp_list_only_ts' => 0);
$sql=rtrim(file_get_contents('sql/a13_ss6_files.sql'));
$sql=stritr($sql,$params);
$d = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
//echo $sql;
$smarty->assign('file_list', $d);






$params=array(':dpt_id' => $_SESSION["dpt_id"],':tn'=>$tn);

$sql = rtrim(file_get_contents('sql/a13_ss6_process_eta_list.sql'));
$sql=stritr($sql,$params);
$eta_list = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('eta_list', $eta_list);

if ($_REQUEST["selected_tp"]!=0)
{
$params=array(':dpt_id' => $_SESSION["dpt_id"],':tn'=>$tn,':tp'=>"'".$_REQUEST["selected_tp"]."'",':eta_list' => "'".$_REQUEST["eta_list"]."'");
$sql = rtrim(file_get_contents('sql/a13_ss6_process_nakl.sql'));
$sql=stritr($sql,$params);
$nakl_list = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('nakl_list', $nakl_list);
}

$params=array(':dpt_id' => $_SESSION["dpt_id"],':tn'=>$tn,':tp'=>0,':eta_list' => "'".$_REQUEST["eta_list"]."'");

$sql=rtrim(file_get_contents('sql/a13_ss6_process_tp.sql'));
$sql=stritr($sql,$params);
$tp = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('tp', $tp);

$sql = rtrim(file_get_contents('sql/a13_ss6_process_nakl.sql'));
$sql=stritr($sql,$params);
$nakl_list_all = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('nakl_list_all', $nakl_list_all);

$sql=rtrim(file_get_contents('sql/a13_ss6_process_nakl_total.sql'));
$sql=stritr($sql,$params);
$nakl_list_all_total = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('nakl_list_all_total', $nakl_list_all_total);

$smarty->display('a13_ss6_process.html');
?>