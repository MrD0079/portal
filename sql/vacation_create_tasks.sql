/* Formatted on 10.12.2013 11:49:57 (QP5 v5.227.12220.39724) */
  SELECT t.id,
         TO_CHAR (t.dt_end, 'dd.mm.yyyy') dt_end,
         t.task,
         t.result,
         t.part_id,
         p.name part_name,
         t.replacement_ok,
         t.replacement_result,
         t.chief_ok,
         t.chief_comment
    FROM vacation_tasks t, vacation_task_parts p
   WHERE t.vac_id = :id AND t.part_id = p.id
ORDER BY p.sort, t.id