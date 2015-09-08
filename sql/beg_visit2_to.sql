/* Formatted on 15.04.2014 11:43:27 (QP5 v5.227.12220.39724) */
  SELECT p.id to_id,
         p.name,
         v.EX_TP,
         v.EX_TOPAVK,
         v.EX_KONKTO,
         v.EX_ROSHEN,
         v.EX_KONTI,
         v.EX_OTHER,
         v.COMMENTS
    FROM (SELECT *
            FROM beg_to
           WHERE rep_show = 1) p,
         (SELECT s.*
            FROM beg_visit_head h, beg_visit_to s
           WHERE h.id = s.head_id(+) AND h.id = :head) v
   WHERE p.id = v.to_id(+)
ORDER BY p.name