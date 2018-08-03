<?

if (isset($_REQUEST['save_item'])) {
    $_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);
    isset($_REQUEST['aa']['dts'])?$_REQUEST['aa']['dts']=OraDate2MDBDate($_REQUEST['aa']['dts']):null;
    isset($_REQUEST['aa']['dte'])?$_REQUEST['aa']['dte']=OraDate2MDBDate($_REQUEST['aa']['dte']):null;
    $keys = array('id'=>$_REQUEST["id"]);
    isset($_REQUEST["aa"])?Table_Update('merch_report_cal_aa_h', $keys,$_REQUEST["aa"]):null;
    if (isset($_REQUEST["obl"])) {
        $keys = array('head_id'=>$_REQUEST["id"]);
        Table_Update('merch_report_cal_aa_o', $keys,null);
        $obl = explode(',',$_REQUEST["obl"]);
        foreach ($obl as $k=>$v) {
                $keys = array('head_id'=>$_REQUEST["id"],'h_o'=>$v);
                Table_Update('merch_report_cal_aa_o', $keys,$keys);
        }
    }
    if (isset($_REQUEST["sku"])) {
        foreach ($_REQUEST["sku"] as $k=>$v) {
            if ($k<0) {
                $keys=$v;
                $keys['head_id']=$_REQUEST["id"];
                $vals=$keys;
            } else {
                $keys=array('id'=>$k);
                $vals=$v;
            }
            Table_Update('merch_report_cal_aa_s', $keys,$vals);
        }
        foreach ($_REQUEST["sku_del"] as $k=>$v) {
            if ($v==1){
                $keys=array('id'=>$k);
                Table_Update('merch_report_cal_aa_s', $keys,null);
            }
        }
    }
} else if (isset($_REQUEST['del_item'])) {
	Table_Update('merch_report_cal_aa_h', array('id'=>$_REQUEST["id"]),null);
} else if (isset($_REQUEST['get_list'])) {
	$sql = "/* Formatted on 13.04.2018 16:41:37 (QP5 v5.252.13127.32867) */
  SELECT h.*,
         TO_CHAR (h.lu, 'dd.mm.yyyy hh24:mi:ss') lut,
         TO_CHAR (h.dts, 'dd.mm.yyyy') dts,
         TO_CHAR (h.dte, 'dd.mm.yyyy') dte,
         ch.city,
         n.net_name,
         a.name ag_name,
         fn_query2str (
               'SELECT DISTINCT c.tz_oblast
            FROM merch_report_cal_aa_o o, cpp c
           WHERE o.head_id = '
            || h.id
            || ' AND c.h_tz_oblast = o.h_o order by c.tz_oblast',
            ', ')
            obl,
         fn_query2str (
            'SELECT sku || '', '' || price_act || '', '' || price_wo_act
             FROM merch_report_cal_aa_s
           WHERE head_id = ' || h.id,
            CHR (10)||CHR (13))
            sku
    FROM merch_report_cal_aa_h h,
         (  SELECT DISTINCT h_city, city
              FROM cpp
             WHERE city IS NOT NULL
          ORDER BY city) ch,
         ms_nets n,
         routes_agents a
   WHERE     h.h_city = ch.h_city(+)
         AND h.id_net = n.id_net(+)
         AND h.ag_id = a.id(+)
         AND DECODE ( :ag_id, 0, NVL (h.ag_id, 0), :ag_id) = NVL (h.ag_id, 0)
         AND (   ( :dt = 1 AND TRUNC (SYSDATE) BETWEEN h.dts AND h.dte)
              OR ( :dt = 2 AND TRUNC (SYSDATE) > h.dte)
              OR :dt = 3
              OR (    :dt = 4
                  AND (   h.dts BETWEEN ADD_MONTHS (TRUNC (SYSDATE), -1)
                                    AND ADD_MONTHS (TRUNC (SYSDATE), 1)
                       OR h.dte BETWEEN ADD_MONTHS (TRUNC (SYSDATE), -1)
                                    AND ADD_MONTHS (TRUNC (SYSDATE), 1))))
ORDER BY h.id DESC";
	$p=array(
		':ag_id'=>$_REQUEST['list_ag_id'],
		':dt'=>$_REQUEST['list_dt'],
	);
	$sql=stritr($sql,$p);
	$x = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('tbl', $x);
} else if (isset($_REQUEST["id"])||isset($_REQUEST["new"])) {
    !isset($_REQUEST["id"])?$_REQUEST["id"]=get_new_id():null;
    $sql = "SELECT h.id,
       h.ag_id,
       h.h_city,
       h.id_net,
       h.tasks,
       h.need_photo,
       h.actual_promo_price,
       h.cancelled,
       TO_CHAR (h.lu, 'dd.mm.yyyy hh24:mi:ss') lut,
       TO_CHAR (h.dts, 'dd.mm.yyyy') dts,
       TO_CHAR (h.dte, 'dd.mm.yyyy') dte,
       ch.city,
       n.net_name,
       a.name ag_name
       FROM merch_report_cal_aa_h h,
       (  SELECT DISTINCT h_city, city
            FROM cpp
           WHERE city IS NOT NULL
        ORDER BY city) ch,
       ms_nets n,
       routes_agents a
       WHERE h.h_city = ch.h_city(+)
       AND h.id_net = n.id_net(+)
       AND h.ag_id = a.id(+)
       AND h.id = :id";
	$p=array(':id'=>$_REQUEST["id"]);
	$sql=stritr($sql,$p);
    $r = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
    $smarty->assign('h', $r);
    $sql = "SELECT DISTINCT c.tz_oblast, c.h_tz_oblast, o.h_o
    FROM merch_report_cal_aa_o o, cpp c
    WHERE o.head_id(+) = '".$_REQUEST["id"]."' AND c.h_tz_oblast = o.h_o(+)
    AND c.h_tz_oblast is not null
    ORDER BY c.tz_oblast";
    $r = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
    $smarty->assign('o', $r);
    $sql = "SELECT z.* FROM merch_report_cal_aa_s z WHERE head_id = '".$_REQUEST["id"]."' ORDER BY id";
    $r = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
    $smarty->assign('s', $r);
    $sql = rtrim(file_get_contents('sql/merch_report_cal_aa_list_a.sql'));
    $x = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
    $smarty->assign('agents', $x);
    $sql = rtrim(file_get_contents('sql/merch_report_cal_aa_list_o.sql'));
    $x = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
    $smarty->assign('obl', $x);
    $sql = rtrim(file_get_contents('sql/merch_report_cal_aa_list_n.sql'));
    $x = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
    $smarty->assign('nets', $x);
    $sql = rtrim(file_get_contents('sql/merch_report_cal_aa_list_c.sql'));
    $x = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
    $smarty->assign('cities', $x);
} else {
	$sql = rtrim(file_get_contents('sql/merch_report_cal_aa_list_a.sql'));
	$x = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('agents', $x);
}
$smarty->display('merch_report_cal_aa.html');
