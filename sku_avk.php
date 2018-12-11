<?php
//get products from AJAX when page is load
if(isset($_REQUEST["get_list"]) && isset($_REQUEST["z_id"])){
    $params[":z_id"] = $_REQUEST["z_id"];
    $sql = rtrim(file_get_contents('sql/bud_ru_zay_sku_avk.sql'));
    $sql = stritr($sql, $params);
    $get_list = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
    PrintJSONFromArray($get_list,"Empty");
    return;
}

//add new field for SKU_AVK (selected products) --USE NOT HERE !!!!!!!!
//$.ajax({
//    url: "?action=sku_avk&print=1&pdf=1",
//    //dataType: 'json',
//	//contentType: "application/x-www-form-urlencoded;charset=utf-8",
//	data: {sku_list:$('#sku_select').val(),z_id:176362626}
//}).done(function (data, status, err) {
//    console.log("Done: "+data);
//})
//.fail(function (req, status, err ) {
//    console.log( 'something went wrong', status, err );
//});
if (isset($_REQUEST["sku_select"]) && isset($_REQUEST["sku_params"]))
{
    if (!isset($_REQUEST["z_id"])) {
        $id = get_new_id();
        echo "new id";
    }else{
        $id = $_REQUEST["z_id"];
        echo "old id: ".$_REQUEST["z_id"];
    }
    //check if sku not selected yet - then set status 0
    $q_status_0 = false;
    $q_status_1 = false;
    //$sku_params = is_array($_REQUEST["sku_params"]) ? $_REQUEST["sku_params"] : json_decode($_REQUEST["sku_params"],true);
    $sku_params = $_REQUEST["sku_params"];

    echo "sku_select: ".json_encode($_REQUEST["sku_select"]);
    if(isset($_REQUEST["z_id"])){
        try {
            $selected_sku = $db->getAll("select id_num from bud_ru_zay_sku_avk where (status = 1 OR status IS NULL) AND z_id=" . $_REQUEST["z_id"]);
            echo "selected_sku: ".json_encode($selected_sku);
            if (count($selected_sku) > 0) {
                foreach ($selected_sku as $k => $v) {
                    if (!in_array($v[0], $_REQUEST["sku_select"])) {
                        $status = 0;
                        $id_num = $v[0];
                        //$keys = array("z_id" => $id, "sku_id" => $v[0]);
                        //$vals = array("z_id" => $id, "sku_id" => $v[0], "lu" => OraDate2MDBDate(date('d.m. Y h:i:s', time())), "status" => $status);
                        $keys = array("z_id" => $_REQUEST["z_id"],'id_num'=>$id_num);
                        $vals = array(
                            "lu" => OraDate2MDBDate(date('d.m. Y h:i:s', time())),
                            "status" => $status
                        );
                        echo "Update: ".json_encode(array_merge($keys,$vals));
                        Table_Update("bud_ru_zay_sku_avk", $keys, $vals);
                    }
                }

            }
            $q_status_0 = true;
        }catch(Exception $e){
           echo "Some error: ".$e->getMessage();
        }
    }

    //add and update selected sku
    try {
        foreach ($_REQUEST["sku_select"] as $k=>$v)
        {
            $status = 1;
            //$keys = array("z_id"=>$id,"sku_id"=>$v);
            //$vals = array("z_id"=>$id,"sku_id"=>$v,"lu"=>OraDate2MDBDate(date('d.m. Y h:i:s', time())),"status"=>$status);
            $id_num = $v;
            $keys = array("z_id" => $id,'id_num'=>$id_num, "sku_id" => $sku_params[$id_num]['sku_id']);
            $vals = array(
                'logistic_expens'=>$sku_params[$id_num]['logistic_expens_m_plan'],
                'market_val'=>$sku_params[$id_num]['mark_cost_plan_cur_m'],
                'price_ss'=>$sku_params[$id_num]['price_ss'],
                'price_uk'=>$sku_params[$id_num]['price_urkaine'],
                'price_kk'=>$sku_params[$id_num]['price_s_kk'],
                'price_net'=>$sku_params[$id_num]['price_one'],
                'total_q'=>$sku_params[$id_num]['total_volume_q'],
                "lu" => OraDate2MDBDate(date('d.m. Y h:i:s', time())),
                "status" => $status
            );
            echo(json_encode(array_merge($keys,$vals)));
            Table_Update("bud_ru_zay_sku_avk",$keys,$vals);
        }
        $q_status_1 = true;
    }catch(Exception $e){
        echo "Some error: ".$e->getMessage();
    }
    if($q_status_0 && $q_status_1)
        echo "ok";
    else if(!$q_status_0)
        echo "ok. not update";
    else
        echo "not save";
    return;
}

getItemsFromDB($db,15);

function getItemsFromDB($db,$limit = 9999999,$sku_list = null){
    include_once "a.charset.php";
    $params = array();
    try {
        if (isset($_REQUEST["q"])) {
            if (strtoupper($_SERVER['REQUEST_METHOD']) == "POST") {
                $q = htmlentities(utf8_decode($_POST['q'])); // right
                $_REQUEST["net_id"] = $_REQUEST["net_id"];
            }else{
                $q = charset_x_win($_REQUEST["q"]);
            }
        } else {
            $q = "";
        }
        $params[":query"] = "'" . $q . "%'";
        //$params[":name_p"] = "'" . $q . "'";
        $params[":name_p"] = $q ;
        $params[":net_id"] = isset($_REQUEST["net_id"]) ? $_REQUEST["net_id"] : 0;

        if(isset($_REQUEST['sku_list']) && !empty($_REQUEST['sku_list'])){
            if(is_array($_REQUEST['sku_list']))
                $_REQUEST['sku_list'] = implode(",",$_REQUEST['sku_list']);
            $params[':sku_list'] = $_REQUEST['sku_list'];
            $params[':show_list'] = 1;
            $params[':show_q'] = 0;
        }else{
            $params[':show_q'] = 1;
            $params[':sku_list'] = 0;
            $params[':show_list'] = 0;
        }

        //get sku_list when edit old 'zayavka' by z_id
        if(isset($_REQUEST["z_id"]) && $_REQUEST["z_id"] != 0){
            $params[":z_id"] = $_REQUEST["z_id"];
            $params[':show_save_list'] = 1;
            $params[':show_list'] = 0;
            $params[':show_q'] = 0;
            //$params[':bsa_field'] = ',bsa.total_q';
            $params[':bsa_table'] = ', bud_ru_zay_sku_avk bsa';
            $params[':bsa_where'] = 'AND (bsa.z_id = '.$_REQUEST["z_id"].' AND bsa.status = 1 AND sa.sku_id IN bsa.sku_id)';
        }else{
            $params[":z_id"] = 0;
            $params[':show_save_list'] = 0;
            $params[':bsa_table'] = '';
            $params[':bsa_where'] = '';
        }
        if($q == "" && !isset($_REQUEST["z_id"]))
            PrintJSONFromArray(array(),'not founds: wrong request');

        if(isset($_REQUEST['page'])) {
            $page_num = ($_REQUEST['page']-1)*$limit;
        }else{
            $page_num = 0;
        }

        $params[':pagination_head'] = 'select * from (select r.*, ROWNUM rnum from (';
        $params[':pagination_footer'] = ') r where ROWNUM <= '.($limit+$page_num).' ) where rnum > '.$page_num;

        $sql_base = rtrim(file_get_contents('sql/sku_avk.sql'));
        $sql = stritr($sql_base, $params);
        $sql = trim(preg_replace('/\s+/', ' ', $sql));
        $sku_avk = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

        $params[':pagination_head'] = '';
        $params[':pagination_footer'] = '';
        $sql = stritr($sql_base, $params);
        $sql = trim(preg_replace('/\s+/', ' ', $sql));
        $r = $db->query($sql);
        $total_count = $r->numRows();

        if (isset($sku_avk))
        {
            if (PEAR::isError($sku_avk))
            {
                PrintJSONFromArray(array(),'error: '.$sku_avk->getMessage() . " " . $sku_avk->getDebugInfo());
            }else{
                PrintJSONFromArray($sku_avk,'not founds: '.$q,$total_count);
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
//------FRON-END----- insert to tpl/bud_ru_zay_create_2.html to end file
//<script>
//$('#sku_select').select2({
// 	multiple: true,
//	ajax: {
//    url: "?action=sku_avk&print=1&pdf=1",
//		dataType: 'json',
//		delay: 250,
//        contentType: "application/x-www-form-urlencoded;charset=utf-8",
//		data: function (params) {
//        return {
//            q: params.term, // search term
//               page: params.page
//           };
//       },
//       processResults: function (data, params) {
//        // parse the results into the format expected by Select2
//        // since we are using custom formatting functions we do not need to
//        // alter the remote JSON data, except to indicate that infinite
//        // scrolling can be used
//        params.page = params.page || 1;
//        return {
//            results: data.items,
//               pagination: {
//                more: (params.page * 10) < data.total_count
//               }
//           };
//       },
//       cache: true
//   },
//   language: "ru",
//   placeholder: 'Поиск товара по имени, по id, по tag',
//   escapeMarkup: function (markup) {return markup; }, // let our custom formatter work
//   minimumInputLength: 1,
//   templateResult: formatRepo,
//   templateSelection: formatRepoSelection
//});
//function formatRepo (repo) {
//    if (repo.loading) {
//        return repo.text;
//    }
//    if(repo.text){
//        return "<div>"+repo.text+"</div>";
//    }
//    var markup1 = "<div class=''>("+repo.sku_id+") "+
//        repo.name+
//        " ("+repo.type_name+": "+repo.weight+" кг. "+")"+
//        "</div>";
//    return markup1;
//}
////text was show if option is selected
//function formatRepoSelection (repo) {
//    return repo.name || repo.text;
//}
//// Fetch the preselected item, and add to the control
//var productsSelect = $('#sku_select');
//$.ajax({
//	url: "?action=sku_avk&print=1&pdf=1",
//	dataType: 'json',
//	contentType: "application/x-www-form-urlencoded;charset=utf-8",
//	data: {get_list:1,z_id:{$smarty.request.id|default:0}} //test: 176303197
//}).then(function (data) {
//    //console.log(data);
//    if(data.items[0].text && data.items[0].text.length > 0){
//        console.log("empty");
//    }else{
//        $.each( data.items, function( key, value ) {
//            // create the option and append to Select2
//            var text = value.text;
//            if(value.name)
//                text = value.name;
//            console.log("id: "+value.id+" - "+text);
//            var option = new Option(text, value.id, true, true);
//            productsSelect.append(option).trigger('change');
//        });
//        // manually trigger the `select2:select` event
//        productsSelect.trigger({
//           type: 'select2:select',
//           params: {
//            data: data.items
//           }
//       });
//   }
//});
//</script>

?>