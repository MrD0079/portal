<?

//ses_req();



$sql = rtrim(file_get_contents('sql/ac_golos_res.sql'));
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('ac_golos_res', $res);



$sql = rtrim(file_get_contents('sql/ac_report_head.sql'));
//$p = array(':tn' => $_REQUEST["k"]["tn"],':y'=>$_REQUEST["k"]["y"]);
$p = array(':id' => $_REQUEST['id']);
$sql=stritr($sql,$p);
//echo $sql;
$res = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('ac_report_head', $res);


$sql = rtrim(file_get_contents('sql/ac_report_golos.sql'));
//$p = array(':tn' => $_REQUEST["k"]["tn"],':y'=>$_REQUEST["k"]["y"]);
$p = array(':id' => $_REQUEST['id']);
$sql=stritr($sql,$p);
//echo $sql;
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
foreach ($res as $k=>$v)
{
$ac_report_golos[$v['comm_tn']][$v['memb_id']]['res_id']=$v['res_id'];
$ac_report_golos[$v['comm_tn']][$v['memb_id']]['res_name']=$v['res_name'];
}
isset($ac_report_golos)?$smarty->assign('ac_report_golos', $ac_report_golos):null;

//print_r($ac_report_golos);


$sql = rtrim(file_get_contents('sql/ac_report_table1.sql'));
//$p = array(':tn' => $_REQUEST["k"]["tn"],':y'=>$_REQUEST["k"]["y"]);
$p = array(':id' => $_REQUEST['id']);
$sql=stritr($sql,$p);
//echo $sql;
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('ac_report_table1', $res);

foreach ($res as $k=>$v)
{
$memb[$v['id']]['fio']=$v['fio'];
$memb[$v['id']]['ie']=$v['ie'];
$memb[$v['id']]['iet']=$v['iet'];
}
$smarty->assign('memb', $memb);

foreach ($res as $k=>$v)
{
//if ($v['block_id']!=null)
//{
$bl[$v['block_id']]['id']=$v['block_id'];
$bl[$v['block_id']]['name']=$v['block_name'];
//}
}
$smarty->assign('bl', $bl);

foreach ($res as $k=>$v)
{
$t1[$v['id']][$v['block_id']]['c1']=$v['c1'];
$t1[$v['id']][$v['block_id']]['en']=$v['en'];
}


foreach ($t1 as $k=>$v)
{
	$t1[$k]['total']['c1']=0;
	foreach ($v as $k1=>$v1)
	{
		$t1[$k]['total']['c1']+=$v1['c1'];
	}
}



$smarty->assign('t1', $t1);

foreach ($res as $k=>$v)
{
$t11[$v['block_id']]['scores'][$v['id']]=$v['en'];
$t11[$v['block_id']]['places'][$v['id']]=0;
}



foreach ($t11 as $k=>$v)
{
	$t11[$k]['scores_sorted']=$t11[$k]['scores'];
	arsort($t11[$k]['scores_sorted']);
	$n = count($t11[$k]['scores_sorted']);
	$place = 1;
	$x=$t11[$k]['scores_sorted'];
	$aa=array();
	$kk=array();
	foreach ($x as $k1=>$v1)
	{
		$aa[]=$v1;
		$kk[]=$k1;
	}
	$place = 1;
	$p=array();
	for ($i = 0; $i < $n; $i++)
	{
		$p[$i] = $place;
		$t11[$k]['places'][$kk[$i]]=$p[$i];
		for ($j = $i+1; $j < $n; $j++)
		{
			if ($aa[$i] == $aa[$j])
			{
				$p[$j]=$place;
				$t11[$k]['places'][$kk[$j]]=$p[$j];
				$i++;
			}
		}
		$place++;
	}
}

foreach ($t11 as $k=>$v)
{
	foreach ($v['scores'] as $k1=>$v1)
	{
		$t11['total']['scores'][$k1]=0;
	}
}

foreach ($t11 as $k=>$v)
{
	foreach ($v['scores'] as $k1=>$v1)
	{
		$t11['total']['scores'][$k1]+=$v1;
	}
}

$t11['total']['scores_sorted']=$t11['total']['scores'];
arsort($t11['total']['scores_sorted']);
$n = count($t11['total']['scores_sorted']);
$place = 1;
$x=$t11['total']['scores_sorted'];
$aa=array();
$kk=array();
foreach ($x as $k1=>$v1)
{
	$aa[]=$v1;
	$kk[]=$k1;
}
$place = 1;
$p=array();
for ($i = 0; $i < $n; $i++)
{
	$p[$i] = $place;
	$t11['total']['places'][$kk[$i]]=$p[$i];
	$max_place=$p[$i];
	for ($j = $i+1; $j < $n; $j++)
	{
		if ($aa[$i] == $aa[$j])
		{
			$p[$j]=$place;
			$t11['total']['places'][$kk[$j]]=$p[$j];
			$max_place=$p[$j];
			$i++;
		}
	}
	$place++;
}




$t11['total']['max_place']=$max_place;

foreach ($x as $k1=>$v1)
{
	//$t11['total']['res_grup'][$k1]=($t11['total']['places'][$k1]-1.0)/$max_place;
	$x1=($t11['total']['places'][$k1]-1.0)/$max_place;
	$color='';
	switch (true)
	{
		case ($x1>=0.0&&$x1<0.33):$color='rgb(51, 255, 51)';break;
		case ($x1>=0.33&&$x1<0.67):$color='yellow';break;
		case ($x1>=0.67&&$x1<=1.0):$color='red';break;
		default:$color='black';
	}
	$t11['total']['colors'][$k1]=$color;
}


/*
echo "<table><tr>";
echo "<td><pre>";
print_r($t11['total']);
echo "</pre></td>";
echo "</tr></table>";
*/
/*
echo "<table><tr>";
foreach ($t11 as $k=>$v)
{
echo "<td><pre>";
print_r($v);
echo "</pre></td>";
}
echo "</tr></table>";
*/
$smarty->assign('t11', $t11);

$sql = rtrim(file_get_contents('sql/ac_report_table2.sql'));
//$p = array(':tn' => $_REQUEST["k"]["tn"],':y'=>$_REQUEST["k"]["y"]);
$p = array(':id' => $_REQUEST['id']);
$sql=stritr($sql,$p);
//echo $sql;
$res = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('ac_report_table2', $res);

/*
foreach ($res as $k=>$v)
{
$memb[$v['id']]['fio']=$v['fio'];
$memb[$v['id']]['ie']=$v['ie'];
$memb[$v['id']]['iet']=$v['iet'];
}
$smarty->assign('memb', $memb);
*/

foreach ($res as $k=>$v)
{
$comm[$v['comm_tn']]['comm_tn']=$v['comm_tn'];
$comm[$v['comm_tn']]['comm_fio']=$v['comm_fio'];
}
$smarty->assign('comm', $comm);

foreach ($res as $k=>$v)
{
$t2[$v['id']][$v['comm_tn']]['comm_tn']=$v['comm_tn'];
$t2[$v['id']][$v['comm_tn']]['comm_fio']=$v['comm_fio'];
}
$smarty->assign('t2', $t2);

//print_r($t2);




$smarty->display('ac_report_head_body.html');




?>