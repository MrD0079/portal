<?php
/**
 * Created by PhpStorm.
 * User: Taras.Daragan
 * Date: 28.01.2020
 * Time: 10:58
 */
try {
    require_once 'PHPExcel/Classes/PHPExcel/IOFactory.php';
} catch(Exception $e) {
    die($e->getMessage());
};
$saveData = isset($_REQUEST['save_data']) ?  $_REQUEST['save_data'] : false;

if($_REQUEST['generate']){

//(45,46,58,78,82,231,342,362,404,426,471,98471382,138606758)
    $sqlGetBudRuZay = 'SELECT z.id,(\'files/bud_ru_zay_files/\' || z.id || \'/sup_doc/\' ||z.SUP_DOC) AS filePath
                        FROM BUD_RU_ZAY z
                        JOIN BUD_RU_ZAY_FF zf ON zf.Z_ID = Z.ID
                        JOIN BUD_RU_FF ff ON zf.FF_ID = ff.ID
                        WHERE z.ID_NET = :id_net
                              AND DT_START >= TO_DATE(\'01.01.2019 00:00:00\', \'dd.mm.yyyy hh24:mi:ss\')
                              AND 1 = (SELECT AC.REP_ACCEPTED
                                      FROM BUD_RU_ZAY_ACCEPT AC
                                      WHERE AC.Z_ID = z.id
                                        AND AC.ACCEPT_ORDER = (SELECT MAX(ACCEPT_ORDER)
                                            FROM BUD_RU_ZAY_ACCEPT
                                            WHERE Z_ID = AC.Z_ID
                                              AND REP_ACCEPTED IS NOT NULL
                                              AND INN_NOT_REPORTMA(TN) = 0))
                               AND ff.ID = 176933669
                                AND (SELECT COUNT(*)
                                        FROM BUD_RU_ZAY_FF
                                        WHERE Z_ID = z.id
                                          AND FF_ID = 19311379
                                          AND (
                                                  LOWER(VAL_TEXTAREA) LIKE \'%штраф%\'
                                                  OR LOWER(VAL_TEXTAREA) LIKE \'%омпенсироват%\'
                                                  OR LOWER(VAL_TEXTAREA) LIKE \'%расход%\'
                                                  OR LOWER(VAL_TEXTAREA) LIKE \'%согласовать затраты%\'
                                                  )) = 0
                               AND z.SUP_DOC IS NOT null
                        ORDER BY z.DT_START';
    $params[":id_net"] = $_REQUEST['id_net'];
    $sqlGetBudRuZay=stritr($sqlGetBudRuZay,$params);
    $BudRuZay = $db->getAll($sqlGetBudRuZay, null, null, null, MDB2_FETCHMODE_ASSOC);

    echo "<pre style='text-align: left;'>";
    echo var_dump($BudRuZay);
    echo "</pre>";

    $logArray = [];
    $skipArray = [];

    if(count($BudRuZay) > 0){

        foreach ($BudRuZay as $i => $zay) {
            try{

                $files = explode("\n",$zay['filepath']);
                if(count($files) > 1){
                    $filePath = substr($files[0], 0, strripos($files[0], '/'));
                    foreach ($files as $i => $file) {
                        if($i >= 1){
                            $file = $filePath.'/'.$file;
                        }
                        $skuArray = loadExcelFile($file,false,$logArray,$skipArray);
                        echo "<pre style='text-align: left;'>";
                        echo var_dump($skuArray);
                        echo "</pre>";
                        if(count($skuArray) > 0 && $saveData){
                            foreach ($skuArray as $vals) {
                                $keys = ['z_id' => $zay['id'], 'SKU_NAME' => $vals['SKU_NAME']];
                                //$keys = ['id' => get_new_id()];
                                Table_Update("BUD_RU_ZAY_REPORT_SKU",$keys,$vals);
                            }
                        }
                    }
                }else{
                    $skuArray = loadExcelFile($zay['filepath'],false,$logArray,$skipArray);
                    echo "<pre style='text-align: left;'>";
                    echo var_dump($skuArray);
                    echo "</pre>";
                    if(count($skuArray) > 0 && $saveData){
                        foreach ($skuArray as $vals) {
                            $keys = ['z_id' => $zay['id'], 'SKU_NAME' => $vals['SKU_NAME']];
                            //$keys = ['id' => get_new_id()];
                            Table_Update("BUD_RU_ZAY_REPORT_SKU",$keys,$vals);
                        }
                    }
                }

                //break;
            }catch (\Exception $e){
                die($e->getMessage());
            }

        }

        echo "<pre style='text-align: left;'>";
        echo PHP_EOL."Log: ";
        print_r($logArray);
        echo "</pre>";

        echo "<pre style='text-align: left;'>";
        echo PHP_EOL."Skip files: ";
        print_r($skipArray);
        echo "</pre>";
    }

}

if($_REQUEST['loadExcel']){


    $date = new DateTime();
    $fp = fopen('/srv/www/1.txt', 'w+');
    ob_start();
    var_dump(['save' => $date->format('Y-m-d H:i:s') ]);
    echo 'Текущий владелец скрипта: ' . get_current_user().PHP_EOL;
    fwrite($fp, ob_get_clean());

    $fp = fopen('/srv/www/1.txt', 'a+');
    ob_start();
    var_dump(["getServerInfo" => getServerInfo($path)]);
    fwrite($fp, ob_get_clean());


    if(isset($_FILES['spreadsheet'])){



//        if($_FILES['spreadsheet']['name']) {
//            if (!$_FILES['spreadsheet']['error']) {
//                try{
//                    $skuArray = loadExcelFile($_FILES['spreadsheet']['name'],true,$logArray,$skipArray);
//                    echo "Flag LAST".PHP_EOL;
//                    echo "<pre style='text-align: left;'>";
//                    echo var_dump($skuArray);
//                    echo "</pre>";
//                    if(count($skuArray) > 0 && isset($_REQUEST['id_zay']) && $_REQUEST['id_zay'] !== ""  && $saveData){
//                        foreach ($skuArray as $vals) {
//                            $keys = ['z_id' => $_REQUEST['id_zay'], 'SKU_NAME' => $vals['SKU_NAME']];
//                            Table_Update("BUD_RU_ZAY_REPORT_SKU",$keys,$vals);
//                        }
//                    }
//                }catch (\Exception $e){
//                    echo "ERROR: ".$e->getMessage();
//                }
//
//            }
//        }

        if (isset($_FILES))
        {
            $fp = fopen('/srv/www/1.txt', 'a+');
            ob_start();
            var_dump($_FILES);
            fwrite($fp, ob_get_clean());
            try{
                $files=array();
                foreach ($_FILES as $k=>$v)
                {

                    $fp = fopen('/srv/www/1.txt', 'a+');
                    ob_start();
                    var_dump(["tmpFile"=>$v['tmp_name']]);
                    fwrite($fp, ob_get_clean());

                    $fp = fopen('/srv/www/1.txt', 'a+');
                    ob_start();
                    var_dump("BEFORE is_upload_file");
                    fwrite($fp, ob_get_clean());

                    $isUpload =is_uploaded_file($v['tmp_name']);

                    $fp = fopen('/srv/www/1.txt', 'a+');
                    ob_start();
                    var_dump(["is_uploaded_file"=>$isUpload]);
                    fwrite($fp, ob_get_clean());

                    if ($isUpload)
                    {
                        $a=pathinfo($v["name"]);
                        $fn=get_new_file_id().".".$a["extension"];
                        $path = "readXlsx_v2/";

                        $fp = fopen('/srv/www/1.txt', 'a+');
                        ob_start();
                        var_dump(["getFilesPerms" => getFilesPerms($path)]);
                        fwrite($fp, ob_get_clean());

                        $path = "readXlsx_v2/".$_REQUEST['id_zay'];


                        $fp = fopen('/srv/www/1.txt', 'a+');
                        ob_start();
                        var_dump(["path"=>$path]);
                        fwrite($fp, ob_get_clean());

                        $fp = fopen('/srv/www/1.txt', 'a+');
                        ob_start();
                        var_dump("BEFORE file_exists");
                        fwrite($fp, ob_get_clean());

                        $fileExists = file_exists($path);

                        $fp = fopen('/srv/www/1.txt', 'a+');
                        ob_start();
                        var_dump(["file_exists"=>$fileExists]);
                        fwrite($fp, ob_get_clean());

                        if (!$fileExists) {

                            $fp = fopen('/srv/www/1.txt', 'a+');
                            ob_start();
                            var_dump("BEFORE mkdir");
                            fwrite($fp, ob_get_clean());

                            $mkdir = mkdir($path,0777,true);

                            $fp = fopen('/srv/www/1.txt', 'a+');
                            ob_start();
                            var_dump(["mkdir"=>$mkdir]);
                            fwrite($fp, ob_get_clean());

                        }

                        $fp = fopen('/srv/www/1.txt', 'a+');
                        ob_start();
                        var_dump("BEFORE move_uploaded_file [".$path.'/'.$fn."]");
                        fwrite($fp, ob_get_clean());

                        $move_uploaded_file = move_uploaded_file($v["tmp_name"], $path.'/'.$fn);

                        $fp = fopen('/srv/www/1.txt', 'a+');
                        ob_start();
                        var_dump(["move_uploaded_file"=>$move_uploaded_file]);
                        fwrite($fp, ob_get_clean());

                    }
                }
            }catch (Exception $e){
                echo $e->getMessage().PHP_EOL;
                echo $e->getLine().PHP_EOL;
                echo $e->getCode().PHP_EOL;
                echo $e->getTraceAsString().PHP_EOL;
            }
        }

    }


}

function getFilesPerms($fileName){
    $perms = fileperms($fileName);

    switch ($perms & 0xF000) {
        case 0xC000: // сокет
            $info = 's';
            break;
        case 0xA000: // символическая ссылка
            $info = 'l';
            break;
        case 0x8000: // обычный
            $info = 'r';
            break;
        case 0x6000: // файл блочного устройства
            $info = 'b';
            break;
        case 0x4000: // каталог
            $info = 'd';
            break;
        case 0x2000: // файл символьного устройства
            $info = 'c';
            break;
        case 0x1000: // FIFO канал
            $info = 'p';
            break;
        default: // неизвестный
            $info = 'u';
    }

// Владелец
    $info .= (($perms & 0x0100) ? 'r' : '-');
    $info .= (($perms & 0x0080) ? 'w' : '-');
    $info .= (($perms & 0x0040) ?
        (($perms & 0x0800) ? 's' : 'x' ) :
        (($perms & 0x0800) ? 'S' : '-'));

// Группа
    $info .= (($perms & 0x0020) ? 'r' : '-');
    $info .= (($perms & 0x0010) ? 'w' : '-');
    $info .= (($perms & 0x0008) ?
        (($perms & 0x0400) ? 's' : 'x' ) :
        (($perms & 0x0400) ? 'S' : '-'));

// Мир
    $info .= (($perms & 0x0004) ? 'r' : '-');
    $info .= (($perms & 0x0002) ? 'w' : '-');
    $info .= (($perms & 0x0001) ?
        (($perms & 0x0200) ? 't' : 'x' ) :
        (($perms & 0x0200) ? 'T' : '-'));

    return $info;
}

function getServerInfo(){
    $info = [];

    $info['SERVER_PROTOCOL'] = $_SERVER['SERVER_PROTOCOL'];
    $info['REQUEST_METHOD'] = $_SERVER['REQUEST_METHOD'];
    $info['QUERY_STRING'] = $_SERVER['QUERY_STRING'];
    $info['REMOTE_ADDR'] = $_SERVER['REMOTE_ADDR'];
    $info['REMOTE_HOST'] = $_SERVER['REMOTE_HOST'];
    $info['REMOTE_PORT'] = $_SERVER['REMOTE_PORT'];
    $info['REMOTE_USER'] = $_SERVER['REMOTE_USER'];
    $info['REDIRECT_REMOTE_USER'] = $_SERVER['REDIRECT_REMOTE_USER'];
    $info['SERVER_PORT'] = $_SERVER['SERVER_PORT'];
    $info['SCRIPT_NAME'] = $_SERVER['SCRIPT_NAME'];
    $info['PHP_AUTH_PW'] = $_SERVER['PHP_AUTH_PW'];
    $info['SCRIPT_NAME'] = $_SERVER['SCRIPT_NAME'];

    return $info;
}

function loadExcelFile($filePath = null, $fileFromForm = false, &$logArray,&$skipArray){
    $skuArray = [];

    if(isset($filePath)){
        if(file_get_contents($filePath) || $fileFromForm) {
            //$inputFile = $_FILES['spreadsheet']['name'];
            //$inputFile = file_get_contents($filePath);
            $extension = strtoupper(pathinfo($filePath, PATHINFO_EXTENSION));
            if($extension == 'XLSX' || $extension == 'ODS') {
                // Read spreadsheeet workbook
                try {

                    if($fileFromForm){
                        $inputFile = $_FILES['spreadsheet']['tmp_name'];
                    }else{
                        $inputFile = $filePath;
                    }

                    $inputFileType = PHPExcel_IOFactory::identify($inputFile);
                    $objReader = PHPExcel_IOFactory::createReader($inputFileType);
                    $objPHPExcel = $objReader->load($inputFile);
                } catch(Exception $e) {
                    die("ERROR: ".$e->getMessage());
                };

                // Get worksheet dimensions
                $sheet = $objPHPExcel->getSheet(0);
                $highestRow = $sheet->getHighestRow();
                $highestColumn = $sheet->getHighestColumn();
//                            $sheet = $objPHPExcel->getActiveSheet()->toArray(null,true,true);
//                            $sheet = recursive_iconv ('UTF-8', 'Windows-1251', $sheet);

                echo '<h4>Sheet Data (', number_format($highestRow), ' Records): '.$filePath.'</h4>';
                echo '<table><tr>
                                    <th class="tiny">COLUMN A</th>
                                    <th class="tiny">COLUMN B</th>
                                    <th class="tiny">COLUMN C</th>
                                    <th class="tiny">COLUMN D</th>
                                    <th class="huge">COLUMN E</th>
                                    <th class="large">COLUMN F</th>
                                    <th class="small">COLUMN G</th>
                                    </tr>';
                // Loop through each row of the worksheet in turn
                $column = array();
                $index = 0;
                $skuRowStart = null;
                $skuNameColumn = null;
                $skuWeightColumn = null;
                $skuPriceColumn = null;

                $skuCount = 0;
                $log = [];
                echo "Flag 8".PHP_EOL;
                for ($row = 2; $row <= $highestRow; $row++){
                    //foreach($sheet as $row => $rowData){
                    // Read a row of data into an array
                    // if($row > 1){
                    $rowData = $sheet->rangeToArray('A' . $row . ':' . $highestColumn . $row, NULL, true, TRUE);
                    $rowData = recursive_iconv ('UTF-8', 'Windows-1251', $rowData);


                    // Insert into array
                    $column[$index]['COLUMN_A'] = $rowData[0][0];
                    $column[$index]['COLUMN_B'] = $rowData[0][1];
                    $column[$index]['COLUMN_C'] = $rowData[0][2];
                    $column[$index]['COLUMN_D'] = $rowData[0][3];
                    $column[$index]['COLUMN_E'] = $rowData[0][4];
                    $column[$index]['COLUMN_F'] = $rowData[0][5];
                    $column[$index]['COLUMN_G'] = $rowData[0][6];


                    foreach ($rowData[0] as $col => $item) {
                        //array_push($log,'skuNameColumn: '.mb_strtolower($item,'Windows-1251').' - продукт ['.strpos(mb_strtolower($item,'Windows-1251'),'продукт').']');
                        if(
                            !isset($skuNameColumn) &&
                            ((strpos(mb_strtolower($item,'Windows-1251'),'продукт') !== false) ||
                                (strpos(mb_strtolower($item,'Windows-1251'),'атб-маркет тов') !== false) ||
                                (strpos(mb_strtolower($item,'Windows-1251'),'наименование') !== false))
                        ){
                            $skuNameColumn = $col;
                            $skuRowStart = $row + 1;
                            continue;
                        }
                        //array_push($log,'skuWeightColumn: '.mb_strtolower($item,'Windows-1251').' - вес ['.strpos(mb_strtolower($item,'Windows-1251'),'вес').']');
                        //array_push($log,'skuWeightColumn: '.mb_strtolower($item,'Windows-1251').' - объем ['.strpos(mb_strtolower($item,'Windows-1251'),'объем').']');
                        if(
                            !isset($skuWeightColumn) &&
                            ((strpos(mb_strtolower($item,'Windows-1251'),'кол-во') !== false) ||
                                (strpos(mb_strtolower($item,'Windows-1251'),' вес ') !== false) ||
                                (strpos(mb_strtolower($item,'Windows-1251'),'объем') !== false))
                        ){
                            $skuWeightColumn = $col;
                            continue;
                        }
                        //array_push($log,'skuPriceColumn: '.mb_strtolower($item,'Windows-1251').' - сумма ['.strpos(mb_strtolower($item,'Windows-1251'),'сумма').']');
                        //array_push($log,'skuPriceColumn: '.mb_strtolower($item,'Windows-1251').' - компенсация ['.strpos(mb_strtolower($item,'Windows-1251'),'компенсация').']');
                        if(
                            !isset($skuPriceColumn) &&
                            ((strpos(mb_strtolower($item,'Windows-1251'),'продажи сумма') !== false) ||
                                (strpos(mb_strtolower($item,'Windows-1251'),'продажи с ндс') !== false) ||
                                (strpos(mb_strtolower($item,'Windows-1251'),'сумма') !== false) ||
                                (strpos(mb_strtolower($item,'Windows-1251'),'компенсация') !== false))
                        ){
                            $skuPriceColumn = $col;
                        }
                    }

                    if($skuRowStart === $row && isset($skuNameColumn) /*&& isset($skuWeightColumn) && isset($skuPriceColumn)*/){
//                        echo "<pre style='text-align: left;'>";
//                        echo mb_strtolower($rowData[0][$skuNameColumn],'Windows-1251').PHP_EOL;
//                        echo "</pre>";
                        if($rowData[0][$skuNameColumn] !== "" && mb_strtolower($rowData[0][$skuNameColumn],'Windows-1251') !== "итого"){
                            $skuArray[$skuCount] = [];
                            $skuArray[$skuCount]['SKU_NAME'] = $rowData[0][$skuNameColumn];
                            if(isset($skuWeightColumn) && is_numeric($rowData[0][$skuWeightColumn]))
                                $skuArray[$skuCount]['SKU_WEIGHT_TOTAL'] = $rowData[0][$skuWeightColumn];
                            if(isset($skuPriceColumn) && is_numeric($rowData[0][$skuPriceColumn]))
                                $skuArray[$skuCount]['SKU_SALES_TOTAL'] = $rowData[0][$skuPriceColumn];


                            $skuCount++;
                        }
                        $skuRowStart++;
                    }

                    // Display data from array
                    if ($row % 2 == 0) {
                        echo '<tr class="dark">';
                    } else {
                        echo '<tr class="light">';
                    }
                    echo '<td class="tiny" data-row="'.$row.'" data-column="A">', $column[$index]['COLUMN_A'], '</td>';
                    echo '<td class="tiny">', $column[$index]['COLUMN_B'], '</td>';
                    echo '<td class="tiny">', $column[$index]['COLUMN_C'], '</td>';
                    echo '<td class="tiny">', $column[$index]['COLUMN_D'], '</td>';
                    echo '<td class="huge">', $column[$index]['COLUMN_E'], '</td>';
                    echo '<td class="large">', $column[$index]['COLUMN_F'], '</td>';
                    echo '<td class="small">', $column[$index]['COLUMN_G'], '</td>';
                    echo '</tr>';
                    $index = $index + 1;
                    //}
                };
                echo '</table>';
//                echo "<pre style='text-align: left;'>";
//                print_r($skuArray);
//                echo "</pre>";
//                echo "<pre style='text-align: left; display: none;'>";
//                echo PHP_EOL."LOG : ";
//                print_r($log);
//                echo "</pre>";
                if(!count($skuArray)){
                    array_push($skipArray,'Cannot parse file: '.$filePath);
                }
            } else {
                array_push($logArray,'upload an XLS: '.$filePath);
                return [];
                //die("Please upload an XLS or XLSX file");
            };
        } else {
            array_push($logArray,'error: file_get_contents('.$filePath.')');
            return [];
            //die('error: file_get_contents('.$filePath.')');
        };
    }else{
        array_push($logArray,"file name is empty");
        return [];
        //die("file name is empty");
    };
    return $skuArray;
}

?>


<style>
    th {
        background-color: #bbb;
    }
    th, td {
        font-size: 11px;
    }
    .tiny {
        width: 77px;
    }
    .small {
        width: 98px;
    }
    .medium {
        width: 140px;
    }
    .large {
        width: 280px;
    }
    .huge {
        width: 420px;
    }
    .dark {
        background-color: #ccc;
    }
    .light {
        background-color: #ddd;
    }
</style>
<div class="container-fluid">
    <div class="xlsToArray">
        <div class="row-fluid well">
            <h3>Load Spreadsheet</h3>
            <div class="row">
                <div class="col-md-1">
                <form method="post" enctype="multipart/form-data" action="/?action=readXlsx_v1">
                    <p>
                        <input type="radio" name="save_data" value="1">Save Data<br>
                        <input type="radio" name="save_data" value="0" checked >Only parse<br>
                    </p>
                    <p>
                        <label for="spreadsheet">Upload File:</label>
                        <input type="file" name="spreadsheet"/>
                        <label for="id_zay">Id zay:</label>
                        <input type="number" name="id_zay" title="Id zay">
                        <input type="submit" name="loadExcel" value="LoadExcel" />
                    </p>
                    <p>
                        <label for="id_net">Id Net:</label>
                        <input type="number" name="id_net" title="Id Net">
                        <input type="submit" name="generate" value="Generate" />
                    </p>
                </form>
                </div>
            </div>
        </div>
    </div>
</div>
