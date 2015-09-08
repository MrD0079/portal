<?
//ses_req();
if (isset($_REQUEST["new_spd"]))
{
	Table_Update("spdtree",$_REQUEST["new_spd"],$_REQUEST["new_spd"]);
}

$smarty->display('new_spd.html');

?>