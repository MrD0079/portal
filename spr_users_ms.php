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
        $_REQUEST["all"]=0;
        $_REQUEST["new"]["birthday"]!=''?$_REQUEST["new"]["birthday"]=OraDate2MDBDate($_REQUEST["new"]["birthday"]):null;
        $_REQUEST["new"]["datauvol"]!=''?$_REQUEST["new"]["datauvol"]=OraDate2MDBDate($_REQUEST["new"]["datauvol"]):null;
        $_REQUEST["new"]["start_company"]!=''?$_REQUEST["new"]["start_company"]=OraDate2MDBDate($_REQUEST["new"]["start_company"]):null;
        Table_Update('spr_users_ms', $_REQUEST["new"], $_REQUEST["new"]);
        ses_req();
    }
    InitRequestVar("all",1);
    $sql=rtrim(file_get_contents('sql/spr_users_ms.sql'));
    $p = array(":tn"=>$tn,':dpt_id' => $_SESSION["dpt_id"],':flt'=>$_REQUEST["all"]);
    $sql=stritr($sql,$p);
    $data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
    $smarty->assign('spr_users_ms', $data);
    $sql="SELECT tn, fio
    FROM user_list
   WHERE     pos_id in ( 69,127707110)
         AND dpt_id = :dpt_id
         AND ADD_MONTHS (TRUNC (NVL (datauvol, SYSDATE), 'mm'), +1) >=
                TRUNC (SYSDATE, 'mm')
         AND (   tn IN (SELECT slave
                          FROM full
                         WHERE master = :tn)
              OR (SELECT is_admin
                    FROM user_list
                   WHERE tn = :tn) = 1

              OR (SELECT is_ma
                    FROM user_list
                   WHERE tn = :tn) = 1

              OR (SELECT is_kk
                    FROM user_list
                   WHERE tn = :tn) = 1

)
ORDER BY fio";
    $p = array(":tn"=>$tn,':dpt_id' => $_SESSION["dpt_id"]);
    $sql=stritr($sql,$p);
    $data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
    $smarty->assign('svms_list', $data);
    $sql = rtrim(file_get_contents('sql/routes_pos.sql'));
    $res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
    $smarty->assign('routes_pos', $res);
    $smarty->display('spr_users_ms.html');
}
