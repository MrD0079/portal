<?
//ini_set('display_errors', 0);
//ini_set("upload_max_filesize", "20Mb");
//ses_req();
ini_set("memory_limit", "512M");
//ini_set("max_input_vars", "10000");
require_once "function.php";
require_once "local_functions.php";
$now=date("d.m.Y");
$nowJS=date("d/m/Y");
$now1=date("01.m.Y");
$now_time=date("H:i:s");
$now_date_time=date("d.m.Y H:i:s");
//$prev1=date("01.m.Y", strtotime('-1 month'));
$next1=date("01.m.Y", strtotime('+1 month'));
$yesterday=date("d.m.Y", strtotime('-1 day'));
$yesterdayJS=date("d/m/Y", strtotime('-1 day'));
$datePlus7DaysJS=date("d/m/Y", strtotime('+7 day'));
$smarty->assign('year_start', date("01.01.Y"));
$smarty->assign('year_end', date("31.12.Y"));
$smarty->assign('now1', $now1);
//$smarty->assign('prev1', $prev1);
$smarty->assign('next1', $next1);
$smarty->assign('now', $now);
$smarty->assign('nowJS', $nowJS);
$smarty->assign('now_time', $now_time);
$smarty->assign('now_date_time', $now_date_time);
$smarty->assign('yesterday', $yesterday);
$smarty->assign('yesterdayJS', $yesterdayJS);
$smarty->assign('datePlus7DaysJS', $datePlus7DaysJS);


$times=array();
for ($h=0;$h<24;$h++)
{
	for ($m=0;$m<6;$m++)
	{
		$times[]=substr('0'.$h,-2,2).'-'.substr('0'.($m*10),-2,2);
	}
}
$smarty->assign('times', $times);


InitRequestVar('remote_addr',$_SERVER["REMOTE_ADDR"]);
$smarty->assign('remote_addr', $_SERVER["REMOTE_ADDR"]);
isset($_REQUEST['action']) ? $action = $_REQUEST['action'] : $action = null;
isset($_SESSION['users_id']) ? null : $_SESSION['users_id'] = null;
isset($_REQUEST['username']) ? $_REQUEST['username']=trim($_REQUEST['username']) : null;
isset($_REQUEST['password']) ? $_REQUEST['password']=trim($_REQUEST['password']) : null;
isset($_POST['username']) ? $_POST['username']=trim($_POST['username']) : null;
isset($_POST['password']) ? $_POST['password']=trim($_POST['password']) : null;
if (isset($_GET['auto'])){$_REQUEST["username"]=$_GET['username'];$_REQUEST["password"]=$_GET['password'];$_POST["username"]=$_GET['username'];$_POST["password"]=$_GET['password'];}
require_once 'MDB2.php';
//$dsn = '';
$dsn = 'oci8://persik:razvitie@'.ZAOIBM;
$db = MDB2::connect($dsn);
if (PEAR::isError($db))
{
	include "m.header.php";
	include "content-div-start.php";
	$smarty->display("db_unreachable.html");
	include "content-div-end.php";
	include "m.footer.php";
	die();
}
$db->loadModule('Extended');
$db->loadModule('Function');
$now_week = $db->getOne("SELECT TO_CHAR (MIN (data), 'dd.mm.yyyy') FROM calendar WHERE wy = (SELECT wy FROM calendar WHERE data = TRUNC (SYSDATE))");
$smarty->assign('now_week', $now_week);
$smarty->assign('next_month_name', get_month_name(date("m", strtotime('+1 month'))));
require_once "Auth.php";
$sql = rtrim(file_get_contents('sql/current_dates.sql'));
$dates = $db->getRow($sql);
!isset($_SESSION["month_list"])?$_SESSION["month_list"]=$dates[0]:null;
!isset($_SESSION["dates_list"])?$_SESSION["dates_list"]=$dates[1]:null;
!isset($_REQUEST["month_list"])?$_REQUEST["month_list"]=$_SESSION["month_list"]:$_SESSION["month_list"]=$_REQUEST["month_list"];
!isset($_REQUEST["dates_list"])?$_REQUEST["dates_list"]=$_SESSION["dates_list"]:$_SESSION["dates_list"]=$_REQUEST["dates_list"];
isset($_REQUEST["select_country"])?$_SESSION["cnt_kod"]=$_REQUEST["select_country"]:null;
!isset($_REQUEST["emp_tn"]) ? $_REQUEST["emp_tn"] = null : null;
setlocale(LC_TIME, "ru_RU");
mb_internal_encoding("CP1251");
$smarty->assign('now_month', $db->getOne("SELECT TO_CHAR (SYSDATE, 'month') FROM DUAL"));
$smarty->assign('now_year', $db->getOne("SELECT TO_CHAR (SYSDATE, 'yyyy') FROM DUAL"));
function loginFunction($username = null, $status = null, &$auth = null)
{
	global $is_don;
	global $smarty;
	global $prev1;
	require_once "m.header.php";
	require_once "content-div-start.php";
	include "avtoriz.php";
	require_once "content-div-end.php";
	require_once "m.footer.php";
}
$options = array('dsn' => $dsn,'usernamecol' => 'login','passwordcol' => 'password','table' => 'user_list','cryptType' => 'none','db_fields' => "*");
$a = new Auth("MDB2", $options, "loginFunction");
if (isset($_REQUEST['action']))
{
	if ($_REQUEST['action'] == "logout" && $a->checkAuth())
	{
		$a->logout();
		session_unset();
		session_destroy();
	}
}
$a->start();
if ($a->getAuth())
{
	if ($action=='logout')
	{
		$a->logout();
		$a->start();
	}
	else
	{
		$smarty->assign('login', $_SESSION["_authsession"]["username"]);
		$login = $_SESSION["_authsession"]["username"];
		$password = $db->getOne("select password from user_list where login='".$login."'");
		$smarty->assign('fio', $a->getAuthData('fio'));
		$fio = $a->getAuthData('fio');
		$a->getAuthData('tn')==0 ? $tn = -1 : $tn = $a->getAuthData('tn');
		$a->setAuthData('tn', $tn, true);
		$smarty->assign('tn', $tn);
		$smarty->assign('datastart', $a->getAuthData('datastart'));
		$smarty->assign('my_department_name', $a->getAuthData('department_name'));
		$smarty->assign('my_pos_name', $a->getAuthData('pos_name'));
		$smarty->assign('my_pos_id', $a->getAuthData('pos_id'));
		$_SESSION["my_department_name"] = $a->getAuthData('department_name');
		$_SESSION["my_pos_name"] = $a->getAuthData('pos_name');
		$_SESSION["my_pos_id"] = $a->getAuthData('pos_id');
		$smarty->assign('is_super', $a->getAuthData('is_super'));
		$smarty->assign('is_admin', $a->getAuthData('is_admin'));
                $is_admin = $a->getAuthData('is_admin');
		$smarty->assign('is_acceptor', $a->getAuthData('is_acceptor'));
		$smarty->assign('is_kk', $a->getAuthData('is_kk'));
		$smarty->assign('is_mkk', $a->getAuthData('is_mkk'));
		$smarty->assign('is_mkk_new', $a->getAuthData('is_mkk_new'));
		$smarty->assign('is_rmkk', $a->getAuthData('is_rmkk'));
                $is_rmkk = $a->getAuthData('is_rmkk');
		$smarty->assign('is_ts', $a->getAuthData('is_ts'));
		$smarty->assign('is_rm', $a->getAuthData('is_rm'));
		$smarty->assign('is_tm', $a->getAuthData('is_tm'));
		$smarty->assign('is_top', $a->getAuthData('is_top'));
		$smarty->assign('is_mservice', $a->getAuthData('is_mservice'));
		$smarty->assign('is_smr', $a->getAuthData('is_smr'));
                $is_smr = $a->getAuthData('is_smr');
		$smarty->assign('is_ma', $a->getAuthData('is_ma'));
                $is_ma = $a->getAuthData('is_ma');
		$smarty->assign('is_do', $a->getAuthData('is_do'));
		$smarty->assign('is_mz', $a->getAuthData('is_mz'));
		$smarty->assign('is_mz_admin', $a->getAuthData('is_mz_admin'));
		$smarty->assign('is_mz_buh', $a->getAuthData('is_mz_buh'));
		$smarty->assign('without_kk', $a->getAuthData('without_kk'));
		$smarty->assign('is_db', $a->getAuthData('is_db'));
		$smarty->assign('has_child_db', $a->getAuthData('has_child_db'));
		$smarty->assign('has_parent_db', $a->getAuthData('has_parent_db'));
		$smarty->assign('is_coach', $a->getAuthData('is_coach'));
		$smarty->assign('is_test_admin', $a->getAuthData('is_test_admin'));
		$smarty->assign('is_dm', $a->getAuthData('is_dm'));
		$p = array(':tn' => $tn);
		$sql=rtrim(file_get_contents('sql/countries.sql'));
		$sql=stritr($sql,$p);
		$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
		$smarty->assign('countries', $data);
		if (isset($_SESSION["cnt_kod"]))
		{
			foreach ($data as $k=>$v)
			{
				if ($v["cnt_kod"]==$_SESSION["cnt_kod"])
				{
					$smarty->assign('dpt_id', $v['dpt_id']);
					$smarty->assign('cnt_kod', $v['cnt_kod']);
					$smarty->assign('cnt_name', $v['cnt_name']);
					$smarty->assign('dpt_name', $v['dpt_name']);
					$smarty->assign('valuta', $v['valuta']);
					$smarty->assign('cur_id', $v['cur_id']);
					$_SESSION["dpt_id"] = $v['dpt_id'];
					$_SESSION["cnt_kod"] = $v['cnt_kod'];
					$_SESSION["cnt_name"] = $v['cnt_name'];
					$_SESSION["dpt_name"] = $v['dpt_name'];
					$_SESSION["valuta"] = $v['valuta'];
					$_SESSION["cur_id"] = $v['cur_id'];
				}
			}
		}
		else
		{
			$smarty->assign('dpt_id', $a->getAuthData('dpt_id'));
			$smarty->assign('cnt_kod', $a->getAuthData('cnt_kod'));
			$smarty->assign('cnt_name', $a->getAuthData('cnt_name'));
			$smarty->assign('dpt_name', $a->getAuthData('dpt_name'));
			$smarty->assign('valuta', $a->getAuthData('valuta'));
			$smarty->assign('cur_id', $a->getAuthData('cur_id'));
			$_SESSION["dpt_id"] = $a->getAuthData('dpt_id');
			$_SESSION["cnt_kod"] = $a->getAuthData('cnt_kod');
			$_SESSION["cnt_name"] = $a->getAuthData('cnt_name');
			$_SESSION["dpt_name"] = $a->getAuthData('dpt_name');
			$_SESSION["valuta"] = $a->getAuthData('valuta');
			$_SESSION["cur_id"] = $a->getAuthData('cur_id');
		}
		$smarty->assign('is_traid', $a->getAuthData('is_traid'));
		$smarty->assign('is_traid_kk', $a->getAuthData('is_traid_kk'));
		$smarty->assign('is_dc', $a->getAuthData('is_dc'));
		$smarty->assign('is_kpr', $a->getAuthData('is_kpr'));
		$smarty->assign('is_fin_man', $a->getAuthData('is_fin_man'));
		$smarty->assign('is_dpu', $a->getAuthData('is_dpu'));
		$smarty->assign('is_nmms', $a->getAuthData('is_nmms'));
		$smarty->assign('is_bud_admin', $a->getAuthData('is_bud_admin'));
		$smarty->assign('is_it', $a->getAuthData('is_it'));
		$smarty->assign('is_run', $a->getAuthData('is_run'));
		$smarty->assign('is_assist', $a->getAuthData('is_assist'));
		$smarty->assign('is_nm', $a->getAuthData('is_nm'));
		$smarty->assign('is_ndp', $a->getAuthData('is_ndp'));
		$smarty->assign('is_don', $a->getAuthData('is_don'));
		$is_don = $a->getAuthData('is_don');
		$smarty->assign('is_fil', $a->getAuthData('is_fil'));
		/*$is_atd_super = $db->getOne("SELECT nvl(is_super,0) FROM atd_contr_avk WHERE inn = ".$tn);
		$smarty->assign('is_atd_super', $is_atd_super);
		$is_azl_super = $db->getOne("SELECT nvl(is_super,0) FROM azl_contr_avk WHERE inn = ".$tn);
		$smarty->assign('is_azl_super', $is_azl_super);
		$is_akr_super = $db->getOne("SELECT nvl(is_super,0) FROM akr_contr_avk WHERE inn = ".$tn);
		$smarty->assign('is_akr_super', $is_akr_super);*/
		$smarty->assign('is_eta', $a->getAuthData('is_eta'));
		$smarty->assign('h_eta', $a->getAuthData('h_eta'));
		$smarty->assign('is_eta_kk', $a->getAuthData('is_eta_kk'));
		$_SESSION["is_eta"] = $a->getAuthData('is_eta');
		$_SESSION["h_eta"] = $a->getAuthData('h_eta');
		$_SESSION["is_eta_kk"] = $a->getAuthData('is_eta_kk');
		$smarty->assign('is_prez', $a->getAuthData('is_prez'));
		$_SESSION["is_prez"] = $a->getAuthData('is_prez');
		$sql=rtrim(file_get_contents('sql/currencies.sql'));
		$currencies = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
		$smarty->assign('currencies', $currencies);
                isset($_REQUEST['act']) ? $actParams = $db->getRow("select c.y,c.my from bud_act_fund b,calendar c where b.act='".$_REQUEST['act']."' and b.act_month=c.data", null, null, null, MDB2_FETCHMODE_ASSOC) : null;
		if ($_SESSION["dpt_id"]!=0)
		{
			$sql=rtrim(file_get_contents('sql/parameters.sql'));
			$p = array(':dpt_id' => $_SESSION["dpt_id"]);
			$sql=stritr($sql,$p);
			$parameters = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
			$p=array();
			foreach($parameters as $k=>$v){$p[$v["param_name"]]=$v;}
			$smarty->assign('parameters', $p);
			$parameters = $p;
		}
		if ($action=='test')
		{
			$params = array($tn);
			$sth = $db->prepare("delete from test_list where tn=?");
			$sth->execute($params);
		}
		$params = array(':exp_tn' => $tn);
		$sql = 'select count(*) from ocenka_test_list where tn=:exp_tn';
		$sql=stritr($sql,$params);
		$test_enabled = $db->GetOne($sql);
		$smarty->assign('test_enabled', $test_enabled);
		/*
		$football_team_responsible = $db->getOne('SELECT COUNT (*) FROM football_teams WHERE '.$tn.' = tn_responsible');
		$football_team_checking = $db->getOne('SELECT COUNT (*) FROM football_teams WHERE '.$tn.' = tn_checking');
		$football_team_responsible > 0 ? $smarty->assign('football_team_responsible', 1) : null;
		$football_team_checking > 0 ? $smarty->assign('football_team_checking', 1) : null;
		*/
                $login_type = strpos($login,'ms')!==false? 'ms' : 'general';
                $smarty->assign('login_type', $login_type);
                //if (!($action=='merch_report_new'&&isset($_POST))) {
                    if (!isset($_REQUEST["pdf"])){require_once "m.header.php";}
                    if (!isset($_REQUEST["print"])&&!isset($_REQUEST["nohead"])) {
                            if (
                                    /*(strpos($login,'akr_avk_')===false)&&(strpos($login,'akr_ag_')===false)&&(strpos($login,'atd_avk_')===false)&&(strpos($login,'atd_ag_')===false)&&(strpos($login,'azl_avk_')===false)&&(strpos($login,'azl_ag_')===false)&&*/
                                    (
                                    /*(
                                            strpos($login,'ms')===false
                                            ||
                                            (strpos($login,'ms')!==false&&$is_smr==1)
                                            )&&*/
                                    (strpos($login,'avk')===false)&&
                                    (strpos($login,'ag0')===false)&&
                                    (strpos($login,'fil0')===false)&&
                                    (strpos($login,'ac')===false))
                            ) {include "menu.php";}
                            include "content-div-start.php";
                    }
                //}
		if (count(glob($action.".php"))==0) {
			/*if (strpos($login,'akr_avk_')!==false){include "akr_report.php";}elseif (strpos($login,'akr_ag_')!==false){include "akr_ag_report.php";}elseif (strpos($login,'atd_avk_')!==false){include "atd_report.php";}elseif (strpos($login,'atd_ag_')!==false){include "atd_ag_report.php";}elseif (strpos($login,'azl_avk_')!==false){include "azl_report.php";}elseif (strpos($login,'azl_ag_')!==false){include "azl_ag_report.php";}else*/
			if (strpos($login,'ms')!==false){include "merch_report_new.php";}
			else if (strpos($login,'avk')!==false){include "golos.php";}
			else if (strpos($login,'ag0')!==false){}
			else if (strpos($login,'fil0')!==false){include "bud_svod_zatd.php";}
			else if (strpos($login,'ac')!==false){include "ac_main.php";}
			else {if ($action !== null) {include "blank.php";} else {include "main.php";}}
		} else {include $action.".php";}
		if (!isset($_REQUEST["print"])&&!isset($_REQUEST["nohead"]))
		{
			include "content-div-end.php";
			include "right-div.php";
		}
		if (!isset($_REQUEST["pdf"])){include "m.footer.php";}
	}
} else {/* echo "<font color=\"#990000\">Ќеправильное им€ пользовател€ или пароль</font>";*/}
$db->disconnect();
?>