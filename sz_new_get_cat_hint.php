<?

echo nl2br($db->getOne("select hint from sz_cat where id=".$_REQUEST["id"]));

?>