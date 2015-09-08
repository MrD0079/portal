<?
$_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);
$keys = array('fil_id'=>$_REQUEST['id'],'cluster_id'=>$_REQUEST['parent']);
//Table_Update('clusters_fils', $keys,$keys);
if ($_REQUEST['val']==0)
{
Table_Update('clusters_fils', $keys,null);}
else
{
Table_Update('clusters_fils', $keys,$keys);
}



$p = array(":id" => $_REQUEST["id"]);
$sql = rtrim(file_get_contents('sql/clusters_fil_clusters.sql'));
$sql=stritr($sql,$p);
$r = $db->getOne($sql);
echo $r;




?>




