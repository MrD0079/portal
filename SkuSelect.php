<?php

namespace SkuSelect;

class SkuSelect
{
    private $db;


    public function __construct($db)
    {
        $this->db = $db;
    }

    private function modalLoadSku($z_id){
        $sql = "SELECT bsa.*,sa.NAME name, иг.WEIGHT weight, sa.TAG_ID tag_id, sa.NAME_BRAND brand FROM bud_ru_zay_sku_avk bsa, sku_avk sa WHERE bsa.id_num = sa.id_num(+) AND bsa.status = 1 AND bsa.z_id = ".$z_id;

        $sku_list = $this->db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

//        if (PEAR::isError($sku_list)) {
//            echo 'error: ' . $sku_list->getMessage() . " " . $sku_list->getDebugInfo();
//            return false;
//        } else {
            return $sku_list;
//        }
    }

    private function controllerCreateHtml($data,$ack_type,$is_calc = false){
        echo '<pre style="display: none;">';
        //print_r($data);
        echo '</pre>';

        $html = '<table id="sku_selected" width="100%" border="1" style="max-width: 900px;background-color: #fff;">'.
                '<thead style="background-color: #03a9f454;">'.
                '<tr style="font-size: 10px;font-weight: bold;text-align: center;">'.
                    '<td rowspan="2">TAG_ID</td>'.
                    '<td rowspan="2">Бренд</td>'.
                    '<td rowspan="2">Продукт</td>'.
                    '<td rowspan="2">Вес, кг</td>'.
                    '<td rowspan="2">СС,грн/кг</td>'.
                    '<td rowspan="2">Цена своб.-отпускн. Укр.,грн с НДС</td>'.
                    '<td rowspan="2">Цена Спец-ии КК, грн с НДС</td>'.
                    '<td rowspan="2">Цена за продажи в сеть за ед.,грн с НДС</td>';
                if ($ack_type == 2 && $is_calc)
                    $html .= '<td rowspan="2" class="type2">Цена за продажи в сеть за ед. со скидкой,грн с НДС</td>';
        $html .= '<td rowspan="2">Объем продажи,шт.</td>';
        if($is_calc) {
            $html .= '<td rowspan="2">Объем продажи,кг.</td>' .
                '<td rowspan="2">Объем продаж, грн с НДС</td>';
            if ($ack_type == 2)
                $html .= '<td rowspan="2" class="type2">Объем продаж с учетом скидки, грн с НДС</td>';
            $html .= '<td rowspan="2">СС на объем отгрузки,грн с НДС</td>' .
                '<td rowspan="2">Ожидаемая ВП,грн с НДС</td>' .
                '<td colspan="'.($ack_type == 2 ? "4" : "5").'" class="colspan5">Расходы сети итого, вт.ч.</td>' .
                '<td rowspan="2">Чистая прибыль, грн с НДС</td>';
            if ($ack_type == 2) {
                $html .= '<td rowspan="2" class="type2">Расходы по акции в скидке, грн с НДС</td>' .
                    '<td rowspan="2" class="type2">Всего затрат по сети, грн с НДС</td>';
            }
        }
        $html .= '</tr>';
        if($is_calc) {
            $html .= '<tr style="font-size: 10px;font-weight: bold;text-align: center;">' .
                '<td>Бонус сети, грн с НДС</td>';
            if ($ack_type == 1)
                $html .='<td class="type1">Затраты по акции б/н (компенсация), грн с НДС</td>' ;
            $html .='<td>Бонус дистриб, грн с НДС</td>' .
                '<td>Расходы по логистике</td>' .
                '<td>Расходы Компании, грн с НДС</td>' .
                '</tr>';
        }
        $html .= '</thead>'.
                '<tbody>';
        if(count($data) > 0) {
            foreach ($data as $key => $sku) {
                $html .= '<!-- SKU -->' .
                    '<tr style="text-align: center;">' .
                    '<td>' .
                     $sku['tag_id'] .
                    '</td>' .
                    '<td>' .
                    $sku['brand'] .
                    '</td>' .
                    '<td>' .
                    $sku['name'] .
                    '</td>' .
                    '<td>' .
                    $sku['weight'] .
                    '</td>' .
                    '<td>' .
                    $sku['price_ss'] .
                    '</td>' .
                    '<td>' .
                    $sku['price_uk'] .
                    '</td>' .
                    '<td>' .
                     $sku['price_kk'] .
                    '</td>' .
                    '<td>' .
                    $sku['price_net'] .
                    '</td>';
                if ($ack_type == 2 && $is_calc)
                    $html .= '<td class="type2" >' .$sku['price_net_disc'] .'</td>';
                $html .= '<td>' .$sku['total_q'] .'</td>';
                if($is_calc){
                    $html .= '<td>'.$sku['total_volume_price'].'</td>'.
                        '<td>'.$sku['total_volume_price_one'].'</td>';
                    if ($ack_type == 2)
                        $html .= '<td class="type2">'.$sku['total_volume_price_one_discount'].'</td>';
                    $html .= '<td>'.$sku['ss_volume'].'</td>'.
                        '<td>'.$sku['expected_vp'].'</td>'.
                        '<td>'.$sku['bonus_net_sku'].'</td>';
                    if ($ack_type == 1)
                        $html .= '<td class="type1">'.$sku['akc_expenses'].'</td>';
                    $html .= '<td>'.$sku['share_expenses'].'</td>'.
                        '<td>'.$sku['logistics_expens_total'].'</td>'.
                        '<td>'.$sku['company_expens_total'].'</td>'.
                        '<td>'.$sku['net_clear'].'</td>';
                    if ($ack_type == 2)
                        $html .= '<td class="type2">'.$sku['prom_costs_discount'].'</td>'.
                        '<td class="type2">'.$sku['total_network_costs'].'</td>';

                }
                $html .='</tr>';
            }
        }
        $html .='</tbody>'.
            '</table>';
        if(count($data) <= 0){
            $html .= '<span class="info-sku">Нет выбранных продуктов</span>';
        }
        return $html;
    }

    private function CalculateSku(&$data,$akc_type,$bonus_net_perc = null,$net_id = null,$akciya_expences_perc = null){
        if(count($data) <=0 )
            return false;
        $is_calc = false;
        try {
            if (!is_null($net_id)) {
                $bonus_distr_pers = $this->modalGetDistribBonus($net_id);
            }else{
                $bonus_distr_pers = 0;
            }
            foreach ($data as $k => $sku) {
                foreach ($sku as $key => $item) {
                    $data[$k][$key] = $this->NormalizeFloat($item);
                }
                //calculate
                if (!is_null($bonus_net_perc)) {
                    $is_calc = true;
                    //$bonus_distr_pers = $this->modalGetDistribBonus($net_id);
                    $akciya_expences_perc /= 100;
                    $bonus_net_perc /= 100;
                    $bonus_distr_pers /= 100;

                    //$data[$k]['total_q'];//объем продаж шт.
                    $data[$k]['total_volume_price'] = $data[$k]['total_q'] * $data[$k]['weight'];//объем продаж кг.
                    $data[$k]['total_volume_price_one'] = $data[$k]['total_q'] * $data[$k]['price_net'];//объем продаж грн
                    $data[$k]['price_net_disc'] = $data[$k]['price_net'] - ($data[$k]['price_net'] * $akciya_expences_perc);
                    $data[$k]['total_volume_price_one_discount'] = $data[$k]['total_q'] * $data[$k]['price_net_disc'];//объем продаж грн. СКИДКА
                    $data[$k]['ss_volume'] = $data[$k]['total_volume_price'] * $data[$k]['price_ss'];//СС на объем отгрузки
                    if ($akc_type == 1) {
                        $data[$k]['expected_vp'] = $data[$k]['total_volume_price_one'] - $data[$k]['ss_volume'];//Ожидаемая ВП
                        $data[$k]['bonus_net_sku'] = $data[$k]['total_volume_price_one'] * $bonus_net_perc;//бонус сети
                    } else {
                        $data[$k]['expected_vp'] = $data[$k]['total_volume_price_one_discount'] - $data[$k]['ss_volume'];//Ожидаемая ВП
                        $data[$k]['bonus_net_sku'] = $data[$k]['total_volume_price_one_discount'] * $bonus_net_perc;//бонус сети
                    }
                    $data[$k]['share_expenses'] = $data[$k]['price_uk'] * $data[$k]['total_q'] * $bonus_distr_pers;//Бонус дистриб
                    $data[$k]['akc_expenses'] = $data[$k]['total_volume_price_one'] * $akciya_expences_perc;//затраты по акции б/н
                    $data[$k]['logistics_expens_total'] = $data[$k]['logistic_expens']*$data[$k]['total_volume_price']*0.001;//Расходы по логистике

                    $company_expens = $data[$k]['company_expens']*$data[$k]['total_volume_price']*0.001; //цена за тонну
                    $market_val = $data[$k]['market_val']*$data[$k]['total_volume_price']*0.001;
                    $data[$k]['company_expens_total'] = ($company_expens + $market_val) * $data[$k]['ss_volume'];//Расходы компании
                    $data[$k]['net_clear'] = $data[$k]['expected_vp'] - $data[$k]['bonus_net_sku'] - $data[$k]['share_expenses'] - $data[$k]['logistics_expens_total'] - $data[$k]['company_expens_total'];//чистая прибыль
                    if ($akc_type == 1)
                        $data[$k]['net_clear'] -= $data[$k]['akc_expenses'];//чистая прибыль
                    $data[$k]['prom_costs_discount'] = $data[$k]['total_volume_price_one'] - $data[$k]['total_volume_price_one_discount'];//Расходы по акции в скидке
                    $data[$k]['total_network_costs'] = ( 0 /*Расходы сети итого, вт.ч.*/ ) + $data[$k]['prom_costs_discount'];//Всего затрат по сети
                }
            }
            return $is_calc;
        }catch (Exception $e){
            echo $e->getMessage();
            return false;
        }

    }

    private function modalGetDistribBonus($net_id){
        $distrBonus = 0;
        if(!is_null($net_id) && $net_id != ""){
            $params[":net_id"] = $net_id;
            $sql = rtrim(file_get_contents('sql/sku_avk_distrib_bonus.sql'));
            $sql = stritr($sql, $params);
            $sql = trim(preg_replace('/\s+/', ' ', $sql));

            $get_list = $this->db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
            if (isset($get_list))
            {
                $distrBonus = $get_list['procent'];
            }

        }
        return $distrBonus;
    }

    private function NormalizeFloat($number){
        $number = $number."";
        if(substr($number,0,1) == "."){
            return number_format((float)$number, 3, '.', '');
        }
        return $number;
    }

    public function GetSkuList($z_id,$akc_type,$bonus_net_perc = null,$net_id = null,$akciya_expences_perc = null,$print = true){
        if(is_null($z_id) || $z_id == "")
            return false;
        try {
            $sku_list = $this->modalLoadSku($z_id);
            if(!is_null($bonus_net_perc)){
                $is_calc = $this->CalculateSku($sku_list,$akc_type,$bonus_net_perc,$net_id,$akciya_expences_perc); // show all fields
            }else{
                $is_calc = $this->CalculateSku($sku_list,$akc_type);
            }

            $skuHtml = $this->controllerCreateHtml($sku_list, $akc_type, $is_calc);
            if ($print)
                echo $skuHtml;
            else
                return $skuHtml;
        }catch (\Exception $e){
            echo "Some error. ".$e->getMessage();
        }
    }
}