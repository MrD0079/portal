<?php
	InitRequestVar("exp_list_without_ts",0);
	InitRequestVar("exp_list_only_ts",0);
	InitRequestVar("eta_list",$_SESSION["h_eta"]);
	InitRequestVar("sd",$now);
	InitRequestVar("ed",$now);

	//InitRequestVar("date",$_SESSION["date"]);
	InitRequestVar("by_who",'eta');
	InitRequestVar("rep_type",'brief');
	InitRequestVar("sttype",0);
//	InitRequestVar("rep_type",'detailed');
	//InitRequestVar("show_desc",0);
	InitRequestVar("stand_type",'all');

	$date = explode("|",$_REQUEST["date"]);
//$_SESSION["date"] = $_REQUEST["date"];
	//$date = array($_SESSION["sd"],$_SESSION["ed"]);
	$params=array(
		':dpt_id' => $_SESSION["dpt_id"],
		':tn'=>$tn,
		':eta_list' => "'".$_REQUEST["eta_list"]."'",
		':sd' => "'".$date[0]."'",
		':ed' => "'".$date[1]."'",
		':exp_list_without_ts' => $_REQUEST["exp_list_without_ts"],
		':exp_list_only_ts' => $_REQUEST["exp_list_only_ts"],
		':by_who'=>"'".$_REQUEST['by_who']."'",
		':stand_type'=>"'".$_REQUEST['stand_type']."'",
        /* standart A arams*/
        ':region_list' => "'".$_REQUEST["region_list"]."'",
        ':ok_st_tm' => 1, /*2 - стандарт засчитан ТМ-ом (А)*/
        ':zst' => 1, /*2 - все ТП со стандартом А*/
        ':sttype' => $_REQUEST['sttype'], /* 0 - все, 1 - только А, 2 - только А(мин) */
        /* standart B params */
        ':ok_photo' => 1,
        ':ok_ts' => 1, /*2- ТС проверил*/
		':ok_auditor' => 1, /* аудитор - все*/
		':st_ts' => 2, /* 2 - ТС соответствует стандарту*/
		':st_auditor' => 1, /* все (соотв, не соответ) стандарту аудитор*/
		':ok_visit' => 1
	);
	//print_r($params);
	$is_show_desc = false;
	if($_REQUEST['show_desc'] == 1){
        $is_show_desc = true;
       // print_r($params);
    }

	if($is_show_desc){
        if($_REQUEST['by_who'] == 'eta'){
            $params[':eta_list'] = "'".$_REQUEST['h_tn']."'";
        }else{
            $params[':ok_st_tm'] = 2;
            $params[':ok_ts'] = 2;
            $params[':st_ts'] = 2;
            $params[':ok_ts'] = 2;
        }
        if($_REQUEST['by_who'] == 'ts'){
            $params[':exp_list_only_ts'] = $_REQUEST['h_tn'];
        }
        if($_REQUEST['by_who'] == 'tm'){
            $params[':exp_list_without_ts'] = $_REQUEST['h_tn'];
        }

        $_REQUEST['stand_type'] = $_REQUEST['stand'];
        /* отобразить детальный отчет по Выбранному  стандарту и выбранному ЭТА | ТС | ТМ | РМ */
    }else {
        $sql = rtrim(file_get_contents('sql/exp_list_from_parent_only_ts.sql'));
        $sql = stritr($sql, $params);
        $exp_list_only_ts = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
        $smarty->assign('exp_list_only_ts', $exp_list_only_ts);
        $sql = rtrim(file_get_contents('sql/exp_list_from_parent_without_ts.sql'));
        $sql = stritr($sql, $params);
        $exp_list_without_ts = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
        $smarty->assign('exp_list_without_ts', $exp_list_without_ts);
        $sql = rtrim(file_get_contents('sql/a14to_eta_list.sql'));
        $sql = stritr($sql, $params);
        $eta_list = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
        $smarty->assign('eta_list', $eta_list);
    }
	if (isset($_REQUEST['generate']) || $is_show_desc)
	{
        $sql_file_all = false;
        switch ($_REQUEST['stand_type']) {
            case "all":
                $sql_file_all = true;
                break;
            case "a": /*sttotp*/
                //if(!$is_show_desc)
                    //$params[':brief']=rtrim(file_get_contents('sql/a18to_stat_brief.sql'));
                $params[':brief']=rtrim(file_get_contents('sql/standA_brief.sql'));
                //$sql_file = "sql/a18to_stat_";
                $sql_file = "sql/standA_stat_";
                $stand_title = "А";
                if(isset($_REQUEST['sttype']) && $_REQUEST['sttype'] == 2)
                    $stand_title .= " (минимум)";
                //$standT = "a18to";
                $standT = "standA";
                break;
            /*case "b":
                $sql_file = "sql/a14to_stat_";
                $stand_title = "В";
                $standT = "a14to";
                break;*/
            case "b":
                $sql_file = "sql/standBst_";
                $stand_title = "B";
                $standT = "standB";
                break;
            case "coffee":
                $sql_file = "sql/a16cost_";
                $stand_title = "Кофе";
                $standT = "a16co";
                break;
            case "sh":
                $sql_file = "sql/standSHst_";
                $stand_title = "Штучка";
                $standT = "standSH";
                break;
        }

	    if ($sql_file_all)
		{
		    //standart A

            echo "<pre style='display: none;text-align: left;'>";
            if($_REQUEST['by_who'] == "eta" || $_REQUEST['by_who'] == "ts" || $_REQUEST['by_who'] == "tm"){
                $sql=rtrim(file_get_contents('sql/standA_stat_'.$_REQUEST['by_who'].'.sql'));
                //$params_new = $params;
                $params[':brief']=rtrim(file_get_contents('sql/standA_brief.sql'));
                $sql=stritr($sql,$params);
                $sql=stritr($sql,$params);

                $st_a = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
                $sql=rtrim(file_get_contents('sql/a18to_stat_total.sql'));
                $sql=stritr($sql,$params);
                $sql=stritr($sql,$params);

                $st_a_t = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
                print_r($st_a);
            }else{
//                if($_REQUEST['by_who'] == "tm"){
//                    $sql_new=rtrim(file_get_contents('sql/standA_stat_'.$_REQUEST['by_who'].'.sql'));
//                    $params_new = $params;
//                    $params_new[':brief']=rtrim(file_get_contents('sql/standA_brief.sql'));
//                    $sql_new=stritr($sql_new,$params_new);
//                    $sql_new=stritr($sql_new,$params_new);
//                    echo $sql_new;
//                }

                $sql=rtrim(file_get_contents('sql/a18to_stat_'.$_REQUEST['by_who'].'.sql'));
                $params[':brief']=rtrim(file_get_contents('sql/a18to_stat_brief.sql'));
                $sql=stritr($sql,$params);
                $sql=stritr($sql,$params);
                $st_a = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
                $sql=rtrim(file_get_contents('sql/a18to_stat_total.sql'));
                $sql=stritr($sql,$params);
                $sql=stritr($sql,$params);
                $st_a_t = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
            }
            echo "</pre>";

            //standart B
            /*$sql=rtrim(file_get_contents('sql/a14to_stat_'.$_REQUEST['by_who'].'.sql'));
            $sql=stritr($sql,$params);
            $st_b = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
            $sql=rtrim(file_get_contents('sql/a14to_stat_total.sql'));
            $sql=stritr($sql,$params);
            $st_b_t = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);*/
            //standart B new
            $sql=rtrim(file_get_contents('sql/standBst_'.$_REQUEST['by_who'].'.sql'));
            $sql=stritr($sql,$params);
            $st_b = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
            $sql=rtrim(file_get_contents('sql/standBst_total.sql'));
            $sql=stritr($sql,$params);
            $st_b_t = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
            //standart Coffee
            $sql=rtrim(file_get_contents('sql/a16cost_'.$_REQUEST['by_who'].'.sql'));
            $sql=stritr($sql,$params);
            $st_c = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
            $sql=rtrim(file_get_contents('sql/a16cost_total.sql'));
            $sql=stritr($sql,$params);
            $st_c_t = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
            //standart Sh
            $sql=rtrim(file_get_contents('sql/standSHst_'.$_REQUEST['by_who'].'.sql'));
            $sql=stritr($sql,$params);
            $st_sh = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
            $sql=rtrim(file_get_contents('sql/standSHst_total.sql'));
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
                $d[$key]['h_tn'] = GetVal($item,'key');
                $d[$key]['eta_tab_number'] = GetVal($item,'eta_tab_number');
                $d[$key]['fio_eta'] = GetVal($item,'fio_eta');
                $d[$key]['tab_num_ts'] = GetVal($item,'tab_num_ts');
                $d[$key]['fio_ts'] = GetVal($item,'fio_ts');
                $d[$key]['tab_num_tm'] = GetVal($item,'tab_num_tm');
                $d[$key]['fio_tm'] = GetVal($item,'fio_tm');
                $d[$key]['tab_num_rm'] = GetVal($item,'tab_num_rm');
                $d[$key]['fio_rm'] = GetVal($item,'fio_rm');
            }
//            echo "<pre style='display: none;text-align: left;'>";
//            print_r($st_a);
//            echo "</pre>";
            $smarty->assign('d', $d);
            $smarty->assign('tt', $tt);

            $dataStandLabels = GetChart($st_a,"labels");

            $dataStand['A'] = GetChart($st_a,"data","a");
            $dataStand['B'] = GetChart($st_b,"data","b");
            $dataStand['Coffee'] = GetChart($st_c,"data","c");
            $dataStand['Sh'] = GetChart($st_sh,"data","sh");


            $smarty->assign('dataStandLabels', $dataStandLabels);
            $smarty->assign('dataStand', $dataStand);
		}else{
            if($is_show_desc){
                $postfix_file = 'detailed';
                
            }else{
                $postfix_file = $_REQUEST['by_who'];
            }
            $sql=rtrim(file_get_contents($sql_file.$postfix_file.'.sql'));
            $sql=stritr($sql,$params);
            if($_REQUEST['stand_type'] == 'a') {
                $sql = stritr($sql, $params);
//                echo "<pre style='display: none;text-align: left;'>";
//                echo $sql;
//                echo "</pre>";
            }
            if($is_show_desc) {
                /*if ($_REQUEST['stand_type'] == "coffee" || $_REQUEST['stand_type'] == "sh") {*/
                if ($_REQUEST['stand_type'] != "a" ) {
                    $sql = "SELECT * FROM (" . $sql . ") WHERE tp_st_ts IS NOT NULL AND tp_st_ts <> 0";
                } else {
                    $sql = "SELECT * FROM (" . $sql . ") WHERE ts1r IS NOT NULL AND ts1r <> 0";
                }
            }

//            echo $sql;
            $t = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

            if(!$is_show_desc){

                $dataStandLabels = GetChart($t,"labels","");
                $dataStand[$_REQUEST['stand_type']] = GetChart($t,"data",$_REQUEST['stand_type']);
                $smarty->assign('dataStandLabels', $dataStandLabels);
                $smarty->assign('dataStand', $dataStand);
            }

           // print_r($t);
            //print_r($dataStand);
//            echo $sql;
            //echo "</pre>";
            //print_r($t);
            if($is_show_desc) {
                $params_tmp = $params;
                $params_tmp[':standT'] = $standT;
                $params_tmp[':ok_ts'] = 2;
                $params_tmp[':ok_tm'] = 1;
                $params_tmp[':st_ts'] = 2;
                $params_tmp[':st_tm'] = 1;
                if($_REQUEST['by_who'] == 'ts' || $_REQUEST['by_who'] == 'tm' || $_REQUEST['by_who'] == 'rm'){
                    $params_tmp[':tn'] = $_REQUEST['h_tn'];
                }
                /*if($_REQUEST['stand_type'] == "coffee" || $_REQUEST['stand_type'] == "sh") {*/
               if($_REQUEST['stand_type'] != "a" ) {
                    foreach ($t as $k => $item) {
                        $sql = rtrim(file_get_contents('sql/standPhotoSt.sql'));
                        $params_tmp[':tp_kod'] = $item['tp_kod_key'];
                        $sql = stritr($sql, $params_tmp);
                        $t[$k]['photos'] = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
                    }
                }else{
                    foreach ($t as $k => $item) {
                        $params_tmp[':standT'] = 'a18to';
                        $params_tmp[':standAcheck'] = 1;
                        $sql = rtrim(file_get_contents('sql/standPhotoStA.sql'));
                        $params_tmp[':tp_kod'] = $item['tp_kod_key'];
                        $sql = stritr($sql, $params_tmp);
                        $sql = stritr($sql, $params_tmp);
                        echo "<pre style='display: none;text-align: left;'>";
                        echo $sql;
                        echo "</pre>";
                        $t[$k]['photos'] = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
                    }
                }
            }

            foreach ($t as $key => $item) {
                $t[$key]['h_tn'] = $item['key'];

            }
//            echo "<pre style='display: none;text-align: left;'>";
//            print_r($t);
////            echo $sql;
//            echo "</pre>";
            $smarty->assign('d', $t);

            /* title info */
            if($is_show_desc){
                $desc = array();
                if($_REQUEST['by_who'] == 'eta'){
                    $fio = array();
                    $fio['fio_title'] = 'ФИО ЭТА';
                    $fio['fio'] = $t[0]['fio_eta'];
                    $desc[] = $fio;
                }
                if($_REQUEST['by_who'] == 'eta' || $_REQUEST['by_who'] == 'ts'){
                    $fio = array();
                    $fio['fio_title'] = 'ФИО ТС';
                    $fio['fio'] = $t[0]['fio_ts'];
                    $desc[] = $fio;
                }
                if($_REQUEST['by_who'] == 'eta' || $_REQUEST['by_who'] == 'ts' || $_REQUEST['by_who'] == 'tm'){
                    $fio = array();
                    $fio['fio_title'] = 'ФИО ТМ';
                    $fio['fio'] = $t[0]['fio_tm'];
                    $desc[] = $fio;
                }
//                if($_REQUEST['by_who'] == 'eta' || $_REQUEST['by_who'] == 'ts' || $_REQUEST['by_who'] == 'tm' || $_REQUEST['by_who'] == 'rm'){
//                    $fio = array();
//                    $fio['fio_title'] = 'ФИО РМ';
//                    $fio['fio'] = $t[0]['fio_rm'];
//                    $desc[] = $fio;
//                }
                $smarty->assign('stand_title',$stand_title);
                $smarty->assign('desc',$desc);
            }

            /* total TP with standart */
            if(!$is_show_desc){
                $params[':sttype'] = 0;
            }
            $sql=rtrim(file_get_contents($sql_file.'total.sql'));
            $sql=stritr($sql,$params);
            $sql=stritr($sql,$params);

            $tt = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
            $smarty->assign('tt', $tt);
//            echo "<pre style='display: none;text-align: left;'>";
//            print_r($tt);
//            echo "</pre>";

        }
	}
    $sql = rtrim(file_get_contents('sql/month_list.sql'));
    $res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
    $smarty->assign('month_list', $res);
    $smarty->assign('now_date', $now1);

	$smarty->display('standTotal.html');

    function GetChart($t,$param=false,$stand=""){
        $dataStand_tmp = array();
        $dataStandLabels_tmp = array();
        foreach ($t as $key => $item) {
                $dataStand_tmp[] = array(
                    "label" => $_REQUEST['by_who'] == "tm" ? $item['fio_tm'] : $_REQUEST['by_who'] == "ts" ? $item['fio_ts'] : $item['fio_eta'],
                    "y" => ($stand != "a") ? $item['tp_st_ts'] : $item['ts1r']
                );

                $dataStandLabels_tmp[] = $_REQUEST['by_who'] == "tm" ? $item['fio_tm'] : $_REQUEST['by_who'] == "ts" ? $item['fio_ts'] : $item['fio_eta'];
        }
        $dataStand_tmp = utf8ize($dataStand_tmp);
        if($param == "labels")
            return $dataStandLabels_tmp;
        if($param == "data")
            return json_encode($dataStand_tmp,JSON_NUMERIC_CHECK);
        return array();
    }

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
function utf8ize($mixed) {
    if (is_array($mixed)) {
        foreach ($mixed as $key => $value) {
            $mixed[$key] = utf8ize($value);
        }
    } elseif (is_string($mixed)) {
        return mb_convert_encoding($mixed, "UTF-8", "Windows-1251");
    }
    return $mixed;
}
?>