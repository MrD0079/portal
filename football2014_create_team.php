<?

audit ("открыл форму редактирования команд","football");

//ses_req();


if (isset($_REQUEST["save"])&&isset($_REQUEST["data"]))
{
	foreach ($_REQUEST["data"] as $k=>$v)
	{
		Table_Update("football_teams", array("id"=>$k),$v);
	}
}

/*
if (isset($_REQUEST["sogl"]))
{
	foreach ($_REQUEST["sogl"] as $k=>$v)
	{
		Table_Update("football_teams", array("id"=>$k),array("status"=>15597782));
		$mail_checking = $db->getOne("SELECT e_mail FROM user_list WHERE tn = (SELECT tn_checking FROM football_teams WHERE id = ".$k.")");
		$fio_responsible = $db->getOne("SELECT fio FROM user_list WHERE tn = (SELECT tn_responsible FROM football_teams WHERE id = ".$k.")");
		$sql = "SELECT ft.gruppa, ft.region, d.dpt_name FROM football_teams ft, departments d WHERE ft.id = ".$k." AND ft.dpt_id = d.dpt_id(+)";
		$r = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);


		После формирования команды ответственный направляет запрос проверяющему на согласование группы.
		При нажатии на кнопку проверяющему формируется письмо:
		Тема: Подтверждение команды футбольного турнира $год, команда $Страна $группа $(область/регион).
		Текст: $ответственный сформировал команду $Страна $группа $(область/регион). Просьба перейти по <a>ссылке</a> для ее подтверждения.
		Письмо отправляется каждый раз при нажатии на кнопку, при этом на форме выводится сообщение, что письмо отправлено.

		$subj = "Подтверждение команды футбольного турнира, ".$r["dpt_name"]." ".$r["gruppa"]." ".$r["region"];
		$text = $fio_responsible." сформировал команду ".$r["dpt_name"]." ".$r["gruppa"]." ".$r["region"]."<br>Просьба перейти по <a href=\"https://ps.avk.ua/?action=football_create_team\">ссылке</a> для ее подтверждения.";

		send_mail($mail_checking,$subj,$text);




	}
}
*/

if (isset($_REQUEST["member_save"])&&isset($_REQUEST["member_data"]))
{
	foreach ($_REQUEST["member_data"] as $k=>$v)
	{
		isset($v['birthday']) ? $v['birthday'] = OraDate2MDBDate($v['birthday']) : null;
		Table_Update("football_teams_members", array("id"=>$k),$v);
	}
}

if (isset($_REQUEST["member_del"]))
{
	foreach ($_REQUEST["member_del"] as $k=>$v)
	{
		$db->extended->autoExecute("football_teams_members", null, MDB2_AUTOQUERY_DELETE, "id=".$k);
	}
}

if (isset($_REQUEST["member_new"]))
{
	isset($_REQUEST["member_data_new"]['birthday']) ? $_REQUEST["member_data_new"]['birthday'] = OraDate2MDBDate($_REQUEST["member_data_new"]['birthday']) : null;


if (isset($_FILES["member_data_new"]))
{
include_once('SimpleImage.php');
$d4="football_teams_members_files";
$z = $_FILES["member_data_new"];
if (is_uploaded_file($z["tmp_name"]["photo"]))
{
	$a=pathinfo($z["name"]["photo"]);
	$fn="ftmf".get_new_file_id().".".$a["extension"];
	move_uploaded_file($z["tmp_name"]["photo"], $d4."/".$fn);
	$image = new SimpleImage();
	$image->load($d4."/".$fn);
	$h=$image->getHeight();
	if ($image->getHeight()>600)
	{
	$image->resizeToHeight(600);
	}
	$image->save($d4."/".$fn);
	$_REQUEST["member_data_new"]["photo"]=$fn;
}
}





	Table_Update("football_teams_members", $_REQUEST["member_data_new"],$_REQUEST["member_data_new"]);
}



if (isset($_FILES["member_data"]))
{
include_once('SimpleImage.php');
$d4="football_teams_members_files";
$z = $_FILES["member_data"];
foreach ($z['tmp_name'] as $k=>$v)
{
	if (is_uploaded_file($z["tmp_name"][$k]))
	{
		$a=pathinfo($z["name"][$k]);
		$fn="ftmf".$k.".".$a["extension"];
		move_uploaded_file($z["tmp_name"][$k], $d4."/".$fn);
		$image = new SimpleImage();
		$image->load($d4."/".$fn);
		$h=$image->getHeight();
		if ($image->getHeight()>600)
		{
		$image->resizeToHeight(600);
		}
		$image->save($d4."/".$fn);
		$keys = array("id"=>$k);
		$vals = array("photo"=>$fn);
		Table_Update ("football_teams_members", $keys, $vals);
	}
}
}










$p = array();
$p[':dpt_id'] = $_SESSION["dpt_id"];
$p[':tn'] = $tn;

$sql = rtrim(file_get_contents('sql/emp_exp_spd_list.sql'));
$sql=stritr($sql,$p);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('spd_list', $data);

$sql = rtrim(file_get_contents('sql/football_team_status.sql'));
$sql=stritr($sql,$p);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('status_list', $data);

$sql = rtrim(file_get_contents('sql/football_create_team.sql'));
$sql=stritr($sql,$p);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('football_teams', $data);


if (isset($_REQUEST["team_id"]))
{
$p = array();
$p[':team_id'] = $_REQUEST["team_id"];
$sql = rtrim(file_get_contents('sql/football_create_team_members.sql'));
$sql=stritr($sql,$p);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('football_team_members', $data);
}



$smarty->display('football_create_team.html');

?>