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
//    dataType: 'json',
//	contentType: "application/x-www-form-urlencoded;charset=utf-8",
//	data: {sku_list:$('#new_st_47154457').val(),z_id:176304069}
//}).fail(function (data) {
//    console.log(data.responseText);
//});
if (isset($_REQUEST["sku_list"]) && is_array($_REQUEST["sku_list"]))
{
    if (!isset($_REQUEST["z_id"])) {
        $id = get_new_id();
    }else{
        $id = $_REQUEST["z_id"];
    }
    //check if sku not selected yet - then set status 0

    if(isset($_REQUEST['z_id'])){
        $selected_sku = $db->getAll("select sku_id from bud_ru_zay_sku_avk where status = 1 OR status IS NULL AND z_id=".$_REQUEST['z_id']);
        if(count($selected_sku) > 0){
            foreach ($selected_sku as $k => $v) {
                if(!in_array($v[0],$_REQUEST["sku_list"])){
                    $status = 0;
                    $keys = array("z_id"=>$id,"sku_id"=>$v[0]);
                    $vals = array("z_id"=>$id,"sku_id"=>$v[0],"lu"=>OraDate2MDBDate(date('d.m. Y h:i:s', time())),"status"=>$status);
                    Table_Update("bud_ru_zay_sku_avk",$keys,$vals);
                }
            }

        }
    }

    //add and update selected sku
    foreach ($_REQUEST["sku_list"] as $k=>$v)
    {
        $keys = array("z_id"=>$id,"sku_id"=>$v);
        $status = 1;
        $vals = array("z_id"=>$id,"sku_id"=>$v,"lu"=>OraDate2MDBDate(date('d.m. Y h:i:s', time())),"status"=>$status);
        Table_Update("bud_ru_zay_sku_avk",$keys,$vals);
    }
    return;
}

getItemsFromDB($db);

function getItemsFromDB($db,$sku_list = null){
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
        $params[":query"] = "'" . $q . "%'";
        $params[":name_p"] = "'" . $q . "'";

        $sql = rtrim(file_get_contents('sql/sku_avk.sql'));
        $sql = stritr($sql, $params);
        $sql = trim(preg_replace('/\s+/', ' ', $sql));

        $sku_avk = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
        PrintJSONFromArray($sku_avk,'not founds: '.$q);

    }catch(Exception $e){
        PrintJSONFromArray(array(),'Some error: ' . $e->getMessage());
        return;
    }
}

function PrintJSONFromArray($array,$errorText=""){
    if(count($array) > 0) {
        $answer['total_count'] = count($array);
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
//  multiple: true,
//            ajax: {
//    url: "?action=sku_avk&print=1&pdf=1",
//                dataType: 'json',
//                delay: 250,
//				contentType: "application/x-www-form-urlencoded;charset=utf-8",
//                data: function (params) {
//        return {
//            q: params.term, // search term
//                        page: params.page
//                    };
//                },
//                processResults: function (data, params) {
//        // parse the results into the format expected by Select2
//        // since we are using custom formatting functions we do not need to
//        // alter the remote JSON data, except to indicate that infinite
//        // scrolling can be used
//        params.page = params.page || 1;
//        return {
//            results: data.items,
//                        pagination: {
//                more: (params.page * 10) < data.total_count
//                        }
//                    };
//                },
//                cache: true
//            },
//            language: "ru",
//            placeholder: 'Поиск товара по имени, по id, по tag',
//            escapeMarkup: function (markup) {return markup; }, // let our custom formatter work
//            minimumInputLength: 1,
//            templateResult: formatRepo,
//            templateSelection: formatRepoSelection
//        });
//        function formatRepo (repo) {
//            if (repo.loading) {
//                return repo.text;
//            }
//            if(repo.text){
//                return "<div>"+repo.text+"</div>";
//            }
//            var markup1 = "<div class=''>("+repo.sku_id+") "+
//                repo.name+
//                " ("+repo.type_name+": "+repo.weight+" кг. "+")"+
//                "</div>";
//            return markup1;
//        }
//        //text was show if option is selected
//        function formatRepoSelection (repo) {
//            return repo.name || repo.text;
//        }
//// Fetch the preselected item, and add to the control
//var productsSelect = $('#sku_select');
//$.ajax({
//    url: "?action=sku_avk&print=1&pdf=1",
//    dataType: 'json',
//	contentType: "application/x-www-form-urlencoded;charset=utf-8",
//	data: {get_list:1,z_id:{$smarty.request.id|default:0}} //test: 176303197
//}).then(function (data) {
//    console.log(data);
//
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
//            type: 'select2:select',
//            params: {
//            data: data.items
//            }
//        });
//    }
//});
//</script>

?>