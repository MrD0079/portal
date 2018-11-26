<?php
$_REQUEST["tu"]==1?$doc_str="торговые услови§":$doc_str="за€вка на проведение активности";

InitRequestVar("exp_list_without_ts",0);
InitRequestVar("dates_list1",$_SESSION["month_list"]);
InitRequestVar("dates_list2",$now);
InitRequestVar("who",0);
InitRequestVar("status",0);
InitRequestVar("srok_ok",0);
InitRequestVar("report_done_flt",0);
InitRequestVar("report_zero_cost_flt",0);
InitRequestVar("st",0);
InitRequestVar("kat",0);
InitRequestVar("creator",0);
InitRequestVar("country",$_SESSION["cnt_kod"]);
InitRequestVar("bud_ru_zay_pos_id",0);
InitRequestVar("fil",0);
InitRequestVar("funds",0);
InitRequestVar("id_net",0);
InitRequestVar("region_name","0");
InitRequestVar("department_name","0");
InitRequestVar("z_id",0);
InitRequestVar("wait4myaccept",1);
InitRequestVar("date_between_brzr","dt12");

$params=array(
    ':exp_list_without_ts' => $_REQUEST["exp_list_without_ts"],
    ':tn' => $tn,
    ':dpt_id' => $_SESSION["dpt_id"],
    ":dates_list1"=>"'".$_REQUEST["dates_list1"]."'",
    ":dates_list2"=>"'".$_REQUEST["dates_list2"]."'",
    ":status"=>$_REQUEST["status"],
    ":srok_ok"=>$_REQUEST["srok_ok"],
    ":report_done_flt"=>$_REQUEST["report_done_flt"],
    ":report_zero_cost"=>$_REQUEST["report_zero_cost_flt"],
    ":st"=>$_REQUEST["st"],
    ":kat"=>$_REQUEST["kat"],
    ":creator"=>$_REQUEST["creator"],
    ":who"=>$_REQUEST["who"],
    ":fil"=>$_REQUEST["fil"],
    ":funds"=>$_REQUEST["funds"],
    ":id_net"=>$_REQUEST["id_net"],
    ":country"=>"'".$_REQUEST["country"]."'",
    ":bud_ru_zay_pos_id"=>$_REQUEST["bud_ru_zay_pos_id"],
    ":region_name"=>"'".$_REQUEST["region_name"]."'",
    ":department_name"=>"'".$_REQUEST["department_name"]."'",
    ':wait4myaccept'=>$_REQUEST['wait4myaccept'],
    "/*dyn_flt*/"=>$dyn_flt,
    ":z_id"=>$_REQUEST["z_id"],
    ':date_between_brzr' => "'".$_REQUEST["date_between_brzr"]."'",
    ':tu'=>$_REQUEST['tu']
);
$sql=rtrim(file_get_contents('sql/bud_ru_zay_report.sql'));
$sql=stritr($sql,$params);
//echo $sql;
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

foreach ($data as $k=>$v)
{
    $d[$v["id"]]["head"]=$v;
    $d[$v["id"]]["executors"][$v["executor_tn"]]=$v;
    $d[$v["id"]]["data"][$v["acceptor_tn"]]=$v;
    if ($v["chat_id"]!="")
    {
        $d[$v["id"]]["chat"][$v["chat_id"]]=$v;
    }
    if ($v["zchat_id"]!="")
    {
        $d[$v["id"]]["zchat"][$v["zchat_id"]]=$v;
    }
}

if (isset($d)) {

    foreach ($d as $k => $v) {
        $sql = rtrim(file_get_contents('sql/bud_ru_zay_get_ff.sql'));
        $p = array(':z_id' => $k);
        $sql = stritr($sql, $p);
        $data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
        foreach ($data as $k1 => $v1) {
            if ($v1["type"] == "file") {
                $v1["val_file"] != null ? $data[$k1]["val_file"] = explode("\n", $v1["val_file"]) : null;
                $v1["rep_val_file"] != null ? $data[$k1]["rep_val_file"] = explode("\n", $v1["rep_val_file"]) : null;
            }
            /*if ($v1['type']=='list')
            {
                if ($v1['val_list'])
                {
                $sql=$db->getOne('SELECT get_item FROM bud_ru_ff_subtypes WHERE id = (SELECT subtype FROM bud_ru_ff WHERE id = '.$v1['ff_id'].')');
                $params[':id'] = $v1['val_list'];
                $sql=stritr($sql,$params);
                $list = $db->getOne($sql);
                $data[$k1]['val_list_name'] = $list;
                }

                if ($v1['rep_val_list'])
                {
                $sql=$db->getOne('SELECT get_item FROM bud_ru_ff_subtypes WHERE id = (SELECT subtype FROM bud_ru_ff WHERE id = '.$v1['ff_id'].')');
                $params[':id'] = $v1['rep_val_list'];
                $sql=stritr($sql,$params);
                $list = $db->getOne($sql);
                $data[$k1]['rep_val_list_name'] = $list;
                }

            }*/
            if (($v1['type'] == 'list') && ($v1['autocomplete'] != 1)) {
                $sql = $db->getOne('select get_list from bud_ru_ff_subtypes where id = (SELECT subtype FROM bud_ru_ff WHERE id = ' . $v1['ff_id'] . ')');
                $sql = stritr($sql, $params);
                $list = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
                $data[$k1]['list'] = $list;
            }

        }
        include "bud_ru_zay_formula.php";
        $d[$k]["ff"] = $data;
        $v["head"]["sup_doc"] != null ? $d[$k]["head"]["sup_doc"] = explode("\n", $v["head"]["sup_doc"]) : null;
    }
//Add button for download reestr in PDF file
if (isset($_REQUEST['get_pdf'])) {
    $params = array(
        "id" => $_REQUEST['get_pdf'],
        "file_name" => 'bud_ru_zay_report',
        "to_file" => 0, // 1 - to save created pdf file on server
        "catalog" => 'bud_ru_zay_report'
    );

    $data = array();
	if (isset($d)) {
		foreach ($d as $item) {
			if ($item['head']['id'] == $_REQUEST['get_pdf']) {
				$data_current = $item;
				break;
			}
		}
		if (isset($data_current)) {

			require_once "CreatePDF.php";
			$pdf = new CreatePDF ($smarty);
			$pdf_res = $pdf->create('tpl','bud_ru_zay_report_pdf.html', $params, $data_current);
			if ($pdf_res != "ok") {
				echo "<div class='error_pdf_text'>" . $pdf_res . "</div>";
			}
		}
    }
}
}

?>