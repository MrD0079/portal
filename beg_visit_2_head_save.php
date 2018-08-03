<?



//InitRequestVar("dt",$now);

$_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);




$keys = array(
	'id'=>$_REQUEST['head']
);
$vals = array(
	$_REQUEST['field']=>$_REQUEST['val']
);
Table_Update('beg_visit_head', $keys,$vals);

//echo 'beg_visit_grup_'.$_SESSION["cnt_kod"];
//print_r($keys);
//print_r($vals);





//echo $now;

?>