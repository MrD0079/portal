/* Formatted on 09/04/2015 12:09:55 (QP5 v5.227.12220.39724) */
  SELECT DISTINCT
         z.id,
         z.name,
         z.sw_kod,
         TO_CHAR (z.lu, 'dd.mm.yyyy hh24:mi:ss') lu,
         TO_CHAR (z.data_end, 'dd.mm.yyyy') data_end,
         z.lu_fio,
         nd.name name_nd,
         z.rp,
         z.rf,
         z.comm,
         z.login,
         s.password,
         FN_QUERY2STR (
               'SELECT t2.fio FROM bud_tn_fil t1, user_list t2 WHERE t1.bud_id = '
            || z.id
            || ' AND t1.tn = t2.tn ORDER BY t2.fio',
            '<br>')
            db_list,
         FN_QUERY2STR (
               'SELECT DISTINCT dolgn || '': '' || mail FROM bud_fil_contacts WHERE delivery = 1 AND fil = '
            || z.id,
            '<br>')
            delivery
    FROM bud_fil z,
         bud_nd nd,
         spr_users s,
         bud_tn_fil bf,
         user_list u
   WHERE     u.tn = bf.tn
         AND z.dpt_id = :dpt_id
         AND z.login = s.login(+)
         AND z.nd = nd.id(+)
         AND z.id = bf.bud_id(+)
         AND (   bf.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_admin, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1
              OR (SELECT NVL (is_super, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND DECODE (:da_db, 0, bf.tn, :da_db) = bf.tn
         AND DECODE (:da_di, 0, z.id, :da_di) = z.id
         AND DECODE (:da_re, '0', u.region_name, :da_re) = u.region_name
         AND DECODE (:da_de, '0', u.department_name, :da_de) =
                u.department_name
ORDER BY z.name