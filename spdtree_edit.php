<?



//ses_req();


if (isset($_REQUEST["save"]))
{
    $vals = $_REQUEST["item"];
    $vals["birthday"]=init_data($vals["birthday"]);
    $vals["fdata"]=init_data($vals["fdata"]);
    $vals["dataper"]=init_data($vals["dataper"]);
    $vals["datauvol"]=init_data($vals["datauvol"]);
    $vals["datastart"]=init_data($vals["datastart"]);
    $vals["dogovordata"]=init_data($vals["dogovordata"]);
    $vals["svidregdata"]=init_data($vals["svidregdata"]);
    $vals["svidendata"]=init_data($vals["svidendata"]);
    $vals["res_dt"]=init_data($vals["res_dt"]);
    if (isset($_FILES["item"]))
    {
        $d1="files/";
        if (!file_exists($d1)) {mkdir($d1,0777,true);}
        if (is_uploaded_file($_FILES["item"]['tmp_name']["sign"]))
        {
            $fn=get_new_file_id().'_'.translit($_FILES["item"]['name']["sign"]);
            move_uploaded_file($_FILES["item"]['tmp_name']["sign"], $d1.$fn);
            $vals["sign"]=$fn;
            include_once('SimpleImage.php');
            $image = new SimpleImage();
            $image->load($d1.$fn);
            $h=$image->getHeight();
            if ($image->getHeight()>600)
            {
            $image->resizeToHeight(600);
            }
            $image->save($d1.$fn);
        }
    }
    Table_Update ("spdtree", array("id"=>$_REQUEST["id"]), $vals);
    if (isset($_REQUEST["spdtree_edit_countries"]))
    {
        $z = $db->getOne("SELECT svideninn FROM spdtree WHERE id = ".$_REQUEST["id"]);
        foreach ($_REQUEST["spdtree_edit_countries"] as $k=>$v)
        {
            $keys = array("dpt_id"=>$k,"tn"=>$z);
            $v==0? $vals = null : $vals = $keys;
            Table_Update ("dpt_tn", $keys, $vals);
        }
    }
}

$p = array(':id' => $_REQUEST["id"]);


$sql=rtrim(file_get_contents('sql/spdtree_edit.sql'));
$sql=stritr($sql,$p);
$data = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('spdtree_edit', $data);

$sql=rtrim(file_get_contents('sql/spdtree_edit_countries.sql'));
$sql=stritr($sql,$p);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('spdtree_edit_countries', $data);

$sql=rtrim(file_get_contents('sql/pos_list.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('pos_list', $data);

$sql=rtrim(file_get_contents('sql/dpt_list.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('dpt_list', $data);


$sql=rtrim(file_get_contents('sql/rekvdpt_list.sql'));
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('rekvdpt_list', $data);


$sql=rtrim(file_get_contents('sql/banks.sql'));
$banks = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
$smarty->assign('banks', $banks);





//print_r($data);

$smarty->display('spdtree_edit.html');

?>