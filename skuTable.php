<?php
include "SkuSelect.php";
$skuObj = new \SkuSelect\SkuSelect($db);
/* GET params */
//($z_id,$akc_type,$bonus_net_perc = null,$net_id = null,$akciya_expences_perc = null,$fil_kod=null,$print = tru)
$z_id = $_REQUEST['z_id'] ? $_REQUEST['z_id'] : 0;
$akc_type = $_REQUEST['akc_type'] ? $_REQUEST['akc_type'] : 0;
$bonus_net_perc = $_REQUEST['bonus_net'] ? $_REQUEST['bonus_net'] : 0;
$net_id = $_REQUEST['net_id'] ? $_REQUEST['net_id'] : 0;
$akciya_expences_perc = $_REQUEST['akciya_expenc'] ? $_REQUEST['akciya_expenc'] : 0;
$fil_kod = $_REQUEST['fil_kod'] ? $_REQUEST['fil_kod'] : 0;

$_REQUEST['filename'] = $_REQUEST['filename'] != "" ? $_REQUEST['filename'] : "����������� SKU �� ������ � ".$z_id;

echo "<p>";
echo '<table border="1">'.
         '<tr>'.
            '<td>'.
                '��� ����� ��:'.
            '</td>'.
            '<td>'.
                ($akc_type == 1 ? '%������ �� ����� (�����������) ' : '%������ �� ����� (������ � ���������) ').
            '</td>'.
         '</tr>'.
        '<tr>'.
            '<td>'.
                '����� ����, %'.
            '</td>'.
            '<td>'.
                $skuObj->convertFloatToHTML($bonus_net_perc).
            '</td>'.
        '</tr>'.
        '<tr>'.
            '<td>'.
                '������ �� �����, %'.
            '</td>'.
            '<td>'.
                $skuObj->convertFloatToHTML($akciya_expences_perc) .
            '</td>'.
        '</tr>'.
     '</table>';
echo "</p>";

$skuObj->GetSkuList($z_id,$akc_type,$bonus_net_perc,$net_id,$akciya_expences_perc,$fil_kod);

//$smarty->display('testSkuSelect.html');
?>