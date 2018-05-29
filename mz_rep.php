<?php

InitRequestVar("mz_list",0);
InitRequestVar("arc",0);

$mz = $_REQUEST["mz_list"];

$sql = rtrim(file_get_contents('sql/month_list.sql'));
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('month_list', $res);

$sql = rtrim(file_get_contents('sql/mz_rep_mz_list.sql'));
$p=array(":tn"=>$tn,":arc"=>$_REQUEST["arc"]);
$sql=stritr($sql,$p);
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('mz_list', $res);


$sql=rtrim(file_get_contents('sql/mz_spr_inv.sql'));
$mz_spr_inv = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('mz_spr_inv', $mz_spr_inv);

$sql=rtrim(file_get_contents('sql/mz_spr_pri.sql'));
$mz_spr_pri = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('mz_spr_pri', $mz_spr_pri);

$sql=rtrim(file_get_contents('sql/mz_spr_ras.sql'));
$mz_spr_ras = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('mz_spr_ras', $mz_spr_ras);

$sql=rtrim(file_get_contents('sql/mz_spr_vis.sql'));
$mz_spr_vis = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('mz_spr_vis', $mz_spr_vis);


if (isset($_REQUEST["save"])&&$_REQUEST["mz_list"]>0)
{
	audit("сохранил отчет о работе музея ".$mz." за ".$_REQUEST["month_list"],"zat");
	$a=array('pri','ras','vis','pds','rss','inv');
	foreach($a as $av)
	{
		if (isset($_REQUEST[$av]))
		{
		foreach ($_REQUEST[$av] as $key=>$val)
		{
			$av=="pds" ? $keys = array("id"=>$key) : $keys = array("mz_id"=>$mz,"dt"=>OraDate2MDBDate($key));
			$vals = array();
			isset($val["pds_dt"]) ? $vals["pds_dt"] = OraDate2MDBDate($val["pds_dt"]) : null;
			isset($val["pds_sum"]) ? $vals["pds_sum"] = $val["pds_sum"] : null;
			isset($val["text"]) ? $vals["text"] = $val["text"] : null;
			isset($val["mz_admin_ok"]) ? $vals["mz_admin_ok"] = $val["mz_admin_ok"] : null;
			isset($val["mz_admin_ok_tn"]) ? $vals["mz_admin_ok_tn"] = $val["mz_admin_ok_tn"] : null;
			//print_r($vals);

			$av=="pds" ? $tbl = "mz_rep_m_pds" : $tbl = "mz_rep_d_".$av;

			Table_Update ($tbl, $keys, $vals);
			if (isset($val["spr"]))
			{
			foreach($val["spr"] as $k=>$v)
			{
				$keys["spr_id"]=$k;
				Table_Update ("mz_rep_d_spr_".$av, $keys, $v);
			}
			}
		}
		}
	}
	foreach ($_FILES as $k=>$v)
	{
		foreach ($v["name"] as $k1=>$v1)
		{
			if (is_uploaded_file($v['tmp_name'][$k1]))
			{
				//echo $mz." ".$k." ".$k1." ".$v1."<br>";
				$dir = "files/mz_rep_files/".$k."/".$k1."/".$mz."/";
				if (!file_exists($dir)) {mkdir($dir,0777,true);}
				$a=pathinfo($v1);
				$fn="mz".get_new_file_id().".".$a["extension"];
				move_uploaded_file($v['tmp_name'][$k1], $dir."/".$fn);

				include('SimpleImage.php');
				$image = new SimpleImage();
				$image->load($dir."/".$fn);

				if (is_resource($image))
				{
					$h=$image->getHeight();
					if ($image->getHeight()>600)
					{
						$image->resizeToHeight(600);
					}
					$image->save($dir."/".$fn);
				}

				$keys = array(
					"mz_id"=>$mz,
					"dt"=>OraDate2MDBDate($k1),
					"fn"=>$fn
				);
				Table_Update ("mz_rep_f_".$k, $keys, $keys);
			}
		}
	}
	if (isset($_REQUEST["rep_m"]))
	{
		$keys = array("mz_id"=>$mz,"dt"=>OraDate2MDBDate($_REQUEST["month_list"]));
		Table_Update("mz_rep_m",$keys,$_REQUEST["rep_m"]);
	}
}



if (isset($_REQUEST["add_pds"])&&$_REQUEST["mz_list"]>0)
{
	$keys = array(
		"mz_id"=>$mz,
		"dt"=>OraDate2MDBDate($_REQUEST["month_list"]),
		"pds_dt"=>OraDate2MDBDate($_REQUEST["new_pds"]["pds_dt"]),
		"pds_sum"=>$_REQUEST["new_pds"]["pds_sum"]
	);
	Table_Update ("mz_rep_m_pds", $keys, $keys);
}


if (isset($_REQUEST["del_file_ras"]))
{
	unlink($_REQUEST["del_file_ras"]);
	$a=pathinfo($_REQUEST["del_file_ras"]);
	$keys=array("fn"=>$a["basename"]);
	Table_Update ("mz_rep_f_ras", $keys, null);
}

if (isset($_REQUEST["del_file_rss"]))
{
	unlink($_REQUEST["del_file_rss"]);
	$a=pathinfo($_REQUEST["del_file_rss"]);
	$keys=array("fn"=>$a["basename"]);
	Table_Update ("mz_rep_f_rss", $keys, null);
}

if (isset($_REQUEST["del_rec"]))
{
	$keys=array("id"=>$_REQUEST["del_rec"]);
	Table_Update ("mz_rep_m_pds", $keys, null);
}


if ((isset($_REQUEST["save"])||isset($_REQUEST["select"])||isset($_REQUEST["add_pds"]))&&$_REQUEST["mz_list"]>0)
{
	$d=array();
	$sql = rtrim(file_get_contents('sql/mz_rep_inv.sql'));
	$p=array(':month_list'=>"'".$_REQUEST["month_list"]."'",":mz_id"=>$_REQUEST["mz_list"]);
	$sql=stritr($sql,$p);
	$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	foreach($res as $k=>$v)
	{
		$d["head"]=$v;
		$d["data"][$v["data"]]["head"]=$v;
		$d["data"][$v["data"]]["spr"][$v["id"]]=$v;
	}
	$sql = rtrim(file_get_contents('sql/mz_rep_inv_total.sql'));
	$p=array(':month_list'=>"'".$_REQUEST["month_list"]."'",":mz_id"=>$_REQUEST["mz_list"]);
	$sql=stritr($sql,$p);
	$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$d["total"]=$res;
	isset($d)?$smarty->assign('mz_rep_inv', $d):null;

	$d=array();
	$sql = rtrim(file_get_contents('sql/mz_rep_pri.sql'));
	$p=array(':month_list'=>"'".$_REQUEST["month_list"]."'",":mz_id"=>$_REQUEST["mz_list"]);
	$sql=stritr($sql,$p);
	$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	foreach($res as $k=>$v)
	{
		$d["head"]=$v;
		$d["data"][$v["data"]]["head"]=$v;
		$d["data"][$v["data"]]["spr"][$v["id"]]=$v;
	}
	$sql = rtrim(file_get_contents('sql/mz_rep_pri_total.sql'));
	$p=array(':month_list'=>"'".$_REQUEST["month_list"]."'",":mz_id"=>$_REQUEST["mz_list"]);
	$sql=stritr($sql,$p);
	$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$d["total"]=$res;
	isset($d)?$smarty->assign('mz_rep_pri', $d):null;


	$d=array();
	$sql = rtrim(file_get_contents('sql/mz_rep_ras.sql'));
	$p=array(':month_list'=>"'".$_REQUEST["month_list"]."'",":mz_id"=>$_REQUEST["mz_list"]);
	$sql=stritr($sql,$p);
	$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	foreach($res as $k=>$v)
	{
		$d["head"]=$v;
		$d["data"][$v["data"]]["head"]=$v;
		$d["data"][$v["data"]]["spr"][$v["id"]]=$v;
		$d["data"][$v["data"]]["files"][$v["fn"]]=$v["fn"];
	}
	$sql = rtrim(file_get_contents('sql/mz_rep_ras_total.sql'));
	$p=array(':month_list'=>"'".$_REQUEST["month_list"]."'",":mz_id"=>$_REQUEST["mz_list"]);
	$sql=stritr($sql,$p);
	$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$d["total"]=$res;
	isset($d)?$smarty->assign('mz_rep_ras', $d):null;


	$d=array();
	$sql = rtrim(file_get_contents('sql/mz_rep_rss.sql'));
	$p=array(':month_list'=>"'".$_REQUEST["month_list"]."'",":mz_id"=>$_REQUEST["mz_list"]);
	$sql=stritr($sql,$p);
//echo $sql;
	$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	foreach($res as $k=>$v)
	{
		$d["head"]=$v;
		$d["data"][$v["data"]]["head"]=$v;
		$d["data"][$v["data"]]["spr"][$v["id"]]=$v;
		$d["data"][$v["data"]]["files"][$v["fn"]]=$v["fn"];
	}


//print_r($d);

	$sql = rtrim(file_get_contents('sql/mz_rep_rss_total.sql'));
	$p=array(':month_list'=>"'".$_REQUEST["month_list"]."'",":mz_id"=>$_REQUEST["mz_list"]);
	$sql=stritr($sql,$p);
	$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$d["total"]=$res;
	isset($d)?$smarty->assign('mz_rep_rss', $d):null;


	$d=array();
	$sql = rtrim(file_get_contents('sql/mz_rep_vis.sql'));
	$p=array(':month_list'=>"'".$_REQUEST["month_list"]."'",":mz_id"=>$_REQUEST["mz_list"]);
	$sql=stritr($sql,$p);
	$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	foreach($res as $k=>$v)
	{
		$d["head"]=$v;
		$d["data"][$v["data"]]["head"]=$v;
		$d["data"][$v["data"]]["spr"][$v["id"]]=$v;
	}
	$sql = rtrim(file_get_contents('sql/mz_rep_vis_total.sql'));
	$p=array(':month_list'=>"'".$_REQUEST["month_list"]."'",":mz_id"=>$_REQUEST["mz_list"]);
	$sql=stritr($sql,$p);
	$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$d["total"]=$res;
	isset($d)?$smarty->assign('mz_rep_vis', $d):null;

	$d=array();
	$sql = rtrim(file_get_contents('sql/mz_rep_pds.sql'));
	$p=array(':month_list'=>"'".$_REQUEST["month_list"]."'",":mz_id"=>$_REQUEST["mz_list"]);
	$sql=stritr($sql,$p);
	$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	isset($res)?$smarty->assign('mz_rep_pds', $res):null;

	$sql = rtrim(file_get_contents('sql/mz_rep_pds_total.sql'));
	$p=array(':month_list'=>"'".$_REQUEST["month_list"]."'",":mz_id"=>$_REQUEST["mz_list"]);
	$sql=stritr($sql,$p);
	$res = $db->getOne($sql);
	isset($res)?$smarty->assign('pds_total', $res):null;

	$sql = rtrim(file_get_contents('sql/mz_rep_m.sql'));
	$p=array(':month_list'=>"'".$_REQUEST["month_list"]."'",":mz_id"=>$_REQUEST["mz_list"]);
	$sql=stritr($sql,$p);
	$res = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	isset($res)?$smarty->assign('rep_m', $res):null;

	$sql = rtrim(file_get_contents('sql/mz_rep_stat.sql'));
	$p=array(':month_list'=>"'".$_REQUEST["month_list"]."'",":mz_id"=>$_REQUEST["mz_list"],":arc"=>$_REQUEST["arc"]);
	$sql=stritr($sql,$p);
	//echo $sql;
	$res = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('stat', $res);
	//print_r($res);
}

$smarty->display('mz_rep.html');

//ses_req();

?>