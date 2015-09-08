<?php
InitRequestVar("lang",array(0));
InitRequestVar("lang_level",array(0));
InitRequestVar("eta_list",$_SESSION["h_eta"]);
//function ar2str($n){return("'".$n."'");}
//isset($_REQUEST["lang"]) ? $lang = join(array_map("ar2str", $_REQUEST["lang"]),',') : $lang = 0;
//isset($_REQUEST["lang_level"]) ? $lang_level = join(array_map("ar2str", $_REQUEST["lang_level"]),',') : $lang_level = 0;
$lang = join($_REQUEST["lang"],',');
$lang_level = join($_REQUEST["lang_level"],',');
$params=array(
	':dpt_id' => $_SESSION["dpt_id"],
	":tn"=>$tn,
	":lang_level" => $lang_level,
	":lang" => $lang,
	':eta_list' => "'".$_REQUEST["eta_list"]."'",
);
//var_dump($lang);
//var_dump($lang_level);
//ses_req();

$sql = rtrim(file_get_contents('sql/anketa_lang_level.sql'));
$sql=stritr($sql,$params);
$x = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('anketa_lang_level', $x);

$sql = rtrim(file_get_contents('sql/lang.sql'));
$sql=stritr($sql,$params);
$x = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('lang', $x);

if (isset($_REQUEST["generate"]))
{
$sql=rtrim(file_get_contents('sql/anketa_lang_report.sql'));
$sql=stritr($sql,$params);

//echo $sql;

$x = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('list', $x);
}

$smarty->display('anketa_lang_report.html');

?>