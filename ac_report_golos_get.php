<?

$_REQUEST = recursive_iconv ('UTF-8', 'Windows-1251', $_REQUEST);

$sql='
SELECT DECODE (SUM (CASE
                       WHEN res_id IN ( (SELECT id
                                           FROM ac_golos_res
                                          WHERE true_val = 1))
                       THEN
                          0
                       ELSE
                          1
                    END),
               0, 1,
               0)
  FROM ac_golos
 WHERE ac_id='.$_REQUEST['id'].' AND memb_id = '.$_REQUEST['mk'];

$x=$db->getOne($sql);
echo $x;

?>