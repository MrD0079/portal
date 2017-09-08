<?
if (isset($_REQUEST["list_tasting_program"])){
    $sql = "SELECT p.* FROM tasting_program p";
    $r = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
    $smarty->assign('x', $r);
} else if (isset($_REQUEST["save_tasting_program"])){
    $_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);
    Table_Update('tasting_program', array("id"=>$_REQUEST["id"]),$_REQUEST["tasting_program"]);
    if (isset($_FILES['tasting_tp_file']))
    {
            $_FILES = recursive_iconv ('UTF-8', 'Windows-1251', $_FILES);
            foreach($_FILES['tasting_tp_file']['tmp_name'] as $k=>$v){
                if (is_uploaded_file($_FILES['tasting_tp_file']['tmp_name'][$k]))
                {
                        $a=pathinfo($_FILES['tasting_tp_file']['name'][$k]);
                        $id=get_new_file_id();
                        $fn=$id.'_'.translit($_FILES['tasting_tp_file']['name'][$k]);
                        $files = $db->getOne("select files from tasting_program where id=".$_REQUEST['id']);
                        $files = preg_split('/\r\n|\r|\n/', $files);
                        $files[]=$fn;
                        $vals = array("files"=>join("\n",$files));
                        Table_Update('tasting_program', array("id"=>$_REQUEST["id"]),$vals);
                        move_uploaded_file($_FILES['tasting_tp_file']['tmp_name'][$k], 'files/'.$fn);
                }
            }
    }
    if (isset($_REQUEST["del_files"])) {
        foreach(explode(",", $_REQUEST["del_files"]) as $v) {
            echo $v."\n";
            $files = $db->getOne("select files from tasting_program where id=".$_REQUEST['id']);
            $files = preg_split('/\r\n|\r|\n/', $files);
            if(($key = array_search($v, $files)) !== false) {unset($files[$key]);}
            $vals = array("files"=>join("\n",$files));
            Table_Update('tasting_program', array("id"=>$_REQUEST["id"]),$vals);
        }
    }
} else if (isset($_REQUEST["list_files"])){
} else if (isset($_REQUEST["id"])||isset($_REQUEST["new_tasting_program"])){
    !isset($_REQUEST["id"])?$_REQUEST["id"]=get_new_id():null;
    $sql = "SELECT p.* FROM tasting_program p WHERE id = '".$_REQUEST["id"]."'";
    $r = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
    $smarty->assign('tasting_program', $r);
}
$smarty->display('tasting_program.html');