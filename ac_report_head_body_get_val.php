<?

/*
$_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);

$sql='SELECT '.$_REQUEST['field'].' FROM ac WHERE id='.$_REQUEST['id'];

$x=$db->getOne($sql);

echo $x;
*/

($_REQUEST['field']=='ok_accept_lu')?$x=$db->getOne("select to_char(ok_accept_lu,'dd.mm.yyyy hh24:mi:ss') from ac where id=".$_REQUEST['id']):$x=$db->getOne('select '.$_REQUEST['field'].' from ac where id='.$_REQUEST['id']);

echo $x;


?>