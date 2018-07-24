<?php
include "act_report_a_1.php";
if (isset($_REQUEST["add"])) {
    if (isset($_REQUEST["keys"])) {
        foreach ($_REQUEST["keys"] as $key => $val) {
            $keys = array('h_tp_kod_data_nakl'=>$key);
            isset($_REQUEST["data_s"][$key]) ? $vals = $_REQUEST["data_s"][$key] : $vals = null;
            //isset($vals["bonus_dt1"]) ? $vals["bonus_dt1"]=OraDate2MDBDate($vals["bonus_dt1"]) : null;
            if ($vals["if1"]!=0) {
                $sql="SELECT COUNT (*)
                    FROM (
                    select h_tp_kod_data_nakl FROM a1807ms1_action_nakl
                    union
                    select h_tp_kod_data_nakl FROM a1807ms2_action_nakl
                    union
                    select h_tp_kod_data_nakl FROM a1807sb4_action_nakl
                    union
                    select h_tp_kod_data_nakl FROM a1807sc_action_nakl
                    union
                    select h_tp_kod_data_nakl FROM a1807ss1_action_nakl
                    union
                    select h_tp_kod_data_nakl FROM a1807ss2_action_nakl
                        )
                    WHERE h_tp_kod_data_nakl = '".$key."'"
                        . "";
                $c=$db->getOne($sql);
                $sql1="
                    SELECT COUNT (*)
                    FROM ".$_REQUEST['act']."_action_nakl
                    WHERE h_tp_kod_data_nakl IN (SELECT h_tp_kod_data_nakl
                    FROM ".$_REQUEST['act']."
                    WHERE tp_kod = (SELECT tp_kod
                    FROM ".$_REQUEST['act']."
                    WHERE h_tp_kod_data_nakl = '".$key."'))
                    AND h_tp_kod_data_nakl <> '".$key."'";
                $c1=$db->getOne($sql1);
                if ($c>0) {
                    echo "<p>Данная накладная уже участвует в одной из акций</p>";
                } else if ($c1>=1) {
                    echo "<p>По одному клиенту за период акции может быть не более одной акционной накладной</p>";
                } else {
                    Table_Update ($_REQUEST['act']."_action_nakl", $keys, $vals);
                }
            } else {
                Table_Update ($_REQUEST['act']."_action_nakl", $keys, null);
            }
        }
    }
}
if (isset($_REQUEST["save"])) {
    if (isset($_FILES["data"])) {
        $d1="files/";
        if (!file_exists($d1)) {mkdir($d1,0777,true);}
        foreach($_FILES["data"]["name"] as $k=>$v) {
            if (is_uploaded_file($_FILES["data"]['tmp_name'][$k]["fn"])) {
                $keys = array('id'=>$k);
                $fn=get_new_file_id().'_'.translit($_FILES["data"]['name'][$k]["fn"]);
                move_uploaded_file($_FILES["data"]['tmp_name'][$k]["fn"], $d1.$fn);
                $v["fn"]=$fn;
                Table_Update ($_REQUEST['act'].'_action_nakl', $keys, $v);
            }
        }
    }
    if (isset($_REQUEST["data"])) {
        foreach($_REQUEST["data"] as $k=>$v) {
            $keys = array('id'=>$k);
            isset($v["bonus_dt1"]) ? $v["bonus_dt1"]=OraDate2MDBDate($v["bonus_dt1"]) : null;
            Table_Update ($_REQUEST['act'].'_action_nakl', $keys, $v);
        }
    }
    if (isset($_REQUEST["data_files"])) {
        foreach($_REQUEST["data_files"] as $k=>$v) {
            $keys = array('id'=>$k);
            Table_Update ($_REQUEST['act'].'_files', $keys, $v);
        }
    }
    if (isset($_REQUEST["del"])) {
        foreach ($_REQUEST["del"] as $key => $val) {
            $keys = array('id'=>$key);
            Table_Update ($_REQUEST['act'].'_action_nakl', $keys, null);
        }
    }
    if (isset($_REQUEST["ok_db"])) {
        $keys = array('tn'=>$tn,'m'=>$actParams['my'],'act'=>$_REQUEST['act']);
        $_REQUEST["ok_db"]==1 ? $vals = $keys : $vals = null;
        Table_Update ('act_ok', $keys, $vals);
        $keys = array('db_tn'=>$tn,'m'=>$actParams['my'],'dpt_id' => $_SESSION["dpt_id"],'act'=>$_REQUEST['act']);
        Table_Update ('act_svod', $keys, null);
        Table_Update ('act_svodt', $keys, null);
        if ($_REQUEST["ok_db"]==1) {
            $params1=$params;
            $params1[':act']="'".$_REQUEST['act']."'";
            $sql=rtrim(file_get_contents("sql/".$_REQUEST['act']."_report_a_svod.sql"));
            $sql=stritr($sql,$params1);
            $x = $db->query($sql);
            $sql=rtrim(file_get_contents("sql/".$_REQUEST['act']."_report_a_svodt.sql"));
            $sql=stritr($sql,$params1);
            $x = $db->query($sql);
        }
    }
}
$sql=rtrim(file_get_contents('sql/'.$_REQUEST['act'].'_report_a_tp.sql'));
$sql=stritr($sql,$params);
$tp = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('tp', $tp);
if ($_REQUEST["selected_tp"]!=0) {
    $sql = rtrim(file_get_contents('sql/'.$_REQUEST['act'].'_report_a_nakl.sql'));
    $sql=stritr($sql,$params);
    $nakl_list = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
    $smarty->assign('nakl_list', $nakl_list);
}
include "act_report_a_2.php";
include "act_report_a_3.php";
?>