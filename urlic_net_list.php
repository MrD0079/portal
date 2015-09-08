<?
if ($_REQUEST["id_net"]!=null)
{
$sql=rtrim(file_get_contents('sql/urlic_net_list.sql'));
$p = array(':id_net' => $_REQUEST["id_net"]);
$sql=stritr($sql,$p);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
echo "<option></option>";
foreach ($data as $k=>$v)
{
if ($v["id_net"]!=null)
{
echo "<option value=".$v["id"].">".$v["name"]."</option>";
}
}
}
?>