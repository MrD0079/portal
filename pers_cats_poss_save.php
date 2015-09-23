<?
$_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);
$keys = array('pos_id'=>$_REQUEST['id'],'pers_cat_id'=>$_REQUEST['parent']);
//Table_Update('pers_cats_poss', $keys,$keys);
if ($_REQUEST['val']==0)
{
Table_Update('pers_cats_poss', $keys,null);}
else
{
Table_Update('pers_cats_poss', $keys,$keys);
}



$p = array(":id" => $_REQUEST["id"]);
$sql = rtrim(file_get_contents('sql/pers_cats_pos_pers_cats.sql'));
$sql=stritr($sql,$p);
$r = $db->getOne($sql);
echo "(".$r.")";




?>




