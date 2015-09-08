<?

//ses_req();

audit("открыл football_lineup","football");

$sql=rtrim(file_get_contents('sql/football_lineup_teams.sql'));
$p = array(":tn"=>$tn,":dpt_id" => $_SESSION["dpt_id"]);
$sql=stritr($sql,$p);
$football_lineup = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

foreach ($football_lineup as $k=>$v)
{
	$sql=rtrim(file_get_contents('sql/football_lineup_members.sql'));
	$p = array(":team_id"=>$v['id']);
	$sql=stritr($sql,$p);
	$members = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$football_lineup[$k]["members"]=$members;
}

$smarty->assign('football_lineup', $football_lineup);

//print_r($football_lineup);

$smarty->display('football_lineup.html');

?>