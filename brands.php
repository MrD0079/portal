<?php

if (isset($_REQUEST["save"])){
    audit("сохранил brands","brands");
    //$_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);

    foreach ($_REQUEST["brands"] as $id => $v)
    {
        $keys = array("brand_id"=>$id);
        $vals = array("status"=>intval($v));
        if ($v != null)
        {
            //echo var_dump(array("keys"=>$keys,"vals"=>$vals));
            Table_Update("sku_avk_brand",$keys,$vals);
        }
    }
}

audit("открыл brands","brands");
$sql=rtrim("SELECT b.* from persik.sku_avk_brand b ORDER BY b.name");

$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('brands', $data);

$smarty->display('brands.html');