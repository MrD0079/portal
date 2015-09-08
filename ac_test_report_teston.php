<?

$_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);

$p = array();
$p[':ac_id'] = $_REQUEST["ac_id"];
$p[':memb_id'] = $_REQUEST["memb_id"];
$p[':ac_test_id'] = $_REQUEST["ac_test_id"];

$sql=rtrim(file_get_contents('sql/ac_test_get_memb_table.sql'));
$sql=stritr($sql,$p);
$x = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$memb_table = $x["table_name"];
$test_type = $x["test_type"];

$keys=array(
	'id'=>$_REQUEST["memb_id"],
	);
$vals=array(
	$test_type.'_test'=>1
	);
Table_Update($memb_table,$keys,$vals);
//echo $memb_table;
//print_r($keys);
//print_r($vals);



?>