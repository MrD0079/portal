<?

if (isset($_REQUEST["new_staff"]))
{
	$x1 = $db->getOne("select count(*) from new_staff where svideninn = ".$_REQUEST["new_staff"]["svideninn"]);
	$x2 = $db->getOne("select count(*) from user_list where tn = ".$_REQUEST["new_staff"]["svideninn"]);
	$new_pos_name = $db->getOne("select pos_name from pos where pos_id = ".$_REQUEST["new_staff"]["pos_id"]);
	$_REQUEST["new_staff"]["creator"]=$tn;
	$ds=$_REQUEST["new_staff"]["datastart"];

	if (($x1+$x2)==0)
	{
		$id=get_new_id();
		$_REQUEST["new_staff"]["datastart"]=OraDate2MDBDate($_REQUEST["new_staff"]["datastart"]);
		$_REQUEST["new_staff"]["limitkom"]=str_replace(",", ".", $_REQUEST["new_staff"]["limitkom"]);
		$_REQUEST["new_staff"]["limittrans"]=str_replace(",", ".", $_REQUEST["new_staff"]["limittrans"]);
		$_REQUEST["new_staff"]["limit_car_vol"]=str_replace(",", ".", $_REQUEST["new_staff"]["limit_car_vol"]);
		$_REQUEST["new_staff"]["gbo_installed"]=$_REQUEST["new_staff"]["gbo_installed"];
		$_REQUEST["new_staff"]["dpt_id"]=$_SESSION["dpt_id"];
		$_REQUEST["new_staff"]["id"]=$id;
		$d1="new_staff_files";
		if (!file_exists($d1)) {mkdir($d1);}
		foreach ($_FILES as $k=>$v)
		{
                        $fn=get_new_file_id()."_".translit($v["name"]);
			if (is_uploaded_file($v['tmp_name'])){
                            move_uploaded_file($v["tmp_name"], $d1."/".$fn);
                            
                        }
			$_REQUEST["new_staff"][$k]=$fn;
		}

		Table_Update("new_staff",$_REQUEST["new_staff"],$_REQUEST["new_staff"]);

		if (isset($_REQUEST['childs']))
		{
			foreach($_REQUEST['childs'] as $k=>$v)
			{
				$keys = array('id'=>get_new_id(),'parent'=>$id);
				$vals = array('tn'=>$v);
				Table_Update("new_staff_childs",$keys,$vals);
			}
		}

		if (isset($_REQUEST['bud_fil']))
		{
			foreach($_REQUEST['bud_fil'] as $k=>$v)
			{
				$keys = array('id'=>get_new_id(),'parent'=>$id);
				$vals = array('fil'=>$v);
				Table_Update("new_staff_bud_fil",$keys,$vals);
			}
		}
        
		$creator_fio=$db->getOne("select fio from user_list where tn=".$_REQUEST["new_staff"]["creator"]);
		$res=$db->getAll("SELECT e_mail FROM user_list WHERE is_admin = 1 AND e_mail IS NOT NULL AND tn <> 2885600038", null, null, null, MDB2_FETCHMODE_ASSOC);
		foreach($res as $k=>$v)
		{
			$subj="Поступила заявка на добавление нового сотрудника";
			$text="Здравствуйте.<br>";
			$text.="Поступила заявка на добавление нового сотрудника<br>";
			$text.="Ф.И.О. новичка: ".$_REQUEST["new_staff"]["fam"]." ".$_REQUEST["new_staff"]["im"]." ".$_REQUEST["new_staff"]["otch"]."<br>";
			$text.="Должность новичка: ".$new_pos_name."<br>";
			$text.="Ф.И.О. подавшего заявку: ".$creator_fio."<br>";
			$text.="Дата начала работы: ".$ds."<br>";
			$text.="Страна: ".$_SESSION["cnt_name"]."<br>";
			$text.="ИНН: ".$_REQUEST["new_staff"]["svideninn"]."<br>";
			$text.="Лимит ком.: ".$_REQUEST["new_staff"]["limitkom"]."<br>";
			$text.="Лимит транс.: ".$_REQUEST["new_staff"]["limittrans"]."<br>";
			$text.="Лимит транс., л: ".$_REQUEST["new_staff"]["limit_car_vol"]."<br>";
                        $gbo_installed = $_REQUEST["new_staff"]["gbo_installed"]==1?'да':'нет';
			$text.="Установлено ГБО: ".$gbo_installed."<br>";
			$text.="Марка авто: ".$_REQUEST["new_staff"]["car_brand"]."<br>";
			$text.="Адрес e-mail: ".$_REQUEST["new_staff"]["email"]."<br>";
			$text.="Прямые подчиненные нового сотрудника:<br>";
			if (isset($_REQUEST['childs']))
			{
				foreach($_REQUEST['childs'] as $k1=>$v1)
				{
					$x=$db->getOne("select fio from user_list where tn=".$v1);
					$text.=$x."<br>";
				}
			}
			send_mail($v["e_mail"],$subj,$text,null);
		}
	}
	else
	{
		$creator_fio=$db->getOne("select fio from user_list where tn=".$_REQUEST["new_staff"]["creator"]);
		$res=$db->getAll("select e_mail from user_list where is_admin=1 and e_mail is not null", null, null, null, MDB2_FETCHMODE_ASSOC);
		foreach($res as $k=>$v)
		{
			$subj="Поступила ОШИБОЧНАЯ заявка на добавление нового сотрудника!";
			$text="Здравствуйте.<br>";
			$text.="Поступила ОШИБОЧНАЯ заявка на добавление нового сотрудника, т.к. сотрудник с таким ИНН уже есть в базе!<br>";
			$text.="Ф.И.О. новичка: ".$_REQUEST["new_staff"]["fam"]." ".$_REQUEST["new_staff"]["im"]." ".$_REQUEST["new_staff"]["otch"]."<br>";
			$text.="Должность новичка: ".$new_pos_name."<br>";
			$text.="Ф.И.О. подавшего заявку: ".$creator_fio."<br>";
			$text.="Дата начала работы: ".$ds."<br>";
			$text.="Страна: ".$_SESSION["cnt_name"]."<br>";
			$text.="ИНН: ".$_REQUEST["new_staff"]["svideninn"]."<br>";
			$text.="Лимит ком.: ".$_REQUEST["new_staff"]["limitkom"]."<br>";
			$text.="Лимит транс.: ".$_REQUEST["new_staff"]["limittrans"]."<br>";
			$text.="Лимит транс., л: ".$_REQUEST["new_staff"]["limit_car_vol"]."<br>";
                        $gbo_installed = $_REQUEST["new_staff"]["gbo_installed"]==1?'да':'нет';
			$text.="Установлено ГБО: ".$gbo_installed."<br>";
			$text.="Марка авто: ".$_REQUEST["new_staff"]["car_brand"]."<br>";
			$text.="Адрес e-mail: ".$_REQUEST["new_staff"]["email"]."<br>";
			send_mail($v["e_mail"],$subj,$text,null);
		}
		$_REQUEST["new_staff"] = null;
		$smarty->assign('error', 1);
	}
}

$p = array(':tn' => $tn,':dpt_id' => $_SESSION["dpt_id"]);

$sql=rtrim(file_get_contents('sql/dolgn_list.sql'));
$sql=stritr($sql,$p);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('dolgn_list_all', $data);

$sql=rtrim(file_get_contents('sql/bt_list.sql'));
$sql=stritr($sql,$p);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('bt_list', $data);

$sql=rtrim(file_get_contents('sql/new_staff_childs.sql'));
$sql=stritr($sql,$p);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('childs', $data);

$sql=rtrim(file_get_contents('sql/bud_fil.sql'));
$sql=stritr($sql,$p);
$bud_fil = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('bud_fil', $bud_fil);

$smarty->display('new_staff.html');

?>