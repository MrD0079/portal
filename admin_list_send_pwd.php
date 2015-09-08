<?
$rtn = $_REQUEST['tn'];
$sql="SELECT NVL (fn_getname ( su.tn), su.login) fio, su.login, su.password, st.email FROM spr_users su, spdtree st WHERE su.tn = ".$rtn." AND su.tn = st.svideninn";
$d = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$subj="Напоминание логина/пароля для работы на корпоративном портале";
$text="Здравствуйте, ".$d['fio'].".<br>";
$text.="Для работы с корпоративным порталом используйте следующие данные:<br>";
$text.="Адрес сайта:<br>";
$text.="<a href=\"https://ps.avk.ua\">https://ps.avk.ua</a><br>";
$text.="<a href=\"https://ps2.avk.ua\">https://ps2.avk.ua</a><br>";
$text.="Логин: ".$d['login']."<br>";
$text.="Пароль: ".$d['password']."<br>";
send_mail($d['email'],$subj,$text,null,false);
echo '<img src="/design/ok.png">';
?>