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
        $sql = "SELECT bsa.*,sa.NAME name, sa.WEIGHT weight, sa.TAG_ID tag_id, sa.NAME_BRAND brand FROM bud_ru_zay_sku_avk bsa, sku_avk sa WHERE bsa.id_num = sa.id_num(+) AND bsa.status = 1 AND bsa.z_id = ".$z_id;

        $sku_list = $this->db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

//        if (PEAR::isError($sku_list)) {
//            echo 'error: ' . $sku_list->getMessage() . " " . $sku_list->getDebugInfo();
//            return false;
//        } else {
            return $sku_list;
//        }
    }

    private function controllerCreateHtml($data,$ack_type,$is_calc = false,$z_id,$akc_type,$bonus_net,$net_id,$akciya_expenc,$fil_kod){
        $html = "";
        if(count($data) > 0) {
            $html .= '<table id="sku_selected" width="100%" border="1" style="max-width: 900px;background-color: #fff;">' .
                '<thead style="background-color: #03a9f454;">' .
                '<tr style="font-size: 10px;font-weight: bold;text-align: center;">' .
                '<td rowspan="2">TAG ID</td>' .
                '<td rowspan="2">�����</td>' .
                '<td rowspan="2">�������</td>' .
                '<td rowspan="2">���, ��</td>' .
                '<td rowspan="2">��,���/��</td>' .
                '<td rowspan="2">���� ����.-�������. ���.,���</td>' .
                '<td rowspan="2">���� ����-�� ��, ��� ��� ���</td>' .
                '<td rowspan="2">���� �� ������� � ���� �� ��.,��� ��� ���</td>';
            if ($ack_type == 2 && $is_calc)
                $html .= '<td rowspan="2" class="type2">���� �� ������� � ���� �� ��. �� �������,��� ��� ���</td>';
            $html .= '<td rowspan="2">����� �������,��.</td>';
            if ($is_calc) {
                $html .= '<td rowspan="2">����� �������,��.</td>' .
                    '<td rowspan="2">����� ������, ���. ���</td>';
                if ($ack_type == 2)
                    $html .= '<td rowspan="2" class="type2">����� ������ � ������ ������, ���</td>';
                $html .= //'<td rowspan="2">�� �� ����� ��������,���</td>' .
                    '<td rowspan="2">��������� ��, ���. ���</td>' .
                    '<td colspan="' . ($ack_type == 2 ? "5" : "6") . '" class="colspan6">������� ���� �����, ��.�.</td>' .
                    '<td rowspan="2">������ ������� EBITDA, ���. ���</td>' .
                    '<td rowspan="2">������ �������, ���. ���</td>' .
                    '<td rowspan="2" >����� ������ �� �����, ���. ��� � ���</td>';
                if ($ack_type == 2) {
                    $html .= '<td rowspan="2" class="type2">������� �� ����� � ������, ���. ���</td>' .
                        '<td rowspan="2" class="type2">����� ������ �� ����, ���. ���</td>';
                }
            }
            $html .= '</tr>';
            if ($is_calc) {
                $html .= '<tr style="font-size: 10px;font-weight: bold;text-align: center;">' .
                    '<td>����� ����, ���. ���</td>';
                if ($ack_type == 1)
                    $html .= '<td class="type1">������� �� ����� �/� (�����������), ���. ���</td>';
                $html .= '<td>����� �������, ���. ���</td>' .
                    '<td>������� �� ���������, ���. ���</td>' .
                    '<td>������� ��������, ���. ���</td>' .
                    '<td>���. �������, ���</td>' .
                    '</tr>';
            }
            $html .= '</thead>' .
                '<tbody>';

            $data_total['total_vol_price'] = 0;
            $data_total['total_prom_cost'] = 0;
            $data_total['expected_vp'] = 0;
            $data_total['bonus_net_sku'] = 0;
            $data_total['akc_expenses'] = 0;
            $data_total['share_expenses'] = 0;
            $data_total['logistics_expens_total'] = 0;
            $data_total['company_expens_total'] = 0;
            $data_total['add_expens'] = 0;
            $data_total['ebitda'] = 0;
            $data_total['net_clear'] = 0;
            $data_total['prom_costs_discount'] = 0;
            $data_total['total_network_costs'] = 0;

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
                        $this->convertFloatToHTML($sku['price_ss']) .
                    '</td>' .
                    '<td>' .
                        $this->convertFloatToHTML($sku['price_uk']) .
                    '</td>' .
                    '<td>' .
                        $this->convertFloatToHTML($sku['price_kk']) .
                    '</td>' .
                    '<td>' .
                        $this->convertFloatToHTML($sku['price_net']) .
                    '</td>';
                if ($ack_type == 2 && $is_calc)
                    $html .= '<td class="type2" >' .$this->convertFloatToHTML($sku['price_net_disc']) .'</td>';
                $html .= '<td>' .$sku['total_q'] .'</td>';
                if($is_calc){
                    $html .= '<td>'.$sku['total_volume_price'].'</td>'.
                        '<td>'.$this->transferToThousands($sku['total_volume_price_one']).'</td>';
                    if ($ack_type == 2)
                        $html .= '<td class="type2">'.$this->transferToThousands($sku['total_volume_price_one_discount']).'</td>';
                    $html .= //'<td>'.$sku['ss_volume'].'</td>'.
                        '<td>'.$this->transferToThousands($sku['expected_vp']).'</td>'.
                        '<td>'.$this->transferToThousands($sku['bonus_net_sku']).'</td>';
                    if ($ack_type == 1)
                        $html .= '<td class="type1">'.$this->transferToThousands($sku['akc_expenses']).'</td>';
                    $html .= '<td>'.$this->transferToThousands($sku['share_expenses']).'</td>'.
                        '<td>'.$this->transferToThousands($sku['logistics_expens_total']).'</td>'.
                        '<td>'.$this->transferToThousands($sku['company_expens_total']).'</td>'.
                        '<td>'.$sku['add_expens'].'</td>'.
                        '<td>'.$this->transferToThousands($sku['ebitda']).'</td>'.
                        '<td>'.$this->transferToThousands($sku['net_clear']).'</td>'.
                        '<td style="background-color: #ffeb3b8a;">'.$this->transferToThousands($sku['summ_prom_cost']).'</td>';
                    if ($ack_type == 2)
                        $html .= '<td class="type2">'.$this->transferToThousands($sku['prom_costs_discount']).'</td>'.
                        '<td class="type2">'.$this->transferToThousands($sku['total_network_costs']).'</td>';

                }
                $html .='</tr>';
                $data_total['total_vol_price'] += $sku['total_volume_price_one'];
                $data_total['total_volume_price_one_discount'] += $sku['total_volume_price_one_discount']; /* 2 */
                $data_total['expected_vp'] += $sku['expected_vp'];
                $data_total['bonus_net_sku'] += $sku['bonus_net_sku'];
                $data_total['akc_expenses'] += $sku['akc_expenses']; /* 1 */
                $data_total['share_expenses'] += $sku['share_expenses'];
                $data_total['logistics_expens_total'] += $sku['logistics_expens_total'];
                $data_total['company_expens_total'] += $sku['company_expens_total'];
                $data_total['add_expens'] += $sku['add_expens'];
                $data_total['ebitda'] += $sku['ebitda'];
                $data_total['net_clear'] += $sku['net_clear'];
                $data_total['summ_prom_cost'] += $sku['summ_prom_cost'];
                $data_total['prom_costs_discount'] += $sku['prom_costs_discount']; /* 2 */
                $data_total['total_network_costs'] += $sku['total_network_costs']; /* 2 */
            }
            $html .='</tbody>';

            if($is_calc) {
                $html .= '<tfoot align="center" style="background: #ffc">' .
                    '<tr style="font-weight:bold; text-align: center;">' .
                    '<td colspan="'.(($ack_type == 1)?'10':'11').'" class="colspan11" >����� (���. ���)</td>' .
                    '<td>' . $this->transferToThousands($data_total['total_vol_price']) . '</td>' ;
                    if ($ack_type == 2)
                        $html .='<td>' . $this->transferToThousands($data_total['total_volume_price_one_discount']) . '</td>' ;
                    $html .='<td>' . $this->transferToThousands($data_total['expected_vp']) . '</td>' .
                    '<td>' . $this->transferToThousands($data_total['bonus_net_sku']) . '</td>' ;
                    if ($ack_type == 1)
                        $html .='<td>' . $this->transferToThousands($data_total['akc_expenses']) . '</td>';
                    $html .='<td>' . $this->transferToThousands($data_total['share_expenses']) . '</td>' .
                    '<td>' . $this->transferToThousands($data_total['logistics_expens_total']) . '</td>' .
                    '<td>' . $this->transferToThousands($data_total['company_expens_total']) . '</td>' .
                    '<td>' . $this->transferToThousands($data_total['add_expens']) . '</td>' .
                    '<td>' . $this->transferToThousands($data_total['ebitda']) . '</td>' .
                    '<td>' . $this->transferToThousands($data_total['net_clear']) . '</td>' .
                    '<td >' . $this->transferToThousands($data_total['summ_prom_cost']) . '</td>' ;
                    if ($ack_type == 2) {
                        $html .= '<td>' . $this->transferToThousands($data_total['prom_costs_discount']) . '</td>' .
                            '<td>' . $this->transferToThousands($data_total['total_network_costs']) . '</td>';
                    }
                    $html .=' </tr>' .
                    ' </tfoot>';
            }
            $html .='</table>';
        }
        if(count($data) <= 0){
            $html .= '<span class="info-sku">��� ��������� ���������</span>';
        }else if($_REQUEST['print'] != 1) {
            $html .= "<p><a href='?action=skuTable&print=1&excel=1&z_id=" . $z_id . "&akc_type=" . $akc_type . "&bonus_net=" . $bonus_net . "&net_id=" . $net_id . "&akciya_expenc=" . $akciya_expenc . "&fil_kod=" . $fil_kod . "&filename=����������� SKU �� ������ �" . $z_id . "' target='_blank'>������� � Excel</a></p>";
        }
        return $html;
    }

    private function transferToThousands($number){
        $dec_point = '.';
        if(isset($_REQUEST['print']) && $_REQUEST['print'] == 1)
            $dec_point = ',';
       return number_format(($number*0.001), 5, $dec_point, ' ');
    }

    private function CalculateSku(&$data,$akc_type,$bonus_net_perc = null,$net_id = null,$akciya_expences_perc = null,$fil_kod=null){
        if(count($data) <=0 )
            return false;
        $is_calc = false;
        try {
            if (!is_null($fil_kod)) {
                $bonus_distr_pers = $this->modalGetDistribBonus($fil_kod);
            }else{
                $bonus_distr_pers = 0;
            }
            if (!is_null($bonus_net_perc)) {
                $akciya_expences_perc /= 100;
                $bonus_net_perc /= 100;
                //$bonus_distr_pers /= 100;
            }

            foreach ($data as $k => $sku) {
                foreach ($sku as $key => $item) {
                    $data[$k][$key] = $this->NormalizeFloat($item);
                }
                //calculate
                if (!is_null($bonus_net_perc)) {
                    $is_calc = true;
                    //$bonus_distr_pers = $this->modalGetDistribBonus($net_id);

                    //$data[$k]['total_q'];//����� ������ ��.
                    $data[$k]['total_volume_price'] = $data[$k]['total_q'] * $data[$k]['weight'];//����� ������ ��.
                    $data[$k]['total_volume_price_one'] = $data[$k]['total_q'] * $data[$k]['price_net'];//����� ������ ���
                    $data[$k]['price_net_disc'] = $data[$k]['price_net'] - ($data[$k]['price_net'] * $akciya_expences_perc);
                    $data[$k]['total_volume_price_one_discount'] = $data[$k]['total_q'] * $data[$k]['price_net_disc'];//����� ������ ���. ������
                    $data[$k]['ss_volume'] = $data[$k]['total_volume_price'] * $data[$k]['price_ss'];//�� �� ����� ��������
                    if ($akc_type == 1) {
                        $data[$k]['expected_vp'] = $data[$k]['total_volume_price_one'] - $data[$k]['ss_volume'];//��������� ��
                        $data[$k]['bonus_net_sku'] = $data[$k]['total_volume_price_one'] * $bonus_net_perc;//����� ����
                    } else {
                        $data[$k]['expected_vp'] = $data[$k]['total_volume_price_one_discount'] - $data[$k]['ss_volume'];//��������� ��
                        $data[$k]['bonus_net_sku'] = $data[$k]['total_volume_price_one_discount'] * $bonus_net_perc;//����� ����
                    }
                    $data[$k]['share_expenses'] = $data[$k]['price_uk'] * $data[$k]['total_q'] * $bonus_distr_pers;//����� �������
                    $data[$k]['akc_expenses'] = $data[$k]['total_volume_price_one'] * $akciya_expences_perc;//������� �� ����� �/�
                    $data[$k]['logistics_expens_total'] = $data[$k]['logistic_expens']*$data[$k]['total_volume_price'];//������� �� ���������

/*company_expens*/  $company_expens = $data[$k]['company_expens'];
                    $market_val = $data[$k]['market_val'];
/*revenue_val*/     $data[$k]['company_expens_total'] = ($company_expens + $market_val) / $data[$k]['revenue_val']  * $data[$k]['total_volume_price_one'];//������� ��������
                    $all_expenses = $data[$k]['bonus_net_sku'] + $data[$k]['share_expenses'] + $data[$k]['logistics_expens_total'] + $data[$k]['company_expens_total'] + $data[$k]['add_expens'];
                    $data[$k]['net_clear'] = $data[$k]['expected_vp'] - $all_expenses;//������ �������
                    if ($akc_type == 1)
                        $data[$k]['net_clear'] -= $data[$k]['akc_expenses'];//������ �������
                    $data[$k]['ebitda'] = $data[$k]['ebitda_val'] * $data[$k]['total_volume_price'] + $data[$k]['net_clear'];// EBITDA
                    $data[$k]['summ_prom_cost'] = $data[$k]['akc_expenses'] * 1.2; // ����� ������ �� �����, ��� � ���
                    $data[$k]['prom_costs_discount'] = $data[$k]['total_volume_price_one'] - $data[$k]['total_volume_price_one_discount'];//������� �� ����� � ������
                    $data[$k]['total_network_costs'] = $all_expenses + $data[$k]['prom_costs_discount'];//����� ������ �� ����

                }
            }
            return $is_calc;
        }catch (\Exception $e){
            echo $e->getMessage();
            return false;
        }

    }

    private function modalGetDistribBonus($fil_kod){
        $distrBonus = 0;
        if(!is_null($fil_kod) && $fil_kod != ""){
            $params[":fil_kod"] = $fil_kod;
            $sql = rtrim(file_get_contents('sql/sku_avk_distrib_bonus.sql'));
            $sql = stritr($sql, $params);
            $sql = trim(preg_replace('/\s+/', ' ', $sql));

            $get_list = $this->db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
            if (isset($get_list) && count($get_list) >= 1)
            {
                $distrBonus = $get_list[0]['procent'];
            }
        }
        return $distrBonus;
    }

    private function NormalizeFloat($number){
        $number = $number."";

        if(substr($number,0,1) == "."){
            return number_format((float)$number, 3, '.', '');
        }
        if($number == "")
            $number = 0;
        return $number;
    }

    public function convertFloatToHTML($number = 0,$decimals = 3){
        $dec_point = '.';
        if(isset($_REQUEST['print']) && $_REQUEST['print'] == 1)
            $dec_point = ',';
        return number_format($number, $decimals, $dec_point, '');
    }

    public function GetSkuList($z_id,$akc_type,$bonus_net_perc = null,$net_id = null,$akciya_expences_perc = null,$fil_kod=null,$print = true){
        if(is_null($z_id) || $z_id == "")
            return false;
        try {
            $sku_list = $this->modalLoadSku($z_id);
            if(!is_null($bonus_net_perc)){
                $is_calc = $this->CalculateSku($sku_list,$akc_type,$bonus_net_perc,$net_id,$akciya_expences_perc,$fil_kod); // show all fields
            }else{
                $is_calc = $this->CalculateSku($sku_list,$akc_type);
            }

            $skuHtml = $this->controllerCreateHtml($sku_list, $akc_type, $is_calc,$z_id,$akc_type,$bonus_net_perc,$net_id,$akciya_expences_perc,$fil_kod);
            if ($print)
                echo $skuHtml;
            else
                return $skuHtml;
        }catch (\Exception $e){
            echo "Some error. ".$e->getMessage();
        }
    }
}