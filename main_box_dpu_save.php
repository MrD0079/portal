<?
$_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);
if (isset($_REQUEST["new"]))
{
	echo "Ваше предложение направлено ДП";
	$id=get_new_id();
	$keys = array(
		'id'=>$id,
		'creator'=>$tn,
		'subj'=>$_REQUEST['box_dpu_subj'],
	);
	Table_Update('box_dpu', $keys,$keys);
	$keys = array(
		'box_id'=>$id,
		'tn'=>$tn,
		'text'=>$_REQUEST['box_dpu_text'],
	);
	Table_Update('box_dpu_chat', $keys,$keys);
}
if (isset($_REQUEST["answer"]))
{
	echo "Ваш ответ отправлен";
	$keys = array(
		'box_id'=>$_REQUEST['box_id'],
		'tn'=>$tn,
		'text'=>$_REQUEST['text'],
	);
	Table_Update('box_dpu_chat', $keys,$keys);
}
if (isset($_REQUEST["closed_dp"]))
{
	//print_r($_REQUEST);
	echo "Тема закрыта ДП";
	$keys = array(
		'id'=>$_REQUEST['box_id'],
	);
	$vals = array(
		'closed_dp'=>1,
	);
	Table_Update('box_dpu', $keys,$vals);
}
if (isset($_REQUEST["closed_init"]))
{
	//print_r($_REQUEST);
	echo "Тема закрыта создателем";
	$keys = array(
		'id'=>$_REQUEST['box_id'],
	);
	$vals = array(
		'closed_init'=>1,
	);
	Table_Update('box_dpu', $keys,$vals);
}
?>