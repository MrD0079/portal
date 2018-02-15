<?


audit("открыл отчет виды активностей","activ");



$sql = rtrim(file_get_contents('sql/dolgn_list.sql'));
//echo $sql;
$dolgn_list = $db->getAssoc($sql, false, array(), MDB2_FETCHMODE_ASSOC);
$smarty->assign('dolgn_list', $dolgn_list);
//print_r($dolgn_list);


$sql = rtrim(file_get_contents('sql/month_list.sql'));
//$res = $db->getAll($sql, MDB2_FETCHMODE_ASSOC);
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('month_list', $res);



!isset($_REQUEST["dolgn_list"]) ? $_REQUEST["dolgn_list"]=0: null;


$params = array
(
    ":month_list" => "'".$_REQUEST["month_list"]."'",
    ':dpt_id' => $_SESSION["dpt_id"],
    ':dolgn_id'=> $_REQUEST["dolgn_list"]
    );
$sql = rtrim(file_get_contents('sql/activ.sql'));
$sql=stritr($sql,$params);
//echo $sql;
//$activ = $db->getAssoc($sql, false, array(), MDB2_FETCHMODE_ASSOC);
$activ = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
//$smarty->assign('activ', $plans);


$a=array();

foreach ($activ as $key=>$val)
{



//$a[$val["tn"]]=array();
$a[$val["tn"]]["emp_dolgn"]=$val["emp_dolgn"];
$a[$val["tn"]]["emp_name"]=$val["emp_name"];
$a[$val["tn"]]["week"][$val["wm"]]["active"][$val["id"]]["active_name"]=$val["name"];
$a[$val["tn"]]["week"][$val["wm"]]["active"][$val["id"]]["plan"]=$val["plan"];
$a[$val["tn"]]["week"][$val["wm"]]["active"][$val["id"]]["fakt"]=$val["fakt"];



}


$smarty->assign('activ', $a);



//print_r($activ);
//print_r($a);






$sql = rtrim(file_get_contents('sql/activ_types.sql'));
$activ_types = $db->getAssoc($sql, false, array(), MDB2_FETCHMODE_ASSOC);
$smarty->assign('activ_types', $activ_types);






$smarty->display('activ.html');












?>