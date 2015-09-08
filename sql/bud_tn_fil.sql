/* Formatted on 16/06/2015 11:54:52 (QP5 v5.227.12220.39724) */
  SELECT e.*,
         st_m.dpt_id,
         st_m.fio emp_name,
         bud.name bud_name,
         st_m.dpt_name dpt_name,
         st_m.region_name,
         st_m.department_name,
         TO_CHAR (e.lu, 'dd.mm.yyyy hh24:mi:ss') lu_txt
    FROM bud_tn_fil e, user_list st_m, bud_fil bud
   WHERE     st_m.tn(+) = e.tn
         AND bud.id = e.bud_id
         AND NVL (st_m.dpt_id, :dpt_id) = :dpt_id
         AND (   (:fil_activ = 2)
              OR (    :fil_activ = 0
                  AND NVL (bud.data_end, TRUNC (SYSDATE)) <
                         TRUNC (SYSDATE, 'mm'))
              OR (    :fil_activ = 1
                  AND NVL (bud.data_end, TRUNC (SYSDATE)) >=
                         TRUNC (SYSDATE, 'mm')))
         AND (   (:kk = 2)
              OR (:kk = 0 AND bud.kk = 0)
              OR (:kk = 1 AND bud.kk = 1))
ORDER BY emp_name, bud.name