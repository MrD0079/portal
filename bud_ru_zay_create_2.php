<?
if (isset($_REQUEST["getProductList"])){
    $sql = "
  SELECT product_id id, TRIM (product_brand)||' / '||product_name_sw name
    FROM dimProduct z, spec s
   WHERE     s.id = z.tagid
         AND dt =
                (SELECT m
                   FROM (  SELECT TRUNC (data, 'mm') m, COUNT (*) c
                             FROM calendar
                            WHERE data BETWEEN TO_DATE ( :sd, 'dd.mm.yyyy')
                                           AND TO_DATE ( :ed, 'dd.mm.yyyy')
                         GROUP BY TRUNC (data, 'mm')
                         ORDER BY c DESC, m DESC)
                  WHERE ROWNUM = 1)
ORDER BY name
";
    $p=array(
        ':sd' => "'".$_REQUEST["sd"]."'",
        ':ed' => "'".$_REQUEST["ed"]."'"
    );
    $sql=stritr($sql,$p);
    //echo $sql;
    $r = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
    $smarty->assign('x', $r);
} elseif (isset($_REQUEST["getProduct"])){
    $sql="SELECT sku_id,
       tagid,
       product_id,
       product_id id,
       TRIM (product_brand) product_brand,
       product_name_sw,
       product_weight,
       s.price,
       get_price (dt, sku_id) price_prot
  FROM dimProduct z, spec s
 WHERE     s.id = z.tagid
       AND dt =
              (SELECT m
                 FROM (  SELECT TRUNC (data, 'mm') m, COUNT (*) c
                           FROM calendar
                          WHERE data BETWEEN TO_DATE ( :sd, 'dd.mm.yyyy')
                                         AND TO_DATE ( :ed, 'dd.mm.yyyy')
                       GROUP BY TRUNC (data, 'mm')
                       ORDER BY c DESC, m DESC)
                WHERE ROWNUM = 1)
       AND product_id = :product";
    $p=array(
        ':sd' => "'".$_REQUEST["sd"]."'",
        ':ed' => "'".$_REQUEST["ed"]."'",
        ':product' => $_REQUEST["product"]
    );
    $sql=stritr($sql,$p);
    //echo $sql;
    $r = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
    $smarty->assign('x', $r);
} else {
    //ini_set('display_errors', 'On');
    $params = array();
    if (isset($_REQUEST["id"]))
    {
            $sql=rtrim(file_get_contents('sql/bud_ru_zay_get_head.sql'));
            $p=array(':z_id' => $_REQUEST["id"]);
            $sql=stritr($sql,$p);
            $z=$db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
            $params[":tn"]=$z["tn"];
            $params[":fil"]=$z["fil"];
            $params[":dpt_id"]=$z["dpt_id"];
            !isset($_REQUEST["save"])?$_REQUEST["new"]=$z:null;
            $sql=rtrim(file_get_contents('sql/bud_ru_zay_get_ff.sql'));
            $p=array(':z_id' => $_REQUEST["id"]);
            $sql=stritr($sql,$p);
            $data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
            foreach ($data as $k1=>$v1)
            {
                    if ($v1["type"]=="file"&&$v1["val_file"]!="")
                    {
                            $data[$k1]["val_file"]=explode("\n",$v1["val_file"]);
                    }
            }
            include "bud_ru_zay_formula.php";
            !isset($_REQUEST["save"])?$_REQUEST["edit_st"]=$data:null;

            $sql=rtrim(file_get_contents('sql/bud_ru_zay_edit_acceptors.sql'));
            $params[":id"]=$_REQUEST["id"];
            $sql=stritr($sql,$params);
            $data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
            $smarty->assign('bud_ru_zay_edit_acceptors', $data);

            $sql=rtrim(file_get_contents('sql/bud_ru_zay_edit_executors.sql'));
            $params[":id"]=$_REQUEST["id"];
            $sql=stritr($sql,$params);
            $data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
            $smarty->assign('bud_ru_zay_edit_executors', $data);

    }
    else
    {
            $params[":dpt_id"]=$_SESSION["dpt_id"];
            $params[":tn"]=$tn;
            $params[":fil"]=$_REQUEST["new"]["fil"];
            $_REQUEST["new"]["tn"]=$tn;
            $_REQUEST["new"]["st"]=$db->getOne("SELECT parent FROM bud_ru_st_ras st WHERE id=".$_REQUEST["new"]["kat"]);
    }

    $sql="select * from user_list where tn=".$params[":tn"];
    $me = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
    $smarty->assign('me', $me);

    if (isset($_REQUEST["save"]))
    {
            if (!isset($_REQUEST["admin"]))
            {
                    foreach ($_REQUEST["bud_ru_acceptors"] as $k=>$v)
                    {
                            if ($v!=null)
                            {
                                    $_REQUEST["new"]["recipient"]=$v;
                            }
                    }
            }
            if (isset($_REQUEST["id"]))
            {
                $id = $_REQUEST["id"];
                //add chat with rejection detail
                try {
                    $sql_acc = 'SELECT accepted FROM bud_ru_zay_accept WHERE z_id=' . $id . ' ORDER BY lu desc';
                    $accepted = $db->getCol($sql_acc);
                    if (is_array($accepted) && count($accepted) > 0) {
//            if sz rejected
                        if ($accepted[0] == 2) {
                            $sql_text = "SELECT p.param_name, p.val_string FROM PARAMETERS p where dpt_id=" . $_SESSION["dpt_id"] . " and p.param_name = 'sz_message_after_resubmission'";
                            $reject_data = $db->getAll($sql_text, null, null, null, MDB2_FETCHMODE_ASSOC);
                            if (is_array($reject_data) && count($reject_data) > 0) {
                                $reject_text = $reject_data[0]['val_string'];
                            } else {
                                $reject_text = '����� ���� ������������ ����� ����������.';
                            }
                            $keys_reject = array(
                                "tn" => 1111111111, // �������
                                "z_id" => $id,
                                "text" => $reject_text);
                            Table_Update("bud_ru_zay_chat", $keys_reject, $keys_reject);
                        }
                    }
                }catch (Exception $e){

                }
            }
            else
            {
                    $id = get_new_id();
            }
            $keys = array("id"=>$id);
            isset($_REQUEST["new"]["dt_start"]) ? $_REQUEST["new"]["dt_start"]=OraDate2MDBDate($_REQUEST["new"]["dt_start"]) : null;
            isset($_REQUEST["new"]["dt_end"]) ? $_REQUEST["new"]["dt_end"]=OraDate2MDBDate($_REQUEST["new"]["dt_end"]) : null;
            Table_Update("bud_ru_zay",$keys,$_REQUEST["new"]);
            $keys = array("z_id"=>$id);
            if (!isset($_REQUEST["admin"]))
            {
                    Table_Update("bud_ru_zay_accept",$keys,null);
                    Table_Update("bud_ru_zay_executors",$keys,null);
                    foreach ($_REQUEST["bud_ru_acceptors"] as $k=>$v)
                    {
                            $keys = array("z_id"=>$id,"tn"=>$v);
                            if ($v!=null)
                            {
                                    Table_Update("bud_ru_zay_accept",$keys,$keys);
                            }
                    }
                    if (isset($_REQUEST["bud_ru_executors"]))
                    {
                            foreach ($_REQUEST["bud_ru_executors"] as $k=>$v)
                            {
                                    $keys = array("z_id"=>$id,"tn"=>$v);
                                    if ($v!=null)
                                    {
                                            Table_Update("bud_ru_zay_executors",$keys,$keys);
                                    }
                            }
                    }
            }
            if (isset($_REQUEST["new_st"]))
            {
                    foreach ($_REQUEST["new_st"] as $k=>$v)
                    {
                            $var_type = $db->getOne("select type from bud_ru_ff where id=".$k);
                            $var_type == "datepicker" && isset($v) ? $v=OraDate2MDBDate($_REQUEST["new_st"][$k]) : null;
                            $keys = array("z_id"=>$id,"ff_id"=>$k);
                            $vals = array("val_".$var_type=>$v);
                            Table_Update("bud_ru_zay_ff",$keys,$vals);
                    }
            }
            //add new field for SKU_AVK (selected products)

            //check if sku not selected yet - then set status 0
            //ONLY if it is not NEW zay
            if(!isset($_REQUEST['sku_select'])){
                $sku_selects = array();
            }else{
                $sku_selects = $_REQUEST["sku_select"];
            }
            if(isset($_REQUEST['id'])){
                $selected_sku = $db->getAll("select id_num from bud_ru_zay_sku_avk where (status = 1 OR status IS NULL) AND z_id=".$_REQUEST['id']);
                if(count($selected_sku) > 0){
                    foreach ($selected_sku as $k => $v) {
                        if(!in_array($v[0],$sku_selects) or count($sku_selects) == 0){
                            $status = 0;
                            //$keys = array("z_id"=>$_REQUEST['id'],"sku_id"=>$v[0]);
                           //$vals = array("z_id"=>$_REQUEST['id'],"sku_id"=>$v[0],"lu"=>OraDate2MDBDate(date('d.m. Y h:i:s', time())),"status"=>$status);
                            $id_num = $v[0];
                            $keys = array("z_id" => $_REQUEST["id"],'id_num'=>$id_num);
                            $vals = array(
                                "lu" => OraDate2MDBDate(date('d.m. Y h:i:s', time())),
                                "status" => $status
                            );
                            Table_Update("bud_ru_zay_sku_avk",$keys,$vals);
                        }
                    }
                }
            }
            if (isset($_REQUEST["sku_select"]) && isset($_REQUEST["sku_params"]))
            {
                $sku_params = $_REQUEST["sku_params"];
                //add and update selected sku
                foreach ($_REQUEST["sku_select"] as $k=>$v)
                {
                    $status = 1;
                    //$keys = array("z_id"=>$id,"sku_id"=>$v);
                    //$vals = array("z_id"=>$id,"sku_id"=>$v,"lu"=>OraDate2MDBDate(date('d.m. Y h:i:s', time())),"status"=>$status);
                    $id_num = $v;
                    $keys = array("z_id" => $id,'id_num'=>$id_num, "sku_id" => $sku_params[$id_num]['sku_id']);
                    $vals = array(
                        'logistic_expens'=>$sku_params[$id_num]['logistic_expens'],
                        'market_val'=>$sku_params[$id_num]['market_val'],
                        'price_ss'=>$sku_params[$id_num]['price_ss'],
                        'price_uk'=>$sku_params[$id_num]['price_urkaine'],
                        'price_kk'=>$sku_params[$id_num]['price_s_kk'],
                        'price_net'=>$sku_params[$id_num]['price_one'],
                        'add_expens'=>$sku_params[$id_num]['add_expenses'],
                        'total_q'=>$sku_params[$id_num]['total_volume_q'],
                        "lu" => OraDate2MDBDate(date('d.m. Y h:i:s', time())),
                        "status" => $status
                    );
                    Table_Update("bud_ru_zay_sku_avk",$keys,$vals);
                }

            }

            if (isset($_REQUEST["productList"]))
            {
                    foreach ($_REQUEST["productList"] as $k=>$v)
                    {
                            $keys = array("z_id"=>$id,"id"=>$k);
                            Table_Update("zay_product_list",$keys,$v);
                    }
            }
            if (isset($_REQUEST["bud_ru_zay_files_del"]))
            {
                    foreach ($_REQUEST["bud_ru_zay_files_del"] as $k=>$v)
                    {
                            $old_val=$db->getOne("select val_file from bud_ru_zay_ff where z_id=".$id." and ff_id=".$k);
                            $ov=explode("\n",$old_val);
                            $keys = array("z_id"=>$id,"ff_id"=>$k);
                            $del_array=array();
                            foreach ($v as $k1=>$v1)
                            {
                                    unlink($v1);
                                    $del_array[]=$k1;
                            }
                            $vals = array("val_file"=>implode(array_diff($ov,$del_array),"\n"));
                            Table_Update("bud_ru_zay_ff",$keys,$vals);
                    }
            }
            if (isset($_FILES["new_st"]))
            {
                    foreach ($_FILES["new_st"]["tmp_name"] as $k=>$v)
                    {
                            $old_val=$db->getOne("select val_file from bud_ru_zay_ff where z_id=".$id." and ff_id=".$k);
                            isset($old_val)?$old_val="\n".$old_val:null;
                            $s=array();
                            foreach ($v as $k1=>$v1)
                            {
                            if (is_uploaded_file($v1))
                            {
                                    $a=pathinfo($_FILES["new_st"]["name"][$k][$k1]);
                                    $fn=translit($_FILES["new_st"]["name"][$k][$k1]);
                                    $path="files/bud_ru_zay_files/".$id."/".$k;
                                    if (!file_exists($path)) {mkdir($path,0777,true);}
                                    move_uploaded_file($v1, $path."/".$fn);
                                    $s[]=$fn;
                                    $ss=implode($s,"\n");
                                    $keys = array("z_id"=>$id,"ff_id"=>$k);
                                    $vals = array("val_file"=>$ss.$old_val);
                                    Table_Update("bud_ru_zay_ff",$keys,$vals);
                            }
                            }
                    }
            }

            $sql=rtrim(file_get_contents('sql/bud_ru_zay_create_get_acceptors.sql'));
            $params=array(":id"=>$id);
            $sql=stritr($sql,$params);
            $data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
            $smarty->assign('acceptors', $data);
    }

    $sql=rtrim(file_get_contents('sql/bud_ru_st_ras.sql'));
    $sql=stritr($sql,$params);
    $bud_ru_st_ras = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
    $smarty->assign('bud_ru_st_ras', $bud_ru_st_ras);

    isset($_REQUEST["new"]['fil'])?$smarty->assign('fil_name', $db->getOne('select name from bud_fil where id='.$_REQUEST["new"]['fil'])):null;

    $sql=rtrim(file_get_contents('sql/bud_funds.sql'));
    $sql=stritr($sql,$params);
    $funds = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
    $smarty->assign('funds', $funds);

    $sql=rtrim(file_get_contents('sql/bud_ru_zay_create_get_rm.sql'));
    $sql=stritr($sql,$params);
    $rm = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
    $smarty->assign('rm', $rm);

    if (!isset($_REQUEST["save"]))
    {
            $params[':kat']=$_REQUEST["new"]["kat"];
            $sql=rtrim(file_get_contents('sql/bud_ru_zay_create_ff.sql'));
            $sql=stritr($sql,$params);
            $st = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
            foreach ($st as $k=>$v)
            {
                    if ($v['type']=='list')
                    {
                            $sql=$db->getOne('select get_list from bud_ru_ff_subtypes where id='.$v['subtype']);
                            $sql=stritr($sql,$params);
                            $list = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
                            $st[$k]['list'] = $list;
                    }
                    if ($v['parent_field']!==null&&$v['parent_field_val']!==null)
                    {
                            $linked_fields[$v['parent_field']][$v['id']]=$v;
                    }
            }
            isset($linked_fields)?$smarty->assign('linked_fields', $linked_fields):null;
            $smarty->assign('st', $st);
    }
    //$_REQUEST["zzz"]=$st;
    

    $sql = rtrim(file_get_contents('sql/emp_exp_spd_list.sql'));
    $data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
    $smarty->assign('spd_list', $data);

    $sql=rtrim(file_get_contents('sql/bud_ru_zay_create_nets.sql'));
    $sql=stritr($sql,$params);
    $nets = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
    $smarty->assign('nets', $nets);

    $sql=rtrim(file_get_contents('sql/statya_list.sql'));
    $data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
    $smarty->assign('statya_list', $data);

    $sql=rtrim(file_get_contents('sql/payment_type.sql'));
    $data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
    $smarty->assign('payment_type', $data);


    $sql=rtrim(file_get_contents('sql/bud_ru_zay_create_getDisabledDates.sql'));
    $sql=stritr($sql,$params);
    $dd = $db->getOne($sql);
    $smarty->assign('DisabledDates', $dd);

}
$smarty->display('bud_ru_zay_create_2.html');
