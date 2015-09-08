/* Formatted on 21.11.2013 10:57:53 (QP5 v5.227.12220.39724) */
  SELECT z.*, TO_CHAR (lu, 'dd.mm.yyyy hh24:mi:ss') lu_txt, u.fio lu_fio
    FROM limits z, user_list u
   WHERE z.tn = :tn AND z.lu_tn = u.tn(+)
ORDER BY z.lu DESC