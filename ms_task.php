<?
if (isset($_REQUEST["save"])&&isset($_REQUEST["data"])){
    $_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);
    $id=$_REQUEST["id"];
    isset($_REQUEST["data"]["end_date"])?$_REQUEST["data"]["end_date"]=OraDate2MDBDate($_REQUEST["data"]["end_date"]):null;
    Table_Update('ms_task', array("id"=>$id),$_REQUEST["data"]);
    isset($_REQUEST["data"]["status"])?$status=$_REQUEST["data"]["status"]:$status=null;
    Table_Update('ms_task_status_log', array("id"=>get_new_id(),"task_id"=>$id),array("status_id"=>$status,"login"=>$login));
    if (isset($_FILES['tfiles']))
    {
            $_FILES = recursive_iconv ('UTF-8', 'Windows-1251', $_FILES);
            foreach($_FILES['tfiles']['tmp_name'] as $k=>$v){
                if (is_uploaded_file($_FILES['tfiles']['tmp_name'][$k]))
                {
                        $a=pathinfo($_FILES['tfiles']['name'][$k]);
                        $fn=get_new_file_id().'_'.translit($_FILES['tfiles']['name'][$k]);
                        $files = $db->getOne("select tfiles from ms_task where id=".$id);
                        $files = preg_split('/\r\n|\r|\n/', $files);
                        $files[]=$fn;
                        $vals = array("tfiles"=>join("\n",$files));
                        Table_Update('ms_task', array("id"=>$id),$vals);
                        move_uploaded_file($_FILES['tfiles']['tmp_name'][$k], 'files/'.$fn);
                }
            }
    }
    if (isset($_REQUEST["del_tfiles"])) {
        foreach(explode(",", $_REQUEST["del_tfiles"]) as $v) {
            echo $v."\n";
            $files = $db->getOne("select tfiles from ms_task where id=".$id);
            $files = preg_split('/\r\n|\r|\n/', $files);
            if(($key = array_search($v, $files)) !== false) {unset($files[$key]);}
            $vals = array("tfiles"=>join("\n",$files));
            Table_Update('ms_task', array("id"=>$id),$vals);
        }
    }
    if (isset($_FILES['rfiles']))
    {
            $_FILES = recursive_iconv ('UTF-8', 'Windows-1251', $_FILES);
            foreach($_FILES['rfiles']['tmp_name'] as $k=>$v){
                if (is_uploaded_file($_FILES['rfiles']['tmp_name'][$k]))
                {
                        $a=pathinfo($_FILES['rfiles']['name'][$k]);
                        $fn=get_new_file_id().'_'.translit($_FILES['rfiles']['name'][$k]);
                        $files = $db->getOne("select rfiles from ms_task where id=".$id);
                        $files = preg_split('/\r\n|\r|\n/', $files);
                        $files[]=$fn;
                        $vals = array("rfiles"=>join("\n",$files));
                        Table_Update('ms_task', array("id"=>$id),$vals);
                        move_uploaded_file($_FILES['rfiles']['tmp_name'][$k], 'files/'.$fn);
                }
            }
    }
    if (isset($_REQUEST["del_rfiles"])) {
        foreach(explode(",", $_REQUEST["del_rfiles"]) as $v) {
            echo $v."\n";
            $files = $db->getOne("select rfiles from ms_task where id=".$id);
            $files = preg_split('/\r\n|\r|\n/', $files);
            if(($key = array_search($v, $files)) !== false) {unset($files[$key]);}
            $vals = array("rfiles"=>join("\n",$files));
            Table_Update('ms_task', array("id"=>$id),$vals);
        }
    }
} else if (isset($_REQUEST["edit"])){
    $sql = "
  SELECT m.id,
         a.name ag_name,
         NVL (us.fio, 'не определен') svms,
         TO_CHAR (m.created, 'dd.mm.yyyy') created,
         TO_CHAR (m.visit_date, 'dd.mm.yyyy') visit_date,
         m.photo_id,
         cpp.ur_tz_name || ' ' || cpp.tz_address address,
         m.rep_w_photo,
         m.subject,
         m.descr,
         TO_CHAR (m.end_date, 'dd.mm.yyyy') end_date,
         t.name TYPE,
         m.status status,
         s.name status_name,
         s.kod status_kod,
         m.end_date - TRUNC (SYSDATE) - 1 days_remain,
         m.photo_id,
         '/merch_spec_report_files/'
         || TO_CHAR (m.visit_date, 'dd.mm.yyyy')
         || '/'
         || m.ag_id
         || '/'
         || m.kod_tp
         || '/'
         || f.fn
         photo
    FROM ms_task m,
         routes_agents a,
         cpp,
         user_list us,
         ms_task_type t,
         ms_task_status s,
         merch_spec_report_files f
   WHERE     m.ag_id = a.id
         AND m.kod_tp = cpp.kodtp(+)
         AND m.svms_tn = us.tn(+)
         AND m.ttype = t.id(+)
         AND m.status = s.id(+)
         AND m.id = ".$_REQUEST["id"]."
              AND m.photo_id = f.id(+)
ORDER BY ag_name,
         svms,
         m.created,
         address
         ";
    $r = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
    $smarty->assign('x', $r);
    $smarty->assign('statuses', $db->getOne("SELECT 'var statuses = {'||wm_concat (id || ':\"' || kod || '\"')||'};' FROM ms_task_status"));
} else if (isset($_REQUEST["addMsg"])){
    $_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);
    Table_Update('ms_task_chat', array("id"=>get_new_id(),"task_id"=>$_REQUEST["task_id"]),array("text"=>$_REQUEST["msg"],"login"=>$login));
} else if (isset($_REQUEST["getFiles"])){
    $sql = "SELECT m.tfiles, m.rfiles FROM ms_task m WHERE m.id = ".$_REQUEST["task_id"];
    $r = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
    $smarty->assign('x', $r);
} else if (isset($_REQUEST["getChat"])){
    $smarty->assign('x', $db->getAll("
SELECT c.id,
       TO_CHAR (c.lu, 'dd.mm.yyyy hh24:mi:ss') lu,
       u.fio,
       CASE WHEN u.login LIKE 'ag%' THEN 1 ELSE 0 END is_ms,
       text
  FROM ms_task_chat c, user_list u
 WHERE c.login = u.login AND task_id = ".$_REQUEST["task_id"]."
UNION
SELECT l.id,
       TO_CHAR (l.lu, 'dd.mm.yyyy hh24:mi:ss') lu,
       u.fio,
       CASE WHEN u.login LIKE 'ag%' THEN 1 ELSE 0 END is_ms,
       'статус задачи изменен на: ' || s.name
  FROM ms_task_status_log l, user_list u, ms_task_status s
 WHERE l.login = u.login AND task_id = ".$_REQUEST["task_id"]." AND l.status_id = s.id(+)
ORDER BY id
", null, null, null, MDB2_FETCHMODE_ASSOC));
} else if (isset($_REQUEST["getSVMSs"])){
    $sql = rtrim(file_get_contents('sql/svms_list.sql'));
    $p = array(":tn"=>$tn,':dpt_id'=>$_SESSION['dpt_id']);
    $sql=stritr($sql,$p);
    $smarty->assign('x', $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC));
} else if (isset($_REQUEST["getAgents"])){
    $smarty->assign('x', $db->getAll("select id, name from routes_agents order by name", null, null, null, MDB2_FETCHMODE_ASSOC));
} else if (isset($_REQUEST["getStatuses"])){
    $smarty->assign('x', $db->getAll("select id,name,available_to_svms from ms_task_status /*where available_to_svms=1*/ order by sort, name", null, null, null, MDB2_FETCHMODE_ASSOC));
} else if (isset($_REQUEST["ms_tasks_list"])){
    $sql = "
  SELECT m.id,
         a.name ag_name,
         NVL (us.fio, 'не определен') svms,
         TO_CHAR (m.created, 'dd.mm.yyyy') created,
         cpp.ur_tz_name || ' ' || cpp.tz_address address,
         m.rep_w_photo,
         m.subject,
         TO_CHAR (m.end_date, 'dd.mm.yyyy') end_date,
         t.name TYPE,
         s.name status,
         m.end_date - TRUNC (SYSDATE) - 1 days_remain,
         (SELECT fio FROM user_list WHERE login = m.creator) producer,
         get_ms_task_source (m.id) source
    FROM ms_task m,
         routes_agents a,
         cpp,
         user_list us,
         ms_task_type t,
         ms_task_status s
   WHERE     m.ag_id = a.id
         AND m.kod_tp = cpp.kodtp(+)
         AND m.svms_tn = us.tn(+)
         AND m.ttype = t.id(+)
         AND m.status = s.id(+)
         and trunc(m.created) between to_date('".$_REQUEST["sd"]."','dd.mm.yyyy') and to_date('".$_REQUEST["ed"]."','dd.mm.yyyy')
         and (m.ag_id = '".$_REQUEST["agent"]."' or length('".$_REQUEST["agent"]."') is null)
         and (m.svms_tn = '".$_REQUEST["svms"]."' or length('".$_REQUEST["svms"]."') is null)
         and (m.status = '".$_REQUEST["status"]."' or length('".$_REQUEST["status"]."') is null)
         and (m.svms_tn in (SELECT slave
                             FROM full
                            WHERE master=".$tn.")
                OR (SELECT NVL (is_ma, 0)
                    FROM user_list
                   WHERE tn = ".$tn.") = 1
                OR (SELECT NVL (is_admin, 0)
                    FROM user_list
                   WHERE tn = ".$tn.") = 1
                       )
ORDER BY ag_name,
         svms,
         m.created,
         address
         ";
    $r = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
    $smarty->assign('x', $r);
}
$smarty->display('ms_task.html');