<?



$d = $db->getAll('SELECT f.*, u.fio    FROM fartuk_ua f, user_list u   WHERE f.tn = u.tn ORDER BY u.fio', null, null, null, MDB2_FETCHMODE_ASSOC);




foreach ($d as $k => $v)

{

$d1="fartuk_ua_files/".$v["tn"];

$file_list=array();
		if (is_dir($d1))
		{
		if ($handle = opendir($d1)) {
			while (false !== ($file = readdir($handle)))
			{
				if ($file != "." && $file != "..") {$file_list[] = array("path"=>$d1,"file"=>$file);}
			}
			closedir($handle);
		}
		}

		isset($file_list)?$d[$k]['fl'] = $file_list:null;









}




//print_r($d);



$smarty->assign('d', $d);

$dt = $db->getRow('SELECT SUM (f.far_poluch) far_poluch,         SUM (f.far_vidano) far_vidano,         SUM (f.summa_act) summa_act,         SUM (f.count_tp) count_tp,         COUNT (*) c    FROM fartuk_ua f, user_list u   WHERE f.tn = u.tn ORDER BY u.fio', null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('dt', $dt);




$smarty->display('fartuk_ua_report.html');





?>