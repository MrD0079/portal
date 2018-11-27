<?php
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

    if(count($sku_avk) > 0) {
        $answer['total_count'] = count($sku_avk);
        $sku_avk = utf8ize($sku_avk);
        $answer['items'] = $sku_avk;
        header('Content-Type: application/json; charset=utf-8');
        echo json_encode($answer, JSON_UNESCAPED_UNICODE);
    }
    else{
        $answer['total_count'] = 1;
        $answer['items'] = array(array('id'=>0,'text'=>'not founds: '.$q));
        $answer = utf8ize($answer);
        header('Content-Type: application/json; charset=utf-8');
        echo json_encode($answer, JSON_UNESCAPED_UNICODE);
    }
}catch(Exception $e){
    $answer['total_count'] = 1;
    $answer['items'][] = array('id' => 0, 'text' => 'Some error: ' . $e->getMessage());
    header('Content-Type: application/json; charset=utf-8');
    $answer = utf8ize($answer);
    echo json_encode($answer, JSON_UNESCAPED_UNICODE);
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

//$('#statya').select2({
//multiple: true,
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



?>