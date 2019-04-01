<?php
$p=isset($_REQUEST['zid']) ? ' AND Z.SOURCE_KOD = '.$_REQUEST['zid'] : '';

$source_kod = array(181174764,
    180709914,
    180910554,
    180640327,
    180776907,
    180488876,
    181037399,
    181245372,
    181037711,
    180640592,
    180640507,
    181174676,
    180910906,
    181245503,
    180911499,
    180911133);
$in = " AND z.source_kod IN (".implode(',',$source_kod).")";
$in = "";
$params = array(
    ':zid'=>$p,
    ':in_array'=> $in
);
$sql = "SELECT  
        z.file_type,

        CASE 
            WHEN z.file_type = 'last_year'
            THEN (SELECT '/files/bud_ru_zay_files/' || z.source_kod || '/102209275/report/'||zf.val_file FROM bud_ru_zay_ff zf WHERE zf.z_id = z.source_kod AND zf.FF_ID = 102209275)

            WHEN z.file_type = 'location'
            THEN (SELECT '/files/bud_ru_zay_files/' || z.source_kod || '/100829427/report/'||zf.val_file FROM bud_ru_zay_ff zf WHERE zf.z_id = z.source_kod AND zf.FF_ID = 100829427)
            
            WHEN z.file_type = 'spec'
            THEN (SELECT '/files/bud_ru_zay_files/' || z.source_kod || '/100829429/report/'||zf.val_file FROM bud_ru_zay_ff zf WHERE zf.z_id = z.source_kod AND zf.FF_ID = 100829429)
            
            WHEN z.file_type = 'planogram'
            THEN (SELECT '/files/bud_ru_zay_files/' || z.source_kod || '/100829430/report/'||zf.val_file FROM bud_ru_zay_ff zf WHERE zf.z_id = z.source_kod AND zf.FF_ID = 100829430)
            
            WHEN z.file_type = 'comm_agree'
            THEN (SELECT '/files/bud_ru_zay_files/' || z.source_kod || '/100850052/report/'||zf.val_file FROM bud_ru_zay_ff zf WHERE zf.z_id = z.source_kod AND zf.FF_ID = 100850052)
            
            WHEN z.file_type = 'syst_dc'
            THEN (SELECT '/files/bud_ru_zay_files/' || z.source_kod || '/103466356/report/'||zf.val_file FROM bud_ru_zay_ff zf WHERE zf.z_id = z.source_kod AND zf.FF_ID = 103466356)
            
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
          WHEN (SELECT zf.val_file FROM bud_ru_zay_ff zf WHERE zf.z_id = z.id AND zf.FF_ID = 102209275 AND zf.val_file IS NOT NULL) IS NOT NULL AND ff.ff_id = 102209275
          THEN 'last_year'

          WHEN (SELECT zf.val_file FROM bud_ru_zay_ff zf WHERE zf.z_id = z.id AND zf.FF_ID = 100829427 AND zf.val_file IS NOT NULL) IS NOT NULL AND ff.ff_id = 100829427
          THEN 'location'
          
          WHEN (SELECT zf.val_file FROM bud_ru_zay_ff zf WHERE zf.z_id = z.id AND zf.FF_ID = 100829429 AND zf.val_file IS NOT NULL) IS NOT NULL AND ff.ff_id = 100829429
          THEN 'spec'
          
          WHEN (SELECT zf.val_file FROM bud_ru_zay_ff zf WHERE zf.z_id = z.id AND zf.FF_ID = 100829430 AND zf.val_file IS NOT NULL) IS NOT NULL AND ff.ff_id = 100829430
          THEN 'planogram'
          
          WHEN (SELECT zf.val_file FROM bud_ru_zay_ff zf WHERE zf.z_id = z.id AND zf.FF_ID = 100850052 AND zf.val_file IS NOT NULL) IS NOT NULL AND ff.ff_id = 100850052
          THEN 'comm_agree'
          
          WHEN (SELECT zf.val_file FROM bud_ru_zay_ff zf WHERE zf.z_id = z.id AND zf.FF_ID = 103466356 AND zf.val_file IS NOT NULL) IS NOT NULL AND ff.ff_id = 103466356
          THEN 'syst_dc'
          ELSE NULL
        END file_type
        

    FROM bud_ru_zay z,
        bud_ru_zay_ff ff,
         bud_fil f
   WHERE     (SELECT NVL (tu, 0)
                FROM bud_ru_st_ras
               WHERE id = z.kat) = 1
         AND z.fil = f.id(+)
         AND z.id = ff.z_id     
        ) z
WHERE z.file_type IS NOT NULL AND z.report_data IS NOT NULL :in_array
  /*AND Z.SOURCE_KOD = 121500341 */
  :zid
";
$sql=stritr($sql,$params);
$data = $db->getAll($sql, null, null, null, MDB2_FETCHMODE_ASSOC);

foreach ($data as $k=>$v)
{
    if($v["url"]!=null){
        $urls=explode("\n",$v["url"]);
        if(count($urls) > 1) {
            $cnt = 0;
            foreach ($urls as $url) {
                if($cnt == 0){
                    $data[$k]['url'] = str_replace ("'","''",$url);
                    $cnt = 1;
                }else{
                    $newRow = $v;
                    $newRow['url'] = substr($data[$k]['url'],0,strripos ($data[$k]['url'],'/')).'/'.str_replace ("'","''",$url);
                    $data[] = $newRow;
                }

            }
        }else{
            $data[$k]['url'] = str_replace ("'","''",$data[$k]['url']);
        }
    }

}
foreach ($data as $k =>$datum) {
    echo "('".$data[$k]['file_type']."','".$data[$k]['url']."',".$data[$k]['source'].",".$data[$k]['source_kod']."),<br>";
}
//echo "<pre style='text-align: left;'>";
//print_r($data);
//echo "</pre>";