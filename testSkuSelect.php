<?php
include "SkuSelect.php";
$skuObj = new \SkuSelect\SkuSelect($db);
$smarty->assign('skuObj', $skuObj);

$smarty->display('testSkuSelect.html');