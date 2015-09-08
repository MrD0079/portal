/* Formatted on 15.10.2012 14:17:02 (QP5 v5.163.1008.3004) */
  SELECT z.*,
         TO_CHAR (lu, 'dd/mm/yyyy hh24:mi:ss') lu_t,
         SUBSTR (name, 0, 50) || '...' name_ss
    FROM kk_flt_nets z
   WHERE tn = :tn
ORDER BY name