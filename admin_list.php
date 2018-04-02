<?php
if (isset($_REQUEST["save"])){
    $table=$_REQUEST["table"];
    $key_field=$_REQUEST["key_field"];
    $val_field=$_REQUEST["val_field"];
    $key=$_REQUEST["key"];
    $val=$_REQUEST["val"];
    //ses_req();
    Table_Update($table,array($key_field=>$key),array($val_field=>$val));
} else {
    InitRequestVar('all',1);
    audit("вошел в список админов");
    if (isset($_REQUEST["ds"]))
    {
            foreach ($_REQUEST["ds"] as $k => $v)
            {
                    $table=$k;
                    foreach ($v as $k1 => $v1)
                    {
                            $key_field=$k1;
                            foreach ($v1 as $k2 => $v2)
                            {
                                    $val_field=$k2;
                                    foreach ($v2 as $k3 => $v3)
                                    {
                                            if ($v3!=null)
                                            {
                                                    $key=$k3;
                                                    $val=$v3;
                                                    Table_Update($table,array($key_field=>$key),array($val_field=>$val));
                                                    //echo "Table_Update($table,array($key_field=>$key),array($val_field=>$val))<br>";
                                                    //$db->query("begin pr_full_update (".$key.", 1); end;");
                                            }
                                    }
                            }
                    }
            }
    }
    $sql = rtrim(file_get_contents('sql/admin_list.sql'));
    $p = array(':dpt_id' => $_SESSION["dpt_id"],':flt'=>$_REQUEST["all"]);
    $sql=stritr($sql,$p);
    $data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
    $smarty->assign('admin_list', $data);
    $smarty->display('admin_list.html');
}
?>