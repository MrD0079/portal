<?
if (isset($_REQUEST["get_prot_db"])){
    $prot_db = $db->getOne("select prot_db from bud_svod_taf where dt=to_date('".$_REQUEST["dt"]."','dd.mm.yyyy') and fil=".$_REQUEST['key2']);
    $smarty->assign('prot_db', $prot_db);
    $smarty->display('bud_svod_ta_list_prot_db.html');
} else {
    
    $_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);
    $keys = array('dt'=>OraDate2MDBDate($_REQUEST['dt']));
    $vals = array($_REQUEST['field']=>$_REQUEST['val']);
    //$_REQUEST['table']=='m'?$keys['dpt_id']=$_SESSION['dpt_id']:null;
    $_REQUEST['table']=='f'?$keys['fil']=$_REQUEST['key2']:null;
    //$_REQUEST['table']=='f'&&$_REQUEST['val']==null&&$_REQUEST['field']=='coach'?$vals=null:null;
    if (isset($_FILES['file']))
    {
            $_FILES = recursive_iconv ('UTF-8', 'Windows-1251', $_FILES);
            if (is_uploaded_file($_FILES['file']['tmp_name']))
            {
                    $a=pathinfo($_FILES['file']['name']);
                    $id=get_new_file_id();
                    //$keys['id']=$id;
                    $fn=$id.'_'.translit($_FILES['file']['name']);
                    //echo "select prot_db from bud_svod_taf where dt=to_date('".$_REQUEST["dt"]."','dd.mm.yyyy') and fil=".$_REQUEST['key2']."<br>";
                    $prot_db = $db->getOne("select prot_db from bud_svod_taf where dt=to_date('".$_REQUEST["dt"]."','dd.mm.yyyy') and fil=".$_REQUEST['key2']);
                    $prot_db = preg_split('/\r\n|\r|\n/', $prot_db);
                    $prot_db[]=$fn;
                    $vals = array($_REQUEST['field']=>join("\n",$prot_db));
                    Table_Update('bud_svod_ta'.$_REQUEST['table'], $keys,$vals);
                    if (!file_exists('files/bud_svod_ta_files')) {mkdir('files/bud_svod_ta_files',0777,true);}
                    move_uploaded_file($_FILES['file']['tmp_name'], 'files/bud_svod_ta_files/'.$fn);
            }
            else
            {echo 'Ошибка загрузки файла<br>';}
    } else {
        if ($_REQUEST['field']=='prot_db'&&isset($_REQUEST['del']))
        {
            $prot_db = $db->getOne("select prot_db from bud_svod_taf where dt=to_date('".$_REQUEST["dt"]."','dd.mm.yyyy') and fil=".$_REQUEST['key2']);
            $prot_db = preg_split('/\r\n|\r|\n/', $prot_db);
            if(($key = array_search($_REQUEST['val'], $prot_db)) !== false) {unset($prot_db[$key]);}
            $vals = array($_REQUEST['field']=>join("\n",$prot_db));
        }
        Table_Update('bud_svod_ta'.$_REQUEST['table'], $keys,$vals);
    }
}
?>