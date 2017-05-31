<?
if (isset($_REQUEST["save"])){
    $_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);
    $_REQUEST["field"]=='birthday'?$_REQUEST["val"]=OraDate2MDBDate($_REQUEST["val"]):null;
    $_REQUEST["field"]=='datauvol'?$_REQUEST["val"]=OraDate2MDBDate($_REQUEST["val"]):null;
    $_REQUEST["field"]=='start_company'?$_REQUEST["val"]=OraDate2MDBDate($_REQUEST["val"]):null;
    Table_Update('spr_users_ms', array('id'=>$_REQUEST['id']), array($_REQUEST['field']=>$_REQUEST['val']));
    echo $_REQUEST['id'];
} else if (isset($_REQUEST["list_rm"])) {
    $sql=rtrim(file_get_contents('sql/ms_vac_list_rm.sql'));
    $p = array(":tn"=>$tn,':dpt_id' => $_SESSION["dpt_id"]);
    $sql=stritr($sql,$p);
    $data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
    $s='<option value=0></option>';
    foreach ($data as $k=>$v){
        $s.='<option value="'.$v["tn"].'">'.$v["fio"].'</option>';
    }
    echo $s;
} else if (isset($_REQUEST["list_svms"])) {
    $sql=rtrim(file_get_contents('sql/ms_vac_list_svms.sql'));
    $p = array(":tn"=>$tn,':dpt_id' => $_SESSION["dpt_id"],':rm_tn' => $_REQUEST["rm_tn"]);
    $sql=stritr($sql,$p);
    $data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
    $s='<option value=0></option>';
    foreach ($data as $k=>$v){
        $s.='<option value="'.$v["tn"].'">'.$v["fio"].'</option>';
    }
    echo $s;
} else if (isset($_REQUEST["list_ms"])) {
    $sql=rtrim(file_get_contents('sql/ms_vac_list_ms.sql'));
    $p = array(":tn"=>$tn,':dpt_id' => $_SESSION["dpt_id"],':rm_tn' => $_REQUEST["rm_tn"],':svms_tn' => $_REQUEST["svms_tn"]);
    $sql=stritr($sql,$p);
    $data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
    $s='';
    foreach ($data as $k=>$v){
        $s.='<tr style="text-align: center">
        <td style="text-align: left">'.$v["fio"].'</td>
        <td>'.$v["start_company"].'</td>
        <td>л:'.$v["experience_y"].' м:'.$v["experience_m"].' д:'.$v["experience_d"].'</td>
        <td>'.$v["vac_days_available"].'</td>
        <td>'.$v["vac_log"].'</td>
    </tr>';
    }
    echo $s;
} else if (isset($_REQUEST["list_ms_json"])) {
    $sql=rtrim(file_get_contents('sql/ms_vac_list_ms.sql'));
    $p = array(":tn"=>$tn,':dpt_id' => $_SESSION["dpt_id"],':rm_tn' => $_REQUEST["rm_tn"],':svms_tn' => $_REQUEST["svms_tn"]);
    $sql=stritr($sql,$p);
    $data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
    echo mb_convert_encoding (json_encode(recursive_iconv('Windows-1251','UTF-8',$data), /*JSON_FORCE_OBJECT | */JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE),'Windows-1251','UTF-8');
} else if (isset($_REQUEST["list_vac"])) {
    $sql=rtrim(file_get_contents('sql/ms_vac.sql'));
    $p = array(":tn"=>$tn,':dpt_id' => $_SESSION["dpt_id"]);
    $sql=stritr($sql,$p);
    $data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
    $s='';
    foreach ($data as $k=>$v){
        $vacDel = $is_ma==1||$is_admin==1 ? '<input type="button" value="Удалить" onclick="vacRemove(\''.$v["id"].'\')">' : '';
        $s.='<tr id="vac'.$v["id"].'">
        <td>'.$vacDel.'</td>
        <td>'.$v["fio"].'</td>
        <td style="text-align: center">'.$v["start_company"].'</td>
        <td style="text-align: center">'.$v["vac_days_used"].'</td>
        <td style="text-align: center">'.$v["vac_period"].'</td>
        <td>'.$v["creator"].'</td>
        <td style="text-align: center">'.$v["created"].'</td>
    </tr>';
    }
    echo $s;
} else if (isset($_REQUEST["vac_remove"])) {
        Table_Update('ms_vac', array('id'=>$_REQUEST["id"]), array('remover'=>$fio));
} else if (isset($_REQUEST["add_vac"])) {
    //ses_req();
        $sql="SELECT DECODE (
                SIGN (
                   ADD_MONTHS (TRUNC (SYSDATE), -12) - s.START_company + 1),
                1,   14
                   - NVL (
                        (SELECT SUM (days)
                           FROM ms_vac
                          WHERE     login = s.login
                                AND TRUNC (vac_start, 'yyyy') =
                                       TRUNC (SYSDATE, 'yyyy') and removed is null),
                        0),
                0)
        FROM spr_users_ms s
        WHERE s.login = '".$_REQUEST["new"]["login"]."'";
        //echo $sql;
        $days_available = $db->getOne($sql);
        if ($days_available>=$_REQUEST["new"]["days"]){
            $_REQUEST["new"]["vac_start"]!=''?$_REQUEST["new"]["vac_start"]=OraDate2MDBDate($_REQUEST["new"]["vac_start"]):null;
            $_REQUEST["new"]["creator"] = $fio;
            Table_Update('ms_vac', $_REQUEST["new"], $_REQUEST["new"]);
            echo "Отпуск создан";
        }
        else {
            echo "Недостаточно дней для создания отпуска";
        }
} else {
    /*$sql=rtrim(file_get_contents('sql/ms_vac_list_ms.sql'));
    $p = array(":tn"=>$tn,':dpt_id' => $_SESSION["dpt_id"],':rm_tn' => 0,':svms_tn' => 0);
    $sql=stritr($sql,$p);
    $data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
    $smarty->assign('list_ms', $data);*/
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
