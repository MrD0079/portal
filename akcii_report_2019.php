<?php

InitRequestVar("id_net_report",[0]);
InitRequestVar("id_net_report_empty",0);

$params=array(':tn'=>$tn,':dpt_id' => $_SESSION["dpt_id"]);

$sql=rtrim(file_get_contents('sql/nets.sql'));
$sql=stritr($sql,$params);
$nets = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('nets', $nets);

if($_REQUEST['id_net_report_empty'] && $_REQUEST['id_net_report_empty'] == 1){
    $_REQUEST["id_net_report"] = [0];
}

$params=array(
    ":id_net_report"    =>  isset($_REQUEST["id_net_report"]) ? 'in ('.implode(',',$_REQUEST["id_net_report"]).')' : ' = 0',
);


if($_REQUEST['select']){
    $sql=rtrim(file_get_contents('sql/akcii_report_2019.sql'));
    $sql=stritr($sql,$params);
//    echo "<pre style='display: none;text-align: left;'>";
//    echo var_dump($sql);
//    echo "</pre>";
    $datas = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
    $akcii_report = [];

    foreach ($datas as $i => $data) {
        //if(!array_key_exists($data['id_net'],$akcii_report) or !array_key_exists($data['id'], $akcii_report[$data['id_net']])){
        if(!array_key_exists($data['id'], $akcii_report)){
            $akcii_report/*[$data['id_net']]*/[$data['id']] = [
                'net_name' => $data['net_name'],
                'sales_total' => $data['fact_sales_total'],
                'discount_total' => $data['discount_total'],
                'dt_start' => $data['dt_start'],
                'dt_end' => $data['dt_end'],
            ];
        }

        $dt_start = new DateTime($datas[$i]['dt_start']);
        $dt_end = new DateTime($datas[$i]['dt_end']);
        $datas[$i]['dt_start'] = $dt_start->format('Y-m-d');
        $datas[$i]['dt_end'] = $dt_end->format('Y-m-d');

        $files = explode("\n",$data['filepath']);
        if(!is_array($datas[$i]['filepath'])){
            $datas[$i]['filepath'] = [];
        }
        if(count($files) > 1){
            $filePath = substr($files[0], 0, strripos($files[0], '/'));
            if(!is_array($datas[$i]['filepath'])){
                $datas[$i]['filepath'] = [];
            }
            foreach ($files as $ind => $file) {
                if ($ind >= 1) {
                    $akcii_report/*[$data['id_net']]*/[$data['id']]['filepath'][] = $filePath . '/' . $file;

                    $datas[$i]['filepath'][] = $filePath . '/' . $file;
                }else{
                    $akcii_report/*[$data['id_net']]*/[$data['id']]['filepath'][] = $file;
                    $datas[$i]['filepath'][] = $file;
                }
            }
        }else{
            $akcii_report/*[$data['id_net']]*/[$data['id']]['filepath'][] = $data['filepath'];
            $datas[$i]['filepath'][] = $data['filepath'];
        }

        $akcii_report/*[$data['id_net']]*/[$data['id']]['skuList'][] = [
            'brand' => $data['name_brand'],
            'sku_name' => $data['sku_name'],
            'sales_weight' => $data['sku_sales_weight'],
            'sales_cost' => $data['sku_sales_cost'],
        ];
    }

//    echo "<pre style='display: none;text-align: left;'>";
//    echo var_dump($datas);
//    echo "</pre>";


    $smarty->assign('akcii_report_source', $datas);
    $smarty->assign('akcii_report', $akcii_report);
}
$nets = isset($_REQUEST["id_net_report"]) ? json_encode($_REQUEST["id_net_report"]) : json_encode([0]);

$smarty->assign('netsSelected', $nets);

$smarty->display('akcii_report_2019.html');