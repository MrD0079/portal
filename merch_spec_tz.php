<?php

InitRequestVar("routes_agents",0);
InitRequestVar("merch_spec_nets",0);
InitRequestVar("merch_spec_oblast","0");
//InitRequestVar("spec_join","0");
InitRequestVar("merch_spec_sd",$now);
InitRequestVar("merch_spec_tz","0");

$sql = rtrim(file_get_contents("sql/merch_spec_join.sql"));
$p=array(":net"=>$_REQUEST["merch_spec_nets"],":ag"=>$_REQUEST["routes_agents"],":oblast"=>"'".$_REQUEST["merch_spec_oblast"]."'");
$sql=stritr($sql,$p);
//echo $sql;
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('merch_spec_join', $res);
//print_r($res);

$smarty->display('merch_spec_tz.html');
?>