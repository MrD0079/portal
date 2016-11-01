/* Formatted on 01.11.2016 08:54:16 (QP5 v5.252.13127.32867) */
  SELECT DISTINCT
         p.id,
         z.id fil_id,
         z.name,
         nd.name name_nd,
         TO_CHAR (
            FN_QUERY2STR (
                  'SELECT t2.fio FROM bud_tn_fil t1, user_list t2 WHERE t1.bud_id = '
               || z.id
               || ' AND t1.tn = t2.tn ORDER BY t2.fio',
               '<br>'))
            db_list,
         TO_CHAR (p.lu, 'dd.mm.yyyy hh24:mi:ss') lu_t,
         p.lu_fio,
         p.comm,
         TO_CHAR (p.status_lu, 'dd.mm.yyyy hh24:mi:ss') status_lu,
         p.status_fio,
         ps.name status,
         p.status_id,
         ps.def_val,
         p.ok_chief,
         p.ok_dpu,
         p.ok_nm,
         po.name ok_chief_name,
         po.def_val ok_chief_def_val,
         po.color,
         po_dpu.name ok_dpu_name,
         po_dpu.def_val ok_dpu_def_val,
         po_dpu.color ok_dpu_color,
         po_nm.name ok_nm_name,
         po_nm.def_val ok_nm_def_val,
         po_nm.color ok_nm_color,
         p.ok_chief_fio,
         p.ok_dpu_fio,
         p.ok_nm_fio,
         TO_CHAR (p.ok_chief_lu, 'dd.mm.yyyy hh24:mi:ss') ok_chief_lu,
         TO_CHAR (p.ok_dpu_lu, 'dd.mm.yyyy hh24:mi:ss') ok_dpu_lu,
         TO_CHAR (p.ok_nm_lu, 'dd.mm.yyyy hh24:mi:ss') ok_nm_lu,
         cat.name cat,
         conq.name conq,
         result.name result,
         p.lu_tn,
         (SELECT parent
            FROM parents
           WHERE tn = p.lu_tn)
            chief_tn,
         (SELECT fio
            FROM user_list
           WHERE tn = (SELECT parent
                         FROM parents
                        WHERE tn = p.lu_tn))
            chief_fio,
         p.lu,
         result.color result_color,
         status.color status_color,
         p.deleted,
         p.deleted_fio,
         TO_CHAR (p.deleted_lu, 'dd.mm.yyyy hh24:mi:ss') deleted_lu
    FROM bud_fil z,
         bud_nd nd,
         spr_users s,
         bud_tn_fil bf,
         user_list u,
         user_list pu,
         (SELECT DECODE (ok_chief, 47085127, 1, 0) need_chief,
                 DECODE (ok_nm, 47085127, 1, 0) need_nm,
                 DECODE (ok_dpu, 47085127, 1, 0) need_dpu,
                 DECODE ( (SELECT COUNT (parent)
                             FROM parents
                            WHERE tn = p1.lu_tn AND parent IN ( :tn)),
                         0, 0,
                         1)
                    i_am_chief,
                 DECODE ( (SELECT SUM (NVL (is_nm, 0))
                             FROM user_list
                            WHERE tn IN ( :tn)),
                         0, 0,
                         1)
                    i_am_nm,
                 DECODE ( (SELECT SUM (NVL (is_dpu, 0))
                             FROM user_list
                            WHERE tn IN ( :tn)),
                         0, 0,
                         1)
                    i_am_dpu,
                 DECODE (
                    (SELECT COUNT (parent)
                       FROM parents
                      WHERE     tn = p1.lu_tn
                            AND parent IN (SELECT slave
                                             FROM full
                                            WHERE     master IN ( (SELECT parent
                                                                     FROM assist
                                                                    WHERE     child =
                                                                                 :tn
                                                                          AND dpt_id =
                                                                                 :dpt_id
                                                                   UNION
                                                                   SELECT :tn
                                                                     FROM DUAL))
                                                  AND full <> -2)),
                    0, 0,
                    1)
                    slaves_chief,
                 DECODE (
                    (SELECT SUM (NVL (is_nm, 0))
                       FROM user_list
                      WHERE tn IN (SELECT slave
                                     FROM full
                                    WHERE     master IN ( (SELECT parent
                                                             FROM assist
                                                            WHERE     child =
                                                                         :tn
                                                                  AND dpt_id =
                                                                         :dpt_id
                                                           UNION
                                                           SELECT :tn FROM DUAL))
                                          AND full <> -2)),
                    0, 0,
                    1)
                    slaves_nm,
                 DECODE (
                    (SELECT SUM (NVL (is_dpu, 0))
                       FROM user_list
                      WHERE tn IN (SELECT slave
                                     FROM full
                                    WHERE     master IN ( (SELECT parent
                                                             FROM assist
                                                            WHERE     child =
                                                                         :tn
                                                                  AND dpt_id =
                                                                         :dpt_id
                                                           UNION
                                                           SELECT :tn FROM DUAL))
                                          AND full <> -2)),
                    0, 0,
                    1)
                    slaves_dpu,
                 p1.*
            FROM distr_prot p1) p,
         distr_prot_status ps,
         distr_prot_ok_chief po,
         distr_prot_ok_chief po_dpu,
         distr_prot_ok_chief po_nm,
         distr_prot_cat cat,
         distr_prot_conq conq,
         distr_prot_status status,
         distr_prot_result result
   WHERE     TRUNC (p.lu) BETWEEN TO_DATE ( :da_sd, 'dd.mm.yyyy')
                              AND TO_DATE ( :da_ed, 'dd.mm.yyyy')
         AND p.cat = cat.id(+)
         AND p.conq = conq.id(+)
         AND p.status_id = status.id(+)
         AND p.result = result.id(+)
         AND u.tn = bf.tn
         AND z.dpt_id = :dpt_id
         AND z.login = s.login(+)
         AND z.nd = nd.id(+)
         AND z.id = bf.bud_id(+)
         AND (   p.lu_tn IN (SELECT slave
                               FROM full
                              WHERE master IN (SELECT parent
                                                 FROM assist
                                                WHERE     child = :tn
                                                      AND dpt_id = :dpt_id
                                               UNION
                                               SELECT :tn FROM DUAL))
              OR (SELECT NVL (is_admin, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1
              OR (SELECT NVL (is_super, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1
              OR (SELECT NVL (is_do, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND DECODE ( :da_db, 0, bf.tn, :da_db) = bf.tn
         AND DECODE ( :da_di, 0, z.id, :da_di) = z.id
         AND DECODE ( :da_re, '0', NVL (u.region_name, '0'), :da_re) =
                NVL (u.region_name, '0')
         AND DECODE ( :da_de, '0', NVL (u.department_name, '0'), :da_de) =
                NVL (u.department_name, '0')
         AND z.id = p.distr
         AND p.status_id = ps.id
         AND p.ok_chief = po.id
         AND p.ok_dpu = po_dpu.id
         AND p.ok_nm = po_nm.id
         AND DECODE ( :da_st, 0, p.status_id, :da_st) = p.status_id
         AND DECODE ( :da_ok_chief, 0, p.ok_chief, :da_ok_chief) = p.ok_chief
         AND DECODE ( :da_ok_nm, 0, p.ok_nm, :da_ok_nm) = p.ok_nm
         AND DECODE ( :da_ok_dpu, 0, p.ok_dpu, :da_ok_dpu) = p.ok_dpu
         AND DECODE ( :da_cat, 0, p.cat, :da_cat) = p.cat
         AND DECODE ( :da_conq, 0, p.conq, :da_conq) = p.conq
         AND DECODE ( :da_result, 0, p.result, :da_result) = p.result
         AND DECODE ( :da_deleted, 0, 0, p.deleted) = p.deleted
         AND pu.tn = p.lu_tn
         AND p.dpt_id = :dpt_id
         AND (   ( :da_full = 0)
              OR (    :da_full = 1
                  AND (   (need_chief = 1 AND i_am_chief = 1)
                       OR (need_nm = 1 AND i_am_nm = 1)
                       OR (need_dpu = 1 AND i_am_dpu = 1)))
              OR (    :da_full = 2
                  AND (   (need_chief = 1 AND slaves_chief = 1)
                       OR (need_nm = 1 AND slaves_nm = 1)
                       OR (need_dpu = 1 AND slaves_dpu = 1))))
         AND DECODE ( :prot_id, 0, p.id, :prot_id) = p.id
ORDER BY p.lu, z.name