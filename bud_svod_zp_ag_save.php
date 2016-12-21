<?
$_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);
if ($_REQUEST['field']=='id')
{
	if ($_REQUEST['val']==0)
	{
		Table_Update('bud_svod_zp', array('id'=>$_REQUEST['id']),null);
	}
}
else
{
    	/*$params = array(
		':tn'=>$tn,
		':dt'=>"'".$_REQUEST['dt']."'",
		':dpt_id' => $_SESSION["dpt_id"],
		':unscheduled'=>$_REQUEST['unscheduled'],
		':h_eta'=>"'".$_REQUEST['h_eta']."'",
	);
*/
    $existingTN = $db->getOne("select max(tn) from bud_svod_zp where id=".$_REQUEST['id']);
    if ($existingTN!=null&&$existingTN!=$tn){
        Table_Update('bud_svod_zp', array('id'=>$_REQUEST['id']),array('tn'=>$tn));
    }
    //$_REQUEST["AAAA"] = [$sqlw,$sqlwo];
    //$_REQUEST["BBBB"] = [$wTS,$woTS];
	$keys = array(
		'id'=>$_REQUEST['id'],
		'tn'=>$tn,
		'dt'=>OraDate2MDBDate($_REQUEST['dt']),
		'dpt_id' => $_SESSION["dpt_id"],
		'unscheduled'=>$_REQUEST['unscheduled']/*,
		'h_eta'=>$_REQUEST['h_eta'],*/
	);
	//Table_Update('bud_svod_zp', $keys,$keys);
	$vals = array(
		//'id'=>$_REQUEST['id'],
		//'tn'=>$tn,
		/*'dt'=>OraDate2MDBDate($_REQUEST['dt']),
		'dpt_id' => $_SESSION["dpt_id"],
		'unscheduled'=>$_REQUEST['unscheduled'],*/
		'h_eta'=>$_REQUEST['h_eta'],
		$_REQUEST['field']=>$_REQUEST['val']
	);
	Table_Update('bud_svod_zp', $keys,$vals);
    //$_REQUEST["CCCC"] = [$keys,$vals];
    //ses_req();
}
