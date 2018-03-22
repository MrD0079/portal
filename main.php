<?
$xxxxxxx=array();
$xxxxxxx[0]=microtime(true);
InitRequestVar("dates_list1",$_SESSION["month_list"]);
InitRequestVar("dates_list2",$now);
$params=array(
	':tn'=>$tn,
	':dpt_id' => $_SESSION["dpt_id"],
	':eta' => "'".$_SESSION["h_eta"]."'"
);
$data = $db->getAll("
SELECT tr.id, tr.name
FROM voiting_test_onoff t, user_list u, tr
WHERE     u.is_prez = 1
AND u.tn = t.tn
AND u.tn = ".$tn."
AND tr.for_prez = 1
AND tr.id = t.tr
ORDER BY tr.name
", null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('voiting_test_list', $data);
$smarty->assign('scmovezayexist', $db->getOne("SELECT COUNT (*) FROM scmovezay WHERE dpt_id = ".$_SESSION['dpt_id']." AND status = 0"));
$sql=rtrim(file_get_contents('sql/main_it_tasks.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('it_tasks', $data);
/*
$sql=rtrim(file_get_contents('sql/main_dzc_accept.sql'));
$params[':wait4myaccept']=0;
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('dzc_accept', $data);
*/
$sql=rtrim(file_get_contents('sql/main_bud_svod_ta.sql'));
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('bud_svod_ta', $data);

$sql=rtrim(file_get_contents('sql/main_kc_dpu.sql'));
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('kc_dpu', $data);

$sql=rtrim(file_get_contents('sql/main_distr_discount_dpu.sql'));
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('distr_discount_dpu', $data);

$sql=rtrim(file_get_contents('sql/main_bud_funds_limits_dpu.sql'));
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('bud_funds_limits_dpu', $data);

$sql=rtrim(file_get_contents('sql/main_promo_nm.sql'));
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('promo_nm', $data);

$sql=rtrim(file_get_contents('sql/main_prob_test.sql'));
$sql=stritr($sql,$params);
$data = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('prob_test', $data);
/*
$sql=rtrim(file_get_contents('sql/main_ac_tests.sql'));
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('ac_tests', $data);
*/
$sql=rtrim(file_get_contents('sql/main_tasks_tmc.sql'));
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('tmc', $data);


$sql=rtrim(file_get_contents('sql/main_tasks_sz_my_creator.sql'));
$sql=stritr($sql,$params);
//$data = $db->getOne($sql);
$data = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('sz_my_creator', $data);

$sql=rtrim(file_get_contents('sql/main_tasks_sz_my_acceptor.sql'));
$sql=stritr($sql,$params);
//$data = $db->getOne($sql);
$data = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$xxxxxxx[1]=microtime(true);$smarty->assign('sz_my_acceptor', $data);

$params1=array(
':tn' => $tn,
':dpt_id' => $_SESSION["dpt_id"],
":dates_list1"=>"'01.01.2000'",
":dates_list2"=>"'31.12.2050'",
":status"=>1,
":st"=>0,
":kat"=>0,
":creator"=>0,
":who"=>0,
":report_data"=>2,
":fil"=>0,
":funds"=>0,
":id_net"=>0,
":orderby"=>1,
":country"=>"'".$_SESSION["cnt_kod"]."'",
":r_pos_id"=>0,
":bud_ru_zay_pos_id"=>0,
":region_name"=>"'0'",
":department_name"=>"'0'",
':wait4myaccept'=>1,
":z_id"=>0,
':date_between_brzr' => "'dt12'",
':tu'=>0,
":exp_list_without_ts"=>0,
':report_zero_cost'=>0,
);

$params1[":who"]=1;

$sql=rtrim(file_get_contents('sql/bud_ru_zay_reestr_total_main.sql'));
$sql = stritr($sql, $params1);
$data = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$xxxxxxx[2]=microtime(true);$smarty->assign('bud_ru_zay_reestr_total_i', $data);

$params1[":who"]=2;

$sql=rtrim(file_get_contents('sql/bud_ru_zay_reestr_total_main.sql'));
$sql = stritr($sql, $params1);
$data = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$xxxxxxx[3]=microtime(true);$smarty->assign('bud_ru_zay_reestr_total_o', $data);



$params1[":status"]=2;
$params1[":srok_ok"]=0;
$params1[":report_done_flt"]=2;
$params1[":report_zero_cost"]=0;

$params1[":who"]=1;
$params1[":tu"]=0;

$sql=rtrim(file_get_contents('sql/bud_ru_zay_report_total_main.sql'));
$sql = stritr($sql, $params1);
$data = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$xxxxxxx[4]=microtime(true);$smarty->assign('bud_ru_zay_report_total1_i_tu0', $data);

$params1[":who"]=2;
$params1[":tu"]=0;

$sql=rtrim(file_get_contents('sql/bud_ru_zay_report_total_main.sql'));
$sql = stritr($sql, $params1);
$data = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$xxxxxxx[5]=microtime(true);$smarty->assign('bud_ru_zay_report_total1_o_tu0', $data);

$params1[":who"]=1;
$params1[":tu"]=1;

$sql=rtrim(file_get_contents('sql/bud_ru_zay_report_total_main.sql'));
$sql = stritr($sql, $params1);
$data = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$xxxxxxx[6]=microtime(true);$smarty->assign('bud_ru_zay_report_total1_i_tu1', $data);

$params1[":who"]=2;
$params1[":tu"]=1;

$sql=rtrim(file_get_contents('sql/bud_ru_zay_report_total_main.sql'));
$sql = stritr($sql, $params1);
$data = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$xxxxxxx[7]=microtime(true);$smarty->assign('bud_ru_zay_report_total1_o_tu1', $data);

$params1[":status"]=2;
$params1[":srok_ok"]=2;
$params1[":report_done_flt"]=2;

$params1[":who"]=1;

$sql=rtrim(file_get_contents('sql/bud_ru_zay_report_total_main.sql'));
$sql = stritr($sql, $params1);
$data = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$xxxxxxx[8]=microtime(true);$smarty->assign('bud_ru_zay_report_total3_i', $data);

$params1[":who"]=2;

$sql=rtrim(file_get_contents('sql/bud_ru_zay_report_total_main.sql'));
$sql = stritr($sql, $params1);
$data = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$xxxxxxx[9]=microtime(true);$smarty->assign('bud_ru_zay_report_total3_o', $data);

$params1[":wait4myaccept"]=0;
$params1[":tu"]=0;

$sql=rtrim(file_get_contents('sql/bud_ru_zay_accept_total_main.sql'));
$sql = stritr($sql, $params1);
$data = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$xxxxxxx[10]=microtime(true);$smarty->assign('bud_ru_zay_accept_total_tu0', $data);


$params1[":wait4myaccept"]=0;
$params1[":tu"]=1;

$sql=rtrim(file_get_contents('sql/bud_ru_zay_accept_total_main.sql'));
$sql = stritr($sql, $params1);
$data = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$xxxxxxx[11]=microtime(true);$smarty->assign('bud_ru_zay_accept_total_tu1', $data);

$params1[":wait4myaccept"]=0;
$params1[":tu"]=0;

$sql=rtrim(file_get_contents('sql/bud_ru_zay_report_accept_total_main.sql'));
$sql = stritr($sql, $params1);
$data = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$xxxxxxx[12]=microtime(true);$smarty->assign('bud_ru_zay_report_accept_total_tu0', $data);

$params1[":wait4myaccept"]=0;
$params1[":tu"]=1;

$sql=rtrim(file_get_contents('sql/bud_ru_zay_report_accept_total_main.sql'));
$sql = stritr($sql, $params1);
$data = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('bud_ru_zay_report_accept_total_tu1', $data);

$params1[':da_deleted']=0;
$params1[':da_db']=0;
$params1[':da_di']=0;
$params1[':da_result']=0;
$params1[':da_re']="'0'";
$params1[':da_de']="'0'";
$params1[':da_st']=44769046;
$params1[':da_ok_chief']=0;
$params1[':da_ok_nm']=0;
$params1[':da_ok_dpu']=0;
$params1[':da_sd']="'01.01.2000'";
$params1[':da_ed']="'31.12.2050'";
$params1[':da_cat']=0;
$params1[':da_conq']=0;
$params1[':da_full']=1;
$params1[':prot_id']=0;
/*
$sql=rtrim(file_get_contents('sql/distr_prot.sql'));
$sql=stritr($sql,$params1);
//echo $sql;
$distr_prot = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('distr_prot', count($distr_prot));
*/
if ($_SESSION['is_eta']==1)
{
$sql=rtrim(file_get_contents('sql/news_eta.sql'));
}
else
{
$sql=rtrim(file_get_contents('sql/news.sql'));
}
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('news', $data);

$sql=rtrim(file_get_contents('sql/main_birthdays.sql'));
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('birthdays', $data);

//echo $sql;
//print_r($data);

$sql=rtrim(file_get_contents('sql/main_in_vac.sql'));
$sql=stritr($sql,$params);
//echo $sql;
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

$x=array();
foreach ($data as $k=>$v)
{
$x[$v['pos_name']][$v['tn']]=$v;
}
$smarty->assign('in_vac1', $x);

//print_r($x);

$sql=rtrim(file_get_contents('sql/main_tasks_pr_count.sql'));
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('pr_count', $data);

$sql=rtrim(file_get_contents('sql/main_tasks_pa_date.sql'));
$sql=stritr($sql,$params);
$data = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$xxxxxxx[18]=microtime(true);$smarty->assign('pa_date', $data);

$sql=rtrim(file_get_contents('sql/main_tasks_pa_zapolnen.sql'));
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$xxxxxxx[19]=microtime(true);$smarty->assign('pa_zapolnen', $data);

$sql=rtrim(file_get_contents('sql/main_tasks_pa_prinyat.sql'));
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$xxxxxxx[20]=microtime(true);$smarty->assign('pa_prinyat', $data);

$sql=rtrim(file_get_contents('sql/main_tasks_zat_date.sql'));
$sql=stritr($sql,$params);
$data = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('zat_date', $data);

$sql=rtrim(file_get_contents('sql/main_tasks_zat_zapolnen.sql'));
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('zat_zapolnen', $data);

$sql=rtrim(file_get_contents('sql/main_tasks_zat_prinyat.sql'));
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('zat_prinyat', $data);

$sql=rtrim(file_get_contents('sql/main_tasks_zat_utverjden.sql'));
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$xxxxxxx[21]=microtime(true);$smarty->assign('zat_utverjden', $data);

$sql=rtrim(file_get_contents('sql/main_tasks_probs.sql'));
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('probs', $data);
/*
$sql=rtrim(file_get_contents('sql/main_tasks_project_my.sql'));
$sql=stritr($sql,$params);
$data = $db->getOne($sql);
$smarty->assign('project_my', $data);

$sql=rtrim(file_get_contents('sql/main_tasks_project_slaves.sql'));
$sql=stritr($sql,$params);
$data = $db->getOne($sql);
$smarty->assign('project_slaves', $data);

$sql=rtrim(file_get_contents('sql/main_tasks_project_report.sql'));
$sql=stritr($sql,$params);
$data = $db->getOne($sql);
$smarty->assign('project_report', $data);

$sql=rtrim(file_get_contents('sql/main_tasks_project_report_chk.sql'));
$sql=stritr($sql,$params);
$data = $db->getOne($sql);
$smarty->assign('project_report_chk', $data);
*/
$sql=rtrim(file_get_contents('sql/main_tasks_fw_count.sql'));
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('fw_count', $data);

$sql=rtrim(file_get_contents('sql/main_tasks_tr.sql'));
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('tr', $data);

$sql=rtrim(file_get_contents('sql/main_tasks_tr_tn.sql'));
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('tr_tn', $data);

$sql=rtrim(file_get_contents('sql/main_tr.sql'));
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('main_tr', $data);

$sql=rtrim(file_get_contents('sql/main_tasks_tr_pt.sql'));
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('tr_pt', $data);

$sql=rtrim(file_get_contents('sql/main_tasks_tr_pt_tn.sql'));
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('tr_pt_tn', $data);

$sql=rtrim(file_get_contents('sql/main_tr_pt.sql'));
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('main_tr_pt', $data);

/*
isset($_REQUEST["debug"])?var_dump($sql):null;
isset($_REQUEST["debug"])?print_r($params):null;
isset($_REQUEST["debug"])?print_r($data):null;
*/

$sql=rtrim(file_get_contents('sql/main_tasks_vacation_report.sql'));
$sql=stritr($sql,$params);
//echo $sql;
$data = $db->getOne($sql);
//echo $data;
$smarty->assign('main_vacation_report', $data);

$sql=rtrim(file_get_contents('sql/main_tasks_vacation_report_my.sql'));
$sql=stritr($sql,$params);
$data = $db->getOne($sql);
$smarty->assign('main_vacation_report_my', $data);

$sql=rtrim(file_get_contents('sql/main_tasks_vacation_reestr.sql'));
$sql=stritr($sql,$params);
$data = $db->getAssoc($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('main_vacation_reestr', $data);

//print_r($data);
//echo $sql;


$sql=rtrim(file_get_contents('sql/main_dc.sql'));
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('main_dc', $data);

$sql=rtrim(file_get_contents('sql/main_tasks_dc.sql'));
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('dc', $data);

/*
$sql=rtrim(file_get_contents('sql/main_tasks_reestr_dc.sql'));
$sql=stritr($sql,$params);
$data = $db->getOne($sql);
$smarty->assign('reestr_dc', $data);

$sql=rtrim(file_get_contents('sql/main_tasks_reestr_dc_os.sql'));
$sql=stritr($sql,$params);
$data = $db->getOne($sql);
$smarty->assign('reestr_dc_os', $data);
*/
$sql=rtrim(file_get_contents('sql/main_tasks_ol_staff.sql'));
$sql=stritr($sql,$params);
$data = $db->getOne($sql);
$smarty->assign('ol_staff', $data);

require_once "main_box_dm.php";
require_once "main_box_dpu.php";

/*
$sql=rtrim(file_get_contents('sql/main_advance_pos_my.sql'));
$sql=stritr($sql,$params);
$x = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('my_advance', $x);
*/

/*
$sql=rtrim(file_get_contents('sql/main_advance_ok_dpu.sql'));
$sql=stritr($sql,$params);
$x = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('advance_ok_dpu', $x);
*/

//echo $sql;

$p = array();

$p[':tn'] = $tn;

$sql=rtrim(file_get_contents('sql/tr_os_get_id.sql'));
$sql=stritr($sql,$p);
$d = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

if ($d)
{
	$id=$d["id"];

	$sql=rtrim(file_get_contents('sql/tr_os_get_tr.sql'));
	$sql=stritr($sql,$p);
	$d = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('d', $d);

	$p[':id'] = $id;
	$sql=rtrim(file_get_contents('sql/tr_list_order.sql'));
	$sql=stritr($sql,$p);
	$h = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
	$smarty->assign('h', $h);
}

if ($_SESSION['is_eta']==1&&isset($_REQUEST["eta_comment"])&&isset($_REQUEST["eta_comment_send"]))
{
$sql="
SELECT DISTINCT r.tab_number,
                r.eta,
                r.h_eta,
                r.dpt_id,
                u.fio,
                u.dpt_name,
                u.region_name,
                u.department_name
  FROM routes r,
       spr_users_eta s,
       user_list u
 WHERE     r.h_eta = s.h_eta
       AND u.tab_num = r.tab_number
       AND u.dpt_id = s.dpt_id
       AND r.tab_number <> 0
       AND r.dpt_id = s.dpt_id
       AND s.login = '".$login."'
";
//echo $sql;
$chief = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$subj="Горячая линия руководства дирекции по продажам. Новое сообщение от ЭТА - ".$fio;
$text=nl2br($_REQUEST["eta_comment"]);
$text.="<p>Руководитель ЭТА - ".$chief["fio"].", ".$chief["dpt_name"].", ".$chief["region_name"].", ".$chief["department_name"]."</p>";
send_mail($parameters["eta_inform"]["val_string"],$subj,$text,null,false);
}

if ($is_admin==1)
{
    $sql=rtrim(file_get_contents('sql/error.sql'));
    $data = $db->getOne($sql);
    $smarty->assign('error', $data);    
}
$smarty->display('main.html');






?>