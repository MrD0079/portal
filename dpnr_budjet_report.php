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
	if (isset($_REQUEST['svod']))
	{
		$sql = rtrim(file_get_contents('sql/dpnr_budjet_report_svod.sql'));
		$sql=stritr($sql,$p);
		$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
		$smarty->assign('data', $res);
	}
	else
	{
			$sql = rtrim(file_get_contents('sql/dpnr_budjet_report_head4print.sql'));
			$sql=stritr($sql,$p);
			$head = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
			//$smarty->assign('head4print', $head);
			//print_r($head);
			$sql = rtrim(file_get_contents('sql/dpnr_budjet_report_body4print.sql'));
			$sql=stritr($sql,$p);
			//echo $sql;
			$body = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
			$d = array();
			foreach ($body as $k=>$v)
			{
				$v['cname']!=null&&$v['spname']==null&&$v['scname']==null?$d[$v['mname']]['total'][$v['cname']]['plan']=$v['plan']:null;
				$v['cname']!=null&&$v['spname']==null&&$v['scname']==null?$d[$v['mname']]['total'][$v['cname']]['fakt']=$v['fakt']:null;
				$v['cname']==null&&$v['spname']==null&&$v['scname']==null?$d[$v['mname']]['zat_plan']=$v['zat_plan']:null;
				$v['cname']==null&&$v['spname']==null&&$v['scname']==null?$d[$v['mname']]['zat_plane']=$v['zat_plane']:null;
				$v['cname']==null&&$v['spname']==null&&$v['scname']==null?$d[$v['mname']]['zat_fakt']=$v['zat_fakt']:null;
				$v['cname']==null&&$v['spname']==null&&$v['scname']==null?$d[$v['mname']]['zat_fakte']=$v['zat_fakte']:null;
				$v['cname']==null&&$v['spname']==null&&$v['scname']==null?$d[$v['mname']]['plan']=$v['plan']:null;
				$v['cname']==null&&$v['spname']==null&&$v['scname']==null?$d[$v['mname']]['fakt']=$v['fakt']:null;
				$v['cname']==null&&$v['spname']!=null&&$v['scname']==null?$d[$v['mname']]['data'][$v['spname']]['plan']=$v['plan']:null;
				$v['cname']==null&&$v['spname']!=null&&$v['scname']==null?$d[$v['mname']]['data'][$v['spname']]['fakt']=$v['fakt']:null;
				$v['cname']!=null&&$v['spname']!=null&&$v['scname']==null?$d[$v['mname']]['data'][$v['spname']]['total'][$v['cname']]['plan']=$v['plan']:null;
				$v['cname']!=null&&$v['spname']!=null&&$v['scname']==null?$d[$v['mname']]['data'][$v['spname']]['total'][$v['cname']]['fakt']=$v['fakt']:null;
				$v['cname']==null&&$v['spname']!=null&&$v['scname']!=null?$d[$v['mname']]['data'][$v['spname']]['data'][$v['scname']]['plan']=$v['plan']:null;
				$v['cname']==null&&$v['spname']!=null&&$v['scname']!=null?$d[$v['mname']]['data'][$v['spname']]['data'][$v['scname']]['fakt']=$v['fakt']:null;
				$v['cname']!=null&&$v['spname']!=null&&$v['scname']!=null?$d[$v['mname']]['data'][$v['spname']]['data'][$v['scname']]['total'][$v['cname']]['plan']=$v['plan']:null;
				$v['cname']!=null&&$v['spname']!=null&&$v['scname']!=null?$d[$v['mname']]['data'][$v['spname']]['data'][$v['scname']]['total'][$v['cname']]['fakt']=$v['fakt']:null;
				$v['cname']!=null&&$v['spname']!=null&&$v['scname']!=null?$d[$v['mname']]['data'][$v['spname']]['data'][$v['scname']]['total'][$v['cname']]['comm']=$v['comm']:null;
			}
			//print_r($d);
			//$smarty->assign('body4print', $d);
			foreach ($head as $k=>$v)
			{
				foreach ($d as $k1=>$v1)
				{
					if ($v['name']==$k1) $head[$k]['body']=$v1;
				}
			}
			//print_r($head);

			$sql = rtrim(file_get_contents('sql/dpnr_budjet_report_head.sql'));
			$sql=stritr($sql,$p);
			$res1 = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
			//$smarty->assign('head', $res1);
			$sql = rtrim(file_get_contents('sql/dpnr_budjet_report_body.sql'));
			$sql=stritr($sql,$p);
			//echo $sql;
			$res2 = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
			$d = array();
			foreach ($res2 as $k=>$v)
			{
				$v['cname']!=null&&$v['spname']==null&&$v['scname']==null?$d['total'][$v['cname']]['plan']=$v['plan']:null;
				$v['cname']!=null&&$v['spname']==null&&$v['scname']==null?$d['total'][$v['cname']]['fakt']=$v['fakt']:null;
				$v['cname']==null&&$v['spname']==null&&$v['scname']==null?$d['zat_plan']=$v['zat_plan']:null;
				$v['cname']==null&&$v['spname']==null&&$v['scname']==null?$d['zat_plane']=$v['zat_plane']:null;
				$v['cname']==null&&$v['spname']==null&&$v['scname']==null?$d['zat_fakt']=$v['zat_fakt']:null;
				$v['cname']==null&&$v['spname']==null&&$v['scname']==null?$d['zat_fakte']=$v['zat_fakte']:null;
				$v['cname']==null&&$v['spname']==null&&$v['scname']==null?$d['plan']=$v['plan']:null;
				$v['cname']==null&&$v['spname']==null&&$v['scname']==null?$d['fakt']=$v['fakt']:null;
				$v['cname']==null&&$v['spname']!=null&&$v['scname']==null?$d['data'][$v['spname']]['plan']=$v['plan']:null;
				$v['cname']==null&&$v['spname']!=null&&$v['scname']==null?$d['data'][$v['spname']]['fakt']=$v['fakt']:null;
				$v['cname']!=null&&$v['spname']!=null&&$v['scname']==null?$d['data'][$v['spname']]['total'][$v['cname']]['plan']=$v['plan']:null;
				$v['cname']!=null&&$v['spname']!=null&&$v['scname']==null?$d['data'][$v['spname']]['total'][$v['cname']]['fakt']=$v['fakt']:null;
				$v['cname']==null&&$v['spname']!=null&&$v['scname']!=null?$d['data'][$v['spname']]['data'][$v['scname']]['plan']=$v['plan']:null;
				$v['cname']==null&&$v['spname']!=null&&$v['scname']!=null?$d['data'][$v['spname']]['data'][$v['scname']]['fakt']=$v['fakt']:null;
				$v['cname']!=null&&$v['spname']!=null&&$v['scname']!=null?$d['data'][$v['spname']]['data'][$v['scname']]['total'][$v['cname']]['plan']=$v['plan']:null;
				$v['cname']!=null&&$v['spname']!=null&&$v['scname']!=null?$d['data'][$v['spname']]['data'][$v['scname']]['total'][$v['cname']]['fakt']=$v['fakt']:null;
				$v['cname']!=null&&$v['spname']!=null&&$v['scname']!=null?$d['data'][$v['spname']]['data'][$v['scname']]['total'][$v['cname']]['comm']=$v['comm']:null;
			}
			//print_r($d);
			$res1['body']=$d;
			array_unshift($head,$res1);
			//$head['-1']=$res1;
			//$head['-1']['body']=$d;
			//print_r($head);
			$smarty->assign('data', $head);
			//$smarty->assign('body', $d);
	}
}
$smarty->display('dpnr_budjet_report.html');
?>