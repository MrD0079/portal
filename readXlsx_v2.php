<?php
/**
 * Created by PhpStorm.
 * User: Taras.Daragan
 * Date: 28.01.2020
 * Time: 10:58
 */

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
                    <form method="post" enctype="multipart/form-data" action="/?action=readXlsx_v2">
                        Upload File: <input type="file" name="spreadsheet"/>
                        <input type="submit" name="submit" value="Submit" />
                    </form>
                </div>
            </div>

            <?php
            /////// Include PHPExcel_IOFactory
            try {
                require_once 'PHPExcel/Classes/PHPExcel/IOFactory.php';
            } catch(Exception $e) {
                die($e->getMessage());
            };
            //Check valid spreadsheet has been uploaded
            if(isset($_FILES['spreadsheet'])){
                if($_FILES['spreadsheet']['name']){
                    if(!$_FILES['spreadsheet']['error']) {
                        $inputFile = $_FILES['spreadsheet']['name'];
                        $extension = strtoupper(pathinfo($inputFile, PATHINFO_EXTENSION));
                        if($extension == 'XLSX' || $extension == 'ODS') {
                            // Read spreadsheeet workbook
                            try {
                                $inputFile = $_FILES['spreadsheet']['tmp_name'];

                                echo "tmp_name: $inputFile ".PHP_EOL;
                                echo "pathinfo: " .PHP_EOL;
                                print_array(pathinfo($inputFile));

                                $inputFileType = PHPExcel_IOFactory::identify($inputFile);
                                $objReader = PHPExcel_IOFactory::createReader($inputFileType);
                                $objPHPExcel = $objReader->load($inputFile);
                            } catch(Exception $e) {
                                die($e->getMessage());
                            };
                            // Get worksheet dimensions
                            $sheet = $objPHPExcel->getSheet(0);
                            $highestRow = $sheet->getHighestRow();
                            $highestColumn = $sheet->getHighestColumn();
//                            $sheet = $objPHPExcel->getActiveSheet()->toArray(null,true,true);
//                            $sheet = recursive_iconv ('UTF-8', 'Windows-1251', $sheet);

                            echo '<h4>Sheet Data (', number_format($highestRow), ' Records):</h4>';
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
                            $skuArray = [];
                            $skuCount = 0;
                            $log = [];
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
                                            (strpos(mb_strtolower($item,'Windows-1251'),'вес') !== false) ||
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


                                if($skuRowStart === $row && isset($skuNameColumn) && isset($skuWeightColumn) && isset($skuPriceColumn)){
                                    if($rowData[0][$skuNameColumn] !== ""){
                                        $skuArray[$skuCount] = [];
                                        $skuArray[$skuCount]['name'] = $rowData[0][$skuNameColumn];
                                        $skuArray[$skuCount]['weight'] = $rowData[0][$skuWeightColumn];
                                        $skuArray[$skuCount]['sales'] = $rowData[0][$skuPriceColumn];

                                        $skuRowStart++;
                                        $skuCount++;
                                    }
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
                            echo "<pre style='text-align: left;'>";
                            print_r($skuArray);
                            echo "</pre>";
                            echo "<pre style='text-align: left; display: none;'>";
                            echo PHP_EOL."LOG : ";
                            print_r($log);
                            echo "</pre>";
                        } else {
                            echo "Please upload an XLS or XLSX file";
                        };
                    } else {
                        echo $_FILES['spreadsheet']['error'];
                    };
                };
            };
            ?>

        </div>
    </div>
</div>
