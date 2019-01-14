<?php

	InitRequestVar("exp_list_without_ts",0);
	InitRequestVar("exp_list_only_ts",0);
	InitRequestVar("eta_list",$_SESSION["h_eta"]);
	InitRequestVar("sd",$now);
	InitRequestVar("ed",$now);
	InitRequestVar("by_who",'eta');
	InitRequestVar("rep_type",'brief');
//	InitRequestVar("rep_type",'detailed');
	//InitRequestVar("show_desc",0);
	InitRequestVar("stand_type",'all');
	$params=array(
		':dpt_id' => $_SESSION["dpt_id"],
		':tn'=>$tn,
		':eta_list' => "'".$_REQUEST["eta_list"]."'",
		':sd' => "'".$_REQUEST["sd"]."'",
		':ed' => "'".$_REQUEST["ed"]."'",
		':exp_list_without_ts' => $_REQUEST["exp_list_without_ts"],
		':exp_list_only_ts' => $_REQUEST["exp_list_only_ts"],
		':by_who'=>"'".$_REQUEST['by_who']."'",
		':stand_type'=>"'".$_REQUEST['stand_type']."'",

        ':region_list' => "'".$_REQUEST["region_list"]."'",
        ':ok_st_tm' => 1, /*2 - стандарт засчитан ТМ-ом (А)*/
        ':zst' => 1, /*2 - все ТП со стандартом А*/

        ':ok_ts' => 2,
		':ok_auditor' => 1,
		':st_ts' => 2,
		':st_auditor' => 1,
		':standart' => 3 /* стандарт В*/
	);
	if($_REQUEST['show_desc'] == 1){
        $params[':eta_list'] = "'".$_REQUEST['h_tn']."'";
        $sql_file_all = false;
        /* отобразить детальный отчет по Выбранному  стандарту и выбранному ЭТА | ТС | ТМ | РМ */
    }
	$sql = rtrim(file_get_contents('sql/exp_list_from_parent_only_ts.sql'));
	$sql=stritr($sql,$params);
	$exp_list_only_ts = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('exp_list_only_ts', $exp_list_only_ts);
	$sql = rtrim(file_get_contents('sql/exp_list_from_parent_without_ts.sql'));
	$sql=stritr($sql,$params);
	$exp_list_without_ts = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('exp_list_without_ts', $exp_list_without_ts);
	$sql = rtrim(file_get_contents('sql/a14to_eta_list.sql'));
	$sql=stritr($sql,$params);
	$eta_list = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('eta_list', $eta_list);

	if (isset($_REQUEST['generate']))
	{
        $sql_file_all = false;
        switch ($_REQUEST['stand_type']) {
            case "all":
                $sql_file_all = true;
                break;
            case "a": /*sttotp*/
                $params[':brief']=rtrim(file_get_contents('sql/a18to_stat_brief.sql'));
                $sql_file = "sql/a18to_stat_";
                break;
            case "b":
                $sql_file = "sql/a14to_stat2et_";
                break;
            case "coffee":
                $sql_file = "sql/a16cost_";
                break;
            case "sh":
                $sql_file = "sql/standSHst_";
                break;
        }

	    if ($sql_file_all) //$_REQUEST["rep_type"]=="brief")
		{
		    //standart A
            $sql=rtrim(file_get_contents('sql/a18to_stat_'.$_REQUEST['by_who'].'.sql'));
            $params[':brief']=rtrim(file_get_contents('sql/a18to_stat_brief.sql'));
            $sql=stritr($sql,$params);
            $sql=stritr($sql,$params);
            $st_a = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
            $sql=rtrim(file_get_contents('sql/a18to_stat_'.'total.sql'));
            $sql=stritr($sql,$params);
            $sql=stritr($sql,$params);
            $st_a_t = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
            //standart B
            $sql=rtrim(file_get_contents('sql/a14to_stat2et_'.$_REQUEST['by_who'].'.sql'));
            $sql=stritr($sql,$params);
            $sql=stritr($sql,$params);
            $st_b = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
            $sql=rtrim(file_get_contents('sql/a14to_stat2et_'.'total.sql'));
            $sql=stritr($sql,$params);
            $sql=stritr($sql,$params);
            $st_b_t = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
            //standart Coffee
            $sql=rtrim(file_get_contents('sql/a16cost_'.$_REQUEST['by_who'].'.sql'));
            $sql=stritr($sql,$params);
            $st_c = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
            $sql=rtrim(file_get_contents('sql/a16cost_'.'total.sql'));
            $sql=stritr($sql,$params);
            $sql=stritr($sql,$params);
            $st_c_t = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
            //standart Sh
            $sql=rtrim(file_get_contents('sql/standSHst_'.$_REQUEST['by_who'].'.sql'));
            $sql=stritr($sql,$params);
            $st_sh = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
            $sql=rtrim(file_get_contents('sql/standSHst_'.'total.sql'));
            $sql=stritr($sql,$params);
            $sql=stritr($sql,$params);
            $st_sh_t = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

            foreach ($st_a as $k=>$v) {$d[$v['key']]['st_a']=$v;}
            foreach ($st_b as $k=>$v) {$d[$v['key']]['st_b']=$v;}
            foreach ($st_c as $k=>$v) {$d[$v['key']]['st_c']=$v;}
            foreach ($st_sh as $k=>$v) {$d[$v['key']]['st_sh']=$v;}

            $tt['st_a']=$st_a_t;
            $tt['st_b']=$st_b_t;
            $tt['st_c']=$st_c_t;
            $tt['st_sh']=$st_sh_t;

            foreach ($d as $key => $item) {
//                if($_REQUEST['by_who'] != "tm" && $_REQUEST['by_who'] != "rm"){
                    $d[$key]['h_tn'] = GetVal($item,'key');
//                }else if ($_REQUEST['by_who'] == "tm"){
//                    $d[$key]['h_tn'] = GetVal($item,'tn_tm');
//                }else{
//                    $d[$key]['h_tn'] = GetVal($item,'tn_rm');
//                }
                $d[$key]['eta_tab_number'] = GetVal($item,'eta_tab_number');
                $d[$key]['fio_eta'] = GetVal($item,'fio_eta');
                $d[$key]['tab_num_ts'] = GetVal($item,'tab_num_ts');
                $d[$key]['fio_ts'] = GetVal($item,'fio_ts');
                $d[$key]['tab_num_tm'] = GetVal($item,'tab_num_tm');
                $d[$key]['fio_tm'] = GetVal($item,'fio_tm');
                $d[$key]['tab_num_rm'] = GetVal($item,'tab_num_rm');
                $d[$key]['fio_rm'] = GetVal($item,'fio_rm');
            }
            echo "<pre style='display: none;text-align: left;'>";
            print_r($d);
            echo "</pre>";
            $smarty->assign('d', $d);
            $smarty->assign('tt', $tt);
		}
		else if(!$sql_file_all){
            $sql=rtrim(file_get_contents($sql_file.$_REQUEST['by_who'].'.sql'));
            $sql=stritr($sql,$params);
            $sql=stritr($sql,$params);
            $t = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
            $smarty->assign('d', $t);
        }
        if (!$sql_file_all){
            $sql=rtrim(file_get_contents($sql_file.'total.sql'));
            $sql=stritr($sql,$params);
            $sql=stritr($sql,$params);
            $t = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
            $smarty->assign('tt', $t);
        }

	}
	$smarty->display('standTotal.html');

	function GetVal($item,$field){
        if($item['st_a'][$field] != ""){
            return $item['st_a'][$field];
        }else if($item['st_b'][$field]  != ""){
            return $item['st_b'][$field];
        }
        else if($item['st_c'][$field]  != ""){
            return $item['st_c'][$field];
        }
        else if($item['st_sh']['tab_num_tm']  != ""){
            return $item['st_sh'][$field];
        }else{
            return "-";
        }
    }
?>