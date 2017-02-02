<?php
ini_set('display_errors',0);
error_reporting(E_ALL^E_STRICT^E_DEPRECATED);
putenv("NLS_LANG=RUSSIAN_CIS.CL8MSWIN1251");
require_once "../function.php";
require_once "../local_functions.php";
require_once 'MDB2.php';
$dsn = 'oci8://persik:razvitie@'.ZAOIBM;
$db =& MDB2::connect($dsn);
$db->loadModule('Extended');
$db->loadModule('Function');

function table2json($table)
{
global $db;
$sql='SELECT * FROM '.$table;
$x=$db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$x = recursive_iconv ('Windows-1251', 'UTF-8', $x);
$s=json_encode($x, JSON_PRETTY_PRINT, JSON_NUMERIC_CHECK);
$f=fopen('output/table_'.$table.'.json',"w+");
fwrite($f,$s);
fclose($f);
}

table2json('routes_agents');
table2json('ms_nets');
table2json('cpp');

?>
