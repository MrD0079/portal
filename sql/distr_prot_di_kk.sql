/* Formatted on 09/11/2015 16:40:42 (QP5 v5.252.13127.32867) */
  SELECT DISTINCT f.id, f.name
    FROM bud_fil f, bud_tn_fil tf
   WHERE     f.dpt_id = :dpt_id
         AND tf.bud_id = f.id
         AND (   tf.tn IN (SELECT slave
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
              OR (SELECT NVL (is_fin_man, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1
              OR (SELECT NVL (is_super, 0)
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND (f.data_end IS NULL OR f.data_end >= TRUNC (SYSDATE))
         AND f.kk = 1
ORDER BY f.name