<?
$sql="
/* Formatted on 28.01.2014 11:08:33 (QP5 v5.227.12220.39724) */
UPDATE spr_users
   SET password = DBMS_RANDOM.STRING ('A', 4)
 WHERE login = (SELECT login
                  FROM bud_fil
                 WHERE id = ".$_REQUEST['fil'].")
";
$db->query($sql);
$sql="
/* Formatted on 28.01.2014 10:26:07 (QP5 v5.227.12220.39724) */
  SELECT z.id,
         z.name,
         z.sw_kod,
         TO_CHAR (z.lu, 'dd.mm.yyyy hh24:mi:ss') lu,
         TO_CHAR (z.data_end, 'dd.mm.yyyy') data_end,
         z.lu_fio,
         z.nd,
         z.rp,
         z.rf,
         z.contact_lpr,
         z.login,
         s.password
    FROM bud_fil z, spr_users s
   WHERE z.id = ".$_REQUEST['fil']." AND z.login = s.login(+)
ORDER BY z.name
";
$d = $db->getRow($sql, null, null, null, MDB2_FETCHMODE_ASSOC);
echo $d['password'];
?>