<?

ini_set('display_errors',0);
error_reporting(E_ALL^E_STRICT^E_DEPRECATED);
putenv("NLS_LANG=RUSSIAN_CIS.CL8MSWIN1251");

require_once "function.php";
require_once "local_functions.php";
require_once 'MDB2.php';
$dsn = 'oci8://persik:razvitie@'.ZAOIBM;
$db =& MDB2::connect($dsn);
$db->loadModule('Extended');
$db->loadModule('Function');


$handle = @fopen("act.csv", "r");
while
(
(
//$buffer = fgets($handle, 4096)
$buffer = stream_get_line($handle,65535,"\r\n")
) !== false
)
{
$vals=split(';',$buffer);
$v1=array();
foreach ($vals as $k=>$v)
{
$v1['f'.($k+1)]=$v;
}
$affectedRows = $db->extended->autoExecute('a1', $v1, MDB2_AUTOQUERY_INSERT);
if (PEAR::isError($affectedRows))
{
$x = $affectedRows->getUserInfo() . "\n" . $affectedRows->getMessage() . "\n" . $affectedRows->getDebugInfo();
echo mb_convert_encoding($x,"Windows-1251","UTF-8")."\n";
}
}
if (!feof($handle)) {
echo "Error: unexpected fgets() fail\n";
}
fclose($handle);

?>