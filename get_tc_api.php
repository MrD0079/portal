<?php
/**
 * Created by PhpStorm.
 * User: Taras.Daragan
 * Date: 26.02.2019
 * Time: 9:59
 */


header('Content-Type: application/json; charset=utf-8');

/* coonect to DB AND load PHP functions */
if(!isset($_REQUEST['action'])){
    require_once "function.php";
    require_once "local_functions.php";
    require_once 'MDB2.php';
    define('ZAOAPI','(DESCRIPTION =    (ADDRESS_LIST =      (ADDRESS = (PROTOCOL = TCP)(PORT = 1521)(HOST = 10.3.11.253))    )    (CONNECT_DATA =      (SERVICE_NAME = ZAOAVK)      (SERVER = DEDICATED)    )  )');
    $dsn = 'oci8://PERSIK_RO:cheiPei2@'.ZAOAPI;

    $db = MDB2::connect($dsn);
    //  var_dump($db);
    if (PEAR::isError($db))
    {
        set_log(0,'Error [db]: '.$db->getMessage(). ' Info: '.$db->getDebugInfo());
    }
    $db->loadModule('Extended');
    $db->loadModule('Function');
}
$sync_status = 0;
$sync_message = "Error: ";
$p=array(':zid' => isset($_REQUEST['zid']) ? 'AND Z.SOURCE_KOD = '.$_REQUEST['zid'] : '');
$date_sync = "";
$syncURL = "t-dm.avk.ua"."/sync_from_portal_tc";

/* Get sync_date param*/

//Table_Update('TCSYNCINFO',null,null);
$sql = "select * from PERSIK_RO.TCSYNCINFO ORDER BY LU DESC";
$date_s = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

if(!isset($date_s) || count($date_s) == 0){
    /* set first sync date*/
    //set_log(0,'Error: Not load last date_sync param');
    $keys = array(
       // "date_sync"=>OraDate2MDBDate('27/02/2019'),
        "date_sync"=>OraDate2MDBDate('01/01/2015'),
        'lu'=>OraDate2MDBDate(date('d.m.Y h:i:s', time())),
        'id'=>1
    );
    $affectedRows = $db->extended->autoExecute('tcsyncinfo', $keys, MDB2_AUTOQUERY_INSERT);
    if(isset($affectedRows))
    {
        if (PEAR::isError($affectedRows)) {
            $sync_message  = 'New sync_date not insert. '.$affectedRows->getMessage(). ' Info: '.$affectedRows->getDebugInfo();
            set_log(0,$sync_message);
        }else{
            $date_s = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
            $date_sync = $date_s[0]['date_sync'];
        }
    }else{
        set_log(0,'Error: Not insert last date_sync param');
    }

}else{
    try {
        $date_sync = $date_s[0]['date_sync'];
    }catch (\Exception $e){
        set_log(0,'Error: '.$e->getMessage(). " [".$e->getTraceAsString()."]");
    }
}

#region Get TC
/* get Head TC */
$sql = "SELECT * FROM  PERSIK_RO.".'"'."TCHead".'"'."  WHERE trunc(rep_lu) >= trunc(to_date('".$date_sync."','yyyy-mm-dd hh24:mi:ss'))";
try {

    $data_head = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
    if (PEAR::isError($data_head)) {
        set_log(0,'Error: '.$data_head->getMessage(). " [".$data_head->getTraceAsString()."]");
    }
}catch (Exception $e){
    set_log(0,'Error: '.$e->getMessage(). " [".$e->getTraceAsString()."]");
}

if(count($data_head) == 0){
    set_log(0,'Empty of selected TC begin with date ['.$date_sync.']');
}
$source_key = array();
try {
    foreach ($data_head as $key => $item) {
        $source_key[] = $item['source_key'];
    }
}catch (\Exception $e){
    set_log(0,'Error: '.$e->getMessage());
}

/* get Detail TC */
$sql = 'SELECT * FROM PERSIK_RO."TCDetailed" WHERE source_key IN ('.implode(",",$source_key).')';
$data_detail= $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

/* get files attach */
$sql = " SELECT
        z.file_type as FILE_TYPE,
        CASE
            WHEN z.file_type = 'last_year'
            THEN (SELECT '/files/bud_ru_zay_files/' || z.source_kod || '/102209275/report/'||zf.val_file FROM PERSIK.bud_ru_zay_ff zf WHERE zf.z_id = z.source_kod AND zf.FF_ID = 102209275)

            WHEN z.file_type = 'location'
            THEN (SELECT '/files/bud_ru_zay_files/' || z.source_kod || '/100829427/report/'||zf.val_file FROM PERSIK.bud_ru_zay_ff zf WHERE zf.z_id = z.source_kod AND zf.FF_ID = 100829427)
            
            WHEN z.file_type = 'spec'
            THEN (SELECT '/files/bud_ru_zay_files/' || z.source_kod || '/100829429/report/'||zf.val_file FROM PERSIK.bud_ru_zay_ff zf WHERE zf.z_id = z.source_kod AND zf.FF_ID = 100829429)
            
            WHEN z.file_type = 'planogram'
            THEN (SELECT '/files/bud_ru_zay_files/' || z.source_kod || '/100829430/report/'||zf.val_file FROM PERSIK.bud_ru_zay_ff zf WHERE zf.z_id = z.source_kod AND zf.FF_ID = 100829430)
            
            WHEN z.file_type = 'comm_agree'
            THEN (SELECT '/files/bud_ru_zay_files/' || z.source_kod || '/100850052/report/'||zf.val_file FROM PERSIK.bud_ru_zay_ff zf WHERE zf.z_id = z.source_kod AND zf.FF_ID = 100850052)
            
            WHEN z.file_type = 'syst_dc'
            THEN (SELECT '/files/bud_ru_zay_files/' || z.source_kod || '/103466356/report/'||zf.val_file FROM PERSIK.bud_ru_zay_ff zf WHERE zf.z_id = z.source_kod AND zf.FF_ID = 103466356)

            ELSE NULL
          END url,

        z.source as SOURCE,
        z.source_kod as SOURCE_KEY
    FROM (SELECT
         ff.*,
         1 source,
         z.id source_kod,
         null created_by,
         null updated_by,
        TO_CHAR (z.report_data, 'dd.mm.yyyy') report_data,
        CASE
          WHEN (SELECT zf.val_file FROM PERSIK.bud_ru_zay_ff zf WHERE zf.z_id = z.id AND zf.FF_ID = 102209275 AND zf.val_file IS NOT NULL) IS NOT NULL AND ff.ff_id = 102209275
          THEN 'last_year'

          WHEN (SELECT zf.val_file FROM PERSIK.bud_ru_zay_ff zf WHERE zf.z_id = z.id AND zf.FF_ID = 100829427 AND zf.val_file IS NOT NULL) IS NOT NULL AND ff.ff_id = 100829427
          THEN 'location'

          WHEN (SELECT zf.val_file FROM PERSIK.bud_ru_zay_ff zf WHERE zf.z_id = z.id AND zf.FF_ID = 100829429 AND zf.val_file IS NOT NULL) IS NOT NULL AND ff.ff_id = 100829429
          THEN 'spec'

          WHEN (SELECT zf.val_file FROM PERSIK.bud_ru_zay_ff zf WHERE zf.z_id = z.id AND zf.FF_ID = 100829430 AND zf.val_file IS NOT NULL) IS NOT NULL AND ff.ff_id = 100829430
          THEN 'planogram'

          WHEN (SELECT zf.val_file FROM PERSIK.bud_ru_zay_ff zf WHERE zf.z_id = z.id AND zf.FF_ID = 100850052 AND zf.val_file IS NOT NULL) IS NOT NULL AND ff.ff_id = 100850052
          THEN 'comm_agree'

          WHEN (SELECT zf.val_file FROM PERSIK.bud_ru_zay_ff zf WHERE zf.z_id = z.id AND zf.FF_ID = 103466356 AND zf.val_file IS NOT NULL) IS NOT NULL AND ff.ff_id = 103466356
          THEN 'syst_dc'
          ELSE NULL
        END file_type

    FROM PERSIK.bud_ru_zay z,
        PERSIK.bud_ru_zay_ff ff,
         PERSIK.bud_fil f
   WHERE     (SELECT NVL (tu, 0)
                FROM PERSIK.bud_ru_st_ras
               WHERE id = z.kat) = 1
         AND z.fil = f.id(+)
         AND z.id = ff.z_id
        ) z
WHERE z.file_type IS NOT NULL AND z.report_data IS NOT NULL AND z.source_kod IN (".implode(',',$source_key).")
  /*AND Z.SOURCE_KOD = 121500341 */
  :zid
";
$sql=stritr($sql,$p);
$sql = trim(preg_replace('/\s+/', ' ', $sql));
$data_files_attach = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);



foreach ($data_files_attach as $k=>$v)
{
    if($v["url"]!=null){
        $urls=explode("\n",$v["url"]);
        if(count($urls) > 1) {
            $cnt = 0;
            foreach ($urls as $url) {
                if($cnt == 0){
                    $data_files_attach[$k]['url'] = str_replace ("'","''",$url);
                    $cnt = 1;
                }else{
                    $newRow = $v;
                    $newRow['url'] = substr($data_files_attach[$k]['url'],0,strripos ($data_files_attach[$k]['url'],'/')).'/'.str_replace ("'","''",$url);
                    $data_files_attach[] = $newRow;
                }

            }
        }else{
            $data_files_attach[$k]['url'] = str_replace ("'","''",$data_files_attach[$k]['url']);
        }
    }

}
#endregion

/* data collection */
$data = array();
$data['TCHEAD'] = array_change_key_case($data_head,CASE_UPPER);
$data['TCDETAIL'] = array_change_key_case($data_detail,CASE_UPPER);
$data['TCFILE_ATTACH'] = array_change_key_case($data_files_attach,CASE_UPPER);
$data = utf8ize($data);
$send_data_tmp = array();//todo: DELETE

#region SYNCHRONIZATION
$all_ok = true;
foreach ($data as $table => $records) {
    $sends_count = 2;
    $response_data = get_response($table,$records);
    if($response_data){
        $current_status = false;
        $send_data_tmp[] = $response_data; //todo: DELETE
        do{
            $send_data_responce = send_data($response_data,$syncURL);
            $send_status = $send_data_responce['STATUS'] ? $send_data_responce['STATUS'] : 0;
            if($send_status){
                $current_status = true;
                break;
            }
            $sends_count--;
            // задержка на повторную отправку данных в сек
            sleep(5);

        }while($sends_count > 0);
        if(!$current_status){
            $all_ok = false;
            if($send_data_responce['Message'])
                $sync_message .= "DM answer: ".$send_data_responce['Message'];
            else
                $sync_message .= "Not all data synchronized. It was be breaking. Last sync_date is [".$date_sync."]";
            break;
        }
    }
}
#endregion
//$all_ok = false;
/* WHEN is OK THEN: update sync_date AND write info in LOG*/
if($all_ok){
//    $new_sync_date = strtotime($date_sync.' +1 day');
//    $new_sync_date = date("d/m/Y h:m:s", $new_sync_date);
    $keys = array(
        //"date_sync"=>OraDate2MDBDate($new_sync_date),
        "date_sync"=>OraDate2MDBDate(date('d.m.Y h:i:s', time())),
        'lu'=>OraDate2MDBDate(date('d.m.Y h:i:s', time()))
    );
    $affectedRows = $db->extended->autoExecute('tcsyncinfo', $keys, MDB2_AUTOQUERY_UPDATE, "id = 1");
    if(isset($affectedRows))
    {
        if (PEAR::isError($affectedRows)) {
            $sync_message = 'New sync_date not updated. '.$affectedRows->getMessage(). ' Info: '.$affectedRows->getDebugInfo();
        }else{
            /* send message that is all OK */
            $sync_status = 1;
            $sync_message = 'All data is synchronized. New syc_date ['.$keys['date_sync'].']';
        }
    }else{
        $sync_status = 2;
        $sync_message = 'Some error to update last date_sync param. Last sync_date - ['.$date_sync.']';
    }
}

header('Content-Type: application/json; charset=utf-8'); //todo: DELETE
echo json_encode(array('status'=>$sync_status,'message'=>$sync_message)); //todo: DELETE

set_log($sync_status,$sync_message);




function set_log($sync_status=-1,$sync_message=""){
    global $db;
    $data_log = array(
        'STATUS' =>$sync_status,
        'Message' => $sync_message,
        'LU' => OraDate2MDBDateFull(date('d.m.Y H:i:s', time()))
    );
    $answ = $db->extended->autoExecute('tcsyncinfolog', $data_log, MDB2_AUTOQUERY_INSERT);
    if(isset($answ)){
        if (PEAR::isError($answ)) {
            echo $answ->getMessage().' Info: '.$answ->getDebugInfo();
        }
    }
    die();
}

function get_response($table = "",$reqords = array()){
    if($table == "" || count($reqords) == 0){
        return false;
    }
    $request = array();
    //$request['ANDROID_VERSION'] = '4.4.2';
    $request['VERSION_APP'] = '1';
    //$request['IMEI'] = '1111111111111';
    //$request['DEVICE_MODEL'] = 'SM-T211';
    //$request['DEVICE_NUMBER'] = 'RF1DA04GPXB';
    $request['DATA'] = '';
    $request['TOKEN'] = 'asjdh87asOQWPnlqlrylSf87Asls3i9cALFNrown3ka';

    $data = array();
    $data['DB_VERSION'] = '1';
    //$data['SYNC_SESSION'] = '6f37d839-d0c8-4154-ab2f-999999999999';
    $data['TABLE'] = $table;
    $data['RECORDS'] = $reqords;
    $request['DATA'] = json_encode($data);

    return $request;
}

function send_data($request = "",$url = ""){
    if($url == "" || $request == ""){
        return 0;
    }

     $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, $url);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
    curl_setopt($ch, CURLOPT_HEADER, 0);
    curl_setopt($ch, CURLOPT_CUSTOMREQUEST, 'POST');
    curl_setopt($ch, CURLOPT_POSTFIELDS, $request);
    curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, 0);
    curl_setopt($ch, CURLOPT_TIMEOUT, 0);
    //curl_setopt($ch, CURLOPT_SSLVERSION, 6);
    //curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
    //curl_setopt($ch, CURLOPT_CAINFO, $this->get('kernel')->getRootDir() . '/avk-ua.pem');
    //curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, 0);

    $response = curl_exec($ch);

    /* write response parser */
    $response_obj = json_decode($response);
    $response_array['STATUS'] = $response_obj->STATUS;
    $response_array['Message'] = $response_obj->Message;
    //$status = $response_array['STATUS'];

    return $response_array;
}

function utf8ize($mixed) {
    if (is_array($mixed)) {
        foreach ($mixed as $key => $value) {
            $mixed[$key] = utf8ize($value);
        }
    } elseif (is_string($mixed)) {
        return mb_convert_encoding($mixed, "UTF-8", "Windows-1251");
    }
    return $mixed;
}

function OraDate2MDBDateFull($v,$format='%Y-%m-%d %H:%M:%S')
{
    if (mb_strlen($v)==0)
    {return("");}
    $sep='/';
    if (count(explode('/', $v))==1)
    {
        $sep='.';
    }
    list($d, $m, $y) = explode($sep, $v);
    $time = explode(" ",$v);
    list($h, $mi, $s) = explode(":", $time[1]);
    $mk=mktime($h, $mi, $s, $m, $d, $y);
    return(strftime($format,$mk));
}