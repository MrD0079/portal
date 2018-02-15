<?php

audit("вошел в оценку","ocenka");


include "ocenka_events.php";


//ses_req();


$params = array
(
    ':emp_tn' => $_REQUEST["emp_tn"],
    ':exp_tn' => $tn,
    ':event' => $_REQUEST["event"],
    );

if (isset($_REQUEST["save"])) {
    $sql = 'select count(*) from ocenka_exp_comment where tn=:emp_tn and exp_tn=:exp_tn and event=:event';
    $sql=stritr($sql,$params);
    $comment_exist = $db->GetOne($sql);
    if ($comment_exist == 0) {
        $sql = 'insert into ocenka_exp_comment (tn,exp_tn,event) values (:emp_tn,:exp_tn,:event)';
        $sql=stritr($sql,$params);
        $res = $db->query($sql);
    }

	$sth = $db->prepare("update ocenka_exp_comment set comm=:comm where tn=:emp_tn and exp_tn=:exp_tn and event=:event");
	$p=$params;
	$p[':comm'] = stripslashes($_REQUEST["comm"]);
	$sth->execute($p);


    if (isset($_REQUEST["exp_comment"])) {
        $sql = 'select count(*) from ocenka_exp_comment where tn=:emp_tn and exp_tn=:emp_tn and event=:event';
        $sql=stritr($sql,$params);
        $comment_exist = $db->GetOne($sql);
        if ($comment_exist == 0) {
            $sql = 'insert into ocenka_exp_comment (tn,exp_tn,event) values (:emp_tn,:emp_tn,:event)';
            $sql=stritr($sql,$params);
            $res = $db->query($sql);
        }

        foreach ($_REQUEST["exp_comment"] as $key => $val) {
            $sql = "update ocenka_exp_comment set " . $key . "=:val where tn=:emp_tn and exp_tn=:emp_tn and event=:event";
            $sql=stritr($sql,$params);
            $sql = stritr($sql, array(':val'=>stripslashes($val)));
            $res = $db->query($sql);
        }
    }

    audit("сохранил комментарий по " . $_REQUEST["emp_tn"],"ocenka");
}
if (isset($_REQUEST["crit"])) {
    $params = array
    (
	$_REQUEST["emp_tn"],
        $tn,
        $_REQUEST["event"],
        );
    $sth = $db->prepare('delete from ocenka_score where tn=? and exp_tn=? and event=? and criteria=?');
    foreach ($_REQUEST["crit"] as $key => $val) {
        $params4score = $params;
        $params4score[] = $key;
	$sth->execute($params4score);
    }
    unset($alldata);
    $sth = $db->prepare('insert into ocenka_score (tn,exp_tn,event,criteria,score) values (?,?,?,?,?)');
    foreach ($_REQUEST["crit"] as $key => $val) {
        if ($val == '' || $val > 3 || $val < 0) {
            $val = "0";
        }
        $params4score = $params;
        $params4score[] = $key;
        $params4score[] = /*str_replace(".", ",", $val)*/$val;


//print_r($params4score);

	$sth->execute($params4score);
    }
    $res = $db->getOne("select fn_getname (" . $_REQUEST["emp_tn"] . ") from dual");
    audit("сохранил баллы по критериям по " . $_REQUEST["emp_tn"]." (".$res.")","ocenka");
}
$row = null;
$res = $db->getOne("select fn_getname (" . $tn . ") from dual");
// $res->fetchInto($row, MDB2_FETCHMODE_ASSOC);
$smarty->assign('exp_fio', $res);
$sql = rtrim(file_get_contents('sql/ocenka_emp_list.sql'));
$params1 = array(
    ':exp_tn' => $tn,
    ':dpt_id' => $_SESSION["dpt_id"],
    ':event' => $_SESSION['event']
    );
$sql = stritr($sql, $params1);
//$res = $db->getAll($sql, MDB2_FETCHMODE_ASSOC);
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('emp_list', $res);
if (isset($_REQUEST["emp_tn"])) {
    $params4fio = array(
        $_REQUEST["emp_tn"]
        );
    $res_fio = $db->getone("SELECT fn_getname (?) from dual", null,$params4fio);
    // $res_fio->fetchInto($row_fio);
    $smarty->assign('emp_fio', $res_fio);
    $sql = rtrim(file_get_contents('sql/ocenka_emp_crit_ocenka.sql'));
    $p1 = array(
        ':emp_tn' => $_REQUEST["emp_tn"],
        ':exp_tn' => $tn,
        ':event' => $_SESSION['event']
        );
    $sql=stritr($sql,$p1);
    $res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
    $smarty->assign('emp_crit', $res);
//print_r($res);
    $params = array
    (
        ':emp_tn' => $_REQUEST["emp_tn"],
        ':exp_tn' => $_REQUEST["emp_tn"],
        ':event' => $_REQUEST["event"],
        );
	$sql = "select nvl(dev_emp,0) f1,nvl(dev_chief,0) f2,nvl(dev_sol,0) f3 from ocenka_exp_comment where tn=:emp_tn and exp_tn=:exp_tn and event=:event";
	$sql=stritr($sql,$params);
	$res_comm = $db->query($sql);
	$row_comm = $res_comm->fetchRow(MDB2_FETCHMODE_ASSOC);
    $smarty->assign('dev_emp', $row_comm['f1']);
    $smarty->assign('dev_chief', $row_comm['f2']);
    $smarty->assign('dev_sol', $row_comm['f3']);
    $params = array
    ($_REQUEST["emp_tn"],
        $tn,
        $_REQUEST["event"],
        );

    $res_comm = $db->getone('select comm from ocenka_exp_comment where tn=? and exp_tn=? and event=?', null, $params);
    $smarty->assign('comm', $res_comm);
}

$smarty->display('ocenka.html');

?>