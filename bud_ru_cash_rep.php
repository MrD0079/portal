<?

audit("открыл bud_ru_cash_rep","bud");

InitRequestVar("sd",$_SESSION["month_list"]);
InitRequestVar("ed",$_SESSION["month_list"]);
InitRequestVar("fil",0);
InitRequestVar("nd","0");
InitRequestVar("region_name","0");
InitRequestVar("db",0);

//isset($_REQUEST["st_pri"]


$p = array();

$p[":tn"] = $tn;
$p[":dpt_id"] = $_SESSION["dpt_id"];



$sql=rtrim(file_get_contents('sql/bud_nd.sql'));
$sql=stritr($sql,$p);
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('nd', $res);


$sql = rtrim(file_get_contents('sql/month_list.sql'));
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('month_list', $res);


$sql = rtrim(file_get_contents('sql/bud_ru_cash_rep_regions.sql'));
$sql=stritr($sql,$p);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('region_list', $data);

$sql = rtrim(file_get_contents('sql/bud_fil.sql'));
$sql=stritr($sql,$p);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('fil_list', $data);

$sql = rtrim(file_get_contents('sql/bud_db_list.sql'));
$sql=stritr($sql,$p);
//echo $sql;
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('db_list', $data);

$sql=rtrim(file_get_contents('sql/bud_ru_st_ras.sql'));
$sql=stritr($sql,$p);
$st = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('st', $st);
foreach ($st as $k=>$v){$init_r_st_ras[$v["id"]]=$v["id"];}
foreach ($st as $k=>$v){$init_r_kat[$v["id"]]=$v["id"];}

$sql=rtrim(file_get_contents('sql/bud_ru_st_pri.sql'));
$sql=stritr($sql,$p);
$st = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('st_pri', $st);
foreach ($st as $k=>$v){$init_r_st_pri[$v["id"]]=$v["id"];}




/*
InitRequestVar("r_st_pri",$init_r_st_pri);
InitRequestVar("r_st_ras",$init_r_st_ras);
InitRequestVar("r_kat",$init_r_kat);
*/

InitRequestVar("r_st_pri",0);
InitRequestVar("r_st_ras",0);
InitRequestVar("r_kat",0);



is_array($_REQUEST["r_st_pri"]) ? $st_pri = 'and st.id in ('.join($_REQUEST["r_st_pri"],',').')' : $st_pri='';
is_array($_REQUEST["r_st_ras"]) ? $st_ras = 'and stp.id in ('.join($_REQUEST["r_st_ras"],',').')' : $st_ras='';
is_array($_REQUEST["r_kat"]) ? $kat = 'and st.id in ('.join($_REQUEST["r_kat"],',').')' : $kat='';

$p[":sd"] = "'".$_REQUEST["sd"]."'";
$p[":ed"] = "'".$_REQUEST["ed"]."'";
$p[":fil"] = $_REQUEST["fil"];
$p[":nd"] = "'".$_REQUEST["nd"]."'";
$p[":region_name"] = "'".$_REQUEST["region_name"]."'";
$p[":db"] = $_REQUEST["db"];

$p["/*:st_pri*/"] = $st_pri;
$p["/*:st_ras*/"] = $st_ras;
$p["/*:kat*/"] = $kat;



//ses_req();


//print_r($p);


if (isset($_REQUEST["select"]))
{

//if (($_REQUEST["r_st_ras"]==$init_r_st_ras)&&($_REQUEST["r_kat"]==$init_r_kat))
if (($_REQUEST["r_st_ras"]==0)&&($_REQUEST["r_kat"]==0))
{
$sql = rtrim(file_get_contents('sql/bud_ru_cash_rep_in.sql'));
$sql=stritr($sql,$p);
$r = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

foreach ($r as $k=>$v)
{
$p[":id"] = $v["id"];
$sql = rtrim(file_get_contents('sql/bud_ru_cash_rep_in_body.sql'));
$sql=stritr($sql,$p);
$rd = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$r[$k]["body"]=$rd;
}
$smarty->assign('pd_in', $r);

$sql = rtrim(file_get_contents('sql/bud_ru_cash_rep_in_total.sql'));
$sql=stritr($sql,$p);
$r = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('pdt_in', $r);
}


//if ($_REQUEST["r_st_pri"]==$init_r_st_pri)
if ($_REQUEST["r_st_pri"]==0)
{
$sql = rtrim(file_get_contents('sql/bud_ru_cash_rep_out.sql'));
$sql=stritr($sql,$p);
$r = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);


foreach ($r as $k=>$v)
{
$p[":id"] = $v["id"];
$sql = rtrim(file_get_contents('sql/bud_ru_cash_rep_out_body.sql'));
$sql=stritr($sql,$p);
$rd = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
foreach ($rd as $k1=>$v1)
{
$r[$k]["data"][$v1["st"]]=$v1;
}
}

foreach ($r as $k=>$v)
{
$p[":id"] = $v["id"];
$sql = rtrim(file_get_contents('sql/bud_ru_cash_rep_out_body1.sql'));
$sql=stritr($sql,$p);
$rd = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
//$r[$k]["body"]=$rd;
//$r[$k]["data"][$rd["st"]]["data"]=$rd;
foreach ($rd as $k1=>$v1)
{
$r[$k]["data"][$v1["st_id"]]["data"][$v1["kat_id"]]=$v1;
}
}



//print_r($r);



$smarty->assign('pd_out', $r);






$sql = rtrim(file_get_contents('sql/bud_ru_cash_rep_out_total.sql'));
$sql=stritr($sql,$p);
$r = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('pdt_out', $r);
}


$sql = rtrim(file_get_contents('sql/bud_ru_cash_rep_total.sql'));
$sql=stritr($sql,$p);
//echo $sql;
$r = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('total', $r);

$sql = rtrim(file_get_contents('sql/bud_ru_cash_rep_total_total.sql'));
$sql=stritr($sql,$p);
//echo $sql;
$r = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('total_total', $r);


}





$smarty->display('bud_ru_cash_rep.html');

?>