<?
//ini_set('display_errors', 'On');
if (isset($_REQUEST['save_item'])) {
    $_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);
    //ses_req();
    $keys=array(
        'aa_id'=>$_REQUEST["id"],
        'kodtp'=>$_REQUEST["kodtp"],
        'head_id'=>$_REQUEST["head_id"],
        'ag_id'=>$_REQUEST["ag_id"]
    );
    isset($_REQUEST['report'])?Table_Update('merch_report_aa_report', $keys,$_REQUEST['report']):null;
    if (isset($_REQUEST["sku"])) {
        $keys=array(
            'aa_id'=>$_REQUEST["id"],
            'kodtp'=>$_REQUEST["kodtp"],
            'head_id'=>$_REQUEST["head_id"],
            'ag_id'=>$_REQUEST["ag_id"]
        );
        foreach ($_REQUEST["sku"] as $k=>$v) {
            $keys['sku_id']=$k;
            $vals=$v;
            Table_Update('merch_report_aa_report_s', $keys,$vals);
        }
    }

    $keys=array(
                'aa_id'=>$_REQUEST["id"],
                'kodtp'=>$_REQUEST["kodtp"],
                'head_id'=>$_REQUEST["head_id"],
                'ag_id'=>$_REQUEST["ag_id"]
            );
    $p=array(
        ':aa_id'=>$_REQUEST["id"],
        ':kodtp'=>$_REQUEST["kodtp"],
        ':head_id'=>$_REQUEST["head_id"],
        ':ag_id'=>$_REQUEST["ag_id"],
    );
    if (isset($_FILES['file']))
    {
        include_once('SimpleImage.php');
        $_FILES = recursive_iconv ('UTF-8', 'Windows-1251', $_FILES);
        foreach($_FILES['file']['tmp_name'] as $k=>$v){
            if (is_uploaded_file($_FILES['file']['tmp_name'][$k]))
            {
                $a=pathinfo($_FILES['file']['name'][$k]);
                $id=get_new_file_id();
                $fn=$id.'_'.translit($_FILES['file']['name'][$k]);
                $sql="select photo from merch_report_aa_report WHERE     aa_id = :aa_id
                AND kodtp = :kodtp
                AND head_id = :head_id
                AND ag_id = :ag_id";
                $sql=stritr($sql,$p);
                $files = $db->getOne($sql);
                $files = preg_split('/\r\n|\r|\n/', $files);
                $files[]=$fn;
                $vals = array("photo"=>join("\n",$files));
                Table_Update('merch_report_aa_report', $keys,$vals);
                move_uploaded_file($_FILES['file']['tmp_name'][$k], 'files/'.$fn);
                $image = new SimpleImage();
		$image->load('files/'.$fn);
                $handle=$image->getHeight();
                if ($image->getHeight()>600)
                {
                $image->resizeToHeight(600);
                }
                $image->save('files/'.$fn);
            }
        }
    }
    if (isset($_REQUEST["del_files"])) {
        foreach(explode(",", $_REQUEST["del_files"]) as $v) {
            echo $v."\n";
            $sql="select photo from merch_report_aa_report WHERE     aa_id = :aa_id
            AND kodtp = :kodtp
            AND head_id = :head_id
            AND ag_id = :ag_id";
            $sql=stritr($sql,$p);
            $files = $db->getOne($sql);
            $files = preg_split('/\r\n|\r|\n/', $files);
            if(($key = array_search($v, $files)) !== false) {unset($files[$key]);}
            $vals = array("photo"=>join("\n",$files));
            Table_Update('merch_report_aa_report', $keys,$vals);
        }
    }





    $keys=array(
        'aa_id'=>$_REQUEST["id"],
        'kodtp'=>$_REQUEST["kodtp"],
        'head_id'=>$_REQUEST["head_id"],
        'ag_id'=>$_REQUEST["ag_id"],
        'rep_id'=>6
    );
    Table_Update('merch_report_cal_sok', $keys,null);
    $sql='INSERT INTO merch_report_cal_sok (aa_id,head_id,
                                  ag_id,
                                  kodtp,
                                  data,
                                  rep_id)
     SELECT aa_id,head_id,
            ag_id,
            kodtp,
            data,
            6
       FROM merch_report_cal_reminders
      WHERE     aa_id = :aa_id
            AND kodtp = :kodtp
            AND head_id = :head_id
            AND ag_id = :ag_id';
    $p=array(
        ':aa_id'=>$_REQUEST["id"],
        ':kodtp'=>$_REQUEST["kodtp"],
        ':head_id'=>$_REQUEST["head_id"],
        ':ag_id'=>$_REQUEST["ag_id"],
    );
    $sql=stritr($sql,$p);
    $db->query($sql);
} else if (isset($_REQUEST["getFiles"])){
        $p=array(
            ':aa_id'=>$_REQUEST["id"],
            ':kodtp'=>$_REQUEST["kodtp"],
            ':head_id'=>$_REQUEST["head_id"],
            ':ag_id'=>$_REQUEST["ag_id"],
        );
                $sql="select photo from merch_report_aa_report WHERE     aa_id = :aa_id
                AND kodtp = :kodtp
                AND head_id = :head_id
                AND ag_id = :ag_id";
                $sql=stritr($sql,$p);
    $photo = $db->getOne($sql);
    $smarty->assign('photo', $photo);
} else {
    $sql = "SELECT h.id,
       h.ag_id,
       h.h_city,
       h.id_net,
       h.tasks,
       h.need_photo,
       h.actual_promo_price,
       h.cancelled,
       TO_CHAR (h.lu, 'dd.mm.yyyy hh24:mi:ss') lut,
       TO_CHAR (h.dts, 'dd.mm.yyyy') dts,
       TO_CHAR (h.dte, 'dd.mm.yyyy') dte,
       ch.city,
       n.net_name,
       a.name ag_name
       FROM merch_report_cal_aa_h h,
       (  SELECT DISTINCT h_city, city
            FROM cpp
           WHERE city IS NOT NULL
        ORDER BY city) ch,
       ms_nets n,
       routes_agents a
       WHERE h.h_city = ch.h_city(+)
       AND h.id_net = n.id_net(+)
       AND h.ag_id = a.id(+)
       AND h.id = :id";
	$p=array(':id'=>$_REQUEST["id"]);
	$sql=stritr($sql,$p);
    $h = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
    $smarty->assign('h', $h);

    $p=array(
        ':aa_id'=>$_REQUEST["id"],
        ':kodtp'=>$_REQUEST["kodtp"],
        ':head_id'=>$_REQUEST["head_id"],
        ':ag_id'=>$h["ag_id"],
    );

    $sql = "SELECT sa.*, sr.price_rack
    FROM merch_report_cal_aa_s sa, merch_report_aa_report_s sr
    WHERE  sa.head_id = :aa_id
       AND sa.head_id = sr.aa_id(+)
       AND sa.id = sr.sku_id(+)
       AND sr.aa_id(+) = :aa_id
       AND sr.kodtp(+) = :kodtp
       AND sr.head_id(+) = :head_id
       AND sr.ag_id(+) = :ag_id
    order by sa.id";
    $sql=stritr($sql,$p);
    $r = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
    $smarty->assign('s', $r);
    
    
    

    $p=array(
        ':aa_id'=>$_REQUEST["id"],
        ':kodtp'=>$_REQUEST["kodtp"],
        ':head_id'=>$_REQUEST["head_id"],
        ':ag_id'=>$h["ag_id"],
    );

    $sql="select * from merch_report_aa_report where aa_id=:aa_id and kodtp=:kodtp and head_id=:head_id and ag_id=:ag_id";
    $sql=stritr($sql,$p);
    $rep = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
    $smarty->assign('rep', $rep);

    
    
    
    
    
    
}
$smarty->display('merch_report_aa_report.html');
