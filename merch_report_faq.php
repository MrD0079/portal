<?
$sql=rtrim(file_get_contents('sql/ms_faq_list.sql'));
$p=array(":login"=>"'".$login."'");
$sql=stritr($sql,$p);
$ms_faq_list = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$d = array();
foreach ($ms_faq_list as $k=>$v)
{
    if ($v['parent']==null)
    {
            $d[$v['id']]['section']=$v;
    }
    else
    {
            $d[$v['parent']]['files'][$v['id']]=$v;
    }
}
$smarty->assign('ms_faq', $d);
$smarty->display('merch_report_faq.html');
?>