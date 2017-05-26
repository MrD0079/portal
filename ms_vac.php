<?
if (isset($_REQUEST["save"])){
    $_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);
    $_REQUEST["field"]=='birthday'?$_REQUEST["val"]=OraDate2MDBDate($_REQUEST["val"]):null;
    $_REQUEST["field"]=='datauvol'?$_REQUEST["val"]=OraDate2MDBDate($_REQUEST["val"]):null;
    $_REQUEST["field"]=='start_company'?$_REQUEST["val"]=OraDate2MDBDate($_REQUEST["val"]):null;
    Table_Update('spr_users_ms', array('id'=>$_REQUEST['id']), array($_REQUEST['field']=>$_REQUEST['val']));
    echo $_REQUEST['id'];
} else {
    if (isset($_REQUEST["add"])){
        $_REQUEST["new"]["start"]!=''?$_REQUEST["new"]["start"]=OraDate2MDBDate($_REQUEST["new"]["start"]):null;
        Table_Update('ms_vac', $_REQUEST["new"], $_REQUEST["new"]);
        ses_req();
    }
    InitRequestVar("all",1);
    $sql=rtrim(file_get_contents('sql/ms_vac.sql'));
    $p = array(":tn"=>$tn,':dpt_id' => $_SESSION["dpt_id"],':flt'=>$_REQUEST["all"]);
    $sql=stritr($sql,$p);
    $data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
    $smarty->assign('users_ms', $data);
    $sql=rtrim(file_get_contents('sql/svms_list.sql'));
    $p = array(":tn"=>$tn,':dpt_id' => $_SESSION["dpt_id"]);
    $sql=stritr($sql,$p);
    $data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
    $smarty->assign('svms_list', $data);
    $sql = rtrim(file_get_contents('sql/routes_pos.sql'));
    $res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
    $smarty->assign('routes_pos', $res);
    $smarty->display('ms_vac.html');
}
