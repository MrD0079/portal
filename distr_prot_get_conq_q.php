<?

echo nl2br($db->getOne("select q from distr_prot_conq where id=".$_REQUEST["id"]));

?>