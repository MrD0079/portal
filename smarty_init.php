<?php
//require('/home/httpd/server2/Smarty/libs/Smarty.class.php');
require('Smarty/libs/Smarty.class.php');
$smarty = new Smarty;
//$smarty->debugging=true;
//$smarty->config_dir   = 'c:/web/smarty/configs/';
//$smarty->cache_dir    = 'c:/php/smarty/cache/';
$smarty->compile_dir  = 'templates_c/';
$smarty->template_dir = 'tpl/';
//$smarty->assign('name','fish boy!');
//$smarty->display('index.html');
?>