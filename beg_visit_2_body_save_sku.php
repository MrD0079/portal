<?

//ses_req();

//InitRequestVar("dt",$now);

$_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);





$keys = array(
	'head_id'=>$_REQUEST['head'],
	'sku'=>$_REQUEST['sku']
);

if ($_REQUEST['field']==='ispresent')
{
	($_REQUEST['val']==1)?$vals=$keys:$vals=null;
}
else
{
	$vals=array($_REQUEST['field']=>$_REQUEST['val']);
}

Table_Update('beg_visit_sku', $keys,$vals);



//echo 'beg_visit_grup_'.$_SESSION["cnt_kod"];
//print_r($keys);
//print_r($vals);





//echo $now;

?>