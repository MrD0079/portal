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
    private function controllerCreateHtml($data,$ack_type,$is_calc = false){
        $html = '<table id="sku_selected" width="100%" border="1" style="max-width: 900px;background-color: #fff;">'.
                '<thead style="background-color: #03a9f454;">'.
                '<tr style="font-size: 10px;font-weight: bold;text-align: center;">'.
                    '<td rowspan="2">TAG_ID</td>'.
                    '<td rowspan="2">�����</td>'.
                    '<td rowspan="2">�������</td>'.
                    '<td rowspan="2">���, ��</td>'.
                    '<td rowspan="2">��,���/��</td>'.
                    '<td rowspan="2">���� ����.-�������. ���.,��� � ���</td>'.
                    '<td rowspan="2">���� ����-�� ��, ��� � ���</td>'.
                    '<td rowspan="2">���� �� ������� � ���� �� ��.,��� � ���</td>';
                if ($ack_type == 2)
                    '<td rowspan="2" class="type2">���� �� ������� � ���� �� ��. �� �������,��� � ���</td>';
        $html .= '<td rowspan="2">����� �������,��.</td>';
        if($is_calc) {
            $html .= '<td rowspan="2">����� �������,��.</td>' .
                '<td rowspan="2">����� ������, ��� � ���</td>';
            if ($ack_type == 2)
                $html .= '<td rowspan="2" class="type2">����� ������ � ������ ������, ��� � ���</td>';
            $html .= '<td rowspan="2">�� �� ����� ��������,��� � ���</td>' .
                '<td rowspan="2">��������� ��,��� � ���</td>' .
                '<td colspan="5" class="colspan5">������� ���� �����, ��.�.</td>' .
                '<td rowspan="2">������ �������, ��� � ���</td>';
            if ($ack_type == 2) {
                $html .= '<td rowspan="2" class="type2">������� �� ����� � ������, ��� � ���</td>' .
                    '<td rowspan="2" class="type2">����� ������ �� ����, ��� � ���</td>';
            }
        }
        $html .= '</tr>';
        if($is_calc) {
            $html .= '<tr style="font-size: 10px;font-weight: bold;text-align: center;">' .
                '<td>����� ����, ��� � ���</td>';
            if ($ack_type == 1)
                $html .='<td class="type1">������� �� ����� �/� (�����������), ��� � ���</td>' ;
            $html .='<td>����� �������, ��� � ���</td>' .
                '<td>������� �� ���������</td>' .
                '<td>������� ��������, ��� � ���</td>' .
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
                    $html .= '<td class="type2" style="display: none;">' .
                        $sku['price_net_disc'] .
                        '</td>';
                $html .= '<td>' .
                    $sku['total_q'] .
                    '</td>' .
                    '</tr>';
            }
        }
        $html .='</tbody>'.
            '</table>';
        if(count($data) <= 0){
            $html .= '<span class="info-sku">��� ��������� ���������</span>';
        }
        return $html;
    }
    private function CalculateSku(&$data){
        if(count($data) <=0 )
            return false;
        foreach ($data as $k => $sku){
            foreach ($sku as $key => $item) {
                $data[$k][$key] = $this->NormalizeFloat($item);

            }
        }
        //calculate
        return false;

    }
    private function NormalizeFloat($number){
        $number = $number."";
        if(substr($number,0,1) == "."){
            return number_format((float)$number, 3, '.', '');
        }
        return $number;
    }
    public function GetSkuList($z_id,$ack_type,$print = true){
        if(is_null($z_id) || $z_id == "")
            return false;
        try {
            $sku_list = $this->modalLoadSku($z_id);
            $is_calc = $this->CalculateSku($sku_list);
            $skuHtml = $this->controllerCreateHtml($sku_list, $ack_type, $is_calc);
            if ($print)
                echo $skuHtml;
            else
                return $skuHtml;
        }catch (Exception $e){
            echo "Some error. ".$e->getMessage();
        }
    }
}