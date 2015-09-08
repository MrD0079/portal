<?


if (isset($_REQUEST["clear_result"]))
{
	$sql = "delete from golos_result";
	$db->query($sql);
}

if (isset($_REQUEST["save_cmds"]))
{
	foreach($_REQUEST["names"] as $k=>$v)
	{
		Table_Update ("golos_cmds", array('id'=>$k), array('name'=>$v));
	}
}

if (isset($_REQUEST["save_golos"]))
{
	foreach($_REQUEST["golos"] as $k=>$v)
	{
		Table_Update ("golos_result", array('cmd_id'=>$k,'login'=>$_SESSION['login']), array('cmd_val'=>$v));
	}
}

$sql = "select * from golos_cmds order by id";
$cmds_full = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('cmds_full', $cmds_full);


$sql = "select * from golos_cmds where name is not null order by id";
$cmds = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('cmds', $cmds);


$sql = "select * from golos_result where login='".$_SESSION['login']."'";
$golos_result = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('golos_result', $golos_result);

//print_r($golos_result);

$smarty->assign('cicle', array(5,4,3,2,1));


$sql = "
/* Formatted on 2011/10/17 21:22 (Formatter Plus v4.8.8) */
SELECT   c.NAME, c.ID cmd_id, SUM (NVL (r.cmd_val, 0)) cmd_val,
         SUM (DECODE (r.cmd_val, 1, 1, 0)) cmd_val1,
         SUM (DECODE (r.cmd_val, 2, 1, 0)) cmd_val2,
         SUM (DECODE (r.cmd_val, 3, 1, 0)) cmd_val3,
         SUM (DECODE (r.cmd_val, 4, 1, 0)) cmd_val4,
         SUM (DECODE (r.cmd_val, 5, 1, 0)) cmd_val5
    FROM golos_result r, golos_cmds c
   WHERE r.cmd_id(+) = c.ID AND c.NAME IS NOT NULL
GROUP BY c.NAME, c.ID
ORDER BY c.ID
";
$golos_report = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('golos_report', $golos_report);



$smarty->display('golos.html');

//print_r($_REQUEST);


?>