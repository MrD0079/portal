<?

echo nl2br($db->getOne("select q from distr_prot_cat where id=".$_REQUEST["id"]));

?>