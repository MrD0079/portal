<?
$rtn = $_REQUEST['tn'];

$new_pwd = $db->getOne("SELECT DBMS_RANDOM.STRING ('A', 6) FROM DUAL");

$sql="UPDATE SPR_USERS SET PASSWORD = '".$new_pwd."' where tn= ".$rtn;
$db->query($sql);
echo $new_pwd;
//echo '<img src="/design/ok.png">';
?>