<?


//ses_req();


audit("открыл mz_spr_mz","mz");

if (isset($_REQUEST["save"])&&isset($_REQUEST["data"]))
{
	foreach ($_REQUEST["data"] as $k=>$v)
	{
            foreach ($v as $k1=>$v1)
            {
                    if ($k1=="dataz")
                    $v[$k1]=init_data($v1);
            }
            Table_Update("mz_spr_mz", array("id"=>$k),$v);
	}
}



if (isset($_REQUEST["del"]))
{
    foreach ($_REQUEST["del"] as $k=>$v)
    {
        Table_Update("mz_spr_mz", array('id'=>$k),null);
    }
}

if (isset($_REQUEST["new"]))
{
	Table_Update("mz_spr_mz", array("name"=>$_REQUEST["new_name"]), array("name"=>$_REQUEST["new_name"]));
}

$sql=rtrim(file_get_contents('sql/mz_spr_mz.sql'));
$mz_spr_mz = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('mz_spr_mz', $mz_spr_mz);
$smarty->display('mz_spr_mz.html');

?>