<?
//ses_req();
if (isset($_REQUEST["saveProd"]))
{
	$_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);
	$keys = array('tn'=>$tn);
	/*for ($i=1;$i<=3;$i++)
	{
		$v = $db->getOne("select product".$i." from voiting where tn=".$tn);
		if ($v==$_REQUEST["column"])
		{
			$vals = array('product'.$i=>0);
			Table_Update('voiting', $keys,$vals);
		}
	}*/
	if ($_REQUEST["selected"]=='false')
	{
		$vals = array('product'.$_REQUEST["row"]=>$_REQUEST["column"]);
	}
	else
	{
		$vals = array('product'.$_REQUEST["row"]=>0);
	}
	Table_Update('voiting', $keys,$vals);
}
elseif (isset($_REQUEST["saveBall"]))
{
	$_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);
	$keys = array('tn'=>$tn);
	/*$vals = array('ball'.$_REQUEST["column"]=>0);
	Table_Update('voiting', $keys,$vals);*/
	if ($_REQUEST["selected"]=='false')
	{
		$vals = array('ball'.$_REQUEST["column"]=>$_REQUEST["val"]);
	}
	else
	{
		$vals = array('ball'.$_REQUEST["column"]=>0);
	}
	Table_Update('voiting', $keys,$vals);
}
else
{
	$d = $db->getRow("SELECT * FROM voiting where tn=".$tn, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('voiting', $d);
	$smarty->display('voiting.html');
}
?>




