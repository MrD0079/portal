<?
if (isset($_REQUEST["del"]))
{
    foreach ($_REQUEST["del"] as $k=>$v)
    {
            $table_name = 'p_prob_inst';
            $fields_values = array('prob_tn'=>$k);
            Table_Update($table_name, $fields_values,null);
    }
}
$params=array(":tn"=>$tn,':dpt_id' => $_SESSION["dpt_id"],":ad_completed"=>$_REQUEST["ad_completed"]);
$sql=rtrim(file_get_contents('sql/probs_my.sql'));
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('probs_my', $data);
$smarty->display('probs_my.html');
?>