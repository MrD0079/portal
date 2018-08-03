<?

$_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);

$keys = array(
	'conq'=>$_REQUEST['conq_id'],
	'fil'=>$_REQUEST['fil_id'],
);



$_REQUEST["val"]==1?Table_Update('distr_prot_conq_fil', $keys,$keys):Table_Update('distr_prot_conq_fil', $keys,null);

?>