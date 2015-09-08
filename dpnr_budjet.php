<?

InitRequestVar("month_list");
InitRequestVar("ml");
InitRequestVar("market");

if(isset($_REQUEST['copy']))
{
$_REQUEST['generate']=1;
$p = array(
":fd" => "'".$_REQUEST["ml"]."'",
":td" => "'".$_REQUEST["month_list"]."'",
":market" => $_REQUEST['market']
);
$sql = rtrim(file_get_contents('sql/dpnr_budjet_copy.sql'));
$sql=stritr($sql,$p);
$res = $db->query($sql);
echo $sql;
}

$sql = rtrim(file_get_contents('sql/month_list.sql'));
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('month_list', $res);

$p = array(":tn" => $tn);
$sql = rtrim(file_get_contents('sql/dpnr_budjet_markets.sql'));
$sql=stritr($sql,$p);
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('markets', $res);

if (isset($_REQUEST['generate']))
{

$p = array(":tn" => $tn, ":m_id" => $_REQUEST['market']);
$sql = rtrim(file_get_contents('sql/dpnr_budjet_market_enabled.sql'));
$sql=stritr($sql,$p);
$res = $db->getOne($sql);
$smarty->assign('market_enabled', $res);
//$smarty->assign('market_enabled', 1);

$p = array(":dt" => "'".$_REQUEST["month_list"]."'", ":m_id" => $_REQUEST['market']);
$sql = rtrim(file_get_contents('sql/dpnr_budjet_head.sql'));
$sql=stritr($sql,$p);
//echo $sql;
$res = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('head', $res);
//print_r($res);

$p = array(":dt" => "'".$_REQUEST["month_list"]."'", ":m_id" => $_REQUEST['market']);
$sql = rtrim(file_get_contents('sql/dpnr_budjet_body.sql'));
$sql=stritr($sql,$p);
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
//echo "<div style='width:100%;text-align:left'><pre>";
//print_r($d);
//echo "</pre></div>";

}

$smarty->display('dpnr_budjet.html');

?>