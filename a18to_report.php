<?php
if (isset($_REQUEST["save"]))
{
	$_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);
	$keys = array(
            'visitdate'=>OraDate2MDBDate($_REQUEST['visitdate']),
            'tp_kod'=>$_REQUEST['tp_kod'],
            'h_name_to'=>$_REQUEST['h_name_to']
        );
	$vals = array($_REQUEST['field']=>$_REQUEST['val']);
	Table_Update('a18totp', $keys,$vals);
}
else
{
	InitRequestVar("ok_photo",1);
	InitRequestVar("ok_visit",1);
	InitRequestVar("eta_list",$_SESSION["h_eta"]);
	InitRequestVar("dt",$now);
	$params=array(
		':dpt_id' => $_SESSION["dpt_id"],
		':tn'=>$tn,
		':ok_photo' => $_REQUEST["ok_photo"],
		':ok_visit' => $_REQUEST["ok_visit"],
		':eta_list' => "'".$_REQUEST["eta_list"]."'",
		':dt' => "'".$_REQUEST["dt"]."'",
	);
	$sql = rtrim(file_get_contents('sql/a18to_eta_list.sql'));
	$sql=stritr($sql,$params);
	$eta_list = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('eta_list', $eta_list);
	if (isset($_REQUEST['generate']))
	{
		$sql=rtrim(file_get_contents('sql/a18to_report.sql'));
		$sql=stritr($sql,$params);
		$d = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
		//echo $sql;
		foreach($d as $k=>$v)
		{
			$sql="
/* Formatted on 05/08/2018 23:50:18 (QP5 v5.252.13127.32867) */
  SELECT DISTINCT t.name_to,
                  t.h_name_to,
                  t.type_standart type_standart_def,
                  t.h_type_standart h_type_standart_def,
                  ats.type_standart,
                  s.h_type_standart,
                  s.ts,
                  s.ts_comm,
                  s.auditor,
                  TO_CHAR (s.auditor_lu, 'dd.mm.yyyy hh24:mi:ss') auditor_lu,
                  s.auditor_fio,
                  s.tasks_assort,
                  s.tasks_mr
    FROM a18to t, a18totp s, a18to_type_standart ats
   WHERE     t.tp_kod_key = :tp_kod
         AND t.visitdate = TO_DATE ( :dt, 'dd.mm.yyyy')
         AND t.visitdate = s.visitdate(+)
         AND t.tp_kod_key = s.tp_kod(+)
         AND t.h_name_to = s.h_name_to(+)
         AND s.h_type_standart = ats.h_type_standart(+)
ORDER BY t.name_to, t.type_standart";
			$params[':tp_kod']=$v['tp_kod_key'];
			$sql=stritr($sql,$params);
			//echo $sql;
                        $cto = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
                        foreach($cto as $k1=>$v1)
                        {
                                $sql="
                                  SELECT url,h_url
                                    FROM a18to t
                                   WHERE     t.tp_kod_key = :tp_kod
                                         AND t.visitdate = TO_DATE ( :dt, 'dd.mm.yyyy')
                                         AND t.h_name_to = :h_name_to
                                         AND t.url IS NOT NULL";
                                $params[':h_name_to']="'".$v1['h_name_to']."'";
                                $sql=stritr($sql,$params);
                                //echo $sql;
                                $photos = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
                                $cto[$k1]['cnt']=count($photos);
                                $cto[$k1]['photos'] = $photos;
                        }
                        $d[$k]['cto']['cnt']=count($cto);
                        $d[$k]['cto']['data'] = $cto;
		}
		$smarty->assign('d', $d);
		//print_r($d);
	}
	$sql="SELECT * FROM A18TO_type_standart order by type_standart";
	$type_standart = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('type_standart', $type_standart);
	$smarty->display('a18to_report.html');
}
?>