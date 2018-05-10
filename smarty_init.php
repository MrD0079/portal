<?php
//require('/home/httpd/server2/Smarty/libs/Smarty.class.php');
mb_internal_encoding("windows-1251");
define('SMARTY_RESOURCE_CHAR_SET', 'windows-1251');
require('Smarty3/libs/Smarty.class.php');
$smarty = new Smarty;
//$smarty->debugging=true;
//$smarty->config_dir   = 'c:/web/smarty/configs/';
//$smarty->cache_dir    = 'c:/php/smarty/cache/';
$smarty->compile_dir  = 'templates_c/';
$smarty->template_dir = 'tpl/';
//$smarty->escape_html = true;
//$smarty->default_modifiers = array('escape:"htmlall"');
//$smarty->assign('name','fish boy!');
//$smarty->display('index.html');
?>