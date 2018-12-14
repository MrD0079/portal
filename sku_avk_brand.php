<?php
//if(isset($_REQUEST["statya_enabled"]) && isset($_REQUEST['brand_select']) && isset($_REQUEST['row_id'])){
//    foreach ($_REQUEST["statya_enabled"] as $key=>$val){
//        $row_id = get_new_id();
//        //unset
//        if (isset($_REQUEST['row_id'][$key]) && $_REQUEST['row_id'][$key] !== null && $_REQUEST['row_id'][$key] != "") {
//            $row_id = $_REQUEST['row_id'][$key];
//            $brand_selected = $db->getAll("select brand_id from nets_plan_month_brand  where status = 1 AND row_id=" . $_REQUEST['row_id'][$key]);
//            if (count($brand_selected) > 0) {
//                foreach ($brand_selected as $k => $v) {
//                    if (!in_array($v[0], $_REQUEST["brand_select"][$key])) {
//                        $brand_id = $v[0];
//                        $keys_tmp = array("row_id" => $_REQUEST['row_id'][$key], 'brand_id' => $brand_id);
//                        $vals_tmp = array(
//                            "lu" => OraDate2MDBDate(date('d.m. Y h:i:s', time())),
//                            "status" => 0
//                        );
//                        echo "Update: " . json_encode(array_merge($keys_tmp, $vals_tmp)) . "\n";
//                        Table_Update("nets_plan_month_brand", $keys_tmp, $vals_tmp);
//                    }
//                }
//
//            }
//        }
//        //add, update
//        foreach ($_REQUEST['brand_select'][$key] as $k => $item) {
//            $brand_keys = array(
//                "row_id" => $row_id,
//                "brand_id" => $item
//            );
//            $brand_values = array(
//                "status" => 1,
//                "lu" => OraDate2MDBDate(date('d.m. Y h:i:s', time()))
//            );
//            echo "Add: " . json_encode(array_merge($brand_keys, $brand_values)) . "\n";
//            Table_Update("nets_plan_month_brand ", $brand_keys, $brand_values);
//        }
//    }
//    echo "ok";
//    return;
//}

if(isset($_REQUEST['row_id']) ){
    $brand_selected = $db->getAll("
      select br.brand_id id,
      br.name name
      from nets_plan_month_brand pl 
      inner join sku_avk_brand br ON br.brand_id = pl.brand_id
      where pl.status = 1 AND pl.row_id=" . $_REQUEST['row_id'], null, null, null, MDB2_FETCHMODE_ASSOC);
    PrintJSONFromArray($brand_selected,'brands not founds');
    return;
}

getItemsFromDB($db,10);

function getItemsFromDB($db,$limit = 9999999){
    include_once "a.charset.php";
    $params = array();
    try {
        if (isset($_REQUEST["q"])) {
            if (strtoupper($_SERVER['REQUEST_METHOD']) == "POST") {
                $q = htmlentities(utf8_decode($_POST['q'])); // right
            }else{
                $q = charset_x_win($_REQUEST["q"]);
            }
        } else {
            $q = "";
        }
        $params[":brand_name"] = $q ;
        $params[":brand_id"] = "'" . $q . "%'";

        if($q == "")
            PrintJSONFromArray(array(),'not founds: wrong request');

        if(isset($_REQUEST['page'])) {
            $page_num = ($_REQUEST['page']-1)*$limit;
        }else{
            $page_num = 0;
        }

        $params[':pagination_head'] = 'select * from (select r.*, ROWNUM rnum from (';
        $params[':pagination_footer'] = ') r where ROWNUM <= '.($limit+$page_num).' ) where rnum > '.$page_num;

        $sql_base = rtrim(file_get_contents('sql/sku_avk_brand.sql'));
        $sql = stritr($sql_base, $params);
        $sql = trim(preg_replace('/\s+/', ' ', $sql));
        $items = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

        $params[':pagination_head'] = '';
        $params[':pagination_footer'] = '';
        $sql = stritr($sql_base, $params);
        $sql = trim(preg_replace('/\s+/', ' ', $sql));
        $r = $db->query($sql);
        $total_count = $r->numRows();

        if (isset($items))
        {
            if (PEAR::isError($items))
            {
                PrintJSONFromArray(array(),'error: '.$items->getMessage() . " " . $items->getDebugInfo());
            }else{
                PrintJSONFromArray($items,'not founds: '.$q,$total_count);
            }
        }


    }catch(Exception $e){
        PrintJSONFromArray(array(),'Some error: ' . $e->getMessage());
        return;
    }
}

function PrintJSONFromArray($array,$errorText="",$total_count = false){
    if(count($array) > 0) {
        $answer['total_count'] = ($total_count != false) ? $total_count : count($array);
        $array = utf8ize($array);
        $answer['items'] = $array;
        header('Content-Type: application/json; charset=utf-8');
        echo json_encode($answer, JSON_UNESCAPED_UNICODE);
    }
    else{
        $answer['total_count'] = 1;
        $answer['items'] = array(array('id'=>0,'text'=>$errorText));
        $answer = utf8ize($answer);
        header('Content-Type: application/json; charset=utf-8');
        echo json_encode($answer, JSON_UNESCAPED_UNICODE);
    }
    return;
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