<?



if (isset($_REQUEST["del"]))
{
foreach ($_REQUEST["del"] as $k=>$v)
{
	//echo $k."<br>";
	$table_name = 'p_prob_inst';
	$fields_values = array('prob_tn'=>$k);
	$affectedRows = $db->extended->autoExecute($table_name, null, MDB2_AUTOQUERY_DELETE, 'prob_tn='.$k);
	audit("удалил адаптационную программу ".$k,"probs_my");
}
}




$params=array(":tn"=>$tn,':dpt_id' => $_SESSION["dpt_id"],":ad_completed"=>$_REQUEST["ad_completed"]);
$sql=rtrim(file_get_contents('sql/probs_my.sql'));
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);



//print_r($data);


$smarty->assign('probs_my', $data);


$smarty->display('probs_my.html');


?>