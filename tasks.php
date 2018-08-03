<?

if (isset($_REQUEST['del_files']))
{
	foreach ($_REQUEST['del_files'] as $k => $v)
	{
		$fn=$db->getOne("select fn from tasks_files where id=".$k);
		unlink("files/".$fn);
		$keys = array('id'=>$k);
		Table_Update('tasks_files', $keys,null);
	}
}
if (isset($_REQUEST['del']))
{
	$keys = array('id'=>$_REQUEST['id']);
	$db->query("begin send_it_task(".$_REQUEST['id'].",'del'); end;");
	Table_Update('tasks', $keys,null);
	$_REQUEST["id"] = null;
}
if (isset($_REQUEST['add']))
{
	$new_id = get_new_id();
	$_REQUEST["id"] = $new_id;
}
if (isset($_REQUEST['save'])||isset($_REQUEST['add']))
{
	$keys = array('id'=>$_REQUEST['id']);
	isset($_REQUEST["task"]["dt_start"]) ? $_REQUEST["task"]["dt_start"]=OraDate2MDBDate($_REQUEST["task"]["dt_start"]) : null;
	isset($_REQUEST["task"]["dt_end"]) ? $_REQUEST["task"]["dt_end"]=OraDate2MDBDate($_REQUEST["task"]["dt_end"]) : null;
	$_REQUEST["task"]["text"] = addslashes($_REQUEST["task"]["text"]);
	$_REQUEST["task"]["lu_tn"] = $tn;
	$vals=[];
	foreach ($_REQUEST["task"] as $k => $v)
	{
		$vals[$k] = $v;
	}
	Table_Update('tasks', $keys,$vals);
	if (isset($_FILES["files"]))
	{
		foreach ($_FILES["files"]["tmp_name"] as $k=>$v)
		{
			if (is_uploaded_file($v))
			{
				$fn="tasks".get_new_file_id()."_".translit($_FILES["files"]["name"][$k]);
				move_uploaded_file($v, "files/".$fn);
				$keys = array("task_id"=>$_REQUEST['id'],"fn"=>$fn);
				Table_Update ("tasks_files", $keys, $keys);
			}
		}
	}
	isset($_REQUEST["add"]) ? $trg = "ins" : $trg = "upd";
	$db->query("begin send_it_task(".$_REQUEST['id'].",'".$trg."'); end;");
}

if (!isset($_REQUEST['id']))
{
$_REQUEST['id']=0;
}

$p=array(':id' => $_REQUEST["id"]);

$sql = rtrim(file_get_contents('sql/tasks.sql'));
$sqlf = rtrim(file_get_contents('sql/task_files.sql'));
$r = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
foreach($r as $k=>$v){
	$r[$k]['files'] = $db->getAll(stritr($sqlf,array(':id' => $v["id"])), null, null, null, MDB2_FETCHMODE_ASSOC);
}
$smarty->assign('tasks', $r);

if ($_REQUEST['id']>0)
{
$sql = rtrim(file_get_contents('sql/task.sql'));
$sql=stritr($sql,$p);
$smarty->assign('task', $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC));
$sql = rtrim(file_get_contents('sql/task_files.sql'));
$sql=stritr($sql,$p);
$smarty->assign('task_files', $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC));
}

$smarty->display('tasks.html');
