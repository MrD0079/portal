<?php
/**
 * Created by PhpStorm.
 * User: Taras.Daragan
 * Date: 26.02.2019
 * Time: 9:59
 */

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
        echo json_encode(var_dump($db));
        die();
    }
    $db->loadModule('Extended');
    $db->loadModule('Function');
}

$p=array(':zid' => isset($_REQUEST['zid']) ? 'AND Z.SOURCE_KOD = '.$_REQUEST['zid'] : '');



/* get Head TC */
$sql = 'SELECT * FROM PERSIK_RO."TCHead"';
$data_head = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);


/* get Detail TC */
$sql = 'SELECT * FROM PERSIK_RO."TCDetailed"';
$data_detail= $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);


/* get files attach */
$sql = " SELECT
        z.file_type,
        CASE
            WHEN z.file_type = 'last_year'
            THEN (SELECT '/files/bud_ru_zay_files/' || z.id || '/102209275/report/'||zf.val_file FROM PERSIK.bud_ru_zay_ff zf WHERE zf.z_id = z.source_kod AND zf.FF_ID = 102209275)

            WHEN z.file_type = 'location'
            THEN (SELECT '/files/bud_ru_zay_files/' || z.id || '/100829427/report/'||zf.val_file FROM PERSIK.bud_ru_zay_ff zf WHERE zf.z_id = z.source_kod AND zf.FF_ID = 100829427)

            WHEN z.file_type = 'spec'
            THEN (SELECT '/files/bud_ru_zay_files/' || z.id || '/100829429/report/'||zf.val_file FROM PERSIK.bud_ru_zay_ff zf WHERE zf.z_id = z.source_kod AND zf.FF_ID = 100829429)

            WHEN z.file_type = 'planogram'
            THEN (SELECT '/files/bud_ru_zay_files/' || z.id || '/100829430/report/'||zf.val_file FROM PERSIK.bud_ru_zay_ff zf WHERE zf.z_id = z.source_kod AND zf.FF_ID = 100829430)

            WHEN z.file_type = 'comm_agree'
            THEN (SELECT '/files/bud_ru_zay_files/' || z.id || '/100850052/report/'||zf.val_file FROM PERSIK.bud_ru_zay_ff zf WHERE zf.z_id = z.source_kod AND zf.FF_ID = 100850052)

            WHEN z.file_type = 'syst_dc'
            THEN (SELECT '/files/bud_ru_zay_files/' || z.id || '/103466356/report/'||zf.val_file FROM PERSIK.bud_ru_zay_ff zf WHERE zf.z_id = z.source_kod AND zf.FF_ID = 103466356)

            ELSE NULL
          END url,

        z.source,
        z.source_kod
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
WHERE z.file_type IS NOT NULL AND z.report_data IS NOT NULL
  /*AND Z.SOURCE_KOD = 121500341 */
  :zid
";
//if(isset($_REQUEST['action'])) {
//    $sql = " SELECT
//        z.file_type,
//        CASE
//            WHEN z.file_type = 'last_year'
//            THEN (SELECT '/files/bud_ru_zay_files/' || z.id || '/102209275/report/'||zf.val_file FROM bud_ru_zay_ff zf WHERE zf.z_id = z.source_kod AND zf.FF_ID = 102209275)
//
//            WHEN z.file_type = 'location'
//            THEN (SELECT '/files/bud_ru_zay_files/' || z.id || '/100829427/report/'||zf.val_file FROM bud_ru_zay_ff zf WHERE zf.z_id = z.source_kod AND zf.FF_ID = 100829427)
//
//            WHEN z.file_type = 'spec'
//            THEN (SELECT '/files/bud_ru_zay_files/' || z.id || '/100829429/report/'||zf.val_file FROM bud_ru_zay_ff zf WHERE zf.z_id = z.source_kod AND zf.FF_ID = 100829429)
//
//            WHEN z.file_type = 'planogram'
//            THEN (SELECT '/files/bud_ru_zay_files/' || z.id || '/100829430/report/'||zf.val_file FROM bud_ru_zay_ff zf WHERE zf.z_id = z.source_kod AND zf.FF_ID = 100829430)
//
//            WHEN z.file_type = 'comm_agree'
//            THEN (SELECT '/files/bud_ru_zay_files/' || z.id || '/100850052/report/'||zf.val_file FROM bud_ru_zay_ff zf WHERE zf.z_id = z.source_kod AND zf.FF_ID = 100850052)
//
//            WHEN z.file_type = 'syst_dc'
//            THEN (SELECT '/files/bud_ru_zay_files/' || z.id || '/103466356/report/'||zf.val_file FROM bud_ru_zay_ff zf WHERE zf.z_id = z.source_kod AND zf.FF_ID = 103466356)
//
//            ELSE NULL
//          END url,
//
//        z.source,
//        z.source_kod
//    FROM (SELECT
//         ff.*,
//         1 source,
//         z.id source_kod,
//         null created_by,
//         null updated_by,
//        TO_CHAR (z.report_data, 'dd.mm.yyyy') report_data,
//        CASE
//          WHEN (SELECT zf.val_file FROM bud_ru_zay_ff zf WHERE zf.z_id = z.id AND zf.FF_ID = 102209275 AND zf.val_file IS NOT NULL) IS NOT NULL AND ff.ff_id = 102209275
//          THEN 'last_year'
//
//          WHEN (SELECT zf.val_file FROM bud_ru_zay_ff zf WHERE zf.z_id = z.id AND zf.FF_ID = 100829427 AND zf.val_file IS NOT NULL) IS NOT NULL AND ff.ff_id = 100829427
//          THEN 'location'
//
//          WHEN (SELECT zf.val_file FROM bud_ru_zay_ff zf WHERE zf.z_id = z.id AND zf.FF_ID = 100829429 AND zf.val_file IS NOT NULL) IS NOT NULL AND ff.ff_id = 100829429
//          THEN 'spec'
//
//          WHEN (SELECT zf.val_file FROM bud_ru_zay_ff zf WHERE zf.z_id = z.id AND zf.FF_ID = 100829430 AND zf.val_file IS NOT NULL) IS NOT NULL AND ff.ff_id = 100829430
//          THEN 'planogram'
//
//          WHEN (SELECT zf.val_file FROM bud_ru_zay_ff zf WHERE zf.z_id = z.id AND zf.FF_ID = 100850052 AND zf.val_file IS NOT NULL) IS NOT NULL AND ff.ff_id = 100850052
//          THEN 'comm_agree'
//
//          WHEN (SELECT zf.val_file FROM bud_ru_zay_ff zf WHERE zf.z_id = z.id AND zf.FF_ID = 103466356 AND zf.val_file IS NOT NULL) IS NOT NULL AND ff.ff_id = 103466356
//          THEN 'syst_dc'
//          ELSE NULL
//        END file_type
//
//    FROM bud_ru_zay z,
//        bud_ru_zay_ff ff,
//         bud_fil f
//   WHERE     (SELECT NVL (tu, 0)
//                FROM bud_ru_st_ras
//               WHERE id = z.kat) = 1
//         AND z.fil = f.id(+)
//         AND z.id = ff.z_id
//        ) z
//WHERE z.file_type IS NOT NULL AND z.report_data IS NOT NULL
//  /*AND Z.SOURCE_KOD = 121500341 */
//  :zid
//";
//}
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


$data = array();
$data['tchead'] = $data_head;
$data['tcdetail'] = $data_detail;
$data['tcfile_attach'] = $data_files_attach;

$data = utf8ize($data);

header('Content-Type: application/json; charset=utf-8');
echo json_encode($data, JSON_UNESCAPED_UNICODE);
//print_r($data);

//echo "<pre style='text-align: left;'>";
//print_r($data);
//echo "</pre>";
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