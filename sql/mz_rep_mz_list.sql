/* Formatted on 05.04.2013 13:38:42 (QP5 v5.163.1008.3004) */
  SELECT DISTINCT mz.*, TO_CHAR (mz.dataz, 'dd.mm.yyyy') dataz_t
    FROM mz_spr_mz mz, mz_tn
   WHERE     mz.id = mz_tn.mz_id(+)
         AND (mz_tn.tn = :tn
              OR (SELECT is_mz_admin
                    FROM user_list
                   WHERE tn = :tn) = 1)
         AND DECODE (dataz, NULL, 0, 1) = DECODE (:arc, 0, 0, 1)
ORDER BY name