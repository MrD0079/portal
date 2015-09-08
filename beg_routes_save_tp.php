<?

$id=$db->getOne("select id from beg_routes_head where tn=".$tn." and dt=to_date('".$_REQUEST["dt"]."','dd.mm.yyyy')");
!$id?$id=get_new_id():null;
$keys=array(
	"id"=>$id,
	"tn"=>$tn,
	"dt"=>OraDate2MDBDate($_REQUEST["dt"])
);
Table_Update ("beg_routes_head", $keys, $keys);

$keys=array(
	"head_id"=>$id,
	"tp"=>$_REQUEST["tp"]
);
$_REQUEST["val"]==1?$vals=$keys:$vals=null;
Table_Update ("beg_routes_body", $keys, $vals);

$_REQUEST["val"]==1?$r='вкл.':$r='выкл.';
echo "<b>$r</b>";

?>