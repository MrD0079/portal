<?
if (isset($_REQUEST["list_tasting_program"])){
    $sql = "SELECT p.* FROM tasting_program p";
    $r = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
    $smarty->assign('x', $r);
} else if (isset($_REQUEST["save_tasting_program"])){
    $_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);
    Table_Update('tasting_program', array("id"=>$_REQUEST["id"]),$_REQUEST["tasting_program"]);
} else if (isset($_REQUEST["id"])||isset($_REQUEST["new_tasting_program"])){
    !isset($_REQUEST["id"])?$_REQUEST["id"]=get_new_id():null;
    $sql = "SELECT p.* FROM tasting_program p WHERE id = '".$_REQUEST["id"]."'";
    $r = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
    $smarty->assign('tasting_program', $r);
}
$smarty->display('tasting_program.html');