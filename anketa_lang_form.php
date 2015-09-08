<?php
if (isset($_REQUEST['save']))
{
	audit("сохранил anketa","anketa");
	$_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);
	if ($_REQUEST['table']=='anketa_lang')
	{
		$keys = array('lang_id'=>$_REQUEST['id']);
		$tn==-1?$keys['h_eta']=$_SESSION["h_eta"]:null;
		$tn!==-1?$keys['tn']=$tn:null;
		$vals = array($_REQUEST['field']=>$_REQUEST['val']);
		$_REQUEST['field']=='lang_level'&&$_REQUEST['val']=='null'?$vals=null:null;
	}
	if ($_REQUEST['table']=='anketa_langh')
	{
		$keys = array();
		$tn==-1?$keys['h_eta']=$_SESSION["h_eta"]:null;
		$tn!==-1?$keys['tn']=$tn:null;
		$vals = array($_REQUEST['field']=>$_REQUEST['val']);
		//$_REQUEST['val']=='null'?$vals=null:null;
	}
	Table_Update($_REQUEST['table'], $keys,$vals);
}
else
{
	audit("открыл anketa","anketa");
	$params=array(':tn' => $tn,':h_eta' => "'".$_SESSION["h_eta"]."'");
	//print_r($params);
	$sql = rtrim(file_get_contents('sql/anketa_lang_form.sql'));
	$sql=stritr($sql,$params);
	$rb = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('list', $rb);
	//echo $sql;
	//print_r($rb);
	$sql = rtrim(file_get_contents('sql/anketa_lang_formh.sql'));
	$sql=stritr($sql,$params);
	$x = $db->getOne($sql);
	$smarty->assign('opit', $x);
	$sql = rtrim(file_get_contents('sql/anketa_lang_level.sql'));
	$x = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('anketa_lang_level', $x);
	$smarty->display('anketa_lang_form.html');
}
?>