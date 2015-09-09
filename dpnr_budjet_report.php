<?

InitRequestVar("sd",$_SESSION['month_list']);
InitRequestVar("ed",$_SESSION['month_list']);
InitRequestVar("markets",array());
InitRequestVar("dpnr",0);
InitRequestVar("ok_chief",2);
InitRequestVar("pf",1);

$p = array(
":dpt_id" => $_SESSION["dpt_id"],
":tn" => $tn,
":sd" => "'".$_REQUEST["sd"]."'",
":ed" => "'".$_REQUEST["ed"]."'",
":m_id" => join(array_keys($_REQUEST['markets']),','),
":ok_chief" => $_REQUEST['ok_chief'],
":dpnr" => $_REQUEST['dpnr']
);

$sql = rtrim(file_get_contents('sql/spd_list.sql'));
$sql=stritr($sql,$p);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('m_tn_list', $data);

$sql = rtrim(file_get_contents('sql/month_list.sql'));
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('month_list', $res);

$sql = rtrim(file_get_contents('sql/dpnr_budjet_markets.sql'));
$sql=stritr($sql,$p);
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('markets', $res);

if (isset($_REQUEST['generate']))
{
$sql = rtrim(file_get_contents('sql/dpnr_budjet_report_head.sql'));
$sql=stritr($sql,$p);
$res = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('head', $res);
$sql = rtrim(file_get_contents('sql/dpnr_budjet_report_body.sql'));
$sql=stritr($sql,$p);
//echo $sql;
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
foreach ($res as $k=>$v)
{
$v['cid']!=null&&$v['cname']!=null&&$v['spid']==null&&$v['spname']==null&&$v['scid']==null&&$v['scname']==null?$d['columns'][$v['cid']]=$v['cname']:null;
$v['cid']!=null&&$v['cname']!=null&&$v['spid']==null&&$v['spname']==null&&$v['scid']==null&&$v['scname']==null?$d['total'][$v['cid']]['plan']=$v['plan']:null;
$v['cid']!=null&&$v['cname']!=null&&$v['spid']==null&&$v['spname']==null&&$v['scid']==null&&$v['scname']==null?$d['total'][$v['cid']]['fakt']=$v['fakt']:null;
$v['cid']==null&&$v['cname']==null&&$v['spid']==null&&$v['spname']==null&&$v['scid']==null&&$v['scname']==null?$d['zat_plan']=$v['zat_plan']:null;
$v['cid']==null&&$v['cname']==null&&$v['spid']==null&&$v['spname']==null&&$v['scid']==null&&$v['scname']==null?$d['zat_plane']=$v['zat_plane']:null;
$v['cid']==null&&$v['cname']==null&&$v['spid']==null&&$v['spname']==null&&$v['scid']==null&&$v['scname']==null?$d['zat_fakt']=$v['zat_fakt']:null;
$v['cid']==null&&$v['cname']==null&&$v['spid']==null&&$v['spname']==null&&$v['scid']==null&&$v['scname']==null?$d['zat_fakte']=$v['zat_fakte']:null;
$v['cid']==null&&$v['cname']==null&&$v['spid']==null&&$v['spname']==null&&$v['scid']==null&&$v['scname']==null?$d['plan']=$v['plan']:null;
$v['cid']==null&&$v['cname']==null&&$v['spid']==null&&$v['spname']==null&&$v['scid']==null&&$v['scname']==null?$d['fakt']=$v['fakt']:null;
$v['cid']==null&&$v['cname']==null&&$v['spid']!=null&&$v['spname']!=null&&$v['scid']==null&&$v['scname']==null?$d['data'][$v['spid']]['spname']=$v['spname']:null;
$v['cid']==null&&$v['cname']==null&&$v['spid']!=null&&$v['spname']!=null&&$v['scid']==null&&$v['scname']==null?$d['data'][$v['spid']]['plan']=$v['plan']:null;
$v['cid']==null&&$v['cname']==null&&$v['spid']!=null&&$v['spname']!=null&&$v['scid']==null&&$v['scname']==null?$d['data'][$v['spid']]['fakt']=$v['fakt']:null;
$v['cid']!=null&&$v['cname']!=null&&$v['spid']!=null&&$v['spname']!=null&&$v['scid']==null&&$v['scname']==null?$d['data'][$v['spid']]['columns'][$v['cid']]['plan']=$v['plan']:null;
$v['cid']!=null&&$v['cname']!=null&&$v['spid']!=null&&$v['spname']!=null&&$v['scid']==null&&$v['scname']==null?$d['data'][$v['spid']]['columns'][$v['cid']]['fakt']=$v['fakt']:null;
$v['cid']==null&&$v['cname']==null&&$v['spid']!=null&&$v['spname']!=null&&$v['scid']!=null&&$v['scname']!=null?$d['data'][$v['spid']]['data'][$v['scid']]['scname']=$v['scname']:null;
$v['cid']==null&&$v['cname']==null&&$v['spid']!=null&&$v['spname']!=null&&$v['scid']!=null&&$v['scname']!=null?$d['data'][$v['spid']]['data'][$v['scid']]['plan']=$v['plan']:null;
$v['cid']==null&&$v['cname']==null&&$v['spid']!=null&&$v['spname']!=null&&$v['scid']!=null&&$v['scname']!=null?$d['data'][$v['spid']]['data'][$v['scid']]['fakt']=$v['fakt']:null;
$v['cid']!=null&&$v['cname']!=null&&$v['spid']!=null&&$v['spname']!=null&&$v['scid']!=null&&$v['scname']!=null?$d['data'][$v['spid']]['data'][$v['scid']]['columns'][$v['cid']]['plan']=$v['plan']:null;
$v['cid']!=null&&$v['cname']!=null&&$v['spid']!=null&&$v['spname']!=null&&$v['scid']!=null&&$v['scname']!=null?$d['data'][$v['spid']]['data'][$v['scid']]['columns'][$v['cid']]['fakt']=$v['fakt']:null;
$v['cid']!=null&&$v['cname']!=null&&$v['spid']!=null&&$v['spname']!=null&&$v['scid']!=null&&$v['scname']!=null?$d['data'][$v['spid']]['data'][$v['scid']]['columns'][$v['cid']]['comm']=$v['comm']:null;
}
$smarty->assign('body', $d);
}

$smarty->display('dpnr_budjet_report.html');

?>