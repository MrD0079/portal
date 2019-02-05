<?php
if (isset($_REQUEST["save"]))
{
        $_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);
	$keys = array(
            'visitdate'=>OraDate2MDBDate($_REQUEST['visitdate']),
            'tp_kod'=>$_REQUEST['tp_kod'],
            'h_name_to'=>$_REQUEST['h_name_to']
        );

	if ($_REQUEST['field1']=='undefined')
        {
            $vals = array($_REQUEST['field'] => $_REQUEST['val']);
        }
        else
        {
            $vals = array($_REQUEST['field'] => $_REQUEST['val'],$_REQUEST['field1'] => $_REQUEST['val1']);
        }


	Table_Update('a18totp', $keys,$vals);
    print_r($vals);

}
else
{
	InitRequestVar("exp_list_without_ts",0);
	InitRequestVar("exp_list_only_ts",0);
	InitRequestVar("eta_list",$_SESSION["h_eta"]);
	InitRequestVar("sd",$now);
	InitRequestVar("ed",$now);
	InitRequestVar("ok_photo",1);
	InitRequestVar("ok_visit",1);
	InitRequestVar("ok_ts",1);
	InitRequestVar("ok_auditor",1);
	InitRequestVar("st_ts",1);
	InitRequestVar("st_auditor",1);
	$params=array(
		':dpt_id' => $_SESSION["dpt_id"],
		':tn'=>$tn,
		':ok_photo' => $_REQUEST["ok_photo"],
		':ok_visit' => $_REQUEST["ok_visit"],
		':ok_ts' => $_REQUEST["ok_ts"],
		':ok_auditor' => $_REQUEST["ok_auditor"],
		':st_ts' => $_REQUEST["st_ts"],
		':st_auditor' => $_REQUEST["st_auditor"],
		':eta_list' => "'".$_REQUEST["eta_list"]."'",
		':sd' => "'".$_REQUEST["sd"]."'",
		':ed' => "'".$_REQUEST["ed"]."'",
		':exp_list_without_ts' => $_REQUEST["exp_list_without_ts"],
		':exp_list_only_ts' => $_REQUEST["exp_list_only_ts"]
	);
	$sql = rtrim(file_get_contents('sql/exp_list_from_parent_only_ts.sql'));
	$sql=stritr($sql,$params);
	$exp_list_only_ts = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('exp_list_only_ts', $exp_list_only_ts);
	$sql = rtrim(file_get_contents('sql/exp_list_from_parent_without_ts.sql'));
	$sql=stritr($sql,$params);
	$exp_list_without_ts = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('exp_list_without_ts', $exp_list_without_ts);
	$sql = rtrim(file_get_contents('sql/a18to_eta_list.sql'));
	$sql=stritr($sql,$params);
	$eta_list = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('eta_list', $eta_list);
	if (isset($_REQUEST['generate']))
	{
		$sql=rtrim(file_get_contents('sql/a18to_accept.sql'));
		$sql=stritr($sql,$params);
		//echo $sql.";";

		$d = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
//        echo "<pre style='display: none;text-align: left;'>";
//        print_r($d);
//        echo $sql;
//        echo "</pre>";
		foreach($d as $k=>$v)
		{
			$sql="
                              SELECT DISTINCT t.name_to,
                                              t.h_name_to,
                                              t.type_standart type_standart_def,
                                              t.h_type_standart h_type_standart_def,
                                              ats.type_standart,
                                              s.h_type_standart,
                                              s.ts,
                                              s.ts_comm,
                                              s.auditor,
                                              s.auditor_comm,
                                              s.traid_comm,
                                              s.traid,
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
                                     AND CASE
                                            WHEN    :ok_ts = 1
                                                 OR (    :ok_ts = 2
                                                     AND s.visitdate IS NOT NULL
                                                     AND s.ts IS NOT NULL)
                                                 OR ( :ok_ts = 3 AND s.ts IS NULL)
                                            THEN
                                               1
                                            ELSE
                                               0
                                         END = 1
                                     AND CASE
                                            WHEN    :ok_auditor = 1
                                                 OR (    :ok_auditor = 2
                                                     AND s.visitdate IS NOT NULL
                                                     AND s.auditor IS NOT NULL)
                                                 OR ( :ok_auditor = 3 AND s.auditor IS NULL)
                                            THEN
                                               1
                                            ELSE
                                               0
                                         END = 1
                                     AND CASE
                                            WHEN    :st_ts = 1
                                                 OR ( :st_ts = 2 AND s.visitdate IS NOT NULL AND s.ts = 1)
                                                 OR ( :st_ts = 3 AND s.visitdate IS NOT NULL AND s.ts = 2)
                                            THEN
                                               1
                                            ELSE
                                               0
                                         END = 1
                                     AND CASE
                                            WHEN    :st_auditor = 1
                                                 OR (    :st_auditor = 2
                                                     AND s.visitdate IS NOT NULL
                                                     AND s.auditor = 1)
                                                 OR (    :st_auditor = 3
                                                     AND s.visitdate IS NOT NULL
                                                     AND s.auditor = 2)
                                            THEN
                                               1
                                            ELSE
                                               0
                                         END = 1
                            ORDER BY t.name_to, t.type_standart";
			$params[':tp_kod']=$v['tp_kod_key'];
			$params[':dt']="'".$v['vd']."'";
			$sql=stritr($sql,$params);
			//echo $sql.";";
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
		$sql=rtrim(file_get_contents('sql/a18to_accept_total.sql'));
		$sql=stritr($sql,$params);
		$t = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
		$smarty->assign('t', $t);
		$sql=rtrim(file_get_contents('sql/a18to_accept_total1.sql'));
		$sql=stritr($sql,$params);
		$t1 = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
		$smarty->assign('t1', $t1);
                //echo $sql;
	}
	$smarty->display('a18to_accept.html');
}
?>