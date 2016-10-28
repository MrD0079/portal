/* Formatted on 17.09.2013 12:35:00 (QP5 v5.227.12220.39724) */
  SELECT pos_id, pos_name, COUNT (*) cnt
    FROM user_list u
   WHERE is_spd = 1 AND datauvol IS NULL AND dpt_id = :dpt_id
   and ((:tr_pt_rep_common_datauvol='all') or (:tr_pt_rep_common_datauvol='actual' and nvl(u.datauvol,trunc(sysdate))>=trunc(sysdate)))
GROUP BY pos_id, pos_name
ORDER BY pos_id, pos_name