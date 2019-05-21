<?php
include "SkuSelect.php";
$skuObj = new \SkuSelect\SkuSelect($db);
$smarty->assign('skuObj', $skuObj);

$zid = $_REQUEST['z_id'] != "" ? $_REQUEST['z_id'] : null;

if(isset($zid)){
    $params= array(':z_id'=> $zid);
    $sql = "SELECT
              bf.id AS fil_kod,
              z.ID_NET as net_id,
              (SELECT DECODE(VAL_LIST, 176856076,1,176856084,2,0)  
              FROM bud_ru_zay_ff WHERE z_id = z.id AND VAL_LIST IS NOT NULL AND ff_id=176856141 /* вид акции */
              ) akc_type,
              (SELECT NVL(VAL_NUMBER,0)  
              FROM bud_ru_zay_ff WHERE z_id =z.id AND VAL_NUMBER IS NOT NULL AND ff_id=176933669 /* % скидки по акции */
              ) akc_expens,
              (SELECT NVL(VAL_NUMBER,0)  
              FROM bud_ru_zay_ff WHERE z_id =z.id AND VAL_NUMBER IS NOT NULL AND ff_id=177005005 /* % скидки по акции */
              ) bonus_net_perc,
              MAX(d.DATE_P) AS db_date
              FROM bud_ru_zay z,
                   BUD_FIL bf,
                   sku_avk_distrib_income d,
                  bud_ru_zay_ff ff
            WHERE z.id = :z_id
                  AND z.FIL = bf.ID
                  AND bf.sw_kod = d.KOD_FILIALA
                  AND ff.Z_ID = z.id
                  AND ROWNUM = 1
            GROUP BY  bf.id,
              z.ID_NET,
              z.id
            ORDER BY db_date DESC";
    $sql=stritr($sql,$params);

    $zay_params = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

    if(count($zay_params) > 0){
        $data = array(
            'z_id' => $zid,
            'akc_type' => $zay_params[0]['akc_type'],
            'bonus_net_perc' => $zay_params[0]['bonus_net_perc'],
            'net_id' => $zay_params[0]['net_id'],
            'akc_expens' => $zay_params[0]['akc_expens'],
            'fil_kod' => $zay_params[0]['fil_kod'],
            'print' => true
        );

        $smarty->assign('params', $data);
    }
}

$smarty->display('testSkuSelect.html');
?>
