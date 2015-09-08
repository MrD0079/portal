/* Formatted on 07.07.2014 16:14:12 (QP5 v5.227.12220.39724) */
  SELECT DISTINCT f.id, f.name
    FROM bud_fil f, bud_tn_fil tf
   WHERE     f.dpt_id = :dpt_id
         AND tf.bud_id = f.id
         AND (   tf.tn IN (SELECT slave
                             FROM full
                            WHERE master = :tn)
              OR (SELECT NVL (is_admin, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1
              OR (SELECT NVL (is_super, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
ORDER BY f.name