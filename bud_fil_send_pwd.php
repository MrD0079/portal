<?
$p = array(":fil" => $_REQUEST['fil']);
$sql=rtrim(file_get_contents('sql/bud_fil_send_pwd.sql'));
$sql=stritr($sql,$p);
$d = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$subj="����������� ������/������ ��� ������ �� ������������� �������";
$text="������������, ".$d['name'].".<br>";
$text.="��� ������ � ������������� �������� ����������� ��������� ������:<br>";
$text.="����� �����:<br>";
$text.="<a href=\"https://ps.avk.ua\">https://ps.avk.ua</a><br>";
$text.="<a href=\"https://ps2.avk.ua\">https://ps2.avk.ua</a><br>";
$text.="�����: ".$d['login']."<br>";
$text.="������: ".$d['password']."<br>";
send_mail($d['delivery'],$subj,$text,null,false);
echo '<img src="/design/ok.png">';
?>