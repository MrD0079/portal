/* Formatted on 06/10/2015 13:40:57 (QP5 v5.252.13127.32867) */
  SELECT e.*,
         st_m.dpt_id,
         st_m.fio emp_name,
         bud.name bud_name,
         st_m.dpt_name dpt_name,
         st_m.region_name,
         st_m.department_name,
         TO_CHAR (e.lu, 'dd.mm.yyyy hh24:mi:ss') lu_txt
    FROM dm_fil e, user_list st_m, bud_fil bud
   WHERE     st_m.tn(+) = e.tn
         AND bud.id = e.bud_id
         /*AND NVL (st_m.dpt_id, :dpt_id) = :dpt_id*/
ORDER BY emp_name, bud.name