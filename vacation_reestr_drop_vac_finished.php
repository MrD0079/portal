<?
Table_Update("vacation", array("id"=>$_REQUEST['id']),array("vac_finished"=>null));
$sql="
SELECT u.e_mail,
       v.replacement_mail,
       TO_CHAR (v_from, 'dd.mm.yyyy') v_from,
       TO_CHAR (v_to, 'dd.mm.yyyy') v_to
  FROM vacation v, user_list u
 WHERE u.tn = v.tn
   AND v.id=".$_REQUEST['id']."
";
$d = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
/*
25. ��� ������� ������ ����������� ������, ������� ������������ "����������" � ��:
- ���� ������: ��������� ���������� ������ �� �������"
- ����� ������: $(��� ������������) �������� ���������� ������ ������ �� ������� �� ������ $start - $end.<br>
��� ���������� ��������� � ������ ����������� ��� ��������� ������ ����������.
*/
$subj='��������� ���������� ������ �� �������';
$text=$fio.' �������� ���������� ������ ������ �� ������� �� ������ '.$d['v_from'].' - '.$d['v_to'].'.<br>��� ���������� ��������� � ������ ����������� ��� ��������� ������ ����������';
$mail=$d['e_mail'].','.$d['replacement_mail'];
//$subj=$mail.' *** '.$subj;
//$mail='denis.yakovenko@avk.ua';
send_mail($mail,$subj,$text,null,false);
?>