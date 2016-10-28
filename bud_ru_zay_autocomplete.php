<?
$result = array();
$params = array();
$params[":tn"]=$_REQUEST["tn"];
$sql=$db->getOne('SELECT get_list FROM bud_ru_ff_subtypes WHERE id = (SELECT subtype FROM bud_ru_ff WHERE id = '.$_REQUEST["ff_id"].')');
$sql=stritr($sql,$params);
$sql='SELECT * FROM ('.$sql.') WHERE lower(name) LIKE \'%\'||lower(\''.mb_convert_encoding($_GET[ "term" ],"Windows-1251","UTF-8").'\')||\'%\' and rownum <=25';
$list = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
foreach ($list as $k=>$v)
{
	array_push( $result, array( "label" => mb_convert_encoding($v["name"],"UTF-8","Windows-1251"), "value" => $v["id"] ) );
}
echo json_encode( $result );
?>