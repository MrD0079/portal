<?
	$sql='
	SELECT var_name
	  FROM bud_ru_ff
	 WHERE var_name IS NOT NULL
	UNION
	SELECT rep_var_name
	  FROM bud_ru_ff
	 WHERE rep_var_name IS NOT NULL
	';
//	$prefix='formula_var_';
	$prefix='';
	$list = $db->getCol($sql/*, null, null, null, MDB2_FETCHMODE_ASSOC*/);
	//print_r($list);
	$list1=array();
	foreach ($list as $lk=>$lv)
	{
	$list1[$prefix.$lv]=0;
	}
	//print_r($list1);
	extract($list1,EXTR_OVERWRITE/*,$prefix*/);
	$d[$k]["formula_vals"]=array();
	foreach ($data as $k1=>$v1)
	{
		if ($v1["var_name"]!='')
		{
			$d[$k]["formula_vals"][$prefix.$v1["var_name"]]=$v1['val_'.$v1["type"]];
		}
		if ($v1["rep_var_name"]!='')
		{
			$d[$k]["formula_vals"][$prefix.$v1["rep_var_name"]]=$v1['rep_val_'.$v1["type"]];
		}
	}
	extract($d[$k]["formula_vals"],EXTR_OVERWRITE/*,$prefix*/);
	foreach ($data as $k1=>$v1)
	{
		if ($v1["type"]=="formula")
		{
			$z = array('$'=>'$'.$prefix);
			$data[$k1]["formula"]=stritr($data[$k1]["formula"],$z);
			$data[$k1]["rep_formula"]=stritr($data[$k1]["rep_formula"],$z);
			@eval('$x='.$data[$k1]["formula"].';');
			@eval('$rx='.$data[$k1]["rep_formula"].';');
			$data[$k1]["val_formula"]=$x;
			$data[$k1]["rep_val_formula"]=$rx;
		}
	}
?>