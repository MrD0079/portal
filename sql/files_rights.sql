/* Formatted on 04/03/2015 10:28:27 (QP5 v5.227.12220.39724) */
  SELECT DISTINCT pos.pos_id, pos.pos_name, f.ID
    FROM user_list st,
         pos,
         (SELECT *
            FROM files_rights
           WHERE file_id = :id) f
   WHERE     pos.pos_id = st.pos_id
         AND pos.pos_id = f.pos_id(+)
         AND st.datauvol IS NULL
         AND st.dpt_id = :dpt_id
         AND st.tn <> 2885600038
ORDER BY pos.pos_name